CREATE DATABASE  IF NOT EXISTS `freshfirst_team` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `freshfirst_team`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: freshfirst_team
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action_history`
--

DROP TABLE IF EXISTS `action_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_history` (
  `action_history_id` int NOT NULL AUTO_INCREMENT,
  `action_id` int NOT NULL,
  `actor_user_id` int DEFAULT NULL,
  `event_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_status` enum('PENDING','IN_PROGRESS','DONE') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_status` enum('PENDING','IN_PROGRESS','DONE') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_details` text COLLATE utf8mb4_unicode_ci,
  `event_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`action_history_id`),
  KEY `fk_action_history_action` (`action_id`),
  KEY `fk_action_history_user` (`actor_user_id`),
  CONSTRAINT `fk_action_history_action` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`),
  CONSTRAINT `fk_action_history_user` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_history`
--

LOCK TABLES `action_history` WRITE;
/*!40000 ALTER TABLE `action_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_action_history_prevent_update` BEFORE UPDATE ON `action_history` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Action audit records cannot be updated';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_action_history_prevent_delete` BEFORE DELETE ON `action_history` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Action audit records cannot be deleted';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions` (
  `action_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `assigned_to` int DEFAULT NULL,
  `action_type` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('CRITICAL','HIGH','MEDIUM','LOW','INSPECTION') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIUM',
  `action_status` enum('PENDING','IN_PROGRESS','DONE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`action_id`),
  KEY `product_id` (`product_id`),
  KEY `assigned_to` (`assigned_to`),
  KEY `idx_actions_status` (`action_status`),
  CONSTRAINT `actions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `actions_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_actions_completion_timestamp` CHECK ((((`action_status` = _utf8mb4'DONE') and (`completed_at` is not null)) or ((`action_status` in (_utf8mb4'PENDING',_utf8mb4'IN_PROGRESS')) and (`completed_at` is null))))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_actions_before_insert` BEFORE INSERT ON `actions` FOR EACH ROW BEGIN
    IF NEW.action_status = 'DONE' AND NEW.completed_at IS NULL THEN
        SET NEW.completed_at = CURRENT_TIMESTAMP;
    END IF;

    IF NEW.action_status <> 'DONE' THEN
        SET NEW.completed_at = NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_action_history_after_insert` AFTER INSERT ON `actions` FOR EACH ROW BEGIN
    DECLARE v_actor_user_id INT DEFAULT NULL;

    SELECT MAX(user_id)
    INTO v_actor_user_id
    FROM users
    WHERE user_id = @freshfirst_actor_user_id;

    INSERT INTO action_history (
        action_id,
        actor_user_id,
        event_type,
        old_status,
        new_status,
        event_details
    )
    VALUES (
        NEW.action_id,
        v_actor_user_id,
        'ACTION_CREATED',
        NULL,
        NEW.action_status,
        NEW.description
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_actions_before_update` BEFORE UPDATE ON `actions` FOR EACH ROW BEGIN
    IF NEW.action_status = 'DONE' AND OLD.action_status <> 'DONE' THEN
        SET NEW.completed_at = CURRENT_TIMESTAMP;
    END IF;

    IF NEW.action_status <> 'DONE' THEN
        SET NEW.completed_at = NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_action_history_after_update` AFTER UPDATE ON `actions` FOR EACH ROW BEGIN
    DECLARE v_actor_user_id INT DEFAULT NULL;

    SELECT MAX(user_id)
    INTO v_actor_user_id
    FROM users
    WHERE user_id = @freshfirst_actor_user_id;

    IF NOT (OLD.action_status <=> NEW.action_status) THEN
        INSERT INTO action_history (
            action_id,
            actor_user_id,
            event_type,
            old_status,
            new_status,
            event_details
        )
        VALUES (
            NEW.action_id,
            v_actor_user_id,
            'STATUS_CHANGED',
            OLD.action_status,
            NEW.action_status,
            NEW.description
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_storage_temp` decimal(5,2) NOT NULL,
  `max_storage_temp` decimal(5,2) NOT NULL,
  `near_expiry_days` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`),
  CONSTRAINT `categories_chk_1` CHECK ((`min_storage_temp` <= `max_storage_temp`)),
  CONSTRAINT `categories_chk_2` CHECK ((`near_expiry_days` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Bakery',15.00,25.00,2),(2,'Dairy',2.00,8.00,3),(3,'Fruits',4.00,12.00,3),(4,'Vegetables',4.00,12.00,3);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `activity` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `activity_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_history_activity_time` (`activity_time`),
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `history_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
INSERT INTO `history` VALUES (1,1,1,'PRODUCT VERIFIED','Fresh Milk verified successfully. Status: SAFE. Temperature: 5.00 C','2026-11-15 05:20:32'),(5,1,1,'PRODUCT UPDATED','Product updated: Fresh Milk, Quantity: 21','2026-11-19 07:48:52'),(6,1,1,'PRODUCT UPDATED','Product updated: Fresh Milk, Quantity: 20','2026-11-19 07:49:19'),(8,1,2,'PRODUCT UPDATED','Product updated: Fresh Milk, Quantity: 21','2026-11-19 08:54:46'),(9,1,2,'PRODUCT UPDATED','Product updated: Fresh Milk, Quantity: 20','2026-11-19 08:54:46');
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_history_prevent_update` BEFORE UPDATE ON `history` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'History records cannot be updated';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_history_prevent_delete` BEFORE DELETE ON `history` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'History records cannot be deleted';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
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
  KEY `idx_products_name` (`product_name`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_products_quantity_positive` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Fresh Milk',2,20,'litres','2026-11-15','2026-11-20',5.00,1,'2026-11-15 04:53:40'),(2,'Apple',3,30,'kg','2026-11-15','2026-11-22',6.00,1,'2026-11-15 04:53:40'),(3,'Banana',3,25,'kg','2026-11-15','2026-11-17',8.00,1,'2026-11-15 04:53:40'),(4,'Carrot',4,15,'kg','2026-11-15','2026-11-25',5.00,1,'2026-11-15 04:53:40'),(5,'Bread',1,20,'packets','2026-11-15','2026-11-18',22.00,1,'2026-11-15 04:53:40');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_product_after_insert` AFTER INSERT ON `products` FOR EACH ROW BEGIN
    INSERT INTO history (product_id, user_id, activity, details)
    VALUES (
        NEW.product_id,
        NEW.created_by,
        'PRODUCT ADDED',
        CONCAT('New product added: ', NEW.product_name,
               ', Quantity: ', NEW.quantity)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_product_after_update` AFTER UPDATE ON `products` FOR EACH ROW BEGIN
    INSERT INTO history (product_id, user_id, activity, details)
    VALUES (
        NEW.product_id,
        COALESCE(@freshfirst_actor_user_id, NEW.created_by),
        'PRODUCT UPDATED',
        CONCAT(
            'Product updated: ', NEW.product_name,
            ', Quantity: ', NEW.quantity
        )
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('ADMIN','MANAGER','STAFF') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Project Administrator','admin','TEMP_HASH_ADMIN','ADMIN','2026-11-15 04:53:11'),(2,'Stock Manager','manager1','TEMP_HASH_MANAGER','MANAGER','2026-11-15 04:53:11'),(3,'Stock Staff','staff1','TEMP_HASH_STAFF','STAFF','2026-11-15 04:53:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verifications`
--

DROP TABLE IF EXISTS `verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verifications` (
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
  KEY `idx_verifications_date` (`verified_at`),
  CONSTRAINT `verifications_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `verifications_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verifications`
--

LOCK TABLES `verifications` WRITE;
/*!40000 ALTER TABLE `verifications` DISABLE KEYS */;
INSERT INTO `verifications` VALUES (1,1,1,5.00,'SAFE','Routine temperature check','2026-11-15 05:19:22');
/*!40000 ALTER TABLE `verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'freshfirst_team'
--

--
-- Dumping routines for database 'freshfirst_team'
--
/*!50003 DROP PROCEDURE IF EXISTS `verify_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `verify_product`(IN p_product_id INT)
BEGIN
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `verify_product_temperature` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `verify_product_temperature`(
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

    -- Validate temperature
    IF p_actual_temperature IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Temperature cannot be NULL';
    END IF;

    -- Validate product
    SELECT COUNT(*),
           MAX(c.min_storage_temp),
           MAX(c.max_storage_temp)
    INTO v_category_found, v_min_temp, v_max_temp
    FROM products p
    JOIN categories c
        ON p.category_id = c.category_id
    WHERE p.product_id = p_product_id;

    IF v_category_found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product not found';
    END IF;

    -- Validate user
    SELECT COUNT(*)
    INTO v_user_found
    FROM users
    WHERE user_id = p_verified_by;

    IF v_user_found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User not found';
    END IF;

    -- Determine temperature status
    IF p_actual_temperature BETWEEN v_min_temp AND v_max_temp THEN
        SET v_status = 'SAFE';
    ELSE
        SET v_status = 'UNSAFE';
    END IF;

    -- Insert verification
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

    SELECT
        LAST_INSERT_ID() AS verification_id,
        v_status AS verification_status;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-19 14:45:38
