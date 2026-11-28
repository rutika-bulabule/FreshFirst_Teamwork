DELIMITER //

CREATE PROCEDURE sp_search_products(
    IN p_keyword VARCHAR(100),
    IN p_category_id INT
)
BEGIN
    SELECT
        product_id,
        product_name,
        category_id,
        quantity,
        unit_price,
        expiry_date
    FROM products
    WHERE
        (p_keyword IS NULL OR p_keyword = ''
         OR product_name LIKE CONCAT('%', p_keyword, '%'))
        AND
        (p_category_id IS NULL OR category_id = p_category_id)
    ORDER BY product_name;
END //

DELIMITER ;
