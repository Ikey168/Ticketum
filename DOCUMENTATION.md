# Deskulo - IT Service Desk

## Overview

Deskulo is a lean IT service desk application built on SAP S/4HANA using the ABAP RESTful Application Programming Model (RAP). It provides a modern, Fiori Elements-based user interface for managing support tickets, items, and comments.

## Features

- **Ticket Management**: Create, update, and track support tickets with comprehensive details
- **Item Tracking**: Associate multiple items with each ticket for detailed request handling
- **Comment System**: Add comments to tickets with support for internal/external visibility
- **Status & Priority**: Track ticket status and priority levels
- **Category Management**: Organize tickets by categories
- **User Assignment**: Assign tickets to requesters and assignees
- **Audit Trail**: Automatic tracking of creation and modification timestamps and users

## Architecture

### Technology Stack

- **Backend**: ABAP RESTful Application Programming Model (RAP)
- **Data Model**: Core Data Services (CDS)
- **Business Logic**: Behavior Definitions and Implementations
- **Service Layer**: OData V4 Service Binding
- **Frontend**: SAP Fiori Elements

### Data Model

The application consists of three main entities:

1. **Tickets** (`ZDESK_TICKET`)
   - Primary entity for support requests
   - Contains ticket details, status, priority, category
   - Tracks requester and assignee
   - Parent entity in composition with Items and Comments

2. **Items** (`ZDESK_ITEM`)
   - Child entity of Tickets
   - Represents items associated with a ticket
   - Includes item type, description, status, and quantity

3. **Comments** (`ZDESK_COMMENT`)
   - Child entity of Tickets
   - Stores ticket-related comments
   - Supports internal/external visibility flag
   - Tracks comment type

### RAP Structure

```
Interface Views (ZI_*)
├── ZI_DESK_TICKET (Root)
│   ├── ZI_DESK_ITEM (Composition child)
│   └── ZI_DESK_COMMENT (Composition child)

Consumption Views (ZC_*)
├── ZC_DESK_TICKET (Projection)
│   ├── ZC_DESK_ITEM (Projection)
│   └── ZC_DESK_COMMENT (Projection)

Behavior Definitions
├── ZI_DESK_TICKET.bdef (Managed implementation)
└── ZC_DESK_TICKET.bdef (Projection)

Service Definition
└── ZDESK_SD

Service Binding
└── ZDESK_UI_O4 (OData V4)
```

## Installation

### Prerequisites

- SAP S/4HANA system (on-premise or cloud)
- ABAP Development Tools (ADT) in Eclipse
- abapGit plugin for Eclipse
- User with development authorization

