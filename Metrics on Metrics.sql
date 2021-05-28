--what metrics are out there?
SELECT
    *
FROM
    metrics m
    INNER JOIN _users  u ON m.owner_id = u.id
    INNER JOIN sites   s ON m.site_id = s.id;
;



SELECT --Metric Activity Logs, for some reason viewing a metric aren't attached to a user
    e.created_at,
    t.name     AS event_name,
    m.name     AS metric_name,
    hu.name    AS username,
    e.hist_target_user_id
FROM
         historical_events e
    INNER JOIN historical_event_types  t ON e.historical_event_type_id = t.type_id
    INNER JOIN hist_metrics            hm ON e.hist_metric_id = hm.id
    INNER JOIN metrics                 m ON hm.metric_id = m.id
    LEFT OUTER JOIN hist_users              hu ON e.hist_actor_user_id = hu.id
--WHERE t.name like '%Metric%'
;
