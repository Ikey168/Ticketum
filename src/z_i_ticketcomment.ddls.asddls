@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Comment View Entity'
define view entity Z_I_TicketComment
  as select from zticket_cmt
  association to parent Z_I_Ticket as _Ticket on $projection.TicketID = _Ticket.TicketID
{
  key ticket_id    as TicketID,
  key comment_id   as CommentID,
      comment_text as CommentText,
      created_at   as CreatedAt,
      created_by   as CreatedBy,
      _Ticket
}
