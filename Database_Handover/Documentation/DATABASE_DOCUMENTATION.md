# Fresh First – Database Documentation

## Database Name
freshfirst_team

## Database Engine
MySQL

## Tables

### 1. users
Stores user details and roles.
- user_id
- full_name
- username
- password_hash
- role
- created_at

### 2. categories
Stores product categories and storage rules.
- category_id
- category_name
- min_storage_temp
- max_storage_temp
- near_expiry_days

### 3. products
Stores perishable product information.
- product_id
- product_name
- category_id
- quantity
- unit
- purchase_date
- expiry_date
- storage_temperature
- created_by
- created_at

### 4. verifications
Stores product verification results.
- verification_id
- product_id
- verified_by
- actual_temperature
- verification_status
- remarks
- verified_at

### 5. actions
Stores actions assigned to products.
- action_id
- product_id
- assigned_to
- action_type
- priority
- action_status
- description
- created_at
- completed_at

### 6. history
Stores product activity records.
- history_id
- product_id
- user_id
- activity
- details
- activity_time

### 7. action_history
Stores action creation and status-change audit records.
- action_history_id
- action_id
- actor_user_id
- event_type
- old_status
- new_status
- event_details
- event_at

## User Roles
- ADMIN
- MANAGER
- STAFF

## Action Priorities
- CRITICAL
- HIGH
- MEDIUM
- LOW
- INSPECTION

## Database Features
- Primary keys and foreign keys
- Unique constraints
- Database indexes for efficient data retrieval
- Eleven triggers covering product history, action lifecycle auditing, history protection and stock movement auditing.
- Stored procedure: verify_product (expiry and storage condition verification)
- Stored procedure: verify_product_temperature (actual temperature verification and result recording)
- History update and delete protection

## Sample Data
- 3 users
- 4 categories
- 5 products
- 1 verification record
- 1 history record

## Important Note
The original sample SQL data used temporary password placeholders. On 22 November 2026, secure Werkzeug scrypt password hashes were generated and saved for the ADMIN, MANAGER and STAFF accounts in the live freshfirst_team database. Application login integration testing remains pending.

## Team Workflow
Database: Rutika
Frontend: Basamma
Backend and Testing: Khushi

# GATE 0 – DATABASE / DATA & INTEGRITY CONTRIBUTION

## Database Purpose
The FreshFirst Team database maintains perishable product records, categories, users, verification records, follow-up actions and activity history. It supports data consistency, integrity and traceability.

## Database Scope
- Relational database using MySQL 9.1.0.
- Seven related InnoDB tables.
- Primary keys and foreign keys.
- Unique and CHECK constraints.
- Database triggers and stored procedures.
- Indexes for efficient retrieval.
- Transaction and rollback support.
- Database integrity verification.

## Database Tables
1. users – user accounts and roles.
2. categories – product categories and storage rules.
3. products – product details, quantity, expiry and temperature.
4. verifications – product verification records.
5. actions – follow-up actions and priorities.
6. history – product activity and audit records.
7. action_history – action lifecycle audit records.

## Identified Limitation (B1)
The database cannot independently prove that physical stock quantity matches the quantity recorded in the system. Staff must physically count the stock, compare it with the database quantity and record any mismatch for review.

## Database Feasibility
MySQL 9.1.0 supports relational tables, constraints, transactions, triggers, stored procedures and indexes required for this project.

# GATE 1 – DATABASE REQUIREMENTS BASELINE

## Functional Requirements

| ID | Requirement |
|---|---|
| DB-FR-01 | Store user accounts and roles. |
| DB-FR-02 | Maintain product records. |
| DB-FR-03 | Maintain product-category relationships. |
| DB-FR-04 | Support product insertion and permitted updates. |
| DB-FR-05 | Support expiry-date calculations. |
| DB-FR-06 | Compare product temperature with category limits. |
| DB-FR-07 | Store verification records linked to products and users. |
| DB-FR-08 | Store follow-up actions, priorities and statuses. |
| DB-FR-09 | Maintain product activity history. |
| DB-FR-10 | Support database reports and integrity checks. |
| DB-FR-11 | Protect history against normal update and deletion. |
| DB-FR-12 | Maintain consistency using constraints and transactions. |

