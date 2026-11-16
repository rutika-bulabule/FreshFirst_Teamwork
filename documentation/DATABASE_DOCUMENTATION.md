# Fresh First – Database Documentation

## Database Name
freshfirst_team

## Database Engine
MySQL

## Tables

### 1. users
Stores user details and roles.
- user_id
- full_name
- username
- password_hash
- role
- created_at

### 2. categories
Stores product categories and storage rules.
- category_id
- category_name
- min_storage_temp
- max_storage_temp
- near_expiry_days

### 3. products
Stores perishable product information.
- product_id
- product_name
- category_id
- quantity
- unit
- purchase_date
- expiry_date
- storage_temperature
- created_by
- created_at

### 4. verifications
Stores product verification results.
- verification_id
- product_id
- verified_by
- actual_temperature
- verification_status
- remarks
- verified_at

### 5. actions
Stores actions assigned to products.
- action_id
- product_id
- assigned_to
- action_type
- priority
- action_status
- description
- created_at
- completed_at

### 6. history
Stores product activity records.
- history_id
- product_id
- user_id
- activity
- details
- activity_time

## User Roles
- ADMIN
- MANAGER
- STAFF

## Action Priorities
- CRITICAL
- HIGH
- MEDIUM
- LOW
- INSPECTION

## Database Features
- Primary keys and foreign keys
- Unique constraints
- Database indexes for efficient data retrieval
- Four triggers
- Stored procedure: verify_product (expiry and storage condition verification)
- Stored procedure: verify_product_temperature (actual temperature verification and result recording)
- History update and delete protection

## Sample Data
- 3 users
- 4 categories
- 5 products
- 1 verification record
- 1 history record

## Important Note
The sample password_hash values are temporary placeholders.
The backend developer must replace them with secure password hashes before implementing login.

## Team Workflow
Database: Rutika
Frontend: Basamma
Backend and Testing: Khushi
