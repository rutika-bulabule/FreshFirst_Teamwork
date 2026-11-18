-- FreshFirst Team
-- Migration: Verification Procedure Input Validation
-- Applied: 18 November 2026
-- Database: freshfirst_team

USE freshfirst_team;

DELIMITER //

DROP PROCEDURE IF EXISTS verify_product_temperature//

CREATE PROCEDURE verify_product_temperature(
    IN p_product_id INT,
    IN p_verified_by INT,
    IN p_actual_temperature DECIMAL(5,2),
    IN p_remarks VARCHAR(255)
)
BEGIN
    DECLARE v_min_temp DECIMAL(5,2);
    DECLARE v_max_temp DECIMAL(5,2);
    DECLARE v_category_found INT DEFAULT 0;
    DECLARE v_user_found INT DEFAULT 0;
    DECLARE v_status VARCHAR(20);

    IF p_actual_temperature IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Temperature cannot be NULL';
    END IF;

    SELECT COUNT(*),
           MAX(c.min_storage_temp),
           MAX(c.max_storage_temp)
    INTO v_category_found, v_min_temp, v_max_temp
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE p.product_id = p_product_id;

    IF v_category_found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product not found';
    END IF;

    SELECT COUNT(*)
    INTO v_user_found
    FROM users
    WHERE user_id = p_verified_by;

    IF v_user_found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User not found';
    END IF;

    IF p_actual_temperature BETWEEN v_min_temp AND v_max_temp THEN
        SET v_status = 'SAFE';
    ELSE
        SET v_status = 'UNSAFE';
    END IF;

    INSERT INTO verifications (
        product_id,
        verified_by,
        actual_temperature,
        verification_status,
        remarks
    )
    VALUES (
        p_product_id,
        p_verified_by,
        p_actual_temperature,
        v_status,
        p_remarks
    );

    SELECT LAST_INSERT_ID() AS verification_id,
           v_status AS verification_status;
END//

DELIMITER ;