## Non-Functional Requirements

- DB-NFR-01: All eight database tables must use InnoDB.
- DB-NFR-02: Invalid foreign-key references must be rejected.
- DB-NFR-03: Product quantity must be greater than zero.
- DB-NFR-04: Usernames and category names must be unique.
- DB-NFR-05: Auditable activities must record the actor and timestamp.
- DB-NFR-06: Backups and a restoration check must be maintained.
- DB-NFR-07: Product-list and summary queries should meet the agreed performance target.

## Acceptance Criteria

1. All eight tables exist and use InnoDB.
2. Every table has a primary key.
3. Invalid foreign-key references are rejected.
4. Duplicate usernames and category names are rejected.
5. Zero or negative quantities are rejected.
6. Invalid category temperature ranges are rejected.
7. Product insertion and updates generate history records.
8. History update and deletion are prevented.
9. Verification records reference valid products and users.
10. Stored procedures execute with expected results.
11. Transaction rollback restores the original database state.
12. Integrity queries identify invalid records.

## User Stories

- Administrator: Maintain user and product records consistently.
- Manager: Review expiry and temperature information.
- Staff: Save verification records for the correct product.
- Inventory reviewer: Access product activity history.

## Requirements Traceability

### Functional Requirements

| Requirement ID | Requirement | Database Component | Testing Evidence | Status |
|---|---|---|---|---|
| DB-FR-01 | Store user accounts and roles | users | Three unique usernames and ADMIN, MANAGER, STAFF roles verified; secure password hashes are stored for all three accounts; application login integration testing remains pending | PARTIAL |
| DB-FR-02 | Maintain product records | products | Sections 3, 5 and Final Database Integrity Verification | PASS |
| DB-FR-03 | Maintain product-category relationships | products, categories, foreign keys | Section 4 – Constraint Testing | PASS |
| DB-FR-04 | Support product insertion and permitted updates | products, product triggers | Section 3 – Trigger Testing | PASS |
| DB-FR-05 | Support expiry-date calculations | products, verify_product | Direct DATEDIFF and expiry-status calculation tested for all five products | PASS |
| DB-FR-06 | Compare product temperature with category limits | categories, verify_product_temperature | Section 2 and Verification Procedure Input Validation | PASS |
| DB-FR-07 | Store verification records linked to products and users | verifications, foreign keys | Verification Procedure Input Validation | PASS |
| DB-FR-08 | Store follow-up actions, priorities and statuses | actions, action_history | Sections 9–10 and Actor Identification Testing | PASS |
| DB-FR-09 | Maintain product activity history | history, product triggers | Section 3 – Trigger Testing | PASS |
| DB-FR-10 | Support database reports and integrity checks | Database queries, indexes and integrity checks | Product stock, category summary and temporary action reporting tests returned expected results | PASS |
| DB-FR-11 | Protect history against normal update and deletion | History protection triggers | Sections 3 and 9 | PASS |
| DB-FR-12 | Maintain consistency using constraints and transactions | InnoDB, constraints and transactions | Sections 4–5 and Transaction Testing | PASS |

### Non-Functional Requirements

| Requirement ID | Requirement | Database Component | Testing Evidence | Status |
|---|---|---|---|---|
| DB-NFR-01 | All eight database tables must use InnoDB | Eight database tables | Section 8 and Final Database Integrity Verification | PASS |
| DB-NFR-02 | Invalid foreign-key references must be rejected | Foreign keys | Section 4 – Constraint Testing | PASS |
| DB-NFR-03 | Product quantity must be greater than zero | CHECK constraint | CHECK Constraint Negative Testing | PASS |
| DB-NFR-04 | Usernames and category names must be unique | UNIQUE constraints | Duplicate category and duplicate username rejection tested | PASS |
| DB-NFR-05 | Auditable activities must record the actor and timestamp | history, action_history and triggers | Action Audit Actor Identification Testing | PASS WITH LIMITATION |
| DB-NFR-06 | Backups and a restoration check must be maintained | MySQL backup | Latest isolated restoration verified; 8 tables, 11 triggers, 3 stored procedures, 12 foreign keys and 23 records matched | PASS |
| DB-NFR-07 | Product-list and summary queries should meet the agreed performance target | Indexes and database queries | NFR-07 query execution and index verification; formal target not established | PARTIAL |

