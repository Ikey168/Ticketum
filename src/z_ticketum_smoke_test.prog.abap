REPORT z_ticketum_smoke_test.

CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD run.
    DATA: lv_ticket_id TYPE z_ticket_id,
          lv_comment_id TYPE sysuuid_x16.

    " 1. Create Ticket
    MODIFY ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        CREATE
          SET FIELDS WITH VALUE #( ( %cid = 'CREATE_TICKET'
                                     Title = 'EML Test Ticket'
                                     RequesterName = 'Tester'
                                     RequesterEmail = 'test@example.com'
                                     Priority = '2' ) )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    IF failed IS NOT INITIAL.
      WRITE: / 'Create Ticket Failed'.
      RETURN.
    ENDIF.

    lv_ticket_id = mapped-ticket[ 1 ]-TicketID.
    WRITE: / 'Ticket Created:', lv_ticket_id.
    COMMIT ENTITIES.

    " 2. Add Item and Comment
    lv_comment_id = cl_system_uuid=>create_uuid_x16_static( ).

    MODIFY ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        CREATE BY \_Items
          SET FIELDS WITH VALUE #( ( TicketID = lv_ticket_id
                                     %target = VALUE #( ( %cid = 'ADD_ITEM'
                                                          ItemNo = '0010'
                                                          Description = 'Test Item'
                                                          PlannedEffortHr = '2.0' ) ) ) )
        CREATE BY \_Comments
          SET FIELDS WITH VALUE #( ( TicketID = lv_ticket_id
                                     %target = VALUE #( ( %cid = 'ADD_COMMENT'
                                                          CommentID = lv_comment_id
                                                          CommentText = 'Test Comment' ) ) ) )
      FAILED failed
      REPORTED reported.

    IF failed IS NOT INITIAL.
      WRITE: / 'Add Item/Comment Failed'.
    ELSE.
      WRITE: / 'Item and Comment Added'.
    ENDIF.
    COMMIT ENTITIES.

    " 3. Test Actions
    " Accept
    MODIFY ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        EXECUTE acceptTicket
          FROM VALUE #( ( TicketID = lv_ticket_id ) )
      FAILED failed
      REPORTED reported.

    IF failed IS INITIAL.
      WRITE: / 'Ticket Accepted'.
    ELSE.
      WRITE: / 'Accept Ticket Failed'.
    ENDIF.
    COMMIT ENTITIES.

    " Resolve
    MODIFY ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        EXECUTE resolveTicket
          FROM VALUE #( ( TicketID = lv_ticket_id ) )
      FAILED failed
      REPORTED reported.

    IF failed IS INITIAL.
      WRITE: / 'Ticket Resolved'.
    ELSE.
      WRITE: / 'Resolve Ticket Failed'.
    ENDIF.
    COMMIT ENTITIES.

    " Close
    MODIFY ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        EXECUTE closeTicket
          FROM VALUE #( ( TicketID = lv_ticket_id ) )
      FAILED failed
      REPORTED reported.

    IF failed IS INITIAL.
      WRITE: / 'Ticket Closed'.
    ELSE.
      WRITE: / 'Close Ticket Failed'.
    ENDIF.
    COMMIT ENTITIES.

    " Reopen
    MODIFY ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        EXECUTE reopenTicket
          FROM VALUE #( ( TicketID = lv_ticket_id ) )
      FAILED failed
      REPORTED reported.

    IF failed IS INITIAL.
      WRITE: / 'Ticket Reopened'.
    ELSE.
      WRITE: / 'Reopen Ticket Failed'.
    ENDIF.
    COMMIT ENTITIES.

    " 4. Verify Final Status
    READ ENTITIES OF Z_I_Ticket
      ENTITY Ticket
        FIELDS ( Status )
        WITH VALUE #( ( TicketID = lv_ticket_id ) )
      RESULT DATA(tickets).

    IF tickets IS NOT INITIAL.
      WRITE: / 'Final Status:', tickets[ 1 ]-Status.
    ENDIF.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_test=>run( ).
