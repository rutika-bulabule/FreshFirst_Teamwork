DELIMITER //

CREATE PROCEDURE sp_stock_movement_summary()
BEGIN
    SELECT
        movement_type,
        COUNT(*) AS total_movements,
        SUM(ABS(quantity_change)) AS total_quantity_moved
    FROM stock_movements
    GROUP BY movement_type
    ORDER BY movement_type;
END //

DELIMITER ;
