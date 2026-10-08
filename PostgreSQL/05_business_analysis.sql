/*
===============================================================================
PROJECT: CRM Sales Pipeline Analytics
FILE: 05_business_analysis.sql
PURPOSE: Final portfolio SQL business analysis
===============================================================================
*/

-- 01. OVERALL SALES PERFORMANCE
SELECT
    COUNT(*) AS total_opportunities,
    COUNT(*) FILTER (WHERE deal_stage = 'Won') AS won_opportunities,
    COUNT(*) FILTER (WHERE deal_stage = 'Lost') AS lost_opportunities,
    COUNT(*) FILTER (WHERE deal_stage IN ('Prospecting','Engaging')) AS open_opportunities,
    COUNT(*) FILTER (WHERE deal_stage IN ('Won','Lost')) AS closed_opportunities,
    ROUND(100.0 * COUNT(*) FILTER (WHERE deal_stage='Won')
        / NULLIF(COUNT(*) FILTER (WHERE deal_stage IN ('Won','Lost')),0),2) AS closed_deal_win_rate_pct,
    SUM(close_value) FILTER (WHERE deal_stage='Won') AS won_revenue,
    ROUND(AVG(close_value) FILTER (WHERE deal_stage='Won'),2) AS avg_won_deal_size
FROM sales_pipeline;
/* Findings: 8,800 opportunities; 4,238 Won; 2,473 Lost; 2,089 Open;
   closed-deal win rate 63.15%; Won revenue $10,005,534;
   average Won deal size $2,360.91. */


-- 02. MONTHLY REVENUE TREND
SELECT
    DATE_TRUNC('month',close_date)::date AS month,
    COUNT(*) AS won_deals,
    SUM(close_value) AS won_revenue,
    ROUND(AVG(close_value),2) AS avg_deal_size
FROM sales_pipeline
WHERE deal_stage='Won' AND close_date IS NOT NULL
GROUP BY DATE_TRUNC('month',close_date)
ORDER BY month;
/* Findings: June 2017 had the highest revenue ($1,338,466).
   October had the highest average Won deal size ($2,623.58). */


-- 03. MONTH-OVER-MONTH REVENUE GROWTH
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month',close_date)::date AS month,
        COUNT(*) AS won_deals,
        SUM(close_value) AS won_revenue
    FROM sales_pipeline
    WHERE deal_stage='Won' AND close_date IS NOT NULL
    GROUP BY DATE_TRUNC('month',close_date)
),
monthly_comparison AS (
    SELECT
        month, won_deals, won_revenue,
        LAG(won_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month, won_deals, won_revenue, previous_month_revenue,
    won_revenue-previous_month_revenue AS revenue_change,
    ROUND(100.0*(won_revenue-previous_month_revenue)
        / NULLIF(previous_month_revenue,0),2) AS mom_growth_pct
FROM monthly_comparison
ORDER BY month;
/* Highest MoM growth: Aug 2017 +50.67%.
   Largest MoM decline: Jul 2017 -47.93%. */


-- 04. PRODUCT PERFORMANCE
WITH product_performance AS (
    SELECT
        p.product,p.series,p.sales_price,
        COUNT(sp.opportunity_id) AS total_opportunities,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won') AS won_deals,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Lost') AS lost_deals,
        SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won') AS won_revenue,
        ROUND(AVG(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),2) AS avg_won_deal_size
    FROM products p
    LEFT JOIN sales_pipeline sp ON p.product=sp.product
    GROUP BY p.product,p.series,p.sales_price
)
SELECT
    product,series,sales_price,total_opportunities,won_deals,lost_deals,
    ROUND(100.0*won_deals/NULLIF(won_deals+lost_deals,0),2) AS win_rate_pct,
    won_revenue,avg_won_deal_size,
    ROUND(100.0*won_revenue/NULLIF(SUM(won_revenue) OVER(),0),2) AS revenue_contribution_pct
FROM product_performance
ORDER BY won_revenue DESC;
/* GTX Pro leads revenue at $3,510,578 (35.09%).
   Top 3 products contribute 83.52%.
   MG Special has the highest win rate (64.84%) but only 0.44% revenue. */


-- 05. SALES AGENT PERFORMANCE
WITH agent_performance AS (
    SELECT
        st.sales_agent,st.manager,st.regional_office,
        COUNT(sp.opportunity_id) AS total_opportunities,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won') AS won_deals,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Lost') AS lost_deals,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Prospecting','Engaging')) AS open_deals,
        COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0) AS won_revenue,
        ROUND(AVG(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),2) AS avg_won_deal_size
    FROM sales_teams st
    LEFT JOIN sales_pipeline sp ON st.sales_agent=sp.sales_agent
    GROUP BY st.sales_agent,st.manager,st.regional_office
),
ranked_agents AS (
    SELECT *,
        ROUND(100.0*won_deals/NULLIF(won_deals+lost_deals,0),2) AS win_rate_pct,
        ROUND(100.0*won_revenue/NULLIF(SUM(won_revenue) OVER(),0),2) AS revenue_contribution_pct,
        RANK() OVER (ORDER BY won_revenue DESC) AS revenue_rank
    FROM agent_performance
)
SELECT
    sales_agent,manager,regional_office,total_opportunities,won_deals,lost_deals,
    open_deals,win_rate_pct,won_revenue,avg_won_deal_size,
    revenue_contribution_pct,revenue_rank
