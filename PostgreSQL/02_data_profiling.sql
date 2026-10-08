-- CRM SALES PIPELINE ANALYTICS
-- 02 DATA PROFILING

-- Sales pipeline completeness and uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT opportunity_id) AS unique_opportunity_ids,
    COUNT(*) - COUNT(DISTINCT opportunity_id) AS duplicate_opportunity_ids,
    COUNT(*) FILTER (WHERE sales_agent IS NULL OR TRIM(sales_agent) = '') AS missing_sales_agent,
    COUNT(*) FILTER (WHERE product IS NULL OR TRIM(product) = '') AS missing_product,
    COUNT(*) FILTER (WHERE account IS NULL OR TRIM(account) = '') AS missing_account,
    COUNT(*) FILTER (WHERE deal_stage IS NULL OR TRIM(deal_stage) = '') AS missing_deal_stage,
    COUNT(*) FILTER (WHERE engage_date IS NULL) AS missing_engage_date,
    COUNT(*) FILTER (WHERE close_date IS NULL) AS missing_close_date,
    COUNT(*) FILTER (WHERE close_value IS NULL) AS missing_close_value
FROM sales_pipeline;

/*
Observed: 8800 rows, 8800 unique IDs, 0 duplicate IDs,
1425 missing account, 500 missing engage_date,
2089 missing close_date, 2089 missing close_value.
*/

-- Null patterns by business stage
SELECT
    deal_stage,
    COUNT(*) AS total_opportunities,
    COUNT(*) FILTER (WHERE engage_date IS NULL) AS missing_engage_date,
    COUNT(*) FILTER (WHERE close_date IS NULL) AS missing_close_date,
    COUNT(*) FILTER (WHERE close_value IS NULL) AS missing_close_value,
    COUNT(*) FILTER (WHERE account IS NULL OR TRIM(account) = '') AS missing_account
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY deal_stage;

/*
Engaging: 1589; close date/value missing for all; missing account 1088.
Lost: 2473; closing fields complete.
Prospecting: 500; engage/close/value missing for all; missing account 337.
Won: 4238; closing fields complete.

2089 missing close dates/values = 1589 Engaging + 500 Prospecting.
These are business-valid open opportunities and must be preserved.
*/

-- Date consistency
SELECT COUNT(*) AS invalid_date_sequences
FROM sales_pipeline
WHERE engage_date IS NOT NULL
  AND close_date IS NOT NULL
  AND engage_date > close_date;
-- Observed: 0

SELECT
    MIN(engage_date) AS min_engage_date,
    MAX(engage_date) AS max_engage_date,
    MIN(close_date) AS min_close_date,
    MAX(close_date) AS max_close_date
FROM sales_pipeline;

-- Close value validation
SELECT
    COUNT(*) FILTER (WHERE close_value > 0) AS positive_values,
    COUNT(*) FILTER (WHERE close_value = 0) AS zero_values,
    COUNT(*) FILTER (WHERE close_value < 0) AS negative_values,
    COUNT(*) FILTER (WHERE close_value IS NULL) AS missing_values,
    MAX(close_value) AS max_close_value
FROM sales_pipeline;
-- Observed: 4238 positive, 2473 zero, 0 negative, 2089 NULL.

-- Deal stages
SELECT deal_stage, COUNT(*) AS opportunity_count
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY deal_stage;

-- Sales-agent distribution
SELECT sales_agent, COUNT(*) AS opportunity_count
FROM sales_pipeline
GROUP BY sales_agent
ORDER BY opportunity_count DESC, sales_agent;

-- Raw product values in fact and master
SELECT product, COUNT(*) AS opportunity_count
FROM sales_pipeline
GROUP BY product
ORDER BY product;

SELECT product, series, sales_price
FROM products
ORDER BY product;
/*
Detected: GTXPro vs GTX Pro; repeated internal whitespace in
MG   Advanced and GTX   Plus Basic.
*/

-- Accounts profiling
SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT account) AS unique_accounts,
    COUNT(*) FILTER (WHERE subsidiary_of IS NULL OR TRIM(subsidiary_of) = '') AS missing_subsidiary_of,
    MIN(year_established) AS min_year,
    MAX(year_established) AS max_year,
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    MIN(employees) AS min_employees,
    MAX(employees) AS max_employees
FROM accounts;

SELECT sector, COUNT(*) AS account_count
FROM accounts GROUP BY sector ORDER BY sector;

SELECT office_location, COUNT(*) AS account_count
FROM accounts GROUP BY office_location ORDER BY office_location;
/* Detected: technolgy and Philipines. */

-- Sales-team profiling
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT sales_agent) AS distinct_agents,
    COUNT(*) FILTER (WHERE sales_agent IS NULL OR TRIM(sales_agent) = '') AS missing_agent,
    COUNT(*) FILTER (WHERE manager IS NULL OR TRIM(manager) = '') AS missing_manager,
    COUNT(*) FILTER (WHERE regional_office IS NULL OR TRIM(regional_office) = '') AS missing_region
FROM sales_teams;

SELECT manager, COUNT(*) AS agent_count
FROM sales_teams GROUP BY manager ORDER BY manager;

SELECT regional_office, COUNT(*) AS agent_count
FROM sales_teams GROUP BY regional_office ORDER BY regional_office;

-- Product profiling
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product) AS distinct_products,
    COUNT(*) FILTER (WHERE product IS NULL OR TRIM(product) = '') AS missing_product,
    COUNT(*) FILTER (WHERE series IS NULL OR TRIM(series) = '') AS missing_series,
    COUNT(*) FILTER (WHERE sales_price IS NULL) AS missing_price,
    MIN(sales_price) AS min_price,
    MAX(sales_price) AS max_price,
    COUNT(*) FILTER (WHERE sales_price = 0) AS zero_price,
    COUNT(*) FILTER (WHERE sales_price < 0) AS negative_price
FROM products;
