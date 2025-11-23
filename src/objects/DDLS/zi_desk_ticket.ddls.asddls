@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Interface View'
define root view entity ZI_DESK_TICKET
  as select from zdesk_ticket
  composition [0..*] of ZI_DESK_ITEM as _Item
  composition [0..*] of ZI_DESK_COMMENT as _Comment
{
  key ticket_uuid as TicketUuid,
      ticket_id as TicketId,
      title as Title,
      description as Description,
      status as Status,
      priority as Priority,
      category as Category,
      requester as Requester,
      assignee as Assignee,
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
      
      _Item,
      _Comment
}
