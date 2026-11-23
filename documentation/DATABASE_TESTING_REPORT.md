# Database Testing Report - FreshFirst Team

**Date:** 18-19 November 2026  
**Database:** freshfirst_team  
**DBMS:** MySQL 9.1.0  
**Storage Engine:** InnoDB

## 1. Testing Scope

The database was tested for stored procedures, triggers, primary keys, foreign keys, unique constraints, check constraints, indexes, transaction rollback, storage-engine configuration and action audit operations.

## 2. Initial Stored Procedure Testing - 18 November 2026

| Test | Expected Result | Actual Result | Status |
|---|---|---|---|
| verify_product(2) | Apple verification result | SAFE | PASS |
| verify_product(999) | No matching product row | Empty result | PASS |
| Temperature 5.00 C | SAFE | SAFE | PASS |
| Temperature 20.00 C | UNSAFE | UNSAFE | PASS |
| Lower boundary 4.00 C | SAFE | SAFE | PASS |
| Upper boundary 12.00 C | SAFE | SAFE | PASS |
| Below minimum 3.99 C | UNSAFE | UNSAFE | PASS |
| Above maximum 12.01 C | UNSAFE | UNSAFE | PASS |
| Invalid product ID 999 | Product not found error | Product not found | PASS |

Temperature verification tests used the category's configured minimum and maximum limits. Temporary test records were rolled back where applicable.

## 3. Initial Trigger Testing - 18 November 2026

| Trigger | Test Performed | Result | Status |
|---|---|---|---|
| trg_history_prevent_update | Attempted to update a history record | Update blocked | PASS |
| trg_history_prevent_delete | Attempted to delete a history record | Delete blocked | PASS |
| trg_product_after_insert | Inserted a temporary product | PRODUCT ADDED history entry generated | PASS |
| trg_product_after_update | Updated a product temporarily | PRODUCT UPDATED history entry generated | PASS |

History update and deletion were prevented with the expected database error messages.

## 4. Initial Constraint Testing - 18 November 2026

| Constraint | Test Performed | Result | Status |
|---|---|---|---|
| Foreign key | Inserted product with invalid category ID 999 | Rejected | PASS |
| Unique constraint | Attempted duplicate category name Fruits | Rejected | PASS |
| Check constraint | Attempted to insert quantity -5 | Rejected | PASS |
| Primary keys | Inspected initial six-table structure | Verified | PASS |

The initial six-table database checkpoint contained 8 foreign keys, 2 unique constraints and 3 check constraints. These are historical results and are superseded by the final verification in Section 8.

## 5. Transaction Rollback Testing

Temporary product insertion and product update operations were tested inside transactions. ROLLBACK successfully restored the original database state.

Apple's original quantity was verified as 30 after rollback. Temporary trigger-generated history records were also rolled back.

**Result: PASS**

## 6. Initial Database Structure - Historical Checkpoint

The following counts describe the initial database checkpoint on 18 November 2026. They are not the final database counts.

| Verification | Initial Result |
|---|---:|
| Total tables | 6 |
| Tables using InnoDB | 6 |
| Primary key constraints | 6 |
| Foreign key constraints | 8 |
| Unique constraints | 2 |
| Check constraints | 3 |
| Triggers | 4 |
| Stored procedures | 2 |

### Initial Tables

1. actions
2. categories
3. history
4. products
5. users
6. verifications

### Stored Procedures

1. verify_product
2. verify_product_temperature

## 7. Initial Testing Conclusion

The initial database checkpoint was examined for data integrity, database structure, stored procedure logic, trigger definitions, constraints, indexes and transaction rollback.

The initial structural and selected functional tests passed. Subsequent database updates expanded the structure and audit functionality. The final results are recorded in the following sections.

# Gate 1 - Database Testing Status

## B2 - Data Integrity Rules

| Rule | Verification Status |
|---|---|
| All seven tables use InnoDB | VERIFIED |
| Primary keys exist on all tables | VERIFIED |
| Invalid foreign-key reference rejected | PASS |
| Duplicate category name rejected | PASS |
| Zero quantity rejected | PASS |
| Negative quantity rejected | PASS |
| Category temperature range protection | Constraint verified |
| History update prevented | PASS |
| History deletion prevented | PASS |

## B3 - Audit Trail Status

