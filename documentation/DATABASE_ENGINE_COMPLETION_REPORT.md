# FreshFirst Team – Database Engine Completion Report

**Project:** Perishable Stock Verification Register
**Engine:** Database / Data & Integrity
**Responsible Member:** Rutika

## 1. Completed Database Work

| Area | Completed work | Status |
|---|---|---|
| Database structure | Seven InnoDB tables | PASS |
| Primary keys | Seven primary keys | PASS |
| Foreign keys | Ten foreign keys | PASS |
| Unique constraints | Two UNIQUE constraints | PASS |
| CHECK constraints | Four CHECK constraints | PASS |
| Indexes | 24 indexes | PASS |
| Triggers | Ten triggers | PASS |
| Stored procedures | Two procedures | PASS |
| Verification | Expiry and temperature verification | PASS |
| Audit history | History protection and audit testing | PASS |
| Reporting | Product, category and action reports | PASS |
| Backup and recovery | Separate-schema restoration test | PASS |
| Query plans | Four queries checked using EXPLAIN | PASS |

## 2. Requirement Status

| Requirement | Status |
|---|---|
| DB-FR-01 – User management | PARTIAL |
| DB-FR-02 to DB-FR-12 | PASS |
| DB-NFR-01 to DB-NFR-04 | PASS |
| DB-NFR-05 – Audit attribution | PASS WITH LIMITATION |
| DB-NFR-06 – Backup and recovery | PASS |
| DB-NFR-07 – Query performance | PARTIAL |

## 3. Pending Work

1. Secure password hashes and application authentication testing remain pending with the backend implementation.
2. A faculty-approved response-time target is required before completing DB-NFR-07 performance testing.
3. The official Gate 1 register must be updated when its original document is available.

## 4. GitHub Submission

Database documentation, SQL files, testing evidence and handover files have been pushed to the main branch.

Latest commit: f783483

## 5. Conclusion

The database structure, integrity constraints, triggers, stored procedures, audit mechanisms, reporting queries and backup restoration have been implemented and tested. The remaining partial requirements are documented for further application-level testing and faculty confirmation.