**Note:** PARTIAL indicates that implementation or some supporting evidence exists, but the complete requirement has not yet been demonstrated. Actor attribution also depends on the application-controlled database session variable.

## B1 – Transaction Types and Stock Effects

| Transaction | Stock Effect | Required Information |
|---|---|---|
| Stock received | Increase (+Q) | Product, quantity, user and time |
| Stock adjustment | Increase or decrease | Old quantity, new quantity, reason and user |
| Product verification | No quantity change | Temperature, status, remarks and verifier |
| Action assignment/status update | No quantity change | Action, priority, status and assigned user |
| Stock disposal/removal | Decrease (-Q) | Product, quantity, reason and authorized user |

These are required business rules; they do not mean every transaction type has already been implemented or tested.

## B2 – Never-Break Database Rules

1. Product quantity must never be zero or negative.
2. Product records must reference valid categories.
3. Verification records must reference valid products and users.
4. Action records must reference valid products and assigned users.
5. History records must reference valid products and users.
6. Duplicate usernames and category names are not allowed.
7. Category minimum temperature must not exceed maximum temperature.
8. Near-expiry days must not be negative.
9. History records must not be modified or deleted through normal operations.
10. Transactions must preserve consistency when rolled back.

## B3 – Audit Trail Acceptance Criteria

Each auditable operation should record:
- Unique history ID.
- Related product ID.
- Acting user ID, where available.
- Activity or transaction type.
- Relevant details.
- Activity timestamp.

History references must remain valid, and normal update and deletion operations must be prevented.

Product insertion and update history triggers are present. Action lifecycle auditing is implemented through action_history triggers. Actor attribution depends on the authenticated application setting and controlling the actor session variable.

## Current Database Verification – 18 November 2026

| Verification | Result |
|---|---:|
| Total tables | 6 |
| InnoDB tables | 6 |
| Primary keys | 6 |
| Foreign keys | 8 |
| Unique constraints | 2 |
| CHECK constraints | 3 |
| Triggers | 4 |
| Stored procedures | 2 |

Tables: actions, categories, history, products, users and verifications.

Stored procedures: verify_product and verify_product_temperature.

Triggers: history update prevention, history deletion prevention, product insertion history and product update history.

## Database Testing Summary

The database testing report documents:
- Foreign-key validation.
- Duplicate-value rejection.
- Quantity validation.
- History update and deletion protection.
- Product insertion and update history generation.
- Stored procedure execution.
- Transaction rollback.
- Index verification.

The temperature verification procedure executed successfully. A rollback test confirmed that the temporary verification record was not retained.

At the 18 November 2026 checkpoint, the actions table was empty, so a complete saved action lifecycle could not yet be demonstrated. Action lifecycle testing was completed and documented in the subsequent 19 November 2026 verification.

At the 19 November 2026 checkpoint, the password values were temporary placeholders. This was updated on 22 November 2026: secure Werkzeug scrypt password hashes were saved for all three user accounts and verified using check_password_hash(). Application login integration testing remains pending.

## Database Conclusion

The FreshFirst Team database provides a relational foundation for perishable stock verification. Its eight InnoDB tables, twelve foreign keys, two unique constraints, four CHECK constraints, eleven triggers and three stored procedures support database integrity and traceability.

Selected structural, functional and transaction tests have been documented. Action lifecycle auditing and its tested controls are documented in the 19 November 2026 verification. Secure password hashes were generated, saved and verified on 22 November 2026. Remaining work includes application login integration and further application-level transaction testing. Backup restoration was successfully tested on 19 November 2026.


