# FreshFirst Team – Database Engine Completion Report

**Project:** Perishable Stock Verification Register
**Engine:** Database / Data & Integrity
**Responsible Member:** Rutika

## 1. Completed Database Work

| Area | Completed work | Status |
|---|---|---|
| Database structure | Eight InnoDB tables | PASS |
| Primary keys | Eight primary keys | PASS |
| Foreign keys | Twelve foreign keys | PASS |
| Unique constraints | Two UNIQUE constraints | PASS |
| CHECK constraints | Four CHECK constraints | PASS |
| Indexes | 24 indexes | PASS |
| Triggers | Eleven triggers | PASS |
| Stored procedures | Three procedures | PASS |
| Verification | Expiry and temperature verification | PASS |
| Audit history | History protection and audit testing | PASS |
| Product and category reporting | Queries executed and results reviewed | PASS |
| Action reporting | Temporary inspection action displayed correctly and transaction rolled back | PASS |
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

1. Secure password hashes for ADMIN, MANAGER and STAFF have been generated using Werkzeug scrypt and verified. Full application login integration testing remains pending.
2. A faculty-approved response-time target is required before completing DB-NFR-07 performance testing.
3. The official Gate 1 register requires a coordinated update after the database review. Gate documents are not modified as part of this report update.

## 4. GitHub Submission

Database documentation, SQL files, testing evidence and handover files have been included in the project repository.

The repository history should be preserved during final submission preparation.

## 5. Conclusion

The database structure, integrity constraints, triggers, stored procedures, audit mechanisms, reporting queries and backup restoration have been implemented and tested.

Product and category reporting queries were executed and their results reviewed. Action reporting was also tested successfully using a temporary inspection action. The expected action details were returned, and the test transaction was rolled back so that no temporary record was retained.

Secure password hashing and Werkzeug verification are complete. Full application login integration testing and final performance benchmarking remain pending.

**Overall Status:** The database structure and major integrity, reporting and recovery tests are completed. Remaining partial requirements are recorded honestly for further validation.

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

## Git Submission Status - 23 November 2026

Database documentation and supporting SQL files are undergoing final local review as of 27 November 2026. The latest review updates have not yet been committed or pushed. Private backups and password-generation or verification scripts are excluded from the submission.
