-- Migration: Add secondary download link (file_url_2) and link toggle to products table
-- Run this SQL to update your database

ALTER TABLE `products` ADD COLUMN `file_url_2` VARCHAR(255) DEFAULT NULL AFTER `file_url`;
ALTER TABLE `products` ADD COLUMN `use_secondary_link` TINYINT(1) NOT NULL DEFAULT 0 AFTER `file_url_2`;
