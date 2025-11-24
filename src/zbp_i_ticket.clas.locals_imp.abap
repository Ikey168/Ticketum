CLASS lhc_Ticket DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Ticket.

    METHODS setDefaults FOR DETERMINATION Ticket~setDefaults
      IMPORTING keys FOR Ticket.

    METHODS updateAudit FOR DETERMINATION Ticket~updateAudit
      IMPORTING keys FOR Ticket.

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

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD acceptTicket.
  ENDMETHOD.

  METHOD resolveTicket.
  ENDMETHOD.

  METHOD closeTicket.
  ENDMETHOD.

  METHOD reopenTicket.
  ENDMETHOD.

ENDCLASS.
