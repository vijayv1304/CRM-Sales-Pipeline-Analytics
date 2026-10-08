# CRM Sales Pipeline — Business Insights & Recommendations

### Project Overview

This project analyzes a B2B CRM sales pipeline to evaluate revenue performance, sales conversion, product contribution, regional performance, sales team productivity, and customer data quality.

The analysis covers 8,800 sales opportunities and integrates four datasets: sales pipeline, accounts, products, and sales teams.

### Tools and Methodology

- **Excel and Power Query:** Data profiling, cleaning, and transformation.
- **PostgreSQL:** SQL-based business analysis and metric validation.
- **Python:** Exploratory data analysis using Pandas and visualization libraries.
- **Power BI:** Data modeling, DAX calculations, interactive dashboards, tooltips, and drill-through analysis.

### Key Business Results

| Metric | Result |
|---|---:|
| Total Opportunities | 8,800 |
| Closed Opportunities | 6,711 |
| Won Opportunities | 4,238 |
| Lost Opportunities | 2,473 |
| Won Revenue | $10,005,534 |
| Closed-Deal Win Rate | 63.15% |
| Open Opportunities | 2,089 |
| Average Won Deal Value | $2,360.91 |
| Average Sales Cycle | 47.99 days |

### Major Findings

1. The company generated approximately $10.01M in won revenue, with a 63.15% closed-deal win rate.
2. West generated the highest regional revenue ($3.57M), while Central contains all 500 Prospecting-stage opportunities.
3. GTX Pro, GTX Plus Pro, and MG Advanced collectively contributed approximately 83.6% of won revenue.
4. Darcel Schlecht led individual sales agents with approximately $1.15M in won revenue, while Melvin Marxen led managers with approximately $2.25M in team revenue.
5. Approximately 68.21% of open opportunities have missing account information, limiting customer-level pipeline analysis.

### Strategic Recommendations

- Establish regular reviews of open opportunities and lost-deal patterns.
- Investigate Central's concentration of Prospecting opportunities.
- Prioritize product-level pipeline follow-up based on conversion potential and deal value.
- Share effective sales practices across agents and managers.
- Improve CRM account-data completeness and monitor data quality by pipeline stage.

### Business Value

The project provides an integrated view of sales performance and pipeline health, helping stakeholders identify revenue drivers, prioritize follow-up activities, compare team performance, and improve the reliability of CRM reporting.

## Executive Summary
## Insight 1: Overall Sales Performance

**Finding:** The company generated $10,005,534 in won revenue from 4,238 successful opportunities. The closed-deal win rate was 63.15%, with 2,089 opportunities still open.

**Business Impact:** The open pipeline represents 23.74% of all recorded opportunities and requires continued follow-up to improve conversion and prevent stalled deals.

**Recommendation:** Establish a regular pipeline review process, prioritize high-potential open opportunities, and analyze lost-deal patterns to identify opportunities for improving conversion.

**Suggested KPIs to Monitor:** Won Revenue, Win Rate, Open Opportunities, Average Deal Value, and Average Sales Cycle.

## Insight 2: Regional Sales Performance and Pipeline Concentration

**Finding:** West generated the highest won revenue ($3.57M), followed by Central ($3.35M) and East ($3.09M). Central has the largest open pipeline, with 908 opportunities, including all 500 Prospecting opportunities.

**Business Impact:** Prospecting-stage opportunities are concentrated entirely in Central. This may indicate differences in lead allocation, pipeline maturity, or CRM stage-management practices. Further investigation is required before identifying the cause.

**Recommendation:** Review Central's 500 Prospecting opportunities, assess lead qualification and follow-up activities, and compare CRM stage-management practices across all three regions.

**Suggested KPIs to Monitor:** Regional Won Revenue, Regional Win Rate, Open Opportunities by Region, Prospecting-to-Engaging Conversion, and Opportunity Aging.

## Insight 3: Product Revenue Concentration and Open Pipeline

**Finding:** GTX Pro ($3.51M), GTX Plus Pro ($2.63M), and MG Advanced ($2.22M) collectively contribute approximately 83.6% of total won revenue. GTX Basic has the largest open opportunity count (430), followed by MG Special (428).

**Business Impact:** Won revenue is concentrated in three products, creating potential product-mix dependence. Meanwhile, GTX Basic and MG Special have substantial open pipelines that may represent conversion opportunities, although their potential revenue cannot be determined from opportunity counts alone.

**Recommendation:** Maintain focus on high-performing products while reviewing open GTX Basic and MG Special opportunities. Compare product-level win rates, deal sizes, and opportunity aging to determine where sales follow-up can have the greatest impact.

**Suggested KPIs to Monitor:** Won Revenue by Product, Product Revenue Share %, Open Opportunities by Product, Product Win Rate, and Average Won Deal Value by Product.

## Insight 4: Sales Agent and Manager Performance

**Finding:** Darcel Schlecht is the highest-revenue sales agent, generating approximately $1.15M from 349 won deals, with a 63.11% win rate. Melvin Marxen leads managers in team won revenue at approximately $2.25M.

**Business Impact:** Sales performance varies across agents and managers. High-performing individuals and teams may provide useful examples of effective sales practices, but differences in territory, team size, and opportunity allocation must be considered before drawing conclusions.

**Recommendation:** Analyze the approaches used by high-performing agents, share effective practices through team coaching, and evaluate managers using normalized performance measures rather than revenue alone.

**Suggested KPIs to Monitor:** Won Revenue by Agent, Win Rate by Agent, Average Deal Value, Revenue per Agent, Average Sales Cycle, and Manager Win Rate.

## Insight 5: Customer Data Quality and Missing Account Information

**Finding:** Of 2,089 open opportunities, 1,425 (68.21%) have missing account information. All opportunities with missing account information are currently open.

**Business Impact:** Incomplete account information limits customer-level pipeline analysis, sector-based segmentation, and the ability to link opportunities to customer records. Some missing values may be legitimate for early-stage leads and require further investigation.

**Recommendation:** Investigate missing account records by deal stage, product, and sales team. Establish CRM data validation rules and define the stage at which account information becomes mandatory. Track data completeness regularly.

**Suggested KPIs to Monitor:** Missing Account Count, Open Pipeline Missing Account %, Account Completeness by Stage, and Missing Account Trends Over Time.

