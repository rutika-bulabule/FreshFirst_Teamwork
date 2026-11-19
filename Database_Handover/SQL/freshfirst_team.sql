-- FreshFirst Team Database Export
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 15, 2026 at 05:27 AM
-- Server version: 9.1.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `freshfirst_team`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `verify_product`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verify_product` (IN `p_product_id` INT)   BEGIN
    SELECT
        p.product_id,
        p.product_name,
        p.expiry_date,
        p.storage_temperature,
        c.min_storage_temp,
        c.max_storage_temp,
        CASE
            WHEN p.expiry_date < CURRENT_DATE THEN 'UNSAFE'
            WHEN p.storage_temperature < c.min_storage_temp
              OR p.storage_temperature > c.max_storage_temp
                THEN 'WARNING'
            WHEN DATEDIFF(p.expiry_date, CURRENT_DATE)
                 <= c.near_expiry_days THEN 'WARNING'
            ELSE 'SAFE'
        END AS verification_status
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE p.product_id = p_product_id;
END$$

DROP PROCEDURE IF EXISTS `verify_product_temperature`$$
CREATE PROCEDURE `verify_product_temperature`(
    IN p_product_id INT,
    IN p_verified_by INT,
    IN p_actual_temperature DECIMAL(5,2),
    IN p_remarks VARCHAR(255)
)
BEGIN
    DECLARE v_min_temp DECIMAL(5,2);
    DECLARE v_max_temp DECIMAL(5,2);
    DECLARE v_category_found INT DEFAULT 0;
    DECLARE v_status VARCHAR(20);

    SELECT COUNT(*), MAX(c.min_storage_temp), MAX(c.max_storage_temp)
    INTO v_category_found, v_min_temp, v_max_temp
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE p.product_id = p_product_id;

    IF v_category_found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product not found';
    ELSE
        IF p_actual_temperature BETWEEN v_min_temp AND v_max_temp THEN
            SET v_status = 'SAFE';
        ELSE
            SET v_status = 'UNSAFE';
        END IF;

        INSERT INTO verifications (
            product_id, verified_by, actual_temperature,
            verification_status, remarks
        )
        VALUES (
            p_product_id, p_verified_by, p_actual_temperature,
            v_status, p_remarks
        );

        SELECT LAST_INSERT_ID() AS verification_id,
               v_status AS verification_status;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
CREATE TABLE IF NOT EXISTS `actions` (
  `action_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `assigned_to` int DEFAULT NULL,
  `action_type` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('CRITICAL','HIGH','MEDIUM','LOW','INSPECTION') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIUM',
  `action_status` enum('PENDING','IN_PROGRESS','DONE') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`action_id`),
  KEY `product_id` (`product_id`),
  KEY `assigned_to` (`assigned_to`),
  KEY `idx_actions_status` (`action_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_storage_temp` decimal(5,2) NOT NULL,
  `max_storage_temp` decimal(5,2) NOT NULL,
  `near_expiry_days` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `min_storage_temp`, `max_storage_temp`, `near_expiry_days`) VALUES
(1, 'Bakery', 15.00, 25.00, 2),
(2, 'Dairy', 2.00, 8.00, 3),
(3, 'Fruits', 4.00, 12.00, 3),
(4, 'Vegetables', 4.00, 12.00, 3);

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE IF NOT EXISTS `history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `activity` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `activity_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_history_activity_time` (`activity_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`history_id`, `product_id`, `user_id`, `activity`, `details`, `activity_time`) VALUES
(1, 1, 1, 'PRODUCT VERIFIED', 'Fresh Milk verified successfully. Status: SAFE. Temperature: 5.00 C', '2026-11-15 05:20:32');

