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


