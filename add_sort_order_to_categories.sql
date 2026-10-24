-- Add sort_order to categories table
ALTER TABLE `categories` ADD COLUMN `sort_order` int(11) DEFAULT 0;