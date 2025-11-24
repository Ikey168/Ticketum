@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ticket Root View Entity'
@UI.headerInfo: { typeName: 'Ticket', typeNamePlural: 'Tickets', title: { type: #STANDARD, value: 'Title' } }
define root view entity Z_I_Ticket
  as select from zticket_hdr
  composition [0..*] of Z_I_TicketItem    as _Items,
  composition [0..*] of Z_I_TicketComment as _Comments
{
      @UI.facet: [
        {
          id: 'General',
          type: #COLLECTION,
          position: 10,
          label: 'General Information'
        },
        {
          id: 'BasicData',
          type: #IDENTIFICATION_REFERENCE,
          position: 10,
          parentId: 'General',
          label: 'Basic Data'
        },
        {
          id: 'Items',
          type: #LINEITEM_REFERENCE,
          position: 20,
          targetElement: '_Items',
          label: 'Items'
        },
        {
          id: 'Comments',
          type: #LINEITEM_REFERENCE,
          position: 30,
          targetElement: '_Comments',
          label: 'Comments'
        }
      ]

      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key ticket_id       as TicketID,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      title           as Title,
      @UI.identification: [{ position: 30 }]
      description     as Description,
      requester_user  as RequesterUser,
      @UI.identification: [{ position: 40 }]
      requester_name  as RequesterName,
      @UI.identification: [{ position: 50 }]
      requester_email as RequesterEmail,
      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{ position: 20 }]
      @UI.identification: [{ position: 60 }]
      priority        as Priority,
      @UI.lineItem: [{ position: 40 }]
      @UI.selectionField: [{ position: 10 }]
      @UI.identification: [{ position: 70 }]
      status          as Status,
      @UI.lineItem: [{ position: 50 }]
      @UI.selectionField: [{ position: 30 }]
      @UI.identification: [{ position: 80 }]
      assigned_agent  as AssignedAgent,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 90 }]
      created_at      as CreatedAt,
      @UI.identification: [{ position: 100 }]
      created_by      as CreatedBy,
      @UI.identification: [{ position: 110 }]
      changed_at      as ChangedAt,
      @UI.identification: [{ position: 120 }]
      changed_by      as ChangedBy,
      _Items,
      _Comments
}
