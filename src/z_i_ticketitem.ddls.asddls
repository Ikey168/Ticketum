@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Item View Entity'
@UI.headerInfo: { typeName: 'Ticket Item', typeNamePlural: 'Ticket Items', title: { type: #STANDARD, value: 'Description' } }
define view entity Z_I_TicketItem
  as select from zticket_itm
  association to parent Z_I_Ticket as _Ticket on $projection.TicketID = _Ticket.TicketID
{
      @UI.facet: [ { id: 'Item', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Item Details', position: 10 } ]

  key ticket_id         as TicketID,
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key item_no           as ItemNo,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      description       as Description,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      status            as Status,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      assigned_agent    as AssignedAgent,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      planned_effort_hr as PlannedEffortHr,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      actual_effort_hr  as ActualEffortHr,
      _Ticket
}