FROM ranked_agents
ORDER BY revenue_rank,sales_agent;
/* Darcel Schlecht ranks #1: $1,153,214 (11.53%).
   Hayden Neloms has the highest active-agent win rate: 70.39%.
   Five team members have no opportunities; NULL win rate is appropriate. */


-- 06. MANAGER PERFORMANCE
SELECT
    st.manager,
    COUNT(DISTINCT st.sales_agent) AS team_size,
    COUNT(sp.opportunity_id) AS total_opportunities,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won') AS won_deals,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Lost') AS lost_deals,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Prospecting','Engaging')) AS open_deals,
    ROUND(100.0*COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won')
        / NULLIF(COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Won','Lost')),0),2) AS win_rate_pct,
    COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0) AS won_revenue,
    ROUND(AVG(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),2) AS avg_won_deal_size,
    ROUND(100.0*COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0)
        / NULLIF(SUM(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won')) OVER(),0),2) AS revenue_contribution_pct
FROM sales_teams st
LEFT JOIN sales_pipeline sp ON st.sales_agent=sp.sales_agent
GROUP BY st.manager
ORDER BY won_revenue DESC;
/* Melvin Marxen leads revenue: $2,251,930 (22.51%).
   Cara Losch has the highest manager win rate: 64.43%.
   Rocco Neubert has the highest average Won deal size: $2,837.26. */


-- 07. REGIONAL PERFORMANCE
SELECT
    st.regional_office,
    COUNT(DISTINCT st.sales_agent) AS team_size,
    COUNT(sp.opportunity_id) AS total_opportunities,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won') AS won_deals,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Lost') AS lost_deals,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Prospecting','Engaging')) AS open_deals,
    ROUND(100.0*COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won')
        / NULLIF(COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Won','Lost')),0),2) AS win_rate_pct,
    COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0) AS won_revenue,
    ROUND(AVG(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),2) AS avg_won_deal_size,
    ROUND(100.0*COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0)
        / NULLIF(SUM(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won')) OVER(),0),2) AS revenue_contribution_pct
FROM sales_teams st
LEFT JOIN sales_pipeline sp ON st.sales_agent=sp.sales_agent
GROUP BY st.regional_office
ORDER BY won_revenue DESC;
/* West leads revenue ($3,568,647 / 35.67%) and win rate (63.94%).
   Central has the highest volume; East has the highest avg Won deal size. */


-- 08. ACCOUNT / CUSTOMER PERFORMANCE
-- accounts.revenue = customer's own company revenue.
-- won_revenue = our CRM Won revenue from that customer.
WITH account_performance AS (
    SELECT
        a.account,a.sector,a.revenue AS account_company_revenue,
        a.employees,a.office_location,
        COUNT(sp.opportunity_id) AS total_opportunities,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won') AS won_deals,
        COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Lost') AS lost_deals,
        COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0) AS won_revenue,
        ROUND(AVG(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),2) AS avg_won_deal_size
    FROM accounts a
    LEFT JOIN sales_pipeline sp ON a.account=sp.account
    GROUP BY a.account,a.sector,a.revenue,a.employees,a.office_location
)
SELECT *,
    ROUND(100.0*won_deals/NULLIF(won_deals+lost_deals,0),2) AS win_rate_pct,
    ROUND(100.0*won_revenue/NULLIF(SUM(won_revenue) OVER(),0),2) AS revenue_contribution_pct,
    RANK() OVER (ORDER BY won_revenue DESC) AS revenue_rank
FROM account_performance
ORDER BY revenue_rank,account;
/* Kan-code is #1: $341,455 (3.41%).
   Customer performance should use revenue, conversion, volume and deal size. */


-- 09. CUSTOMER REVENUE CONCENTRATION
WITH account_revenue AS (
    SELECT
        a.account,
        COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0) AS won_revenue
    FROM accounts a
    LEFT JOIN sales_pipeline sp ON a.account=sp.account
    GROUP BY a.account
),
ranked_accounts AS (
    SELECT
        account,won_revenue,
        RANK() OVER (ORDER BY won_revenue DESC) AS revenue_rank,
        ROUND(100.0*won_revenue/NULLIF(SUM(won_revenue) OVER(),0),2) AS revenue_contribution_pct
    FROM account_revenue
)
SELECT account,won_revenue,revenue_contribution_pct,revenue_rank
FROM ranked_accounts
ORDER BY revenue_rank,account;
/* Top 5 ≈ 12.09%; Top 10 ≈ 20.72%.
   Revenue is relatively diversified across customers. */

-- Reconciliation
SELECT SUM(close_value) AS total_won_revenue
FROM sales_pipeline
WHERE deal_stage='Won';

SELECT COALESCE(SUM(close_value),0) AS won_revenue_missing_account
FROM sales_pipeline
WHERE deal_stage='Won' AND account IS NULL;


-- 10. SECTOR PERFORMANCE
SELECT
    a.sector,
    COUNT(DISTINCT a.account) AS total_accounts,
    COUNT(sp.opportunity_id) AS total_opportunities,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won') AS won_deals,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Lost') AS lost_deals,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Prospecting','Engaging')) AS open_deals,
    ROUND(100.0*COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Won')
        / NULLIF(COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage IN ('Won','Lost')),0),2) AS win_rate_pct,
    COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0) AS won_revenue,
    ROUND(AVG(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),2) AS avg_won_deal_size,
    ROUND(100.0*COALESCE(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won'),0)
        / NULLIF(SUM(SUM(sp.close_value) FILTER (WHERE sp.deal_stage='Won')) OVER(),0),2) AS revenue_contribution_pct
FROM accounts a
LEFT JOIN sales_pipeline sp ON a.account=sp.account
GROUP BY a.sector
ORDER BY won_revenue DESC;
/* Retail leads: $1,867,528 (18.66%).
   Marketing has the highest win rate: 64.85%.
   Entertainment has the highest avg Won deal: $2,650.03.
   Retail + Technology + Medical ≈ 47.40% of Won revenue. */


-- 11. SALES CYCLE ANALYSIS
SELECT
    deal_stage,
    COUNT(*) AS closed_deals,
    ROUND(AVG(close_date-engage_date),2) AS avg_sales_cycle_days,
    MIN(close_date-engage_date) AS min_sales_cycle_days,
    MAX(close_date-engage_date) AS max_sales_cycle_days
FROM sales_pipeline
WHERE deal_stage IN ('Won','Lost')
  AND engage_date IS NOT NULL AND close_date IS NOT NULL
GROUP BY deal_stage
ORDER BY deal_stage;
/* Lost avg: 41.48 days. Won avg: 51.78 days.
   Won deals take ~10.30 days longer on average. Association, not causation. */


-- 12. SALES CYCLE DISTRIBUTION
SELECT
    deal_stage,
    COUNT(*) AS closed_deals,
    ROUND(AVG(close_date-engage_date),2) AS avg_sales_cycle_days,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY close_date-engage_date)::numeric,2) AS median_sales_cycle_days,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY close_date-engage_date)::numeric,2) AS p25_sales_cycle_days,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY close_date-engage_date)::numeric,2) AS p75_sales_cycle_days
