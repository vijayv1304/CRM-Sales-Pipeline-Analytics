# CRM Sales Pipeline Analytics
## End-to-End Data Analytics Project — Case Study

**Domain:** B2B Sales Operations / Customer Relationship Management

**Tools:** Excel, Power Query, PostgreSQL, Python, Power BI, DAX

**Project Type:** End-to-End Data Analytics Portfolio Project

---

## 1. Executive Summary

This project analyzes a B2B customer relationship management (CRM) dataset containing 8,800 sales opportunities across multiple products, customer accounts, sales agents, and regional offices.

The analysis evaluates revenue generation, sales conversion, pipeline health, sales team productivity, product performance, and CRM data quality.

The project delivers an interactive Power BI dashboard supported by PostgreSQL analysis, Python exploratory data analysis, and validated DAX measures.

The analysis identified $10.01 million in won revenue, a 63.15% closed-deal win rate, 2,089 open opportunities, and significant missing account information within the open pipeline.

## 2. Business Problem

Sales leadership needs reliable visibility into sales performance and the current opportunity pipeline.

Without consolidated analytical reporting, decision-makers may struggle to understand:

- Which products and regions generate the most revenue.
- Which sales agents and managers are performing effectively.
- How successfully opportunities are converted into won deals.
- Where open opportunities are concentrated.
- How long opportunities take to close.
- Whether incomplete CRM records affect customer-level reporting.

The objective is to transform transactional CRM data into a consistent reporting solution that supports performance monitoring and evidence-based business decisions.

## 3. Project Objectives

The project was designed to achieve six objectives:

1. **Revenue Analysis:** Measure total won revenue, average deal value, monthly trends, and product contributions.
2. **Conversion Analysis:** Calculate closed-deal win rates and evaluate won versus lost opportunities.
3. **Pipeline Analysis:** Identify open opportunities by deal stage, product, and regional office.
4. **Sales Team Analysis:** Compare agent and manager performance using revenue, conversion, and sales-cycle metrics.
5. **Customer Analysis:** Examine account-level and industry-sector revenue contributions.
6. **Data Quality Analysis:** Identify missing customer information and evaluate its impact on reporting.

## 4. Business Stakeholders

The following are representative stakeholders for this portfolio case study, rather than stakeholders from an actual commissioned project.

| Stakeholder | Analytical Requirements |
|---|---|
| Sales Director | Overall revenue, win rate, and regional performance |
| Regional Sales Manager | Regional pipeline, team performance, and opportunities |
| Sales Operations Analyst | Sales-cycle analysis, opportunity stages, and CRM data quality |
| Product Manager | Product revenue contribution and pipeline distribution |
| Account Manager | Customer-level performance and account visibility |

## 5. Project Scope

### In Scope

- Four related CRM source datasets.
- Data inspection and transformation using Power Query.
- Relational data modeling and DAX calculations.
- SQL-based business analysis using PostgreSQL.
- Python exploratory data analysis.
- Four interactive Power BI report pages.
- Business insights, recommendations, and metric validation.

### Out of Scope

- Predictive machine learning models.
- Automated CRM data ingestion.
- Real-time dashboard refresh.
- Production CRM integration.
- Automated sales forecasting.

## 6. Success Criteria

The project is considered successful when:

- Core business KPIs are defined consistently.
- PostgreSQL, Python, and Power BI produce matching validated results.
- Dashboard pages answer the defined business questions.
- Users can filter, explore, and drill through sales performance.
- Data quality risks are clearly identified.
- Findings are translated into actionable business recommendations.
- The complete project is documented and organized for GitHub.

---
## 7. Dataset Understanding

The project uses four related Excel datasets representing a B2B sales environment.

### 7.1 Source Datasets

| Dataset | Business Purpose | Key Columns |
|---|---|---|
| `sales_pipeline.xlsx` | Records sales opportunities, deal stages, values, and dates | opportunity_id, sales_agent, product, account, deal_stage, engage_date, close_date, close_value |
| `accounts.xlsx` | Stores customer account and industry information | account, sector |
| `products.xlsx` | Provides product reference information | product |
| `sales_teams.xlsx` | Maps sales agents to managers and regional offices | sales_agent, manager, regional_office |

