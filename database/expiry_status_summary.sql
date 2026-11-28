DELIMITER //

CREATE PROCEDURE sp_expiry_status_summary()
BEGIN
    SELECT
        CASE
            WHEN expiry_date < CURDATE() THEN 'EXPIRED'
            WHEN expiry_date <= DATE_ADD(CURDATE(), INTERVAL 3 DAY)
                THEN 'NEAR EXPIRY'
            ELSE 'SAFE'
        END AS expiry_status,
        COUNT(*) AS total_products,
        COALESCE(SUM(quantity), 0) AS total_quantity
    FROM products
    GROUP BY expiry_status
    ORDER BY FIELD(expiry_status, 'EXPIRED', 'NEAR EXPIRY', 'SAFE');
END //

DELIMITER ;
