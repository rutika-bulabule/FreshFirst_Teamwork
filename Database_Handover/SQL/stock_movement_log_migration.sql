USE freshfirst_team;

CREATE TABLE IF NOT EXISTS stock_movements (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    previous_quantity INT NOT NULL,
    new_quantity INT NOT NULL,
    quantity_change INT NOT NULL,
    movement_type ENUM('STOCK_IN', 'STOCK_OUT') NOT NULL,
    reason VARCHAR(255) NOT NULL,
    changed_by INT NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stock_movement_product
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_stock_movement_user
        FOREIGN KEY (changed_by) REFERENCES users(user_id),
    INDEX idx_stock_movement_product (product_id),
    INDEX idx_stock_movement_date (changed_at)
) ENGINE=InnoDB;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_stock_movement_after_update$$

CREATE TRIGGER trg_stock_movement_after_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.quantity <> NEW.quantity THEN
        IF @freshfirst_actor_user_id IS NULL
           OR @freshfirst_actor_user_id <= 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A valid stock movement actor is required';
        END IF;

        IF @freshfirst_movement_reason IS NULL
           OR CHAR_LENGTH(TRIM(@freshfirst_movement_reason)) = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A stock movement reason is required';
        END IF;

        IF NOT EXISTS (
            SELECT 1 FROM users
            WHERE user_id = @freshfirst_actor_user_id
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Stock movement actor does not exist';
        END IF;

        INSERT INTO stock_movements (
            product_id, previous_quantity, new_quantity,
            quantity_change, movement_type, reason, changed_by
        )
        VALUES (
            NEW.product_id, OLD.quantity, NEW.quantity,
            NEW.quantity - OLD.quantity,
            IF(NEW.quantity > OLD.quantity, 'STOCK_IN', 'STOCK_OUT'),
            TRIM(@freshfirst_movement_reason),
            @freshfirst_actor_user_id
        );
    END IF;
END$$

DROP PROCEDURE IF EXISTS sp_update_product_quantity_with_audit$$

CREATE PROCEDURE sp_update_product_quantity_with_audit(
    IN p_product_id INT,
    IN p_new_quantity INT,
    IN p_actor_user_id INT,
    IN p_reason VARCHAR(255)
)
BEGIN
    DECLARE v_product_count INT DEFAULT 0;
    DECLARE v_user_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @freshfirst_actor_user_id = NULL;
        SET @freshfirst_movement_reason = NULL;
        RESIGNAL;
    END;

    IF p_product_id IS NULL OR p_product_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A valid product ID is required';
    END IF;

    IF p_new_quantity IS NULL OR p_new_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'New quantity must be greater than zero';
    END IF;

    IF p_actor_user_id IS NULL OR p_actor_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A valid actor user ID is required';
    END IF;

    IF p_reason IS NULL OR CHAR_LENGTH(TRIM(p_reason)) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A stock movement reason is required';
    END IF;

    SELECT COUNT(*) INTO v_product_count
    FROM products WHERE product_id = p_product_id;

    IF v_product_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    SELECT COUNT(*) INTO v_user_count
    FROM users WHERE user_id = p_actor_user_id;

    IF v_user_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Actor user does not exist';
    END IF;

    SET @freshfirst_actor_user_id = p_actor_user_id;
    SET @freshfirst_movement_reason = TRIM(p_reason);

    UPDATE products
    SET quantity = p_new_quantity
    WHERE product_id = p_product_id;

    SET @freshfirst_actor_user_id = NULL;
    SET @freshfirst_movement_reason = NULL;

    SELECT p_product_id AS product_id,
           p_new_quantity AS new_quantity,
           'Quantity update completed' AS result;
END$$

DELIMITER ;