The `sales_pipeline` dataset is the primary transactional table, containing 8,800 opportunities.

The other three datasets provide descriptive attributes for analyzing opportunities by customer, product, agent, manager, and region.

### 7.2 Data Granularity

The analytical grain is **one row per sales opportunity**.

Each opportunity is identified by an `opportunity_id` and contains information about its assigned sales agent, product, customer account, deal stage, relevant dates, and closing value.

Maintaining this grain is important to avoid duplicate opportunity counts and inflated revenue calculations.

### 7.3 Opportunity Stages

The CRM data contains four deal stages:

| Deal Stage | Opportunity Count | Classification |
|---|---:|---|
| Won | 4,238 | Closed |
| Lost | 2,473 | Closed |
| Engaging | 1,589 | Open |
| Prospecting | 500 | Open |
| **Total** | **8,800** | |

For reporting purposes:

- **Closed Opportunities** = Won + Lost = 6,711
- **Open Opportunities** = Engaging + Prospecting = 2,089
- **Won Revenue** = Sum of closing values for Won opportunities
- **Closed-Deal Win Rate** = Won Opportunities / Closed Opportunities

The win-rate denominator excludes open opportunities because their outcomes have not yet been determined.

## 8. Data Quality Assessment

Data quality checks were included to evaluate the reliability of sales reporting.

### 8.1 Missing Customer Account Information

The analysis identified **1,425 opportunities with missing account information**.

All 1,425 belong to open pipeline stages.

This represents:

- **68.21% of open opportunities**
- Approximately **16.19% of all opportunities**

This issue limits the ability to attribute open opportunities to specific customers and perform complete account-level pipeline analysis.

Missing accounts should not automatically be treated as invalid records, since account identification may not be required at every stage of the sales process.

**Recommended action:** Establish stage-appropriate CRM data completeness requirements and investigate opportunities that progress without account identification.

### 8.2 Deal Stage Validation

Opportunity counts were reviewed to confirm that each record belongs to one of the four expected stages.

The distinction between open and closed stages was applied consistently across SQL, Python, and Power BI calculations.

### 8.3 Revenue Validation

Revenue reporting focuses on **Won opportunities**.

Open opportunities are not counted as realized revenue, and lost opportunities do not contribute to won revenue.

This prevents potential pipeline values from being mixed with completed sales revenue.

### 8.4 Date and Sales Cycle Considerations

The dataset contains engagement and closing dates used for time-based and sales-cycle analysis.

Sales-cycle duration is calculated from engagement to closing for opportunities with the required valid dates.

The average sales cycle across the analyzed closed opportunities was approximately **47.99 days**.

Open opportunities should not be assigned an artificial closing date merely to calculate sales-cycle duration.

## 9. Data Preparation and Transformation

### 9.1 Excel and Power Query

Excel source files were inspected and prepared for reporting through Power Query.

The preparation workflow focused on:

1. Reviewing dataset structures and column data types.
2. Checking missing values and opportunity classifications.
3. Ensuring date and numerical fields were suitable for analysis.
4. Preparing the datasets for relational modeling.
5. Validating business measures after data loading.

The original datasets were preserved separately in the `Raw_Data` folder.

The `Power_Query` folder contains the Excel files referenced by the Power BI report.

### 9.2 PostgreSQL

PostgreSQL was used as a separate analytical environment to query CRM records and validate sales metrics.

SQL analysis covered opportunity distributions, revenue, conversion rates, sales team performance, regional performance, product contributions, and data quality.

### 9.3 Python

Python and Pandas were used to load the source datasets, inspect their structure, evaluate data quality, and perform exploratory analysis.

The notebook uses relative project paths to access the Excel files from the `Raw_Data` folder.

This makes the Python workflow easier to reproduce when the repository is downloaded to another computer.

### 9.4 Data Preparation Principles

The project followed these principles:

- Preserve the original source files.
- Maintain one record per opportunity.
- Avoid replacing unknown account information with fabricated values.
- Keep open opportunities separate from completed sales.
- Use consistent KPI definitions across analytical tools.
- Validate totals before interpreting business performance.

