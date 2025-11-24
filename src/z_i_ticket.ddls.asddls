@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Root View Entity'
define root view entity Z_I_Ticket
  as select from zticket_hdr
  composition [0..*] of Z_I_TicketItem as _Items
{
  key ticket_id       as TicketID,
      title           as Title,
      description     as Description,
      requester_user  as RequesterUser,
      requester_name  as RequesterName,
      requester_email as RequesterEmail,
      priority        as Priority,
      status          as Status,
      assigned_agent  as AssignedAgent,
      created_at      as CreatedAt,
      created_by      as CreatedBy,
      changed_at      as ChangedAt,
      changed_by      as ChangedBy,
      _Items
}
