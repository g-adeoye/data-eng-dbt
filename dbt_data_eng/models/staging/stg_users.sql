WITH source as (
    SELECT
        id as user_id,
        name as user_name,
        email,
        {{ extract_email_domain('email') }} AS email_domain,
        gaggle_id,
        created_at
    FROM
        {{ ref('raw_user') }}
)

SELECT * FROM source