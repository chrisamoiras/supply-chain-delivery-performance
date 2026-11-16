-- Late deliveries by shipping mode (cancelled orders excluded, Jan 2015 – Sep 2017)
SELECT
    s.shipping_mode,
    COUNT(*)                                        AS order_items,
    ROUND(100.0 * SUM(f.is_late) / COUNT(*), 1)     AS late_pct,
    ROUND(AVG(f.days_for_shipment_scheduled), 2)    AS avg_scheduled_days,
    ROUND(AVG(f.days_for_shipping_real), 2)         AS avg_real_days,
    ROUND(AVG(CASE WHEN f.is_late = 1 THEN f.delay_days END), 2) AS avg_delay_when_late
FROM fact_order_items f
JOIN dim_shipping_mode s ON s.shipping_mode_id = f.shipping_mode_id
JOIN dim_date d          ON d.date_key = f.order_date_key
WHERE f.is_cancelled = 0
  AND d.in_analysis_period = 1
GROUP BY s.shipping_mode
ORDER BY late_pct DESC;
