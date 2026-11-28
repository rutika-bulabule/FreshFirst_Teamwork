DELIMITER //

CREATE PROCEDURE sp_customer_purchase_report()
BEGIN
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT s.sale_id) AS total_purchases,
        SUM(si.quantity) AS total_quantity,
        SUM(si.line_total) AS total_spent,
        MAX(s.sale_date) AS last_purchase_date
    FROM customers c
    INNER JOIN sales s ON c.customer_id = s.customer_id
    INNER JOIN sale_items si ON s.sale_id = si.sale_id
    WHERE s.sale_status = 'COMPLETED'
    GROUP BY c.customer_id, c.customer_name
    ORDER BY total_spent DESC;
END //

DELIMITER ;
