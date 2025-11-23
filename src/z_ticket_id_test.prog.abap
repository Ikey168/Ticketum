REPORT z_ticket_id_test.

DATA: lv_number TYPE char10,
      lv_rc     TYPE sysubrc.

CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
    nr_range_nr             = '01'
    object                  = 'Z_TICKET_ID'
  IMPORTING
    number                  = lv_number
    returncode              = lv_rc
  EXCEPTIONS
    interval_not_found      = 1
    number_range_not_intern = 2
    object_not_found        = 3
    quantity_is_0           = 4
    quantity_is_not_1       = 5
    interval_overflow       = 6
    buffer_overflow         = 7
    OTHERS                  = 8.

IF sy-subrc = 0.
  WRITE: / 'Next Ticket ID:', lv_number.
ELSE.
  WRITE: / 'Error getting number:', sy-subrc.
ENDIF.
