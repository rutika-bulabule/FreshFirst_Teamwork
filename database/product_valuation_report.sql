DELIMITER //

CREATE PROCEDURE sp_product_valuation_report()
BEGIN
    SELECT
        COUNT(*) AS total_products,
        SUM(CASE WHEN unit_price IS NOT NULL THEN 1 ELSE 0 END)
            AS priced_products,
        SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END)
            AS unpriced_products,
        COALESCE(SUM(quantity * unit_price), 0.00)
            AS total_stock_value
    FROM products;
END //

DELIMITER ;
