with renamed as (
    SELECT
        close_date,
        amount,
        deal_name,
        deal_stage,
        email
    FROM {{ ref("deals") }}
)

SELECT * FROM renamed
