WITH source AS (
    SELECT
        id,
        name,
        latitude,
        longitude
    FROM {{ source('thelook', 'distribution_centers') }}
)

SELECT * FROM source