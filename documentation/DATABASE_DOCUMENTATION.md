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
- Four triggers
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
The sample password_hash values are temporary placeholders.
The backend developer must replace them with secure password hashes before implementing login.

## Team Workflow
Database: Rutika
Frontend: Basamma
Backend and Testing: Khushi

# GATE 0 – DATABASE / DATA & INTEGRITY CONTRIBUTION

## Database Purpose
The FreshFirst Team database maintains perishable product records, categories, users, verification records, follow-up actions and activity history. It supports data consistency, integrity and traceability.

## Database Scope
- Relational database using MySQL 9.1.0.
- Six related InnoDB tables.
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

- DB-NFR-01: All six core tables must use InnoDB.
- DB-NFR-02: Invalid foreign-key references must be rejected.
- DB-NFR-03: Product quantity must be greater than zero.
- DB-NFR-04: Usernames and category names must be unique.
- DB-NFR-05: Auditable activities must record the actor and timestamp.
- DB-NFR-06: Backups and a restoration check must be maintained.
- DB-NFR-07: Product-list and summary queries should meet the agreed performance target.

## Acceptance Criteria

1. All six tables exist and use InnoDB.
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

| Requirement | Database Component |
|---|---|
| User management | users |
| Product management | products |
| Category rules | categories |
| Verification | verifications |
| Follow-up actions | actions |
| Audit history | history |
| Relationships | Foreign keys |
| Data validation | CHECK and UNIQUE constraints |
| Activity logging | Triggers |
| Verification logic | Stored procedures |
| Efficient retrieval | Indexes |
| Transaction safety | InnoDB |

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
- Acting user ID.
- Activity or transaction type.
- Relevant details.
- Activity timestamp.

History references must remain valid, and normal update and deletion operations must be prevented.

Product insertion and update history triggers are present. Complete action-lifecycle audit coverage still requires implementation and testing.

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

The actions table was empty at the recorded checkpoint, so a complete saved action lifecycle cannot yet be demonstrated.

The three existing password values are temporary placeholders, not secure password hashes. Secure password hashing must be completed before login is considered production-ready.

## Database Conclusion

The FreshFirst Team database provides a relational foundation for perishable stock verification. Its six InnoDB tables, eight foreign keys, two unique constraints, three CHECK constraints, four triggers and two stored procedures support database integrity and traceability.

Selected structural, functional and transaction tests have been documented. Further work is required for complete action auditing, secure password storage and remaining transaction workflows.