FROM sales_pipeline
WHERE deal_stage IN ('Won','Lost')
  AND engage_date IS NOT NULL AND close_date IS NOT NULL
GROUP BY deal_stage
ORDER BY deal_stage;
/* Won median: 57 days. Lost median: 14 days.
   Lost average is much higher than its median, so average alone is misleading. */


-- 13. PRODUCT SALES CYCLE
SELECT
    product,
    COUNT(*) FILTER (WHERE deal_stage='Won') AS won_deals,
    ROUND(AVG(close_date-engage_date) FILTER (WHERE deal_stage='Won'),2) AS avg_won_cycle_days,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY close_date-engage_date)
        FILTER (WHERE deal_stage='Won')::numeric,2) AS median_won_cycle_days,
    COUNT(*) FILTER (WHERE deal_stage='Lost') AS lost_deals,
    ROUND(AVG(close_date-engage_date) FILTER (WHERE deal_stage='Lost'),2) AS avg_lost_cycle_days,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY close_date-engage_date)
        FILTER (WHERE deal_stage='Lost')::numeric,2) AS median_lost_cycle_days
FROM sales_pipeline
WHERE deal_stage IN ('Won','Lost')
  AND engage_date IS NOT NULL AND close_date IS NOT NULL
GROUP BY product
ORDER BY avg_won_cycle_days DESC;
/* Won cycles are longer than Lost cycles across all seven products.
   GTK 500: longest Won avg 64.07 days, but only 15 Won deals.
   GTX Pro: shortest Won avg 48.33 days. */