## Historical Database Verification — 19 November 2026 (superseded by the 27 November update)

The following figures reflect the current verified database structure. The earlier 18 November verification summary above is retained as a historical checkpoint.

| Verification | Current Result |
|---|---:|
| Database tables | 7 |
| InnoDB tables | 7 |
| Primary keys | 7 |
| Foreign keys | 10 |
| Unique constraints | 2 |
| CHECK constraints | 4 |
| Triggers | 10 |
| Stored procedures | 2 |
| Total indexes | 24 |
| Tables with indexes | 7 |
| Orphan product records | 0 |

### Current Database Tables

1. users
2. categories
3. products
4. verifications
5. actions
6. history
7. action_history

### Action Lifecycle and Audit Trail

The action_history table records action creation and status changes, including the acting user where available, event type, old status, new status and event timestamp.

Action statuses are PENDING, IN_PROGRESS and DONE. Completion timestamps are maintained using database triggers and a CHECK constraint.

Normal UPDATE and DELETE operations on action_history are prevented by database triggers.

### Current Trigger Coverage

The database contains 11 triggers covering:

- Product insertion and update history.
- History update and deletion protection.
- Action insertion and update validation.
- Action lifecycle audit logging.
- Action history update and deletion protection.
- Automatic stock movement auditing after quantity updates.

### Current Stored Procedures

1. verify_product
2. verify_product_temperature
3. sp_update_product_quantity_with_audit

The two verification procedures have been tested, including invalid product IDs, invalid user IDs and temperature validation. The stock quantity audit procedure validates quantity, actor and reason before updating stock.

### Transaction Verification

COMMIT and ROLLBACK operations were tested successfully on 19 November 2026. The original Fresh Milk quantity was restored to 20 after testing.

### Remaining Limitations

- Secure password hashes are stored for all three user accounts. Full application login integration testing remains pending.
- The database cannot independently verify physical stock quantities without staff physically counting stock.
- The actor session variable used for action auditing must be controlled by the authenticated application; it is not independent authentication.
- Further testing is required for complete application-level transaction workflows.





### NFR-06 – Database Backup Verification (19 November 2026)

A database backup was successfully exported using MySQL Workbench.

| Verification | Result |
|---|---|
| Backup file | freshfirst_team_backup.sql |
| Backup location | database/freshfirst_team_backup.sql |
| File size | 28,095 bytes |
| Tables exported | 7 of 7 |
| Stored procedures | Included |
| Events and triggers | Selected for export |
| Backup export | SUCCESS |
| Restoration test | SUCCESSFUL - 19 November 2026 |

The backup was restored successfully into the separate freshfirst_team_restore_test database. Seven tables, ten triggers and two stored procedures were verified after restoration.

### NFR-07 – Database Query Performance Verification (19 November 2026)

Three database queries were executed using EXPLAIN ANALYZE in MySQL Workbench.

| Test | Query | Observed Execution Time | Result |
|---|---|---:|---|
| 1 | Product-category JOIN | Approximately 1.42 ms | PASS |
| 2 | Category summary and aggregation | Approximately 0.49 ms | PASS |
| 3 | Product lookup by category | Approximately 0.056 ms | PASS |

### Index Usage Verification

- The product-category JOIN used the category_name index and idx_products_category.
- The category summary query completed aggregation using a temporary table.
- The category lookup used idx_products_category.

All three queries executed successfully.

**Limitation:** The formal performance acceptance target has not yet been established. These results demonstrate successful query execution and index usage, not compliance with an agreed response-time target.

## Gate 1 – B1: Stock Transaction Baseline

The following transaction types define the expected effect on stock quantity.

| Transaction type | Expected stock quantity effect | Database evidence / rule |
|---|---|---|
| Product received or added | Increase by received quantity | Product record insertion |
| Stock quantity correction | Increase or decrease by the difference | Product update and audit history |
| Product verification | No quantity change | Verification record |
| Action assignment or status change | No quantity change | Action and action-history records |
| Product disposal or removal | Decrease by approved quantity, if implemented | Requires an authorised stock adjustment operation |

