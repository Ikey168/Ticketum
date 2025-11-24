CLASS z_ticketum_odata_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z_ticketum_odata_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_tickets TYPE STANDARD TABLE OF Z_I_Ticket.

    TRY.
        " 1. Create Client Proxy for OData V4 Service Binding
        " Note: The service_id is the name of the Service Binding
        DATA(lo_client_proxy) = cl_web_odata_client_factory=>create_v4_local_proxy(
          VALUE #( service_key = VALUE #( service_id      = 'ZUI_TICKETUM_O4'
                                          service_version = '0001' ) ) ).

        " 2. Create Read Request for 'Ticket' Entity Set
        DATA(lo_resource) = lo_client_proxy->create_resource_for_entity_set( 'Ticket' ).
        DATA(lo_request) = lo_resource->create_request_for_read( ).

        " Set top 5 to avoid fetching too much
        lo_request->set_top( 5 ).

        " 3. Execute Request
        DATA(lo_response) = lo_request->execute( ).

        " 4. Retrieve Business Data
        lo_response->get_business_data( IMPORTING et_business_data = lt_tickets ).

        out->write( |OData Service Call Successful.| ).
        out->write( |Number of Tickets retrieved: { lines( lt_tickets ) }| ).
        
        LOOP AT lt_tickets INTO DATA(ls_ticket).
            out->write( |Ticket ID: { ls_ticket-TicketID }, Title: { ls_ticket-Title }| ).
        ENDLOOP.

      CATCH cx_root INTO DATA(lx_root).
        out->write( |Error executing OData Request: { lx_root->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
