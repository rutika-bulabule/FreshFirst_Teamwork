# Gate 1 – B2: Database Integrity Rules

**Project:** FreshFirst – Perishable Stock Verification Register  
**Engine:** Database / Data & Integrity  
**Database:** freshfirst_team  
**DBMS:** MySQL 9.1.0

## 1. Purpose

This document identifies database rules that must not be violated and records the constraints and triggers that enforce them.

## 2. Stock and Data Validation Rules

| ID | Rule | Database Enforcement |
|---|---|---|
| B2-01 | Product quantity must always be greater than zero. | CHECK constraint |
| B2-02 | Category minimum storage temperature must not exceed maximum temperature. | CHECK constraint |
| B2-03 | Near-expiry days must not be negative. | CHECK constraint |
| B2-04 | A completed action must have a completion timestamp. | CHECK constraint and trigger |
| B2-05 | Pending and in-progress actions must not have a completion timestamp. | CHECK constraint and trigger |
| B2-06 | Category names must be unique. | UNIQUE constraint |
| B2-07 | Usernames must be unique. | UNIQUE constraint |

## 3. Referential Integrity Rules

The database enforces these relationships through foreign keys:

| Child Table | Column | Referenced Table |
|---|---|---|
| action_history | action_id | actions |
| action_history | actor_user_id | users |
| actions | product_id | products |
| actions | assigned_to | users |
| history | product_id | products |
| history | user_id | users |
| products | category_id | categories |
| products | created_by | users |
| verifications | product_id | products |
| verifications | verified_by | users |

These constraints prevent invalid references to missing parent records.

## 4. Audit Trail Protection

The following triggers prevent modification or deletion of audit records:

- trg_history_prevent_update
- trg_history_prevent_delete
- trg_action_history_prevent_update
- trg_action_history_prevent_delete

The database raises an error when an update or deletion is attempted on these protected records.

## 5. Automatic Database Actions

The database also contains triggers that:

- Set completed_at when an action is marked DONE.
- Clear completed_at when an action is not DONE.
- Record product insertion and update events.
- Record action creation and status-change events.

## 6. Verified Database Integrity Evidence

| Database Feature | Verified Count |
|---|---:|
| InnoDB tables | 7 |
| CHECK constraints | 4 |
| UNIQUE constraints | 2 |
| Foreign-key constraints | 10 |
| Triggers | 10 |
| Stored procedures | 2 |

Stored procedures:
1. verify_product
2. verify_product_temperature

## 7. Evidence Limitations

- Database constraints and trigger definitions were inspected through information_schema and SHOW CREATE TABLE.
- Existing audit protection tests are documented in DATABASE_TESTING_REPORT.md.
- No dedicated transaction ledger or unique transaction-posting identifier has been verified. Therefore, prevention of duplicate business transaction postings is not yet demonstrated.
- Application-level authorization and complete application workflow enforcement require separate application testing.
- Foreign keys prevent orphan references in the existing tables; they do not independently prove a complete stock transaction workflow.
- Physical stock quantities still require staff verification.

## 8. Conclusion

The database contains verified CHECK, UNIQUE and FOREIGN KEY constraints, InnoDB tables, triggers and stored procedures to protect data integrity.

**B2 database integrity rules: Documented from verified database evidence.**

**Application-level evidence limitations: Recorded for review.**