--
-- Triggers `history`
--
DROP TRIGGER IF EXISTS `trg_history_prevent_delete`;
DELIMITER $$
CREATE TRIGGER `trg_history_prevent_delete` BEFORE DELETE ON `history` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'History records cannot be deleted';
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_history_prevent_update`;
DELIMITER $$
CREATE TRIGGER `trg_history_prevent_update` BEFORE UPDATE ON `history` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'History records cannot be updated';
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kg',
  `purchase_date` date DEFAULT NULL,
  `expiry_date` date NOT NULL,
  `storage_temperature` decimal(5,2) DEFAULT NULL,
  `created_by` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_products_expiry` (`expiry_date`),
  KEY `idx_products_category` (`category_id`),
  KEY `idx_products_name` (`product_name`)
) ;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `category_id`, `quantity`, `unit`, `purchase_date`, `expiry_date`, `storage_temperature`, `created_by`, `created_at`) VALUES
(1, 'Fresh Milk', 2, 20, 'litres', '2026-11-15', '2026-11-20', 5.00, 1, '2026-11-15 04:53:40'),
(2, 'Apple', 3, 30, 'kg', '2026-11-15', '2026-11-22', 6.00, 1, '2026-11-15 04:53:40'),
(3, 'Banana', 3, 25, 'kg', '2026-11-15', '2026-11-17', 8.00, 1, '2026-11-15 04:53:40'),
(4, 'Carrot', 4, 15, 'kg', '2026-11-15', '2026-11-25', 5.00, 1, '2026-11-15 04:53:40'),
(5, 'Bread', 1, 20, 'packets', '2026-11-15', '2026-11-18', 22.00, 1, '2026-11-15 04:53:40');

--
-- Triggers `products`
--
DROP TRIGGER IF EXISTS `trg_product_after_insert`;
DELIMITER $$
CREATE TRIGGER `trg_product_after_insert` AFTER INSERT ON `products` FOR EACH ROW BEGIN
    INSERT INTO history (product_id, user_id, activity, details)
    VALUES (
        NEW.product_id,
        NEW.created_by,
        'PRODUCT ADDED',
        CONCAT('New product added: ', NEW.product_name,
               ', Quantity: ', NEW.quantity)
    );
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_product_after_update`;
DELIMITER $$
CREATE TRIGGER `trg_product_after_update` AFTER UPDATE ON `products` FOR EACH ROW BEGIN
    INSERT INTO history (product_id, user_id, activity, details)
    VALUES (
        NEW.product_id,
        NEW.created_by,
        'PRODUCT UPDATED',
        CONCAT('Product updated: ', NEW.product_name,
               ', Quantity: ', NEW.quantity)
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('ADMIN','MANAGER','STAFF') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `username`, `password_hash`, `role`, `created_at`) VALUES
(1, 'Project Administrator', 'admin', 'TEMP_HASH_ADMIN', 'ADMIN', '2026-11-15 04:53:11'),
(2, 'Stock Manager', 'manager1', 'TEMP_HASH_MANAGER', 'MANAGER', '2026-11-15 04:53:11'),
(3, 'Stock Staff', 'staff1', 'TEMP_HASH_STAFF', 'STAFF', '2026-11-15 04:53:11');

-- --------------------------------------------------------

--
-- Table structure for table `verifications`
--

DROP TABLE IF EXISTS `verifications`;
CREATE TABLE IF NOT EXISTS `verifications` (
  `verification_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `verified_by` int NOT NULL,
  `actual_temperature` decimal(5,2) NOT NULL,
  `verification_status` enum('SAFE','WARNING','UNSAFE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`verification_id`),
  KEY `verified_by` (`verified_by`),
  KEY `idx_verifications_product` (`product_id`),
  KEY `idx_verifications_date` (`verified_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `verifications`
--

INSERT INTO `verifications` (`verification_id`, `product_id`, `verified_by`, `actual_temperature`, `verification_status`, `remarks`, `verified_at`) VALUES
(1, 1, 1, 5.00, 'SAFE', 'Routine temperature check', '2026-11-15 05:19:22');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `actions`
--
ALTER TABLE `actions`
  ADD CONSTRAINT `actions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `actions_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `history_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `verifications`
--
ALTER TABLE `verifications`
  ADD CONSTRAINT `verifications_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `verifications_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
