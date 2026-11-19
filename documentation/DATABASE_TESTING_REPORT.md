# Database Testing Report â€“ FreshFirst Team

**Date:** 18 November 2026
**Database:** freshfirst_team
**DBMS:** MySQL 9.1.0
**Environment:** Windows, MySQL Server 9.1.0 and MySQL Workbench

## 1. Testing Scope

The database was tested for stored procedures, triggers, primary keys, foreign keys, unique constraints, check constraints, indexes, transaction rollback, and storage-engine configuration.

## 2. Stored Procedure Testing

| Test | Expected Result | Actual Result | Status |
|---|---|---|---|
| verify_product(2) | Apple verification result | SAFE | PASS |
| verify_product(999) | No matching product row | Empty result | PASS |
| Temperature 5.00Â°C | SAFE | SAFE | PASS |
| Temperature 20.00Â°C | UNSAFE | UNSAFE | PASS |
| Lower boundary 4.00Â°C | SAFE | SAFE | PASS |
| Upper boundary 12.00Â°C | SAFE | SAFE | PASS |
| Below minimum 3.99Â°C | UNSAFE | UNSAFE | PASS |
| Above maximum 12.01Â°C | UNSAFE | UNSAFE | PASS |
| Invalid product ID 999 | Product not found error | Product not found | PASS |

Temperature verification tests used the category's configured minimum and maximum limits. Temporary test records were rolled back where applicable.

## 3. Trigger Testing

| Trigger | Test Performed | Result | Status |
|---|---|---|---|
| trg_history_prevent_update | Attempted to update a history record | Update blocked | PASS |
| trg_history_prevent_delete | Attempted to delete a history record | Delete blocked | PASS |
| trg_product_after_insert | Inserted a temporary product | PRODUCT ADDED history entry generated | PASS |
| trg_product_after_update | Updated a product temporarily | PRODUCT UPDATED history entry generated | PASS |

History update and deletion were prevented with the expected database error messages.

## 4. Constraint Testing

| Constraint | Test Performed | Result | Status |
|---|---|---|---|
| Foreign key | Inserted product with invalid category ID 999 | Rejected | PASS |
| Unique constraint | Attempted duplicate category name Fruits | Rejected | PASS |
| Check constraint | Attempted to insert quantity -5 | Rejected | PASS |
| Primary keys | Inspected all six tables | Verified | PASS |

The database contains 8 foreign key constraints, 2 unique constraints and 3 check constraints.

## 5. Transaction Rollback Testing

Temporary product insertion and product update operations were tested inside transactions. ROLLBACK successfully restored the original database state.

Apple's original quantity was verified as 30 after rollback. Temporary trigger-generated history records were also rolled back.

**Result: PASS**

## 6. Database Structure Verification

| Verification | Result |
|---|---|
| Total tables | 6 |
| Tables using InnoDB | 6 |
| Primary key constraints | 6 |
| Foreign key constraints | 8 |
| Unique constraints | 2 |
| Check constraints | 3 |
| Triggers | 4 |
| Stored procedures | 2 |
| Index definitions | Verified using INFORMATION_SCHEMA.STATISTICS |

### Tables Verified

1. actions
2. categories
3. history
4. products
5. users
6. verifications

### Stored Procedures Verified

1. verify_product
2. verify_product_temperature

## 7. Conclusion

The FreshFirst Team database was examined for data integrity, database structure, stored procedure logic, trigger definitions, constraints, indexes, and transaction rollback.

The database contains six InnoDB tables, eight foreign keys, two unique constraints, three check constraints, four triggers, and two stored procedures. The temperature verification procedure executed successfully, and the transaction rollback test confirmed that the temporary verification record was not retained.

The documented trigger and constraint tests passed. Additional testing of remaining transaction workflows and complete audit coverage is still required.

**Overall Result: Database structure and selected functional tests verified successfully.**

# Gate 1 â€“ Database Testing Status

## B2 â€“ Data Integrity Rules

| Rule | Verification Status |
|---|---|
| All six tables use InnoDB | VERIFIED |
| Primary keys exist on all tables | VERIFIED |
| Invalid foreign-key reference rejected | PASS |
| Duplicate category name rejected | PASS |
| Zero quantity rejected | PASS |
| Negative quantity rejected | PASS |
| Invalid category temperature range protection | Constraint verified |
| History update prevented | PASS |
| History deletion prevented | PASS |

## B3 â€“ Audit Trail Status

| Operation | Database Evidence |
|---|---|
| Product insertion | History trigger verified |
| Product update | History trigger verified |
| Product verification | Verification and history records present |
| History update prevention | Trigger verified |
| History deletion prevention | Trigger verified |
| Action assignment and completion audit | Further implementation and testing required |

## Remaining Database Limitations

1. The actions table was empty at the recorded checkpoint.
2. Complete action lifecycle audit coverage is not yet demonstrated.
3. Existing password values are temporary placeholders and require secure hashing.
4. A complete restore test remains to be demonstrated.

**Database testing conclusion:** Structural checks and selected functional tests were verified. Remaining limitations are recorded honestly for further work.



# Database Verification Update – 18 November 2026

This update supersedes the earlier database structure counts in this report.

## 8. Updated Database Structure

| Verification | Latest Verified Result |
|---|---:|
| Total tables | 7 |
| InnoDB tables | 7 |
| Primary keys | 7 |
| Foreign keys | 10 |
| Unique constraints | 2 |
| Check constraints | 4 |
| Triggers | 10 |
| Stored procedures | 2 |
| Indexes | Verified using INFORMATION_SCHEMA.STATISTICS |

### Tables

1. actions
2. action_history
3. categories
4. history
5. products
6. users
7. verifications