| Operation | Database Evidence |
|---|---|
| Product insertion | History trigger verified |
| Product update | History trigger verified |
| Product verification | Verification and history records present |
| History update prevention | Trigger verified |
| History deletion prevention | Trigger verified |
| Action assignment and completion audit | Implemented and tested - see Section 9 |

# Database Verification Update - 19 November 2026

This section records the updated database structure and supersedes the initial counts in Sections 4 and 6.

## 8. Final Database Structure

| Verification | Final Verified Result |
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

### Final Tables

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

## 12. Backup and Restoration Testing

Database backup restoration was successfully completed on 19 November 2026 using the separate `freshfirst_team_restore_test` database.

A further read-only verification was performed on 23 November 2026 by comparing the original `freshfirst_team` database with the restored database.

| Verification | Original Database | Restore Test | Result |
|---|---:|---:|---|
| Tables | 7 | 7 | PASS |
| Total records | 18 | 18 | PASS |
| Foreign keys | 10 | 10 | PASS |
| Triggers | 10 | 10 | PASS |
| Stored procedures | 2 | 2 | PASS |
| CHECK constraints | 4 | 4 | PASS |
| UNIQUE constraints | 2 | 2 | PASS |
| InnoDB tables | 7 | 7 | PASS |
| Indexes | 24 | 24 | PASS |

The row counts were identical across all seven tables. The verification confirmed matching structural counts and row counts; it did not independently establish row-by-row data equality.

The restoration test used a separate database to avoid modifying the official `freshfirst_team` database.

**Restoration Result: PASS**

## 13. Remaining Database Limitations

1. Actor attribution depends on the application setting the database session variable `@freshfirst_actor_user_id` for each authenticated session. The database validates the supplied user ID but does not independently authenticate the user.
2. Secure Werkzeug password hashes were generated and verified for the three database user accounts on 22 November 2026. Application login integration remains pending.
3. A formal query-performance target and benchmark still require completion or faculty confirmation.
4. Audit protection triggers prevent ordinary SQL updates and deletes, but privileged database administrators can still alter database objects.
5. Physical stock quantities require staff to perform physical stock counts; the database cannot independently verify actual stock.

## 14. Action Audit Actor Identification Testing

**Test date:** 19 November 2026

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

**Result: All three role tests passed.**

## Verification Procedure Input Validation ΓÇö 18 November 2026

The stored procedure `verify_product_temperature` was enhanced with explicit input validation.

### Validation Tests

| Test Case | Expected Result | Actual Result |
|---|---|---|
| Valid temperature (5┬░C) | SAFE | PASS |
| Out-of-range temperature (15┬░C) | UNSAFE | PASS |
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

## CHECK Constraint Negative Testing ΓÇö 18 November 2026

Three negative tests were executed against the database.

| Test Case | Expected Result | Actual Result |
|---|---|---|
| Set product quantity to 0 | Reject invalid quantity | PASS - Error 3819 |
| Set minimum temperature above maximum | Reject invalid range | PASS - Error 3819 |
| Set near-expiry days to -1 | Reject negative value | PASS - Error 3819 |

### Data Preservation Verification

- Fresh Milk (product_id 1) quantity remained 20.
- Bakery temperature range remained 15ΓÇô25┬░C.
- Dairy temperature range remained 2ΓÇô8┬░C.
- Fruits temperature range remained 4ΓÇô12┬░C.
- Vegetables temperature range remained 4ΓÇô12┬░C.

**Result:** All three negative tests passed. Existing records remained unchanged.

## Transaction Testing ΓÇö 19 November 2026

| Test Case | Expected Result | Actual Result |
|---|---|---|
| Update quantity to 999 and ROLLBACK | Original quantity restored | PASS - Quantity returned to 20 |
| Update quantity to 21 and COMMIT | Updated value saved | PASS - Quantity remained 21 |
| Restore original quantity | Quantity returned to 20 | PASS |

**Result:** COMMIT and ROLLBACK operations behaved as expected. Original product data was restored.

## Final Database Integrity Verification ΓÇö 19 November 2026

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

## Expiry-Date Calculation Testing ΓÇö 19 November 2026

A read-only SQL query using `DATEDIFF()` and `CASE` was executed to calculate the number of days remaining and identify expired products.

