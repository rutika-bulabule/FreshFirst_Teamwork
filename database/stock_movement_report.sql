DELIMITER //

CREATE PROCEDURE sp_stock_movement_report()
BEGIN
    SELECT
        sm.movement_id,
        p.product_name,
        sm.previous_quantity,
        sm.new_quantity,
        sm.quantity_change,
        sm.movement_type,
        sm.reason,
        u.username AS changed_by,
        sm.changed_at
    FROM stock_movements sm
    INNER JOIN products p
        ON sm.product_id = p.product_id
    INNER JOIN users u
        ON sm.changed_by = u.user_id
    ORDER BY sm.changed_at DESC;
END //

DELIMITER ;
