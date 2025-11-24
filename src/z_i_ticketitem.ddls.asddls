@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Item View Entity'
define view entity Z_I_TicketItem
  as select from zticket_itm
  association to parent Z_I_Ticket as _Ticket on $projection.TicketID = _Ticket.TicketID
{
  key ticket_id         as TicketID,
  key item_no           as ItemNo,
      description       as Description,
      status            as Status,
      assigned_agent    as AssignedAgent,
      planned_effort_hr as PlannedEffortHr,
      actual_effort_hr  as ActualEffortHr,
      _Ticket
}
