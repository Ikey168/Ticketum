@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Root View Entity'
@UI.headerInfo: { typeName: 'Ticket', typeNamePlural: 'Tickets', title: { type: #STANDARD, value: 'Title' } }
define root view entity Z_I_Ticket
  as select from zticket_hdr
  composition [0..*] of Z_I_TicketItem    as _Items,
  composition [0..*] of Z_I_TicketComment as _Comments
{
      @UI.lineItem: [{ position: 10 }]
  key ticket_id       as TicketID,
      @UI.lineItem: [{ position: 20 }]
      title           as Title,
      description     as Description,
      requester_user  as RequesterUser,
      requester_name  as RequesterName,
      requester_email as RequesterEmail,
      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{ position: 20 }]
      priority        as Priority,
      @UI.lineItem: [{ position: 40 }]
      @UI.selectionField: [{ position: 10 }]
      status          as Status,
      @UI.lineItem: [{ position: 50 }]
      @UI.selectionField: [{ position: 30 }]
      assigned_agent  as AssignedAgent,
      @UI.lineItem: [{ position: 60 }]
      created_at      as CreatedAt,
      created_by      as CreatedBy,
      changed_at      as ChangedAt,
      changed_by      as ChangedBy,
      _Items,
      _Comments
}
