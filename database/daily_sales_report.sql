DELIMITER //

CREATE PROCEDURE sp_daily_sales_report()
BEGIN
    SELECT
        DATE(s.sale_date) AS sales_date,
        COUNT(DISTINCT s.sale_id) AS total_bills,
        COALESCE(SUM(si.quantity), 0) AS items_sold,
        COALESCE(SUM(si.line_total), 0) AS daily_revenue
    FROM sales s
    LEFT JOIN sale_items si ON s.sale_id = si.sale_id
    WHERE s.sale_status = 'COMPLETED'
    GROUP BY DATE(s.sale_date)
    ORDER BY sales_date DESC;
END //

DELIMITER ;
