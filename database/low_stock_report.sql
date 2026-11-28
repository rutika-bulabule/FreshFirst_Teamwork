DELIMITER //

CREATE PROCEDURE sp_low_stock_report(IN p_threshold INT)
BEGIN
    SELECT
        product_id,
        product_name,
        quantity,
        unit_price,
        CASE
            WHEN quantity = 0 THEN 'OUT OF STOCK'
            ELSE 'LOW STOCK'
        END AS stock_status
    FROM products
    WHERE quantity <= p_threshold
    ORDER BY quantity ASC;
END //

DELIMITER ;