| Product | Expiry Date | Days Remaining | Expected Status | Actual Status |
|---|---|---:|---|---|
| Fresh Milk | 2026-11-20 | 1 | NOT EXPIRED | NOT EXPIRED |
| Apple | 2026-11-22 | 3 | NOT EXPIRED | NOT EXPIRED |
| Banana | 2026-11-17 | -2 | EXPIRED | EXPIRED |
| Carrot | 2026-11-25 | 6 | NOT EXPIRED | NOT EXPIRED |
| Bread | 2026-11-18 | -1 | EXPIRED | EXPIRED |

**Result:** All five expiry calculations and status classifications matched the expected results. No product records were modified.

**Test limitation:** This test verifies direct SQL expiry calculation. It does not independently establish that the `verify_product` stored procedure performs the same calculation.

## Database Reporting Query Testing ΓÇö 19 November 2026

Three read-only reporting queries were executed successfully.

| Test | Verification | Result |
|---|---|---|
| Product stock report | Displayed five products with category, quantity, unit, expiry date and storage temperature | PASS |
| Category summary report | Displayed product counts, total quantities, expired products and near-expiry products for four categories | PASS |
| Action status report | Query executed successfully, but returned no rows because the actions table contained zero records | PASS ΓÇô QUERY EXECUTED |

**Limitation:** Action status report output with actual action records has not yet been demonstrated. No test records were inserted.

**Result:** Product stock and category summary reports returned the expected data. All three reporting queries executed without SQL errors.

## Duplicate Username Constraint Testing ΓÇö 19 November 2026

The `users` table definition was inspected and confirmed to contain a UNIQUE constraint on `username`.

A duplicate insert using the existing username `admin` was attempted within a transaction.

| Test | Expected Result | Actual Result |
|---|---|---|
| Insert a second user with username `admin` | Reject duplicate username | Error 1062: Duplicate entry 'admin' for key 'users.username' |
| Check user count after ROLLBACK | Remain at 3 | 3 users |

**Result:** Duplicate username insertion was rejected and the original three user records remained unchanged.

## User Account and Role Verification ΓÇö 19 November 2026

A read-only query was executed to verify the existing user accounts and assigned roles.

| User ID | Username | Role |
|---:|---|---|
| 1 | admin | ADMIN |
| 2 | manager1 | MANAGER |
| 3 | staff1 | STAFF |

**Result:** All three user records and their assigned roles were returned successfully.

**Limitation:** This test verifies existing account and role records only. User creation, login authentication and role modification were not tested here.


## 15. Final Conclusion

The final FreshFirst Team database contains seven InnoDB tables, ten foreign keys, two unique constraints, four check constraints, ten triggers and two stored procedures.

The initial stored procedure and trigger tests passed. Action lifecycle management, automatic completion timestamps, audit event generation, audit update/delete protection, actor identification testing and transaction rollback were also reported as successful.

Database backup restoration was successfully tested using the separate `freshfirst_team_restore_test` database.

The remaining limitations relating to secure password hashes, application-controlled actor attribution, performance benchmarking and physical stock verification are documented honestly.

**Overall Result:** The final database structure and the documented database integrity, action audit and restoration tests were verified successfully.

# Current Database Status Update – 22 November 2026

This update records work completed after the earlier testing checkpoints.

## Secure Password Hashing
- Password hashes for ADMIN, MANAGER and STAFF were generated using Werkzeug scrypt.
- The hashes were saved in the official `freshfirst_team` database.
- All three passwords passed Werkzeug `check_password_hash()` verification.
- Full application login integration testing remains pending.

## Category Image Path Support
- Added `image_path VARCHAR(255) NULL` to the `categories` table.
- Saved image paths for Bakery, Dairy, Fruits and Vegetables.
- Existing category records and temperature rules were preserved.
- Actual image files and frontend display integration remain pending with the frontend team.

## Remaining Limitations
- DB-NFR-07 performance acceptance requires a faculty-approved response-time target.
- Application login integration testing remains pending.
- Physical stock quantities require staff verification.

This update supersedes earlier checkpoint statements where they conflict with the current status above. Historical test results remain unchanged.

## 13. Separate Stock Quantity Decrease Test

| Test | Expected Result | Actual Result | Status |
|---|---|---|---|
| Original Fresh Milk quantity | 20 | 20 | PASS |
| Decrease quantity by 5 | 15 | 15 | PASS |
| Execute ROLLBACK | Restore quantity to 20 | 20 | PASS |

The decrease-only quantity test was performed inside an InnoDB transaction. The temporary decrease from 20 to 15 was successfully rolled back, restoring the original quantity of 20.

