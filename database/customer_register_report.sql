DROP PROCEDURE IF EXISTS sp_customer_register_report;

DELIMITER //

CREATE PROCEDURE sp_customer_register_report()
BEGIN
    SELECT
        c.customer_id,
        c.customer_name,
        c.phone,
        COUNT(DISTINCT CASE
            WHEN s.sale_status = 'COMPLETED' THEN s.sale_id
        END) AS total_purchases,
        COALESCE(SUM(
            CASE
                WHEN s.sale_status = 'COMPLETED'
                THEN si.line_total
                ELSE 0
            END
        ), 0.00) AS total_spent,
        c.created_at
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    LEFT JOIN sale_items si ON s.sale_id = si.sale_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.phone,
        c.created_at
    ORDER BY c.customer_name;
END //

DELIMITER ;