**Integrity requirements:**
1. Stock quantity must remain greater than zero for active product records.
2. Product references must point to valid categories.
3. Verification and action records must reference valid parent records.
4. Auditable changes must identify the actor, activity and timestamp.
5. Verification and action status changes must not silently modify stock quantity.

**Implementation note:** This baseline documents the expected transaction behaviour. Each operation must be tested before it is declared fully implemented.

## Gate 1 – A3: Database Acceptance Criteria

The following criteria define the expected database behaviour for each functional requirement. Status reflects the available database evidence; application-level integration is assessed separately.

| Requirement | Acceptance criterion | Testing method / Evidence | Status |
|---|---|---|---|
| DB-FR-01 – User accounts and roles | Each username must be unique. Each account must have a valid role, and passwords must be stored as secure hashes rather than plain text. | Unique constraint, role records and password-hash verification. Application login integration remains pending. | PARTIAL |
| DB-FR-02 – Product records | Product records must store the required product information and maintain valid product data. | Product table inspection, product insertion and record verification tests. | PASS |
| DB-FR-03 – Product-category relationships | Every product must reference an existing category. Invalid category references must be rejected. | Foreign-key constraint inspection and integrity testing. | PASS |
| DB-FR-04 – Product insertion and updates | Valid products must be insertable, and permitted quantity updates must preserve database consistency. Invalid quantities must be rejected. | Product insertion, quantity update, CHECK constraint and transaction tests. | PASS |
| DB-FR-05 – Expiry-date calculations | Expiry status must be calculated correctly using the product expiry date and current date. | DATEDIFF and expiry-status calculation tests for the stored products. | PASS |
| DB-FR-06 – Temperature verification | A product's recorded storage temperature must be evaluated against its category's permitted temperature limits. | Temperature verification procedure tests, including valid and invalid temperature cases. | PASS |
| DB-FR-07 – Verification records | Each verification record must reference an existing product and valid verifying user. | Verification procedure tests and foreign-key checks. | PASS |
| DB-FR-08 – Follow-up actions | Actions must reference valid products and assigned users. Action status and completion timestamp must remain consistent. | Action lifecycle tests, foreign-key checks, CHECK constraints and trigger inspection. | PASS |
| DB-FR-09 – Product activity history | Auditable product changes must generate history records containing the relevant activity details, actor and timestamp. | Product update trigger test and recorded audit-history evidence. | PASS |
| DB-FR-10 – Reports and integrity checks | Database queries must return the expected product stock, category summary and action reporting results. | Product stock, category summary and temporary action reporting tests. | PASS |
| DB-FR-11 – History protection | Normal database operations must not allow protected history records to be updated or deleted. | History protection trigger tests for UPDATE and DELETE. | PASS |
| DB-FR-12 – Database consistency | Foreign keys, CHECK constraints, unique constraints and transactions must preserve valid database relationships and prevent invalid data. | Constraint tests, InnoDB verification and COMMIT/ROLLBACK tests. | PASS |

**A3 Result:** Acceptance criteria are explicitly defined for all 12 database functional requirements. DB-FR-01 remains PARTIAL because application login integration testing is pending. Complete application-level workflows require separate integration testing.
## Gate 1 – A5: Database Requirement Traceability

| Stakeholder need | Requirement | Database evidence |
|---|---|---|
| Secure user management | DB-FR-01 | users table, unique username constraint and role records |
| Product management | DB-FR-02 to DB-FR-04 | products table, category foreign key and integrity constraints |
| Stock verification | DB-FR-05 to DB-FR-07 | verifications table and verification procedures |
| Priority and action management | DB-FR-08 | actions table, priority and status constraints, action triggers |
| Product activity history | DB-FR-09 | history table and product activity triggers |
| Reporting | DB-FR-10 | Product stock, category summary and action reporting queries |
| Audit history protection | DB-FR-11 | History protection triggers preventing normal update and deletion |
| Database consistency | DB-FR-12 | InnoDB, foreign keys, CHECK constraints and transaction testing |

