DELIMITER //

CREATE PROCEDURE sp_expired_products_report()
BEGIN
    SELECT
        product_id,
        product_name,
        expiry_date,
        DATEDIFF(CURDATE(), expiry_date) AS days_expired,
        quantity
    FROM products
    WHERE expiry_date < CURDATE()
    ORDER BY expiry_date ASC;
END //

DELIMITER ;