---
## 10. Data Modeling

### 10.1 Analytical Data Model

The Power BI report uses a relational model centered on the `sales_pipeline` fact table.

The fact table records individual sales opportunities, while lookup tables provide descriptive attributes for products, accounts, sales agents, and dates.

| Table | Role | Business Purpose |
|---|---|---|
| sales_pipeline | Fact | Opportunity-level transactions and sales outcomes |
| products | Dimension | Product attributes and categories |
| accounts | Dimension | Customer and industry attributes |
| sales_teams | Dimension | Sales agent, manager, and regional information |
| DateTable | Date dimension | Time-based reporting and DAX calculations |

### 10.2 Relationships

The model uses one-to-many relationships between lookup tables and the opportunity fact table.

| Lookup Column | Fact Column | Relationship |
|---|---|---|
| products[product] | sales_pipeline[product] | One-to-many |
| accounts[account] | sales_pipeline[account] | One-to-many |
| sales_teams[sales_agent] | sales_pipeline[sales_agent] | One-to-many |
| DateTable[Date] | sales_pipeline[close_date] | Active |
| DateTable[Date] | sales_pipeline[engage_date] | Inactive |

The active closing-date relationship supports revenue trends and completed-deal analysis.

The inactive engagement-date relationship allows engagement-based analysis through appropriate DAX calculations when required.

### 10.3 Modeling Decisions

The data model was designed to:

- Maintain opportunity-level granularity.
- Reduce unnecessary duplication of descriptive attributes.
- Support filtering by region, agent, manager, customer, and product.
- Provide consistent measures across dashboard pages.
- Enable time-intelligence calculations using a dedicated date table.

## 11. PostgreSQL Analysis

PostgreSQL was used to perform independent business analysis and validate the results displayed in Power BI.

### 11.1 Analytical Areas

The SQL workflow included:

1. Opportunity counts and deal-stage distribution.
2. Won revenue and average deal value.
3. Closed-deal win-rate calculations.
4. Regional and product revenue analysis.
5. Agent and manager performance comparisons.
6. Open pipeline analysis.
7. Customer and sector revenue contributions.
8. Missing account information and data quality checks.

### 11.2 SQL Techniques

The analysis involved relational queries, conditional aggregation, filtering, grouping, joins, and calculated metrics.

These techniques support common business reporting requirements, including segment-level performance comparisons and KPI reconciliation.

### 11.3 Key SQL Results

| Metric | Validated Result |
|---|---:|
| Total Opportunities | 8,800 |
| Won Opportunities | 4,238 |
| Lost Opportunities | 2,473 |
| Closed Opportunities | 6,711 |
| Open Opportunities | 2,089 |
| Won Revenue | $10,005,534 |
| Closed-Deal Win Rate | 63.15% |
| Average Won Deal Value | $2,360.91 |

The SQL scripts are available in the `PostgreSQL` folder.

## 12. Python Exploratory Data Analysis

### 12.1 Purpose

Python was used to independently explore the CRM datasets, evaluate data distributions, identify performance patterns, and verify important business metrics.

### 12.2 Tools and Libraries

- Pandas for data loading, manipulation, and aggregation.
- NumPy for numerical operations.
- Matplotlib for analytical visualizations.
- Seaborn for statistical and comparative visualizations.
- Jupyter Notebook in VS Code for interactive analysis.

### 12.3 EDA Workflow

The exploratory analysis included:

1. Loading the four Excel datasets.
2. Inspecting dataset dimensions and data types.
3. Checking missing values and opportunity classifications.
4. Analyzing sales opportunity distributions.
5. Comparing revenue across products and regions.
6. Exploring sales team and customer performance.
7. Investigating sales-cycle duration.
8. Validating analytical results against SQL and Power BI.

### 12.4 Reproducibility

The Python notebook is stored at:

`Python/CRM_Sales_Pipeline_EDA.ipynb`

The required libraries are documented in:

`Python/requirements.txt`

The notebook uses relative paths to access the source datasets from the `Raw_Data` folder, allowing the analysis to be reproduced without hardcoded drive-specific file paths when the working directory is set correctly.

## 13. KPI Definitions and Validation