**Limitation:** Database evidence establishes the data structures and integrity mechanisms. Complete user-interface and application-level acceptance must be verified during integration.

## Gate 1 – Final Database Evidence Status
**Review date:** 19 November 2026

| Requirement | Current status | Evidence / remaining limitation |
|---|---|---|
| DB-FR-01 – User management | PARTIAL | Three unique usernames and all three valid roles verified. Secure password hashes are stored for all three accounts; application login integration testing remains pending. |
| DB-FR-02 to DB-FR-09 | PASS | Database structures, integrity rules, verification and action mechanisms documented and tested. |
| DB-FR-10 – Reporting | PASS | Product, category and action reporting tested. Temporary action reporting test returned the expected record and was rolled back. |
| DB-FR-11 to DB-FR-12 | PASS | Existing database requirement evidence retained. |
| DB-NFR-01 to DB-NFR-04 | PASS | Existing integrity, structure and database evidence retained. |
| DB-NFR-05 – Audit attribution | PASS WITH LIMITATION | Actor attribution depends on the application setting the database session variable. |
| DB-NFR-06 – Backup and recovery | PASS | Backup restored successfully into the separate test schema; original database preserved. |
| DB-NFR-07 – Query performance | PARTIAL | Query timings and index usage tested; no formal response-time target was established. |

### Additional Gate 1 evidence completed

- B1: Stock transaction baseline documented.
- A3: Database acceptance criteria documented.
- A5: Database requirement traceability documented.
- B2: Negative quantity and invalid category tests both rejected.
- B3: Product update generated an audit record; audit update and delete operations were blocked.
- Backup restoration: Seven tables, their records, stored procedures and ten triggers restored in the separate test schema.

**Review note:** PARTIAL requirements remain open until their stated limitations are addressed. Faculty review and approval are reserved for the faculty.

## Gate 1 – Authoritative Final Status Update
**Review date:** 19 November 2026

This final status supersedes earlier historical checkpoints in this document.

| Requirement | Final status | Reason |
|---|---|---|
| DB-FR-01 – User management and authentication | PARTIAL | Three unique usernames, three valid roles and password_hash VARCHAR(255) verified. Secure password hashes are stored for all three accounts; application login integration testing remains pending. |
| DB-FR-10 – Reporting | PASS | Product, category and action reporting queries tested successfully. |
| DB-NFR-05 – Audit attribution | PASS WITH LIMITATION | Actor attribution depends on the application setting the database session variable. |
| DB-NFR-06 – Backup and recovery | PASS | Backup restored successfully into a separate test schema. |
| DB-NFR-07 – Query performance | PARTIAL | Query timings and index usage tested; formal response-time target awaits faculty confirmation. |

All other database requirements retain their previously documented verified statuses.

**Gate 1 database evidence review:** Completed for the tests recorded in this documentation.

**Faculty decision and approval:** Pending faculty review.


## Gate 1 – DB-NFR-07: Final Query Index Verification

The following four query execution plans were checked using MySQL EXPLAIN.

| Table | Filter condition | Index used | Access type | Result |
|---|---|---|---|---|
| products | category_id = 1 | idx_products_category | ref | PASS |
| verifications | product_id = 1 | idx_verifications_product | ref | PASS |
| history | product_id = 1 | product_id | ref | PASS |
| actions | action_status = 'PENDING' | idx_actions_status | ref | PASS |

**Evidence result:** All four tested queries used indexes.

**Limitation:** DB-NFR-07 remains PARTIAL because a formal faculty-approved query response-time target has not yet been established. Index usage alone does not establish that a response-time target has been met.



# Database Completion Update – 22 November 2026

