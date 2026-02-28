-- Optional: add source column to ordere for "Sales by Source" (Google, FB, X, IG, etc.)
-- Run this once to enable the Accounting > "Total sales by source" report.
-- Then capture utm_source (or referrer) in checkout and save to this column.
-- If the column already exists, skip this or you will get an error.

ALTER TABLE `ordere` ADD COLUMN `source` VARCHAR(100) DEFAULT NULL AFTER `method`;

-- Optional: add delivery_cost for "Delivery fee collected vs Delivery Cost" and related reports.
-- delivery_fee = what the customer pays (already in ordere). delivery_cost = what you pay (driver, fuel, etc.).
-- If the column already exists, skip this or you will get an error.

ALTER TABLE `ordere` ADD COLUMN `delivery_cost` DECIMAL(10,2) DEFAULT NULL AFTER `delivery_fee`;
