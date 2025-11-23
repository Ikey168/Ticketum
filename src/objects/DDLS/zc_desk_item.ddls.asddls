@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Consumption View'
@Metadata.allowExtensions: true
define view entity ZC_DESK_ITEM
  as projection on ZI_DESK_ITEM
{
  key ItemUuid,
      TicketUuid,
      ItemId,
      ItemType,
      Description,
      Status,
      Quantity,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      
      _Ticket : redirected to parent ZC_DESK_TICKET
}
