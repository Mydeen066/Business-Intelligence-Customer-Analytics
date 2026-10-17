# Business Intelligence & Customer Analytics Dashboard

An end-to-end analytics project: SQL data validation and analysis, Python EDA,
and a 3-page Power BI dashboard on an e-commerce dataset
(100K orders, 20K customers, 150K web sessions).

## Business questions
- How are revenue, profit and delivery performing over time?
- Which categories drive profit?
- Which acquisition channels and customer groups matter most?
- Where do visitors drop off in the purchase funnel?

## Tools
MySQL · Python (pandas) · Power BI (DAX, data modelling)

## Process
1. **Data quality checks (SQL):** null checks, duplicate keys, orphaned foreign keys, invalid ranges
2. **Analysis (SQL):** revenue/profit KPIs, monthly trends, category and product performance,
   customer segments, repeat vs. one-time customers, discount impact, web funnel
3. **Data model:** star schema with a Date table; measures filtered to Delivered orders
4. **Dashboard:** Overview, Customer Analysis, Website Performance

## Key findings
- Delivered revenue of ₹406.67M and profit of ₹139.69M (34.35% margin) from 84K delivered orders
- Only 84.2% of orders are delivered; 6.9% are cancelled and 5.9% returned
- Electronics generates the most profit; revenue dips every February
- Organic Search brings 29% of customers, but revenue per customer is similar
  across channels (₹24.5K–26.2K)
- About 81% of active customers are repeat buyers
- Session conversion is about 8.4% across traffic sources and devices;
  the largest drop-off is between add-to-cart and purchase

## Screenshots
(add the three page images here)

## Files
- `analysis.sql`: validation and analysis queries
- `eda.ipynb`: exploratory analysis
- `dashboard.pbix`: Power BI report
