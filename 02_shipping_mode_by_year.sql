-- Is the shipping-mode result stable in every year? (check for confounding with market/period)
SELECT
    d.year,
    s.shipping_mode,
    COUNT(*)                                    AS order_items,
    ROUND(100.0 * SUM(f.is_late) / COUNT(*), 1) AS late_pct
FROM fact_order_items f
JOIN dim_shipping_mode s ON s.shipping_mode_id = f.shipping_mode_id
JOIN dim_date d          ON d.date_key = f.order_date_key
WHERE f.is_cancelled = 0
  AND d.in_analysis_period = 1
GROUP BY d.year, s.shipping_mode
ORDER BY s.shipping_mode, d.year;
