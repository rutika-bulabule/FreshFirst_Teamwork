USE freshfirst_team;

-- Stock Movement Log table
CREATE TABLE stock_movements (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    previous_quantity INT NOT NULL,
    new_quantity INT NOT NULL,
    quantity_change INT NOT NULL,
    movement_type ENUM('STOCK_IN', 'STOCK_OUT') NOT NULL,
    reason VARCHAR(255),
    changed_by INT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stock_movement_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_stock_movement_user
        FOREIGN KEY (changed_by)
        REFERENCES users(user_id),

    INDEX idx_stock_movement_product (product_id),
    INDEX idx_stock_movement_date (changed_at)
) ENGINE=InnoDB;

-- Automatically record product quantity changes
DELIMITER $$

CREATE TRIGGER trg_stock_movement_after_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.quantity <> NEW.quantity THEN

        INSERT INTO stock_movements (
            product_id,
            previous_quantity,
            new_quantity,
            quantity_change,
            movement_type,
            reason,
            changed_by
        )
        VALUES (
            NEW.product_id,
            OLD.quantity,
            NEW.quantity,
            NEW.quantity - OLD.quantity,
            IF(
                NEW.quantity > OLD.quantity,
                'STOCK_IN',
                'STOCK_OUT'
            ),
            COALESCE(
                @freshfirst_movement_reason,
                'Quantity updated'
            ),
            COALESCE(
                @freshfirst_actor_user_id,
                NEW.created_by
            )
        );

    END IF;
END$$

DELIMITER ;
