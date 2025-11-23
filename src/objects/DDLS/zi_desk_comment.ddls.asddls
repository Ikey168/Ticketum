@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comment Interface View'
define view entity ZI_DESK_COMMENT
  as select from zdesk_comment
  association to parent ZI_DESK_TICKET as _Ticket
    on $projection.TicketUuid = _Ticket.TicketUuid
{
  key comment_uuid as CommentUuid,
      ticket_uuid as TicketUuid,
      comment_text as CommentText,
      comment_type as CommentType,
      is_internal as IsInternal,
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
