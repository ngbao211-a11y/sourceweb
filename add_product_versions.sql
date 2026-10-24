-- Migration: Add Product Version Group System
-- Run this SQL on the production database

-- 1. Create product_groups table
CREATE TABLE IF NOT EXISTS `product_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- 2. Add group-related columns to products table
ALTER TABLE `products`
  ADD COLUMN `group_id` int(11) DEFAULT NULL,
  ADD COLUMN `version_name` varchar(100) DEFAULT NULL,
  ADD COLUMN `is_latest` tinyint(1) DEFAULT 0,
  ADD COLUMN `sort_order` int(11) DEFAULT 0,
  ADD INDEX `idx_group_id` (`group_id`),
  ADD INDEX `idx_is_latest` (`is_latest`);
