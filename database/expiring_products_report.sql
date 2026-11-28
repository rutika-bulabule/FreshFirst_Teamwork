DELIMITER //

CREATE PROCEDURE sp_expiring_products_report(IN p_days INT)
BEGIN
    IF p_days IS NULL OR p_days < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Days must be zero or greater';
    END IF;

    SELECT
        product_id,
        product_name,
        expiry_date,
        DATEDIFF(expiry_date, CURDATE()) AS days_remaining,
        quantity
    FROM products
    WHERE expiry_date BETWEEN CURDATE()
        AND DATE_ADD(CURDATE(), INTERVAL p_days DAY)
    ORDER BY expiry_date ASC;
END //

DELIMITER ;
