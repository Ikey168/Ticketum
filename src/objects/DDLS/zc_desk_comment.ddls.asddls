@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comment Consumption View'
@Metadata.allowExtensions: true
define view entity ZC_DESK_COMMENT
  as projection on ZI_DESK_COMMENT
{
  key CommentUuid,
      TicketUuid,
      CommentText,
      CommentType,
      IsInternal,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      
      _Ticket : redirected to parent ZC_DESK_TICKET
}
