# FreshFirst Team – Database Handover

## Contents
- SQL: Database schema, backup, restore-test copy and migration scripts.
- Documentation: Database documentation and testing report.

## Database
Database name: freshfirst_team
DBMS: MySQL
Storage engine: InnoDB

## Important
1. Keep the original database unchanged.
2. Review the SQL files before importing.
3. Use a separate test schema for restoration practice.
4. Configure application database credentials securely.
5. Do not use the restore-test SQL file as the production database.
6. Coordinate with the Database member before changing tables,
   constraints, triggers or stored procedures.

## Known limitations
- Application-level authentication testing remains pending.
- A formal query response-time target requires faculty confirmation.
- Audit actor attribution depends on the application setting
  the database session variable.

Faculty approval remains pending.