## 9. Action Lifecycle and Audit Testing

| Test | Expected Result | Actual Result | Status |
|---|---|---|---|
| Default action status | PENDING | PENDING | PASS |
| Completion timestamp for PENDING | NULL | NULL | PASS |
| Completion timestamp when marked DONE | Automatically generated | Generated | PASS |
| Action creation audit | ACTION_CREATED event | Generated | PASS |
| Action status-change audit | STATUS_CHANGED event | Generated | PASS |
| Audit record update | Rejected | Error 1644 | PASS |
| Audit record deletion | Rejected | Error 1644 | PASS |
| Transaction rollback | Temporary records removed | Removed | PASS |

## 10. Action Audit Triggers

1. trg_actions_before_insert
2. trg_actions_before_update
3. trg_action_history_after_insert
4. trg_action_history_after_update
5. trg_action_history_prevent_update
6. trg_action_history_prevent_delete

The existing product and history triggers were also verified.

## 11. Final Database Cleanup

| Check | Result |
|---|---:|
| Temporary actions remaining | 0 |
| Temporary action audit records remaining | 0 |
| Database tables | 7 |
| Database triggers | 10 |

## 12. Remaining Limitations

1. Action audit records currently have a NULL actor_user_id because the database does not yet receive the identity of the user performing each action.
2. Existing user password values are temporary placeholders and require secure password hashes.
3. A complete database backup restoration test remains to be demonstrated.
4. Audit protection triggers prevent ordinary SQL updates and deletes, but privileged database administrators can still alter database objects.

## 13. Updated Conclusion

The FreshFirst Team database has seven InnoDB tables, ten foreign keys, two unique constraints, four check constraints, ten triggers and two stored procedures.

Action lifecycle management, automatic completion timestamps, audit event generation, audit update/delete protection and transaction rollback were tested successfully.

Temporary test records were removed through rollback. Remaining limitations are documented honestly.

**Updated Result: Database structure and the tested action lifecycle and audit controls were verified successfully.**


## Action Audit Actor Identification Testing

**Test date:** 18 November 2026

The action audit triggers were updated to capture the database session's supplied user ID and validate it against the users table.

### Test Results

| User Role | User ID | ACTION_CREATED | STATUS_CHANGED |
|---|---:|---|---|
| Admin | 1 | PASS | PASS |
| Manager | 2 | PASS | PASS |
| Staff | 3 | PASS | PASS |

### Verification

- Actor IDs and usernames were correctly recorded.
- Action creation events were recorded.
- Status transitions from PENDING to IN_PROGRESS were recorded.
- Temporary test transactions were rolled back.
- Cleanup queries confirmed zero remaining test actions and audit records.

**Result:** All three role tests passed.

**Limitation:** Actor identification depends on the database session setting `@freshfirst_actor_user_id`. The application must set and reset this variable for each authenticated database session. The database trigger validates the supplied ID but does not independently authenticate the user.

## Verification Procedure Input Validation — 18 November 2026

The stored procedure `verify_product_temperature` was enhanced with explicit input validation.

### Validation Tests

| Test Case | Expected Result | Actual Result |
|---|---|---|
| Valid temperature (5°C) | SAFE | PASS |
| Out-of-range temperature (15°C) | UNSAFE | PASS |
| NULL temperature | Error: Temperature cannot be NULL | PASS |
| Invalid product ID (9999) | Error: Product not found | PASS |
| Invalid user ID (9999) | Error: User not found | PASS |

### Data Integrity Verification

- Invalid inputs are rejected before inserting verification records.
- Product existence is checked before verification.
- User existence is checked before verification.
- The existing foreign key constraint on `verified_by` remains as an additional integrity safeguard.
- Verification test-record cleanup query returned NULL (no matching records).

**Result:** All five procedure validation tests passed.

## CHECK Constraint Negative Testing — 18 November 2026

Three negative tests were executed against the database.

| Test Case | Expected Result | Actual Result |
|---|---|---|
| Set product quantity to 0 | Reject invalid quantity | PASS - Error 3819 |
| Set minimum temperature above maximum | Reject invalid range | PASS - Error 3819 |
| Set near-expiry days to -1 | Reject negative value | PASS - Error 3819 |

### Data Preservation Verification

- Fresh Milk (product_id 1) quantity remained 20.
- Bakery temperature range remained 15–25°C.
- Dairy temperature range remained 2–8°C.
- Fruits temperature range remained 4–12°C.
- Vegetables temperature range remained 4–12°C.

**Result:** All three negative tests passed. Existing records remained unchanged.

## Transaction Testing — 19 November 2026

| Test Case | Expected Result | Actual Result |
|---|---|---|
| Update quantity to 999 and ROLLBACK | Original quantity restored | PASS - Quantity returned to 20 |
| Update quantity to 21 and COMMIT | Updated value saved | PASS - Quantity remained 21 |
| Restore original quantity | Quantity returned to 20 | PASS |

**Result:** COMMIT and ROLLBACK operations behaved as expected. Original product data was restored.

## Final Database Integrity Verification — 19 November 2026

| Verification | Expected | Actual | Result |
|---|---|---|---|
| InnoDB tables | 7 | 7 | PASS |
| Primary keys | 7 | 7 | PASS |
| Foreign keys | 10 | 10 | PASS |
| Unique constraints | 2 | 2 | PASS |
| CHECK constraints | 4 | 4 | PASS |
| Triggers | 10 | 10 | PASS |
| Stored procedures | 2 | 2 | PASS |
| Tables with indexes | 7 | 7 | PASS |
| Orphan products | 0 | 0 | PASS |
| Original products | 5 | 5 | PASS |

**Result:** Final database structure and data integrity verification completed successfully.
