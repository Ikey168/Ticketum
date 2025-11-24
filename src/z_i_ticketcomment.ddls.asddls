@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Comment View Entity'
@UI.headerInfo: { typeName: 'Ticket Comment', typeNamePlural: 'Ticket Comments', title: { type: #STANDARD, value: 'CommentText' } }
define view entity Z_I_TicketComment
  as select from zticket_cmt
  association to parent Z_I_Ticket as _Ticket on $projection.TicketID = _Ticket.TicketID
{
      @UI.facet: [ { id: 'Comment', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Comment Details', position: 10 } ]

  key ticket_id    as TicketID,
  key comment_id   as CommentID,
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
      comment_text as CommentText,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      created_at   as CreatedAt,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      created_by   as CreatedBy,
      _Ticket
}
