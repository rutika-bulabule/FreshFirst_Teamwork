DELIMITER //

CREATE PROCEDURE sp_category_stock_report()
BEGIN
    SELECT
        c.category_id,
        c.category_name,
        COUNT(p.product_id) AS total_products,
        COALESCE(SUM(p.quantity), 0) AS total_quantity,
        COALESCE(SUM(p.quantity * p.unit_price), 0.00)
            AS total_stock_value
    FROM categories c
    LEFT JOIN products p
        ON c.category_id = p.category_id
    GROUP BY c.category_id, c.category_name
    ORDER BY c.category_name;
END //

DELIMITER ;
