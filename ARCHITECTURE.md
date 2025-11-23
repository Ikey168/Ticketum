# Deskulo Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         SAP Fiori Launchpad                      │
│                    (User Interface Layer)                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ HTTP/HTTPS
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                     OData V4 Service Binding                     │
│                        (ZDESK_UI_O4)                            │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐   │
│  │              Service Definition (ZDESK_SD)              │   │
│  │  - Exposes: Ticket, Item, Comment                      │   │
│  └────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                    Consumption Layer (ZC_*)                      │
│                  (Projection / UI Consumption)                   │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │  ZC_DESK_TICKET  │  │  ZC_DESK_ITEM    │  │ ZC_DESK_     │ │
│  │   (Projection)   │  │   (Projection)   │  │   COMMENT    │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │            Metadata Extensions (UI Annotations)           │  │
│  │  - List Reports   - Object Pages   - Field Arrangements  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │         Projection Behavior Definition (ZC)              │  │
│  │  - use create, update, delete                            │  │
│  │  - use associations                                      │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                    Business Object Layer (ZI_*)                  │
│                  (Interface / Core Data Model)                   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                  ZI_DESK_TICKET (Root)                    │  │
│  │  - UUID Key                                               │  │
│  │  - Business Data (Title, Description, Status, Priority)  │  │
│  │  - Audit Fields (Created/Changed By/At)                  │  │
│  │                                                            │  │
│  │  ┌─────────────────────────────────────────────────┐     │  │
│  │  │      Composition [0..*] ZI_DESK_ITEM            │     │  │
│  │  │  - Item Type, Description, Status, Quantity     │     │  │
│  │  │  - Association to Parent                         │     │  │
│  │  └─────────────────────────────────────────────────┘     │  │
│  │                                                            │  │
│  │  ┌─────────────────────────────────────────────────┐     │  │
│  │  │      Composition [0..*] ZI_DESK_COMMENT         │     │  │
│  │  │  - Comment Text, Type, Is Internal              │     │  │
│  │  │  - Association to Parent                         │     │  │
│  │  └─────────────────────────────────────────────────┘     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │      Managed Behavior Definition (ZI)                    │  │
│  │  - CRUD Operations (Create, Read, Update, Delete)        │  │
│  │  - Field Numbering (Managed)                             │  │
│  │  - Etag Master (Optimistic Locking)                      │  │
│  │  - Authorization (Master/Dependent)                      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │       Behavior Implementation (ZBP_I_DESK_TICKET)        │  │
│  │  - Minimal for Managed Scenario                          │  │
│  │  - Can add: Validations, Determinations, Actions         │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                      Persistence Layer                           │
│                     (Database Tables)                            │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │  ZDESK_TICKET    │  │  ZDESK_ITEM      │  │  ZDESK_      │ │
│  │                  │  │                  │  │  COMMENT     │ │
│  │ - CLIENT (Key)   │  │ - CLIENT (Key)   │  │ - CLIENT     │ │
│  │ - TICKET_UUID    │  │ - ITEM_UUID      │  │ - COMMENT_   │ │
│  │   (Key)          │  │   (Key)          │  │   UUID (Key) │ │
│  │ - TICKET_ID      │  │ - TICKET_UUID    │  │ - TICKET_    │ │
│  │ - TITLE          │  │   (FK)           │  │   UUID (FK)  │ │
│  │ - DESCRIPTION    │  │ - ITEM_ID        │  │ - COMMENT_   │ │
│  │ - STATUS         │  │ - ITEM_TYPE      │  │   TEXT       │ │
│  │ - PRIORITY       │  │ - DESCRIPTION    │  │ - COMMENT_   │ │
│  │ - CATEGORY       │  │ - STATUS         │  │   TYPE       │ │
│  │ - REQUESTER      │  │ - QUANTITY       │  │ - IS_        │ │
│  │ - ASSIGNEE       │  │ - Audit Fields   │  │   INTERNAL   │ │
│  │ - Audit Fields   │  │                  │  │ - Audit      │ │
│  │                  │  │                  │  │   Fields     │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│                                                                  │
│                    SAP HANA Database                             │
└──────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Read Operation (GET)
```
User Request
    ↓
Fiori Launchpad
    ↓
OData Service (ZDESK_UI_O4)
    ↓
Service Definition (ZDESK_SD)
    ↓
Consumption View (ZC_DESK_TICKET)
    ↓
Interface View (ZI_DESK_TICKET)
    ↓
Database Table (ZDESK_TICKET)
    ↓
HANA Database
    ↓
← Data returned through stack ←
    ↓
User sees Ticket in Fiori UI
```

