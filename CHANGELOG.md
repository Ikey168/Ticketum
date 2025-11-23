# Changelog

All notable changes to the Deskulo project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-23

### Added
- Initial implementation of Deskulo IT Service Desk
- Database tables for Tickets, Items, and Comments
- CDS Interface Views for data model
- CDS Consumption Views for projection
- Behavior Definitions for managed RAP implementation
- Service Definition and Service Binding (OData V4)
- Fiori UI annotations via Metadata Extensions
- Comprehensive documentation (README and DOCUMENTATION)
- abaplint configuration for code quality
- abapGit configuration for version control

### Features
- Ticket Management with full CRUD operations
- Item tracking with parent-child composition
- Comment system with internal/external visibility
- Status and priority tracking
- Category management
- User assignment (requester/assignee)
- Automatic audit trail (created/changed by/at)
- Fiori Elements UI with responsive design
- OData V4 RESTful API

### Structure
- 3 Database tables
- 6 CDS views (3 interface + 3 consumption)
- 2 Behavior definitions
- 1 Service definition
- 1 Service binding
- 3 Metadata extensions
- 1 Behavior implementation class

[1.0.0]: https://github.com/Ikey168/Ticketum/releases/tag/v1.0.0
