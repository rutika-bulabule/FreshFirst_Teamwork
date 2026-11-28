DELIMITER //

CREATE PROCEDURE sp_sales_detail_report(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    IF p_start_date IS NULL OR p_end_date IS NULL
       OR p_start_date > p_end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid date range';
    END IF;

    SELECT
        s.sale_id,
        c.customer_name,
        p.product_name,
        si.quantity,
        si.unit_price,
        si.line_total,
        s.sale_status,
        s.sale_date
    FROM sales s
    INNER JOIN sale_items si ON s.sale_id = si.sale_id
    INNER JOIN products p ON si.product_id = p.product_id
    LEFT JOIN customers c ON s.customer_id = c.customer_id
    WHERE s.sale_date >= p_start_date
      AND s.sale_date < DATE_ADD(p_end_date, INTERVAL 1 DAY)
    ORDER BY s.sale_date DESC, s.sale_id DESC;
END //

DELIMITER ;
