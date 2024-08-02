WITH
nearest_distribution_center AS (
    SELECT
        user_id,
        dc_id
    FROM {{ ref('int_nearest_distribution_centers') }}
),
order_data_last_year AS (
    SELECT
        u.id AS user_id,
        COALESCE(SUM(CASE WHEN o.status = 'Complete' THEN oi.sale_price ELSE 0 END), 0) AS total_spent_last_year,
        COALESCE(SUM(CASE WHEN o.status = 'Returned' IS NOT NULL THEN 1 ELSE 0 END), 0) AS total_returns_last_year,
        COUNT(o.order_id) AS total_orders_last_year
    FROM {{ ref('stg_users') }} u
    LEFT JOIN {{ ref('stg_orders') }} o ON u.id = o.user_id AND o.created_at >= (CURRENT_DATE - INTERVAL '1 year')
    LEFT JOIN {{ ref('stg_order_items') }} oi ON o.order_id = oi.order_id
    GROUP BY u.id
)

SELECT * FROM order_data_last_year