### Create Operation (POST)
```
User Input (Create Ticket)
    ↓
Fiori Elements Form
    ↓
OData POST Request
    ↓
Behavior Definition (Managed)
    ↓
Behavior Implementation (if needed)
    ↓
Automatic UUID Generation
    ↓
Database Insert (ZDESK_TICKET)
    ↓
Audit Fields Auto-populated
    ↓
← Success Response ←
    ↓
UI Updated with New Ticket
```

## Component Relationships

```
┌─────────────────────────────────────────────────────────┐
│                   ZDESK_TICKET (Parent)                  │
│  TicketUUID, TicketID, Title, Description, Status, etc. │
└──────────────────┬──────────────────┬───────────────────┘
                   │                  │
         ┌─────────┴─────────┐       │
         │                   │       │
         │ Composition [0..*]│       │ Composition [0..*]
         │                   │       │
         ▼                   │       ▼
┌─────────────────┐          │  ┌─────────────────┐
│  ZDESK_ITEM     │          │  │ ZDESK_COMMENT   │
│  (Child)        │          │  │ (Child)         │
├─────────────────┤          │  ├─────────────────┤
│ ItemUUID        │          │  │ CommentUUID     │
│ TicketUUID (FK) │◄─────────┼──│ TicketUUID (FK) │
│ ItemType        │          │  │ CommentText     │
│ Description     │          │  │ CommentType     │
│ Status          │          │  │ IsInternal      │
│ Quantity        │          │  └─────────────────┘
└─────────────────┘          │
         │                   │
         │  Association      │
         │  to Parent        │
         └───────────────────┘
```

## Technology Stack Layers

```
┌──────────────────────────────────────────┐
│         Presentation Layer               │
│  SAP Fiori Elements (Auto-generated UI) │
│  - List Report                           │
│  - Object Page                           │
│  - Responsive Design                     │
└──────────────────────────────────────────┘
                   ↕
┌──────────────────────────────────────────┐
│          Service Layer                   │
│  OData V4 Protocol                       │
│  RESTful API                             │
│  JSON/XML Response                       │
└──────────────────────────────────────────┘
                   ↕
┌──────────────────────────────────────────┐
│       Business Logic Layer               │
│  ABAP RAP (Managed Scenario)             │
│  - Automatic CRUD                        │
│  - Transactional Consistency             │
│  - Authorization                         │
└──────────────────────────────────────────┘
                   ↕
┌──────────────────────────────────────────┐
│          Data Model Layer                │
│  CDS Views                               │
│  - Interface Views (ZI_*)                │
│  - Consumption Views (ZC_*)              │
│  - Associations & Compositions           │
└──────────────────────────────────────────┘
                   ↕
┌──────────────────────────────────────────┐
│       Persistence Layer                  │
│  Database Tables (ZDESK_*)               │
│  SAP HANA Database                       │
└──────────────────────────────────────────┘
```

## Key Features Per Layer

### UI Layer (Fiori Elements)
- ✅ Auto-generated based on annotations
- ✅ Responsive design
- ✅ Search and filter
- ✅ Sort and pagination
- ✅ CRUD operations
- ✅ Navigation

### Service Layer (OData V4)
- ✅ RESTful endpoints
- ✅ $expand for associations
- ✅ $filter for queries
- ✅ $orderby for sorting
- ✅ CRUD operations
- ✅ Batch operations

### Business Logic (RAP)
- ✅ Managed CRUD
- ✅ Transactional handling
- ✅ Optimistic locking
- ✅ Authorization checks
- ✅ Validation framework
- ✅ Draft handling (can be enabled)

### Data Model (CDS)
- ✅ View entities
- ✅ Associations
- ✅ Compositions
- ✅ Semantic annotations
- ✅ Access control (can be added)

### Database Layer
- ✅ HANA optimized
- ✅ Client handling
- ✅ UUID keys
- ✅ Audit trail
- ✅ Referential integrity

## Deployment Flow

```
GitHub Repository
       ↓
   abapGit Pull
       ↓
SAP S/4HANA System
       ↓
Object Activation
       ↓
Service Publishing
       ↓
Fiori Launchpad Configuration
       ↓
User Access
```

## Extension Points

```
Current Implementation
        ↓
    ┌───┴────────────────────────────┐
    │                                │
    ▼                                ▼
Custom Actions                  Validations
(e.g., Escalate)         (e.g., Status checks)
    │                                │
    ▼                                ▼
Determinations                  Value Helps
(e.g., Auto-assign)      (e.g., Dropdowns)
    │                                │
    └─────────┬──────────────────────┘
              ▼
      Enhanced Application
```

---

This architecture follows SAP's best practices for ABAP RAP development and provides a solid foundation for an enterprise-grade IT service desk application.
