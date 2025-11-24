# Ticketum

Ticketum is a minimalist IT service desk application built for S/4HANA. It serves as a reference implementation for a modern ABAP stack, utilizing the **ABAP RESTful Application Programming Model (RAP)**, **CDS View Entities**, and **SAP Fiori Elements** (OData V4).

The application manages the lifecycle of IT support tickets, allowing users to create tickets, add work items, log comments, and transition tickets through various statuses (Open → In Progress → Resolved → Closed).

## Key Features

*   **Ticket Management**: Create, read, update, and delete support tickets.
*   **Lifecycle Workflow**: Managed status transitions with specific business logic (e.g., cannot edit closed tickets).
*   **Sub-entities**:
    *   **Items**: Track planned vs. actual effort for specific tasks within a ticket.
    *   **Comments**: specific text log for communication history.
*   **Validations & Determinations**:
    *   Automatic ID generation (Early Numbering).
    *   Audit trail (Created By/At, Changed By/At).
    *   Status-based validation logic.
*   **User Interface**:
    *   Fiori Elements List Report & Object Page.
    *   Draft support for interruptible work.
    *   Responsive design.

## Technical Stack

### Backend (ABAP)
*   **Model**: ABAP RESTful Application Programming Model (RAP) - Managed Scenario.
*   **Data Modeling**: CDS View Entities (`Z_I_Ticket`, `Z_I_TicketItem`, `Z_I_TicketComment`).
*   **Behavior**: ABAP Behavior Definitions (BDEF) & Implementation Classes (`ZBP_I_TICKET`).
*   **Service Exposure**: OData V4 via Service Definition and Service Binding.
*   **Persistence**: Transparent tables (`ZTICKET_HDR`, `ZTICKET_ITM`, `ZTICKET_CMT`).

### Frontend (SAPUI5)
*   **Framework**: SAPUI5 / Fiori Elements.
*   **Pattern**: List Report / Object Page.
*   **Tooling**: SAP Fiori Tools, UI5 Tooling.

## Installation

### Backend (ABAP System)
1.  Install **abapGit** on your SAP system.
2.  Create a new offline or online repository.
3.  Clone this repository: `https://github.com/Ikey168/Ticketum.git`
4.  Pull the objects into your package (`ZPKG_TICKETUM`).
5.  Activate all objects.
6.  Publish the Service Binding `ZUI_TICKETUM_O4`.

### Frontend (Local Development)
1.  Ensure you have **Node.js** and **npm** installed.
2.  Navigate to the Fiori project folder:
    ```bash
    cd TicketumFiori
    ```
3.  Install dependencies:
    ```bash
    npm install
    ```
4.  Run the application locally (requires connection to ABAP backend):
    ```bash
    npm start
    ```

## Testing

### ABAP Unit
The project includes ABAP Unit tests for the persistence layer and RAP business object logic.
*   Run tests via ADT (ABAP Development Tools) on `Z_TICKETUM_SMOKE_TEST` or the behavior classes.

### UI Integration Tests
The Fiori application includes OPA5 integration tests.
1.  Navigate to `TicketumFiori`.
2.  Run the tests:
    ```bash
    npm run test
    ```

## Project Structure

```text
Ticketum/
├── src/                        # ABAP Source Code (CDS, Classes, Tables)
├── TicketumFiori/              # SAPUI5 Fiori Elements Application
│   ├── webapp/
│   │   ├── manifest.json       # App Descriptor
│   │   └── test/               # OPA5 Tests
│   ├── package.json            # NPM dependencies
│   └── ui5.yaml                # UI5 Tooling config
├── .abapgit.xml                # abapGit configuration
└── README.md                   # Project Documentation
