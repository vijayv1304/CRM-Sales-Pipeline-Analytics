-- CRM SALES PIPELINE ANALYTICS
-- 01 DATABASE SETUP
-- Database: crm_sales_analytics

CREATE TABLE sales_pipeline (
    opportunity_id VARCHAR(50),
    sales_agent VARCHAR(100),
    product VARCHAR(100),
    account VARCHAR(150),
    deal_stage VARCHAR(50),
    engage_date DATE,
    close_date DATE,
    close_value NUMERIC(12,2)
);

CREATE TABLE accounts (
    account VARCHAR(150),
    sector VARCHAR(100),
    year_established INTEGER,
    revenue NUMERIC(15,2),
    employees INTEGER,
    office_location VARCHAR(100),
    subsidiary_of VARCHAR(150)
);

CREATE TABLE sales_teams (
    sales_agent VARCHAR(100),
    manager VARCHAR(100),
    regional_office VARCHAR(50)
);

CREATE TABLE products (
    product VARCHAR(100),
    series VARCHAR(50),
    sales_price NUMERIC(12,2)
);

-- Post-import validation. Expected: 8800, 85, 35, 7.
SELECT 'sales_pipeline' AS table_name, COUNT(*) AS row_count FROM sales_pipeline
UNION ALL SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL SELECT 'sales_teams', COUNT(*) FROM sales_teams
UNION ALL SELECT 'products', COUNT(*) FROM products;