### Installation Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/Ikey168/Ticketum.git
   ```

2. **Import via abapGit**
   - Open ABAP Development Tools
   - Install and configure abapGit plugin
   - Create a new abapGit repository
   - Link to the cloned repository
   - Pull the objects into your SAP system

3. **Activate Objects**
   - Activate all imported objects
   - Check for any activation errors
   - Resolve dependencies if needed

4. **Create Service Binding**
   - Open service binding `ZDESK_UI_O4`
   - Publish the service
   - Note the service URL

5. **Configure Fiori Launchpad** (Optional)
   - Create a Fiori Launchpad tile
   - Configure tile to point to the published service
   - Assign to user roles

## Usage

### Accessing the Application

1. **Via Service Binding**
   - Open `ZDESK_UI_O4` in ADT
   - Click "Preview" to test the service
   - Select entity set to display

2. **Via Fiori Launchpad**
   - Log into SAP Fiori Launchpad
   - Navigate to the Deskulo tile
   - Access ticket management interface

### Creating a Ticket

1. Click "Create" button
2. Fill in required fields:
   - Title: Brief description of the issue
   - Description: Detailed explanation
   - Status: Initial status (e.g., "New", "Open")
   - Priority: Urgency level
   - Category: Ticket category
   - Requester: User requesting support
   - Assignee: User assigned to handle the ticket

3. Save the ticket

### Adding Items

1. Open a ticket
2. Navigate to "Items" section
3. Click "Create" to add a new item
4. Fill in item details:
   - Item Type: Type of item
   - Description: Item details
   - Status: Item status
   - Quantity: Number of items

5. Save the item

### Adding Comments

1. Open a ticket
2. Navigate to "Comments" section
3. Click "Create" to add a comment
4. Enter:
   - Comment Text: Your comment
   - Comment Type: Type of comment
   - Is Internal: Check if comment is internal only

5. Save the comment

## Technical Notes

### Database Table Field Definitions

The database tables use standard ABAP field definitions where:
- `INTLEN` (Internal Length): Storage length in bytes, including Unicode encoding overhead
- `LENG` (Display Length): Actual character length for display
- For CHAR fields, INTLEN is typically 2x LENG due to Unicode (UTF-16) encoding

This is standard SAP behavior and not a data truncation issue.

### Behavior Implementation

The behavior implementation class `ZBP_I_DESK_TICKET` is minimal by design, as this is a managed RAP scenario where SAP provides automatic CRUD operations. The class can be extended with:
- Early numbering for custom ID generation
- Validations for business rules
- Determinations for field calculations
- Actions for custom business logic

## Development

### Object Naming Convention

- Tables: `ZDESK_*`
- Interface Views: `ZI_DESK_*`
- Consumption Views: `ZC_DESK_*`
- Behavior Definitions: `ZI_DESK_*.bdef` / `ZC_DESK_*.bdef`
- Service Definition: `ZDESK_SD`
- Service Binding: `ZDESK_UI_O4`
- Classes: `ZBP_I_DESK_*`

### Extending the Application

#### Adding New Fields

1. Modify database table in `src/objects/TABL/`
2. Update interface view in `src/objects/DDLS/zi_*.ddls.asddls`
3. Update consumption view in `src/objects/DDLS/zc_*.ddls.asddls`
4. Update behavior definition if needed
5. Update metadata extension for UI annotations

#### Adding Actions

1. Define action in interface behavior definition
2. Implement action in behavior implementation class
3. Expose action in projection behavior definition
4. Add UI button annotation in metadata extension

#### Adding Validations

1. Define validation in interface behavior definition
2. Implement validation in behavior implementation class
3. Specify when validation should trigger

## API

### OData Service Endpoints

Base URL: `https://<your-system>/sap/opu/odata4/sap/zdesk_ui_o4/srvd/sap/zdesk_sd/0001/`

#### Entities

- `/Ticket` - Ticket collection
- `/Item` - Item collection
- `/Comment` - Comment collection

#### Operations

- **GET** `/Ticket` - Retrieve all tickets
- **GET** `/Ticket(guid'...')` - Retrieve specific ticket
- **POST** `/Ticket` - Create new ticket
- **PATCH** `/Ticket(guid'...')` - Update ticket
- **DELETE** `/Ticket(guid'...')` - Delete ticket

Similar operations available for Items and Comments.

## Configuration

### Status Values

Recommended status values:
- New
- Open
- In Progress
- Pending
- Resolved
- Closed
- Cancelled

### Priority Values

Recommended priority values:
- Critical
- High
- Medium
- Low

### Categories

Example categories:
- Hardware
- Software
- Network
- Access
- Other

These can be customized based on your organization's needs.

## Troubleshooting

### Common Issues

**Issue**: Service binding activation fails
- **Solution**: Check that all dependent objects are activated

**Issue**: Fiori app displays no data
- **Solution**: Verify service is published and accessible

**Issue**: Unable to create tickets
- **Solution**: Check user authorizations for the service

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions:
- Create an issue in the GitHub repository
- Contact the development team

## Roadmap

Future enhancements planned:
- Email notifications
- SLA tracking
- Knowledge base integration
- Attachment support
- Dashboard and analytics
- Mobile app support

---

Built with ❤️ using SAP RAP Framework
