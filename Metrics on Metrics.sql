--what metrics are out there?
select * from metrics m
inner join _users u on m.owner_id = u.id
inner join sites s on m.site_id=s.id;
;

select --Metric Activity Logs, for some reason views aren't attached to a user
e.created_at
,t.name as event_name
,m.name as metric_name
,hu.name as username
,e.hist_target_user_id
from historical_events e
inner join historical_event_types t on e.historical_event_type_id = t.type_id
inner join hist_metrics hm on e.hist_metric_id=hm.id
inner join metrics m on hm.metric_id=m.id
left outer join hist_users hu on e.hist_actor_user_id=hu.id 
--where t.name like '%Metric%'
;
