CLASS lhc_Ticket DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

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