-- 14. OPEN PIPELINE OVERVIEW
SELECT
    deal_stage,
    COUNT(*) AS open_opportunities,
    ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS open_pipeline_pct,
    COUNT(*) FILTER (WHERE account IS NULL) AS missing_account,
    COUNT(*) FILTER (WHERE account IS NOT NULL) AS identified_account
FROM sales_pipeline
WHERE deal_stage IN ('Prospecting','Engaging')
GROUP BY deal_stage
ORDER BY open_opportunities DESC;
/* 2,089 open opportunities: Engaging 1,589 (76.07%), Prospecting 500 (23.93%).
   1,425 (68.21%) have no identified account.
   close_value is NULL for open opportunities, so this is volume analysis. */


-- 15. OPEN PIPELINE BY PRODUCT
SELECT
    product,
    COUNT(*) AS open_opportunities,
    COUNT(*) FILTER (WHERE deal_stage='Prospecting') AS prospecting,
    COUNT(*) FILTER (WHERE deal_stage='Engaging') AS engaging,
    ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS open_pipeline_pct,
    COUNT(*) FILTER (WHERE account IS NULL) AS missing_account
FROM sales_pipeline
WHERE deal_stage IN ('Prospecting','Engaging')
GROUP BY product
ORDER BY open_opportunities DESC;
/* GTX Basic leads with 430 (20.58%); MG Special has 428 (20.49%).
   Together they represent ~41.07% of the open pipeline.
   GTK 500 has 15 open opportunities, all Engaging. */


-- 16. OPEN PIPELINE BY REGION
SELECT
    st.regional_office,
    COUNT(sp.opportunity_id) AS open_opportunities,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Prospecting') AS prospecting,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.deal_stage='Engaging') AS engaging,
    ROUND(100.0*COUNT(sp.opportunity_id)
        / SUM(COUNT(sp.opportunity_id)) OVER(),2) AS open_pipeline_pct,
    COUNT(sp.opportunity_id) FILTER (WHERE sp.account IS NULL) AS missing_account
FROM sales_teams st
LEFT JOIN sales_pipeline sp
    ON st.sales_agent=sp.sales_agent
   AND sp.deal_stage IN ('Prospecting','Engaging')
GROUP BY st.regional_office
ORDER BY open_opportunities DESC;
/* Central: 908 (43.47%); West: 748 (35.81%); East: 433 (20.73%).
   All 500 Prospecting opportunities are assigned to Central.
   This should be investigated as a business/process observation, not
   automatically classified as a data error. */


/*
===============================================================================
END OF 05_business_analysis.sql

SQL SKILLS DEMONSTRATED:
- JOIN / LEFT JOIN
- GROUP BY
- FILTER and conditional aggregation
- CTEs
- Window functions: LAG, RANK, SUM OVER
- Percentages and KPI calculations
- NULLIF and COALESCE
- DATE_TRUNC and date arithmetic
- PERCENTILE_CONT
- Business reconciliation and interpretation
===============================================================================
*/