## 1. Secure Password Hashing
- Password hashes for ADMIN, MANAGER and STAFF accounts were generated using Werkzeug scrypt.
- Hashes were successfully saved in the `freshfirst_team` database.
- All three passwords passed Werkzeug `check_password_hash()` verification.
- Application login integration testing remains a separate validation step.

## 2. Category Image Path Support
- Added `image_path VARCHAR(255) NULL` to the `categories` table.
- Saved relative image paths for all four existing categories:
  - Bakery: `images/categories/bakery.jpg`
  - Dairy: `images/categories/dairy.jpg`
  - Fruits: `images/categories/fruits.jpg`
  - Vegetables: `images/categories/vegetables.jpg`
- Existing category records, temperature rules and expiry settings were preserved.
- Actual image files and frontend display integration remain pending with the frontend team.


# Current Database Update – 22 November 2026

## Secure Password Hashing
- ADMIN, MANAGER and STAFF password hashes were generated using Werkzeug scrypt.
- The hashes were successfully saved in `freshfirst_team`.
- All three passwords passed Werkzeug `check_password_hash()` verification.
- Full application login integration testing remains pending.

## Category Image Path Support
- Added `image_path VARCHAR(255) NULL` to the `categories` table.
- Bakery: `images/categories/bakery.jpg`
- Dairy: `images/categories/dairy.jpg`
- Fruits: `images/categories/fruits.jpg`
- Vegetables: `images/categories/vegetables.jpg`
- Existing category temperature rules and expiry settings were preserved.
- Actual image files and frontend integration remain pending with the frontend team.

This update supersedes earlier status statements where they conflict with the current implementation status. Historical records remain unchanged.

## Current Database Status Update - 23 November 2026

- Secure Werkzeug scrypt password hashes were generated and verified for the admin, manager1 and staff1 accounts on 22 November 2026.
- Application-level login integration testing remains pending with the backend.
- Backup restoration was tested separately using freshfirst_team_restore_test on 23 November 2026.
- The restoration comparison confirmed matching table counts, row counts, foreign-key counts, trigger counts, procedure counts, CHECK constraints, UNIQUE constraints, InnoDB tables and index counts.
- Actor attribution still depends on the application setting the database session variable.
- The faculty-approved query response-time target remains pending.

# Current Database Update – 26 November 2026

## Stock Movement Log

A Stock Movement Log feature was added to maintain an automatic record of product quantity changes.

### 1. New Database Table

Table name: `stock_movements`

| Column | Purpose |
|---|---|
| movement_id | Primary key |
| product_id | References products |
| previous_quantity | Quantity before update |
| new_quantity | Quantity after update |
| quantity_change | Difference in quantity |
| movement_type | STOCK_IN or STOCK_OUT |
| reason | Reason for the movement |
| changed_by | References users |
| changed_at | Movement timestamp |

### 2. Database Integrity

- Product reference is protected by a foreign key.
- User reference is protected by a foreign key.
- Product and date indexes support movement-history queries.
- The table uses the InnoDB storage engine.

### 3. Automatic Movement Trigger

Trigger: `trg_stock_movement_after_update`

Event: AFTER UPDATE ON products.

The trigger automatically inserts a movement record when the product quantity changes.

- Quantity increase: STOCK_IN.
- Quantity decrease: STOCK_OUT.
- Unchanged quantity: no movement record.

### 4. Testing Results – 26 November 2026

| Test | Result |
|---|---|
| STOCK_IN: 20 to 21 | PASS |
| STOCK_OUT: 21 to 20 | PASS |
| Previous quantity tracking | PASS |
| New quantity tracking | PASS |
| Quantity difference calculation | PASS |
| User ID recording | PASS |
| Timestamp recording | PASS |

### 5. Application Integration Limitation

Accurate actor attribution and movement reasons depend on the application setting:

- `@freshfirst_actor_user_id`
- `@freshfirst_movement_reason`

Application-level integration and testing remain pending.

**Overall Result:** The Stock Movement Log table and automatic quantity-change trigger were successfully tested at the database level.

Migration file: `database/stock_movement_log_migration.sql`
