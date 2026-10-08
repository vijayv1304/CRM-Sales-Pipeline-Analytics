-- CRM SALES PIPELINE ANALYTICS
-- 03 DATA CLEANING
-- Pattern: preview -> update -> validate.

-- Standardize sales_pipeline product join key
SELECT product, COUNT(*) AS rows_affected
FROM sales_pipeline
WHERE product = 'GTXPro'
GROUP BY product;

UPDATE sales_pipeline
SET product = 'GTX Pro'
WHERE product = 'GTXPro';

SELECT
    COUNT(*) FILTER (WHERE product = 'GTXPro') AS old_value,
    COUNT(*) FILTER (WHERE product = 'GTX Pro') AS new_value
FROM sales_pipeline;
-- Observed after cleaning: 0 old, 1480 standardized.

-- Correct account sector typo
SELECT sector, COUNT(*) FROM accounts
WHERE sector = 'technolgy' GROUP BY sector;

UPDATE accounts
SET sector = 'technology'
WHERE sector = 'technolgy';

-- Correct office location typo
SELECT office_location, COUNT(*) FROM accounts
WHERE office_location = 'Philipines'
GROUP BY office_location;

UPDATE accounts
SET office_location = 'Philippines'
WHERE office_location = 'Philipines';

SELECT
    COUNT(*) FILTER (WHERE sector = 'technolgy') AS old_sector,
    COUNT(*) FILTER (WHERE sector = 'technology') AS technology,
    COUNT(*) FILTER (WHERE office_location = 'Philipines') AS old_location,
    COUNT(*) FILTER (WHERE office_location = 'Philippines') AS philippines
FROM accounts;

-- Normalize repeated whitespace in product master
SELECT
    product AS raw_product,
    REGEXP_REPLACE(TRIM(product), '\s+', ' ', 'g') AS cleaned_product
FROM products
ORDER BY product;

UPDATE products
SET product = REGEXP_REPLACE(TRIM(product), '\s+', ' ', 'g');

SELECT product, series, sales_price
FROM products
ORDER BY product;

/*
NULL-handling decisions:
- account: 1425 NULLs retained.
- engage_date: 500 NULLs retained (Prospecting).
- close_date: 2089 NULLs retained (open opportunities).
- close_value: 2089 NULLs retained (open opportunities).
- subsidiary_of: 70 NULLs retained (no recorded parent).
- Lost close_value = 0 retained; 0 and NULL have different meanings.
No fake dates, zeros, Unknown, or N/A values were introduced.
*/
