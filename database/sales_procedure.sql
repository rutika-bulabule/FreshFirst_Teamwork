DELIMITER //

CREATE PROCEDURE sp_record_sale(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2),
    IN p_actor_user_id INT
)
BEGIN
    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_actor_count INT DEFAULT 0;
    DECLARE v_sale_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET @freshfirst_actor_user_id = NULL;
        SET @freshfirst_movement_reason = NULL;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    IF p_unit_price IS NULL OR p_unit_price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid unit price';
    END IF;

    SELECT COUNT(*) INTO v_actor_count
    FROM users
    WHERE user_id = p_actor_user_id;

    IF v_actor_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid actor user ID';
    END IF;

    SELECT quantity INTO v_stock
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

    INSERT INTO sales (customer_id, sale_status)
    VALUES (p_customer_id, 'COMPLETED');

    SET v_sale_id = LAST_INSERT_ID();

    INSERT INTO sale_items (
        sale_id, product_id, quantity, unit_price
    )
    VALUES (
        v_sale_id, p_product_id, p_quantity, p_unit_price
    );

    SET @freshfirst_actor_user_id = p_actor_user_id;
    SET @freshfirst_movement_reason = CONCAT(
        'Customer sale #', v_sale_id
    );

    UPDATE products
    SET quantity = quantity - p_quantity
    WHERE product_id = p_product_id;

    COMMIT;

    SET @freshfirst_actor_user_id = NULL;
    SET @freshfirst_movement_reason = NULL;

    SELECT
        v_sale_id AS sale_id,
        p_quantity AS quantity_sold,
        p_unit_price AS unit_price,
        p_quantity * p_unit_price AS total_amount;
END //

DELIMITER ;
