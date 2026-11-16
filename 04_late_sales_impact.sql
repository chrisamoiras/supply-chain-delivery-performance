-- Sales linked to late deliveries and profit margin late vs on time
WITH base AS (
    SELECT s.shipping_mode, f.is_late, f.sales, f.profit
    FROM fact_order_items f
    JOIN dim_shipping_mode s ON s.shipping_mode_id = f.shipping_mode_id
    JOIN dim_date d          ON d.date_key = f.order_date_key
    WHERE f.is_cancelled = 0
      AND d.in_analysis_period = 1
)
SELECT
    shipping_mode,
    ROUND(SUM(sales), 0)                                         AS total_sales,
    ROUND(SUM(CASE WHEN is_late = 1 THEN sales ELSE 0 END), 0)   AS late_sales,
    ROUND(100.0 * SUM(CASE WHEN is_late = 1 THEN sales ELSE 0 END) / SUM(sales), 1) AS late_sales_pct,
    ROUND(100.0 * SUM(CASE WHEN is_late = 1 THEN profit END) / SUM(CASE WHEN is_late = 1 THEN sales END), 1) AS margin_late_pct,
    ROUND(100.0 * SUM(CASE WHEN is_late = 0 THEN profit END) / SUM(CASE WHEN is_late = 0 THEN sales END), 1) AS margin_on_time_pct
FROM base
GROUP BY shipping_mode
ORDER BY late_sales DESC;
