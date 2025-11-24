CLASS lhc_Ticket DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Ticket.

    METHODS setDefaults FOR DETERMINATION Ticket~setDefaults
      IMPORTING keys FOR Ticket.

    METHODS updateAudit FOR DETERMINATION Ticket~updateAudit
      IMPORTING keys FOR Ticket.

    METHODS validateHeader FOR VALIDATE ON SAVE
      IMPORTING keys FOR Ticket~validateHeader.

    METHODS validateClosedStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Ticket~validateClosedStatus.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Ticket RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Ticket RESULT result.

    METHODS acceptTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~acceptTicket RESULT result.

    METHODS resolveTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~resolveTicket RESULT result.

    METHODS closeTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~closeTicket RESULT result.

    METHODS reopenTicket FOR MODIFY
      IMPORTING keys FOR ACTION Ticket~reopenTicket RESULT result.

ENDCLASS.

CLASS lhc_TicketItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateParentStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR TicketItem~validateParentStatus.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR TicketItem RESULT result.

ENDCLASS.

CLASS lhc_TicketComment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateParentStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR TicketComment~validateParentStatus.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR TicketComment RESULT result.

ENDCLASS.

CLASS lhc_Ticket IMPLEMENTATION.

  METHOD earlynumbering_create.
    DATA: lv_number TYPE char10.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr = '01'
          object      = 'Z_TICKET_ID'
        IMPORTING
          number      = lv_number
        EXCEPTIONS
          OTHERS      = 1.

      IF sy-subrc = 0.
        APPEND VALUE #( %cid = <entity>-%cid
                        TicketID = lv_number ) TO mapped-ticket.
      ELSE.
        APPEND VALUE #( %cid = <entity>-%cid
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Error generating Ticket ID' ) ) TO reported-ticket.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setDefaults.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    GET TIME STAMP FIELD DATA(lv_ts).

    MODIFY ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        UPDATE
          FIELDS ( Status CreatedAt CreatedBy )
          WITH VALUE #( FOR ticket IN tickets
                        ( %tky = ticket-%tky
                          Status = COND #( WHEN ticket-Status IS INITIAL THEN '01' ELSE ticket-Status )
                          CreatedAt = lv_ts
                          CreatedBy = sy-uname ) ).
  ENDMETHOD.

  METHOD updateAudit.
    GET TIME STAMP FIELD DATA(lv_ts).

    MODIFY ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        UPDATE
          FIELDS ( ChangedAt ChangedBy )
          WITH VALUE #( FOR key IN keys
                        ( %tky = key-%tky
                          ChangedAt = lv_ts
                          ChangedBy = sy-uname ) ).
  ENDMETHOD.

  METHOD validateHeader.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Title RequesterName RequesterEmail ) WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Title IS INITIAL.
        APPEND VALUE #( %tky = ticket-%tky ) TO failed-ticket.
        APPEND VALUE #( %tky = ticket-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Title is required' ) ) TO reported-ticket.
      ENDIF.

      IF ticket-RequesterName IS INITIAL AND ticket-RequesterEmail IS INITIAL.
        APPEND VALUE #( %tky = ticket-%tky ) TO failed-ticket.
        APPEND VALUE #( %tky = ticket-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Either Requester Name or Email is required' ) ) TO reported-ticket.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateClosedStatus.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '04'. " Closed
        SELECT SINGLE status FROM zticket_hdr WHERE ticket_id = @ticket-TicketID INTO @DATA(db_status).
        IF sy-subrc = 0 AND db_status = '04'.
           APPEND VALUE #( %tky = ticket-%tky ) TO failed-ticket.
           APPEND VALUE #( %tky = ticket-%tky
                           %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text = 'Cannot edit a closed ticket. Reopen it first.' ) ) TO reported-ticket.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    result = VALUE #( FOR ticket IN tickets
                      ( %tky = ticket-%tky
                        %action-acceptTicket  = COND #( WHEN ticket-Status = '01' THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
                        %action-resolveTicket = COND #( WHEN ticket-Status = '02' THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
                        %action-closeTicket   = COND #( WHEN ticket-Status = '03' THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
                        %action-reopenTicket  = COND #( WHEN ticket-Status = '03' OR ticket-Status = '04' THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
                      ) ).
  ENDMETHOD.

  METHOD acceptTicket.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    GET TIME STAMP FIELD DATA(lv_ts).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '01'. " Open
        MODIFY ENTITIES OF Z_I_Ticket IN LOCAL MODE
          ENTITY Ticket
            UPDATE
              FIELDS ( Status AssignedAgent )
              WITH VALUE #( ( %tky = ticket-%tky
                              Status = '02'
                              AssignedAgent = COND #( WHEN ticket-AssignedAgent IS INITIAL THEN sy-uname ELSE ticket-AssignedAgent ) ) )
          ENTITY Ticket
            CREATE BY \_Comments
              FIELDS ( CommentText CreatedAt CreatedBy )
              WITH VALUE #( ( %tky = ticket-%tky
                              %target = VALUE #( ( %cid = 'ACCEPT' && ticket-TicketID
                                                   CommentText = 'Ticket accepted.'
                                                   CreatedAt = lv_ts
                                                   CreatedBy = sy-uname ) ) ) ).
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_tickets).

    result = VALUE #( FOR result_ticket IN result_tickets
                      ( %tky = result_ticket-%tky
                        %param = result_ticket ) ).
  ENDMETHOD.

  METHOD resolveTicket.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    GET TIME STAMP FIELD DATA(lv_ts).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '02'. " In Progress
        MODIFY ENTITIES OF Z_I_Ticket IN LOCAL MODE
          ENTITY Ticket
            UPDATE
              FIELDS ( Status )
              WITH VALUE #( ( %tky = ticket-%tky
                              Status = '03' ) )
          ENTITY Ticket
            CREATE BY \_Comments
              FIELDS ( CommentText CreatedAt CreatedBy )
              WITH VALUE #( ( %tky = ticket-%tky
                              %target = VALUE #( ( %cid = 'RESOLVE' && ticket-TicketID
                                                   CommentText = 'Ticket resolved.'
                                                   CreatedAt = lv_ts
                                                   CreatedBy = sy-uname ) ) ) ).
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_tickets).

    result = VALUE #( FOR result_ticket IN result_tickets
                      ( %tky = result_ticket-%tky
                        %param = result_ticket ) ).
  ENDMETHOD.

  METHOD closeTicket.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    GET TIME STAMP FIELD DATA(lv_ts).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '03'. " Resolved
        MODIFY ENTITIES OF Z_I_Ticket IN LOCAL MODE
          ENTITY Ticket
            UPDATE
              FIELDS ( Status )
              WITH VALUE #( ( %tky = ticket-%tky
                              Status = '04' ) )
          ENTITY Ticket
            CREATE BY \_Comments
              FIELDS ( CommentText CreatedAt CreatedBy )
              WITH VALUE #( ( %tky = ticket-%tky
                              %target = VALUE #( ( %cid = 'CLOSE' && ticket-TicketID
                                                   CommentText = 'Ticket closed.'
                                                   CreatedAt = lv_ts
                                                   CreatedBy = sy-uname ) ) ) ).
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_tickets).

    result = VALUE #( FOR result_ticket IN result_tickets
                      ( %tky = result_ticket-%tky
                        %param = result_ticket ) ).
  ENDMETHOD.

  METHOD reopenTicket.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(tickets).

    GET TIME STAMP FIELD DATA(lv_ts).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '03' OR ticket-Status = '04'. " Resolved or Closed
        MODIFY ENTITIES OF Z_I_Ticket IN LOCAL MODE
          ENTITY Ticket
            UPDATE
              FIELDS ( Status )
              WITH VALUE #( ( %tky = ticket-%tky
                              Status = '01' ) )
          ENTITY Ticket
            CREATE BY \_Comments
              FIELDS ( CommentText CreatedAt CreatedBy )
              WITH VALUE #( ( %tky = ticket-%tky
                              %target = VALUE #( ( %cid = 'REOPEN' && ticket-TicketID
                                                   CommentText = 'Ticket reopened.'
                                                   CreatedAt = lv_ts
                                                   CreatedBy = sy-uname ) ) ) ).
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_tickets).

    result = VALUE #( FOR result_ticket IN result_tickets
                      ( %tky = result_ticket-%tky
                        %param = result_ticket ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_TicketItem IMPLEMENTATION.

  METHOD validateParentStatus.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( TicketID = key-TicketID ) )
      RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '04'.
        LOOP AT keys INTO DATA(key) WHERE TicketID = ticket-TicketID.
          APPEND VALUE #( %tky = key-%tky ) TO failed-ticketitem.
          APPEND VALUE #( %tky = key-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Cannot modify items of a closed ticket.' ) ) TO reported-ticketitem.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( TicketID = key-TicketID ) )
      RESULT DATA(tickets).

    LOOP AT keys INTO DATA(key).
      READ TABLE tickets INTO DATA(ticket) WITH KEY TicketID = key-TicketID.
      IF sy-subrc = 0.
        APPEND VALUE #( %tky = key-%tky
                        %update = COND #( WHEN ticket-Status = '04' THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
                        %delete = COND #( WHEN ticket-Status = '04' THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
                      ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_TicketComment IMPLEMENTATION.

  METHOD validateParentStatus.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( TicketID = key-TicketID ) )
      RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).
      IF ticket-Status = '04'.
        LOOP AT keys INTO DATA(key) WHERE TicketID = ticket-TicketID.
          APPEND VALUE #( %tky = key-%tky ) TO failed-ticketcomment.
          APPEND VALUE #( %tky = key-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Cannot modify comments of a closed ticket.' ) ) TO reported-ticketcomment.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF Z_I_Ticket IN LOCAL MODE
      ENTITY Ticket
        FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( TicketID = key-TicketID ) )
      RESULT DATA(tickets).

    LOOP AT keys INTO DATA(key).
      READ TABLE tickets INTO DATA(ticket) WITH KEY TicketID = key-TicketID.
      IF sy-subrc = 0.
        APPEND VALUE #( %tky = key-%tky
                        %update = COND #( WHEN ticket-Status = '04' THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
                        %delete = COND #( WHEN ticket-Status = '04' THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
                      ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
