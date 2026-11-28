DROP PROCEDURE IF EXISTS sp_sales_summary;

DELIMITER //

CREATE PROCEDURE sp_sales_summary()
BEGIN
    SELECT
        COUNT(DISTINCT CASE
            WHEN s.sale_status = 'COMPLETED' THEN s.sale_id
        END) AS completed_sales,
        COUNT(DISTINCT CASE
            WHEN s.sale_status = 'CANCELLED' THEN s.sale_id
        END) AS cancelled_sales,
        COALESCE(SUM(CASE
            WHEN s.sale_status = 'COMPLETED' THEN si.line_total
            ELSE 0
        END), 0) AS total_revenue,
        COALESCE(SUM(CASE
            WHEN s.sale_status = 'COMPLETED' THEN si.quantity
            ELSE 0
        END), 0) AS total_items_sold
    FROM sales s
    LEFT JOIN sale_items si ON s.sale_id = si.sale_id;
END //

DELIMITER ;
