-- CRM SALES PIPELINE ANALYTICS
-- 04 DATA VALIDATION & INTEGRITY CONSTRAINTS

-- Product FK coverage. Expected: 0 rows.
SELECT sp.product, COUNT(*) AS unmatched_rows
FROM sales_pipeline sp
LEFT JOIN products p ON sp.product = p.product
WHERE p.product IS NULL
GROUP BY sp.product;

-- Sales-agent FK coverage. Expected: 0 rows.
SELECT sp.sales_agent, COUNT(*) AS unmatched_rows
FROM sales_pipeline sp
LEFT JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE st.sales_agent IS NULL
GROUP BY sp.sales_agent;

-- Account FK coverage, excluding valid NULL accounts. Expected: 0 rows.
SELECT sp.account, COUNT(*) AS unmatched_rows
FROM sales_pipeline sp
LEFT JOIN accounts a ON sp.account = a.account
WHERE sp.account IS NOT NULL
  AND a.account IS NULL
GROUP BY sp.account;

-- Master sales agents with no opportunities. Expected: 5 agents.
SELECT st.sales_agent, st.manager, st.regional_office
FROM sales_teams st
LEFT JOIN sales_pipeline sp ON st.sales_agent = sp.sales_agent
WHERE sp.sales_agent IS NULL
ORDER BY st.sales_agent;

-- Fact vs dimension coverage. Observed: 7, 7, 30, 35, 85, 85.
SELECT
    (SELECT COUNT(DISTINCT product) FROM sales_pipeline) AS pipeline_products,
    (SELECT COUNT(*) FROM products) AS master_products,
    (SELECT COUNT(DISTINCT sales_agent) FROM sales_pipeline) AS active_sales_agents,
    (SELECT COUNT(*) FROM sales_teams) AS total_sales_agents,
    (SELECT COUNT(DISTINCT account) FROM sales_pipeline WHERE account IS NOT NULL) AS pipeline_accounts,
    (SELECT COUNT(*) FROM accounts) AS master_accounts;

-- Primary keys
ALTER TABLE sales_pipeline
ADD CONSTRAINT pk_sales_pipeline PRIMARY KEY (opportunity_id);

ALTER TABLE accounts
ADD CONSTRAINT pk_accounts PRIMARY KEY (account);

ALTER TABLE products
ADD CONSTRAINT pk_products PRIMARY KEY (product);

ALTER TABLE sales_teams
ADD CONSTRAINT pk_sales_teams PRIMARY KEY (sales_agent);

-- Foreign keys
ALTER TABLE sales_pipeline
ADD CONSTRAINT fk_pipeline_product
FOREIGN KEY (product) REFERENCES products(product);

ALTER TABLE sales_pipeline
ADD CONSTRAINT fk_pipeline_sales_agent
FOREIGN KEY (sales_agent) REFERENCES sales_teams(sales_agent);

ALTER TABLE sales_pipeline
ADD CONSTRAINT fk_pipeline_account
FOREIGN KEY (account) REFERENCES accounts(account);

-- Valid CRM deal-stage domain
ALTER TABLE sales_pipeline
ADD CONSTRAINT chk_deal_stage
CHECK (deal_stage IN ('Prospecting', 'Engaging', 'Won', 'Lost'));

/*
Do NOT set account, engage_date, close_date, close_value, or
subsidiary_of to NOT NULL. Their NULL values have validated
business meaning.
*/

-- Final constraint inspection
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
  AND tc.table_name IN ('sales_pipeline','accounts','products','sales_teams')
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;