### 13.1 Core Business Metrics

| KPI | Business Definition | Result |
|---|---|---:|
| Total Opportunities | Count of all sales opportunities | 8,800 |
| Won Opportunities | Count of opportunities with Won stage | 4,238 |
| Lost Opportunities | Count of opportunities with Lost stage | 2,473 |
| Closed Opportunities | Won + Lost opportunities | 6,711 |
| Open Opportunities | Engaging + Prospecting opportunities | 2,089 |
| Won Revenue | Sum of close values for Won opportunities | $10,005,534 |
| Win Rate | Won opportunities / Closed opportunities | 63.15% |
| Average Won Deal Value | Won revenue / Won opportunities | $2,360.91 |
| Average Sales Cycle | Average engagement-to-close duration for analyzed closed deals | 47.99 days |
| Open Pipeline Share | Open opportunities / Total opportunities | 23.74% |
| Missing Account Share of Open Pipeline | Open opportunities missing account / Open opportunities | 68.21% |

### 13.2 Cross-Tool Validation

The project compared results from PostgreSQL, Python, and Power BI to confirm that core metrics followed the same business definitions.

The validation focused on:

- Total opportunity counts.
- Won, lost, and open stage distributions.
- Won revenue.
- Closed-deal win rate.
- Average won deal value.
- Open pipeline counts.
- Missing account information.

### 13.3 Validation Outcome

The principal KPI results were consistent across the analytical workflows.

This reconciliation increased confidence in the accuracy of the dashboard and reduced the risk of presenting conflicting figures to business stakeholders.

---
## 14. Power BI Dashboard Design

### 14.1 Dashboard Objective

The Power BI dashboard was designed to convert CRM opportunity data into an interactive reporting solution for sales performance monitoring and business decision-making.

The report consists of four business-facing pages, supported by a custom tooltip page and a hidden validation page.

### 14.2 Executive Overview

**Purpose:** Provide sales leadership with a consolidated view of overall business performance.

**Key Components:**

- KPI cards for won revenue, won opportunities, win rate, and other performance measures.
- Monthly revenue trend analysis.
- Product revenue comparisons.
- Regional sales performance.
- Month-over-month revenue analysis.
- Interactive filtering and reset controls.

**Business Value:** Enables stakeholders to monitor revenue performance, identify trends, and compare major revenue contributors.

### 14.3 Sales Performance

**Purpose:** Evaluate the productivity and effectiveness of sales agents and managers.

**Key Components:**

- Top 10 sales agents by won revenue.
- Manager-level performance comparisons.
- Sales-cycle analysis.
- Win-rate comparisons.
- Revenue and opportunity performance visualizations.
- Custom sales agent report-page tooltip.
- Drill-through navigation to individual agent details.

**Business Value:** Supports performance reviews, identifies high-performing agents, and highlights opportunities for coaching and process improvement.

### 14.4 Pipeline & Customer Analysis

**Purpose:** Evaluate pipeline composition and customer-level sales performance.

**Key Components:**

- Open opportunity KPIs.
- Opportunity stages by product and region.
- Sector-level revenue.
- Customer account revenue.
- Missing account information analysis.
- Interactive filtering and reset controls.

**Business Value:** Helps identify pipeline concentrations, customer revenue contributors, and data quality risks.

### 14.5 Sales Agent Detail

**Purpose:** Enable detailed investigation of an individual sales agent's performance.

**Key Components:**

- Dynamic agent selection.
- Agent-specific performance KPIs.
- Monthly won revenue.
- Product-level revenue.
- Won and lost sales-cycle comparisons.
- Opportunity-level transaction details.
- Back navigation to the originating report page.

**Business Value:** Allows sales managers to move from team-level summaries to individual performance analysis.

### 14.6 Interactive Features

The report includes:

- Slicers and cross-filtering.
- Custom report-page tooltips.
- Sales agent drill-through.
- Dynamic DAX measures.
- Time-based performance analysis.
- Reset controls.
- Context-sensitive visual interactions.

These features support self-service exploration without requiring users to write SQL or Python queries.

## 15. Business Findings and Recommendations

### 15.1 Overall Sales Performance

