@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Consumption View'
@Metadata.allowExtensions: true
define root view entity ZC_DESK_TICKET
  provider contract transactional_query
  as projection on ZI_DESK_TICKET
{
  key TicketUuid,
      TicketId,
      Title,
      Description,
      Status,
      Priority,
      Category,
      Requester,
      Assignee,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      
      _Item : redirected to composition child ZC_DESK_ITEM,
      _Comment : redirected to composition child ZC_DESK_COMMENT
}
