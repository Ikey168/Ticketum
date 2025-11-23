# Deployment Guide

This guide provides detailed instructions for deploying Deskulo to your SAP S/4HANA system.

## Prerequisites

### System Requirements

- SAP S/4HANA 2020 or later
- ABAP Platform (minimum version 7.54)
- SAP Fiori Frontend Server (optional, for Fiori Launchpad)
- SAP Gateway (embedded or standalone)

### User Requirements

- Development authorization (`S_DEVELOP`)
- Authorization to create database tables
- Authorization to publish OData services
- Authorization to configure Fiori apps (if using Launchpad)

### Tools Required

- ABAP Development Tools (ADT) in Eclipse
- abapGit plugin for Eclipse
- Git client (optional, for command line operations)
- Web browser (for testing Fiori UI)

## Installation Methods

### Method 1: Using abapGit (Recommended)

#### Step 1: Install abapGit

If not already installed:

1. Download abapGit from [abapGit.org](https://abapgit.org)
2. Import abapGit into your system
3. Activate all abapGit objects

#### Step 2: Create Package

1. Open ADT in Eclipse
2. Connect to your SAP system
3. Create a new package:
   - Name: `ZDESK` (or your preferred name)
   - Description: "Deskulo - IT Service Desk"
   - Software Component: `HOME` (or your local component)
   - Application Component: (as per your organization)

#### Step 3: Link Repository

1. In ADT, right-click on your package
2. Select "abapGit" → "Link to abapGit Repository"
3. Enter repository URL: `https://github.com/Ikey168/Ticketum.git`
4. Branch: `main`
5. Click "OK"

#### Step 4: Pull Objects

1. Open abapGit Repository view
2. Select your linked repository
3. Click "Pull"
4. Review objects to be imported
5. Click "Pull" to import

#### Step 5: Activate Objects

1. In ADT, navigate to your package
2. Select all objects
3. Right-click → "Activate"
4. Verify all objects are active (green light)

### Method 2: Manual Import

If abapGit is not available:

#### Step 1: Create Package

Same as Method 1, Step 2

#### Step 2: Create Database Tables

1. Create table `ZDESK_TICKET`:
   - Use XML file: `src/objects/TABL/zdesk_ticket.tabl.xml`
   - Or create manually in SE11

2. Create table `ZDESK_ITEM`:
   - Use XML file: `src/objects/TABL/zdesk_item.tabl.xml`

3. Create table `ZDESK_COMMENT`:
   - Use XML file: `src/objects/TABL/zdesk_comment.tabl.xml`

4. Activate all tables

#### Step 3: Create CDS Views

Create views in this order:

1. `ZI_DESK_TICKET` (Interface view)
2. `ZI_DESK_ITEM` (Interface view)
3. `ZI_DESK_COMMENT` (Interface view)
4. `ZC_DESK_TICKET` (Consumption view)
5. `ZC_DESK_ITEM` (Consumption view)
6. `ZC_DESK_COMMENT` (Consumption view)

Copy content from respective .ddls.asddls files

#### Step 4: Create Behavior Definitions

1. Create `ZI_DESK_TICKET` behavior definition
2. Create `ZC_DESK_TICKET` behavior definition (projection)
3. Copy content from .bdef.asbdef files

#### Step 5: Create Behavior Implementation

1. Create class `ZBP_I_DESK_TICKET`
2. Copy content from .clas.abap file
3. Implement required methods (if any)

#### Step 6: Create Service Definition

1. Create service definition `ZDESK_SD`
2. Copy content from .srvd.asrvd file

#### Step 7: Create Service Binding

1. Create service binding `ZDESK_UI_O4`
2. Binding Type: OData V4 - UI
3. Service Definition: `ZDESK_SD`

#### Step 8: Create Metadata Extensions

1. Create `ZC_DESK_TICKET` metadata extension
2. Create `ZC_DESK_ITEM` metadata extension
3. Create `ZC_DESK_COMMENT` metadata extension
4. Copy content from .ddlx.asddlxs files

#### Step 9: Activate All Objects

Activate in order to resolve dependencies

## Post-Installation Configuration

### Step 1: Publish Service

1. Open service binding `ZDESK_UI_O4` in ADT
2. Click "Publish" button
3. Wait for service to be published
4. Note the service URL

### Step 2: Test Service

1. In service binding, click "Preview"
2. Select entity set (e.g., "Ticket")
3. Browser should open with Fiori Elements preview
4. Try creating a test ticket

### Step 3: Configure Authorizations

Grant required authorizations to users:

```abap
* Service authorization
* Auth object: S_SERVICE
* Service: ZDESK_UI_O4

* CDS authorization (if using access control)
* Implement access control in CDS views
```

### Step 4: Configure Fiori Launchpad (Optional)

#### Create Tile

1. Open Fiori Launchpad Designer
2. Create new catalog
3. Add new tile:
   - Type: App
   - Title: "Deskulo Service Desk"
   - Subtitle: "Manage Support Tickets"
   - Icon: sap-icon://ticket
   
4. Configure navigation:
   - Semantic Object: `ZDesk`
   - Action: `manage`
   - URL: (OData service URL)

5. Assign catalog to roles

#### Configure Role

1. Transaction: PFCG
2. Create/modify role
3. Add Fiori catalog
4. Assign to users

## Verification

### Test Checklist

- [ ] All objects activated successfully
- [ ] Service binding published
- [ ] Can preview service in browser
- [ ] Can create a ticket
- [ ] Can add items to ticket
- [ ] Can add comments to ticket
- [ ] Can update ticket
- [ ] Can delete test data
- [ ] UI displays correctly
- [ ] All fields visible and editable
- [ ] Navigation works (ticket → items → comments)
- [ ] OData API accessible

### Test Data

Create test data to verify functionality:

```
Ticket 1:
- Title: "Test Ticket 1"
- Description: "Test description"
- Status: "Open"
- Priority: "High"
- Category: "Software"

Item 1 (for Ticket 1):
- Type: "Laptop"
- Description: "Dell Latitude"
- Quantity: 1

Comment 1 (for Ticket 1):
- Text: "Test comment"
- Type: "Note"
- Is Internal: No
```

## Troubleshooting

### Issue: Objects Won't Activate

**Cause**: Missing dependencies

**Solution**: 
- Activate in order: Tables → Interface Views → Consumption Views → Behavior Definitions
- Check error log for specific missing objects
- Ensure all required objects exist

### Issue: Service Won't Publish

**Cause**: Behavior definition errors

**Solution**:
- Check behavior implementation class exists
- Verify all mappings in behavior definition
- Check for syntax errors

### Issue: No Data Displayed in UI

**Cause**: Authorization or data issues

**Solution**:
- Check user has authorization
- Verify service is published
- Test OData service directly
- Check if tables contain data

### Issue: Fiori App Won't Load

**Cause**: Gateway or Fiori configuration

**Solution**:
- Verify Gateway service is running
- Check Fiori configuration in transaction /IWFND/MAINT_SERVICE
- Clear browser cache
- Check for JavaScript errors in browser console

## Uninstallation

To remove Deskulo:

1. Delete service binding `ZDESK_UI_O4`
2. Delete service definition `ZDESK_SD`
3. Delete metadata extensions
4. Delete behavior definitions
5. Delete CDS views
6. Delete behavior implementation class
7. Delete database tables (after backing up data!)
8. Delete package (if dedicated package was used)

**Warning**: Deleting database tables will permanently delete all ticket data!

## Upgrade

To upgrade to a new version:

### Using abapGit

1. Open abapGit repository
2. Click "Pull"
3. Review changes
4. Pull new version
5. Activate updated objects
6. Test functionality

### Manual Upgrade

1. Export existing data (if needed)
2. Note customizations
3. Import new version
4. Reapply customizations
5. Import data
6. Test thoroughly

## Backup

Before major changes:

1. Export data from tables:
   - ZDESK_TICKET
   - ZDESK_ITEM
   - ZDESK_COMMENT

2. Export object versions via ADT
3. Backup via abapGit (commit to Git)

## Support

For deployment issues:
- Check DOCUMENTATION.md
- Review troubleshooting section
- Open issue on GitHub
- Contact SAP Basis team

## Next Steps

After successful deployment:
- Configure status values
- Configure priority values
- Define categories
- Set up user roles
- Train users
- Create user documentation
- Plan go-live

---

For questions or issues, please refer to the main DOCUMENTATION.md or open an issue on GitHub.
