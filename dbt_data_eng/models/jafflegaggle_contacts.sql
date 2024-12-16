{% set personal_emails = get_personal_emails() %}

with users as (
    SELECT * FROM {{ ref('stg_users') }}
),
events as (
    SELECT * FROM {{ ref('stg_events') }}
),
user_events as (
    SELECT
        user_id,
        min(timestamp) as first_event,
        max(timestamp) as most_recent_event,
        count(event_id) as number_of_events
    from events
    group by 1
),
order_events as (
    SELECT 
        user_id,
        min(timestamp) as first_order,
        max(timestamp) as most_recent_order,
        count(event_id) as number_of_orders
    FROM events
    where event_name = 'order_placed'
    group by 1
),

final_all_users as (
    SELECT
        users.user_id,
        users.user_name,
        users.gaggle_id,
        users.email,
        users.created_at,
        user_events.first_event,
        user_events.most_recent_event,
        user_events.number_of_events,
        order_events.first_order,
        order_events.most_recent_order,
        order_events.number_of_orders,
        if(users.email_domain in {{ personal_emails }}, null, users.email_domain)
            as corporate_email
    FROM users
    left join user_events
        on users.user_id = user_events.user_id

    left join order_events
        on users.user_id = order_events.user_id
),

final_merged_users as (
    SELECT
        coalesce(fmu.user_id, fau.user_id) as user_id,
        coalesce(fmu.email, fau.email) as email,
        coalesce(fmu.corporate_email, fau.corporate_email) as corporate_email,

        ARRAY_AGG(fau.user_name ORDER BY fau.created_at desc)[1] as user_name,


        {#- 
            Note that a user can be associated with multiple gaggles depending on the merge,
            but the max() below explicitly will take only the later gaggle as associated.
        #}
        max(fau.gaggle_id) as gaggle_id,

        min(fau.created_at) as created_at,
        min(fau.first_event) as first_event,
        min(fau.most_recent_event) as most_recent_event,
        sum(fau.number_of_events) as number_of_events,
        min(fau.first_order) as first_order,
        min(fau.most_recent_order) as most_recent_order,
        sum(fau.number_of_orders) as number_of_orders,
        substring(cast(fau.created_at as varchar), 1, 10) as user_cohort
        
    from final_all_users fau
    left join {{ ref('merged_user') }} mu on fau.email = mu.old_email
    left join final_all_users fmu on fmu.email = mu.new_email
    group by 1, 2, 3, 13
)

select * from final_merged_users