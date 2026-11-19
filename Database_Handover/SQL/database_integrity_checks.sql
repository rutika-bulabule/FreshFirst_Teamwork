USE freshfirst_team;

-- 1. Check all database tables and storage engines
SELECT
    TABLE_NAME,
    ENGINE,
    TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'freshfirst_team'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- 2. Check database constraints
SELECT
    CONSTRAINT_TYPE,
    COUNT(*) AS total_constraints
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'freshfirst_team'
GROUP BY CONSTRAINT_TYPE;

-- 3. Check foreign keys
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'freshfirst_team'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 4. Check triggers
SHOW TRIGGERS;

-- 5. Check stored procedures
SHOW PROCEDURE STATUS
WHERE Db = 'freshfirst_team';

-- 6. Check indexes
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'freshfirst_team'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- 7. Check product records
SELECT *
FROM products
ORDER BY product_id;

-- 8. Check products with invalid quantities
SELECT *
FROM products
WHERE quantity <= 0;

-- 9. Check products with missing categories
SELECT p.product_id, p.product_name, p.category_id
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

-- 10. Check product storage temperatures
SELECT
    p.product_id,
    p.product_name,
    p.storage_temperature,
    c.min_storage_temp,
    c.max_storage_temp
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
WHERE p.storage_temperature < c.min_storage_temp
   OR p.storage_temperature > c.max_storage_temp;

-- 11. Check expired and category-specific near-expiry products
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.expiry_date,
    c.near_expiry_days,
    DATEDIFF(p.expiry_date, CURRENT_DATE) AS days_left
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
WHERE p.expiry_date <= DATE_ADD(
    CURRENT_DATE,
    INTERVAL c.near_expiry_days DAY
)
ORDER BY p.expiry_date;
