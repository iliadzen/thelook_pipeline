WITH
distance_calculations AS (
    SELECT
        u.id AS user_id,
        dc.id AS dc_id,
        (3959 * ACOS(
            COS(RADIANS(u.latitude)) * COS(RADIANS(dc.latitude)) * COS(RADIANS(dc.longitude) - RADIANS(u.longitude)) +
            SIN(RADIANS(u.latitude)) * SIN(RADIANS(dc.latitude))
        )) AS distance
    FROM {{ ref('stg_users') }} u
    CROSS JOIN {{ ref('stg_distribution_centers') }} dc
),
nearest_center AS (
    SELECT
        user_id,
        dc_id
    FROM (
        SELECT
            user_id,
            dc_id,
            distance,
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY distance) AS rn
        FROM distance_calculations
    ) t
    WHERE rn = 1
)

SELECT * FROM nearest_center
