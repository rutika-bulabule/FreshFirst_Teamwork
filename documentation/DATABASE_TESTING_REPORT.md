# Database Testing Report â€“ FreshFirst Team

**Date:** 18 November 2026
**Database:** freshfirst_team
**DBMS:** MySQL 9.1.0
**Environment:** Windows, MySQL Server 9.1.0 and MySQL Workbench

> **Historical checkpoint:** Sections 1–7 record the database testing results from 18 November 2026. The updated database structure and final verification results are documented in the later sections dated 19 November 2026.
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

> **Historical update:** The remaining action lifecycle auditing and audit coverage were subsequently implemented and tested on 19 November 2026. Refer to Sections 9–13 and the later verification results below.

# Gate 1 â€“ Database Testing Status

## B2 â€“ Data Integrity Rules

| Rule | Verification Status |
|---|---|
| All seven tables use InnoDB | VERIFIED |
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
| Action assignment and completion audit | Implemented and tested – see 19 November verification |

## Remaining Database Limitations

The action lifecycle and audit coverage were tested successfully on 19 November 2026.

1. Existing password values are temporary placeholders and require secure password hashing.
2. A complete database backup restoration test remains pending.
3. Actor attribution depends on the application setting and controlling the database session variable for each authenticated session.
4. Physical stock quantities require staff to perform physical stock counts; the database cannot independently verify actual stock.

**Database testing conclusion:** Structural checks and selected functional tests were verified. Remaining limitations are recorded honestly for further work.



# Database Verification Update – 19 November 2026

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

1. Actor attribution depends on the application setting the database session variable @freshfirst_actor_user_id for each authenticated session. The database validates the supplied user ID but does not independently authenticate the user.
2. Existing user password values are temporary placeholders and require secure password hashes.
3. A complete database backup restoration test remains to be demonstrated.
4. Audit protection triggers prevent ordinary SQL updates and deletes, but privileged database administrators can still alter database objects.

## 13. Updated Conclusion

The FreshFirst Team database has seven InnoDB tables, ten foreign keys, two unique constraints, four check constraints, ten triggers and two stored procedures.

Action lifecycle management, automatic completion timestamps, audit event generation, audit update/delete protection and transaction rollback were tested successfully.

Temporary test records were removed through rollback. Remaining limitations are documented honestly.

**Updated Result: Database structure and the tested action lifecycle and audit controls were verified successfully.**


## Action Audit Actor Identification Testing

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

## Expiry-Date Calculation Testing — 19 November 2026

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

## Database Reporting Query Testing — 19 November 2026

Three read-only reporting queries were executed successfully.

| Test | Verification | Result |
|---|---|---|
| Product stock report | Displayed five products with category, quantity, unit, expiry date and storage temperature | PASS |
| Category summary report | Displayed product counts, total quantities, expired products and near-expiry products for four categories | PASS |
| Action status report | Query executed successfully, but returned no rows because the actions table contained zero records | PASS – QUERY EXECUTED |

**Limitation:** Action status report output with actual action records has not yet been demonstrated. No test records were inserted.

**Result:** Product stock and category summary reports returned the expected data. All three reporting queries executed without SQL errors.

## Duplicate Username Constraint Testing — 19 November 2026

The `users` table definition was inspected and confirmed to contain a UNIQUE constraint on `username`.

A duplicate insert using the existing username `admin` was attempted within a transaction.

| Test | Expected Result | Actual Result |
|---|---|---|
| Insert a second user with username `admin` | Reject duplicate username | Error 1062: Duplicate entry 'admin' for key 'users.username' |
| Check user count after ROLLBACK | Remain at 3 | 3 users |

**Result:** Duplicate username insertion was rejected and the original three user records remained unchanged.

## User Account and Role Verification — 19 November 2026

A read-only query was executed to verify the existing user accounts and assigned roles.

| User ID | Username | Role |
|---:|---|---|
| 1 | admin | ADMIN |
| 2 | manager1 | MANAGER |
| 3 | staff1 | STAFF |

**Result:** All three user records and their assigned roles were returned successfully.

**Limitation:** This test verifies existing account and role records only. User creation, login authentication and role modification were not tested here.

## Backup Restoration Verification — 19 November 2026

The database backup was successfully restored into a separate test database named `freshfirst_team_restore_test`.

| Restored table | Record count |
|---|---:|
| users | 3 |
| products | 5 |
| categories | 4 |
| actions | 0 |
| action_history | 0 |
| history | 5 |
| verifications | 1 |

**Result:** All seven tables were restored and their records were accessible. The original `freshfirst_team` database was kept separate and was not selected as the restoration target.

**Status: PASS**

**Additional restoration verification:**
- 10 triggers restored successfully.
- 2 stored procedures restored successfully.
- No restoration errors were reported.

**Final restoration result: PASS**

## Gate 1 – B2: Negative Database Integrity Testing
**Date:** 19 November 2026

| Test | Invalid operation | Expected result | Actual result |
|---|---|---|---|
| B2-T01 | Update product quantity to -1 | Database rejects negative stock quantity | PASS - Rejected |
| B2-T02 | Update product category to invalid ID 999999 | Foreign key rejects invalid category reference | PASS - Rejected |

**Execution:** Both tests were executed inside a transaction and rolled back.

**Result:** Both invalid operations were rejected. Original product records were protected. No invalid data was committed.

**Overall status: PASS**

## Gate 1 – B3: Audit Trail Acceptance Testing
**Date:** 19 November 2026

| Test | Expected result | Actual result |
|---|---|---|
| B3-T01 – Product quantity update | Update creates an audit history record | PASS |
| B3-T02 – Actor attribution | Audit record stores the actor user ID | PASS |
| B3-T03 – Activity details | Audit record stores activity type and product details | PASS |
| B3-T04 – Timestamp | Audit record stores the event timestamp | PASS |

**Observed evidence:**
- History ID: 10
- Actor user ID: 1
- Event type: PRODUCT UPDATED
- Event details: Product updated: Fresh Milk, Quantity: 21
- Event timestamp: 2026-11-19 18:11:45

**Result:** The product update trigger generated an audit history record with actor, activity details and timestamp. The test transaction was rolled back.

**Overall status: PASS for the tested product-update audit event.**

## Gate 1 – B3: Audit History Protection Testing
**Date:** 19 November 2026

| Test | Expected result | Actual result |
|---|---|---|
| B3-T05 – Update audit history | Database blocks audit history updates | PASS - Update blocked |
| B3-T06 – Delete audit history | Database blocks audit history deletion | PASS - Delete blocked |

**Result:** Audit history protection triggers successfully prevented both update and delete operations.

**Overall status:** PASS for the tested audit history protections.

## Gate 1 – DB-FR-10: Action Reporting Test
**Date:** 19 November 2026

| Test data | Expected result | Actual result |
|---|---|---|
| Temporary inspection action | Action report displays action type, priority, status and description | PASS |

**Observed result:**
- Action type: INSPECTION
- Priority: HIGH
- Status: PENDING
- Description: Temporary Gate 1 action reporting test

**Execution:** Temporary action inserted inside a transaction and rolled back.

**Result:** Action reporting successfully returned the expected record. No test record was retained.


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