**Finding:** The business generated $10,005,534 in won revenue from 4,238 won opportunities, with a closed-deal win rate of 63.15%.

There are 2,089 open opportunities, representing 23.74% of all recorded opportunities.

**Business Implication:** A substantial portion of the sales pipeline remains unresolved and requires ongoing management.

**Recommendation:** Review open opportunities regularly, investigate lost-deal patterns, and prioritize follow-up based on opportunity value, stage, and age.

### 15.2 Regional Performance

**Finding:** West generated approximately $3.57M in won revenue, followed by Central at $3.35M and East at $3.09M.

Central has 908 open opportunities and contains all 500 Prospecting-stage opportunities.

**Business Implication:** Prospecting-stage concentration may reflect regional workflow differences, lead allocation, or CRM stage-update practices.

**Recommendation:** Investigate Central's pipeline processes and compare stage definitions and qualification practices across regions before drawing conclusions about performance.

### 15.3 Product Performance

**Finding:** GTX Pro generated approximately $3.51M, GTX Plus Pro $2.63M, and MG Advanced $2.22M.

These three products collectively contributed approximately 83.6% of won revenue.

GTX Basic and MG Special have 430 and 428 open opportunities respectively.

**Business Implication:** Revenue is concentrated in a small number of products, while other products have sizable unresolved pipelines.

**Recommendation:** Monitor product concentration and evaluate open opportunities using conversion rates, deal values, and pipeline age rather than opportunity counts alone.

### 15.4 Sales Team Performance

**Finding:** Darcel Schlecht generated approximately $1.15M in won revenue across 349 won opportunities, with a 63.11% win rate.

Melvin Marxen led managers with approximately $2.25M in team won revenue.

**Business Implication:** Agent and manager performance varies, but absolute revenue alone does not fully explain effectiveness.

**Recommendation:** Compare agents and teams using win rate, average deal value, sales-cycle duration, opportunity volume, and revenue.

### 15.5 Customer Data Quality

**Finding:** 1,425 of 2,089 open opportunities have missing account information, representing 68.21% of the open pipeline.

**Business Implication:** Incomplete account identification limits customer-level pipeline visibility and may affect account ownership, segmentation, and follow-up reporting.

**Recommendation:** Introduce stage-appropriate account completeness checks and investigate records that remain unidentified as they progress through the pipeline.

## 16. Project Limitations

This project has several important limitations.

### 16.1 Historical Dataset

The analysis uses a static CRM dataset rather than a live production CRM system.

Results describe the available historical records and should not be interpreted as current business performance.

### 16.2 No Real-Time Refresh

The Power BI report uses Excel-based data sources.

It does not include automated CRM integration, scheduled production refresh, or real-time updates.

### 16.3 Missing Account Information

A significant portion of the open pipeline lacks account information.

This limits complete customer-level analysis of unresolved opportunities.

### 16.4 No Predictive Forecasting

The project focuses on descriptive and diagnostic analytics.

It does not estimate future sales using predictive models or assign probabilities to individual open opportunities.

### 16.5 Limited Business Context

The dataset does not provide all possible business context, such as detailed lead qualification history, marketing attribution, sales targets, or explanations for lost deals.

Recommendations are therefore analytical suggestions rather than proven causal conclusions.

## 17. Future Improvements

Potential future enhancements include:

1. Integrating a live CRM data source.
2. Automating data refresh and quality checks.
3. Adding sales targets and quota attainment analysis.
4. Tracking pipeline aging and stage transitions over time.
5. Introducing sales forecasting and conversion probability models.
6. Expanding customer segmentation and account-level analysis.
7. Implementing standardized CRM data quality monitoring.

## 18. Conclusion

The CRM Sales Pipeline Analytics project demonstrates a complete analytical workflow, from understanding business requirements and preparing raw data to validating metrics, building interactive dashboards, and communicating business findings.

The analysis identified important patterns in revenue generation, regional performance, product concentration, sales team productivity, open pipeline composition, and CRM data quality.

By combining Excel, Power Query, PostgreSQL, Python, DAX, and Power BI, the project demonstrates practical end-to-end data analytics skills focused on reliable reporting and actionable business recommendations.