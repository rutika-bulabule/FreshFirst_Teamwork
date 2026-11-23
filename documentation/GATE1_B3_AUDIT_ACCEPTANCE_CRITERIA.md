# Gate 1 – B3: Audit Trail Acceptance Criteria

**Project:** FreshFirst – Perishable Stock Verification Register  
**Engine:** Database / Data & Integrity  
**Database:** freshfirst_team  
**DBMS:** MySQL 9.1.0

## 1. Purpose

This document defines what the audit trail must record for database activities and identifies the acceptance criteria and test evidence available.

## 2. Audit Trail Acceptance Criteria

| ID | Acceptance Criterion | Expected Result |
|---|---|---|
| B3-01 | Every recorded audit event must have a unique audit record ID. | A unique audit record identifier is generated. |
| B3-02 | The audit record must identify the affected product. | The correct product ID is recorded. |
| B3-03 | The audit record must identify the responsible user. | The actor user ID is recorded. |
| B3-04 | The audit record must identify the activity performed. | The event type and activity details are recorded. |
| B3-05 | The audit record must include the event date and time. | A timestamp is recorded. |
| B3-06 | Existing history records must not be modified. | UPDATE operations are rejected. |
| B3-07 | Existing history records must not be deleted. | DELETE operations are rejected. |
| B3-08 | Action creation and status changes must generate action audit events. | Corresponding records are created in action_history. |

## 3. Audit Information to Be Recorded

### Product History (`history`)

- `history_id` – unique audit record identifier.
- `product_id` – affected product.
- `user_id` – actor responsible for the activity.
- `activity` – type of activity performed.
- `details` – description of the activity.
- `activity_time` – event timestamp.

### Action History (`action_history`)

- `action_history_id` – unique action audit record identifier.
- `action_id` – related corrective action.
- `actor_user_id` – user responsible for the event; this field permits NULL.
- `event_type` – type of action event.
- `old_status` – previous action status.
- `new_status` – new action status.
- `event_details` – description of the event.
- `event_at` – event timestamp.

The action audit record identifies its related product through the `action_id` relationship to the `actions` table.

## 4. Existing Database Enforcement

The database contains triggers that:

- Record product insertion events.
- Record product update events.
- Record action creation events.
- Record action status-change events.
- Prevent updates to history records.
- Prevent deletion of history records.
- Prevent updates to action_history records.
- Prevent deletion of action_history records.

## 5. Verified Audit Trail Test Evidence

**Test date:** 19 November 2026

| Test ID | Test | Expected Result | Recorded Result |
|---|---|---|---|
| B3-T01 | Update product quantity | Audit history record is generated. | PASS |
| B3-T02 | Check actor attribution | Actor user ID is recorded. | PASS |
| B3-T03 | Check activity details | Activity type and product details are recorded. | PASS |
| B3-T04 | Check event timestamp | Event timestamp is recorded. | PASS |
| B3-T05 | Update history record | Database blocks the update. | PASS |
| B3-T06 | Delete history record | Database blocks the deletion. | PASS |

### Observed Product Update Evidence

- History ID: 10
- Actor user ID: 1
- Event type: PRODUCT UPDATED
- Event details: Product updated: Fresh Milk, Quantity: 21
- Event timestamp: 2026-11-19 18:11:45

The product update trigger generated the audit record successfully. The test transaction was rolled back.

The database also contains triggers for action creation and status-change audit events. Their existence is verified; complete audit coverage for every possible application transaction is not established by the product-update test.

## 6. Audit History Protection

Four database triggers protect the audit tables:

- trg_history_prevent_update
- trg_history_prevent_delete
- trg_action_history_prevent_update
- trg_action_history_prevent_delete

They reject attempts to modify or delete protected audit records using SQLSTATE 45000.

## 7. Evidence Limitations

- The product-update audit event has recorded evidence for actor, activity details and timestamp.
- Action audit triggers exist, and action lifecycle testing is documented in DATABASE_TESTING_REPORT.md.
- Complete end-to-end audit testing for every application transaction has not been independently established.
- Duplicate business transaction prevention is not demonstrated by audit-history protection alone.
- Application-controlled actor attribution requires backend integration and testing.
- Physical stock verification requires staff confirmation.

## 8. Conclusion

The database provides product history recording, action audit triggers and protection against modification or deletion of audit records.

**B3 audit acceptance criteria: Documented.**

**Verified audit evidence: Recorded for the tested operations.**

**Complete application-level audit coverage: Requires further integration and testing.**

