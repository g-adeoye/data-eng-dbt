with renamed as (
    SELECT 
        event_id,
        user_id,
        event_name,
        timestamp
    FROM
        {{ ref("raw_event") }}
)

select * from renamed