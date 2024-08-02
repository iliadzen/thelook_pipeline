WITH
user_features AS (
    SELECT
        u.id AS user_id,
        u.age,
        u.country,
        u.state,
        ndc.dc_id AS nearest_distribution_center,
        odly.total_spent_last_year,
        COALESCE(odly.total_returns_last_year * 1.0 / NULLIF(odly.total_orders_last_year, 0), 0) AS return_rate
    FROM {{ ref('stg_users') }} u
    LEFT JOIN {{ ref('int_nearest_distribution_centers') }} ndc ON u.id = ndc.user_id
    LEFT JOIN {{ ref('int_order_data_last_year') }} odly ON u.id = odly.user_id
)

SELECT
    user_id,
    age,
    country,
    state,
    nearest_distribution_center,
    return_rate,
    CASE
        WHEN total_spent_last_year <= 50 THEN 1
        WHEN total_spent_last_year <= 150 THEN 2
        ELSE 3
    END AS profit_level
FROM user_features