-- Migration: Add short_code column to products table
-- This column stores a random short identifier for clean product URLs
-- Example URL: /p/abc123 instead of /product/long-title-slug-here

ALTER TABLE `products` ADD COLUMN `short_code` VARCHAR(10) DEFAULT NULL AFTER `slug`;
ALTER TABLE `products` ADD UNIQUE INDEX `idx_short_code` (`short_code`);