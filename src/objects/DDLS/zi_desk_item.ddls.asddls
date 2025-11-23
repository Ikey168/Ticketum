@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Interface View'
define view entity ZI_DESK_ITEM
  as select from zdesk_item
  association to parent ZI_DESK_TICKET as _Ticket
    on $projection.TicketUuid = _Ticket.TicketUuid
{
  key item_uuid as ItemUuid,
      ticket_uuid as TicketUuid,
      item_id as ItemId,
      item_type as ItemType,
      description as Description,
      status as Status,
      quantity as Quantity,
      @Semantics.user.createdBy: true
      created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      _Ticket
}
