# Gate 1 – B1: Transaction Types and Their Effect on Stock Balance

**Project:** FreshFirst – Perishable Stock Verification Register  
**Engine:** Database / Data & Integrity  
**Database:** `freshfirst_team`  
**DBMS:** MySQL 9.1.0

## 1. Purpose

This document lists the stock-related transaction types identified in the current database and explains their effect on the recorded stock balance in the `products` table.

## 2. Transaction Types and Balance Effects

| ID | Transaction | Effect on Stock Balance | Evidence / Status |
|---|---|---|---|
| B1-T01 | Add a product | Creates a product with its initial quantity. | Product insertion and rollback tests documented. |
| B1-T02 | Increase quantity | Increases the recorded quantity. | Quantity update and COMMIT test documented. |
| B1-T03 | Decrease quantity | Decreases the recorded quantity. | Quantity update testing documented; separate decrease test not identified. |
| B1-T04 | Correct quantity | Replaces an incorrect quantity with the corrected value. | Quantity restoration and ROLLBACK tests documented. |
| B1-T05 | Verify product | Does not directly change product quantity; creates verification records. | Stored procedure and verification tests documented. |
| B1-T06 | Assign or complete corrective action | Action status and audit records change; no automatic quantity change is established by the action record alone. | Action lifecycle and audit tests documented. |

## 3. Stock Balance Rules

1. Product quantity must satisfy the existing CHECK constraint.
2. Product records must reference valid categories through foreign keys.
3. Quantity changes must preserve database integrity.
4. Product verification records inspection results and does not itself establish a quantity change.
5. Corrective action status changes must be recorded in the audit trail.
6. Quantity changes must be supported by authorized application operations.

## 4. Transaction Safety

The database uses InnoDB tables and supports:

- COMMIT – saves a successful transaction.
- ROLLBACK – cancels uncommitted changes.

The database testing report documents successful quantity update, COMMIT and ROLLBACK tests.

## 5. Unsupported or Unverified Transaction Types

The current evidence does not establish a dedicated purchase, sales, customer-return, wastage or soft-delete transaction implementation.

These must not be presented as implemented stock transactions without corresponding database functionality and test evidence.

## 6. Evidence Summary

Existing database testing documentation confirms product insertion, quantity updates, transaction safety, verification procedures, and corrective-action audit testing.

A separate decrease-only test and a complete application-level transaction workflow have not been independently established by this document.

**B1 transaction types and balance effects: Documented.**

**Remaining evidence limitations: Recorded honestly for review.**
