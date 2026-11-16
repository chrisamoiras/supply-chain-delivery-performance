-- Distribution of actual delivery days per shipping mode
SELECT
    s.shipping_mode,
    f.days_for_shipping_real,
    COUNT(*) AS order_items
FROM fact_order_items f
JOIN dim_shipping_mode s ON s.shipping_mode_id = f.shipping_mode_id
JOIN dim_date d          ON d.date_key = f.order_date_key
WHERE f.is_cancelled = 0
  AND d.in_analysis_period = 1
GROUP BY s.shipping_mode, f.days_for_shipping_real
ORDER BY s.shipping_mode, f.days_for_shipping_real;
