--Who has alerts or subscriptions? This will combine the list of View-Subscriptions, Alerts, and Workbook-Subscriptions together

select --subscription to single view in workbook
w.name as "Workbook"
,w.owner_name
,si.url_namespace
,'WB Subscription' as "Type"
,count(distinct s.id) as "Count"
,count(distinct s.user_id ) as "Reciepients"
from subscriptions s
left join SUBSCRIPTIONS_VIEWS sv on s.id = sv.subscription_id
left join views v on sv.repository_url = v.repository_url
left join _workbooks w on v.workbook_id = w.id
left join sites si on s.site_id = si.id
where w.name is not null
group by 
w.name
,w.owner_name
,si.url_namespace

UNION ALL

select --counts of alerts and reciepients of alerts
w.name as "Workbook"
,w.owner_name
,s.url_namespace
,'Alert' as "Type"
,count(distinct a.id) as "Count"
,count(distinct r.id) as "Reciepients"
from DATA_ALERTS a
left join DATA_ALERTS_RECIPIENTS r on a.id = r.data_alert_id
left join _workbooks w on a.workbook_id = w.id
left join _system_users su on w.system_user_id = su.id
left join sites s on a.site_id = s.id
--where a.id = 56
group by w.name
,w.owner_name
,s.url_namespace

UNION ALL

select --subscription to entire workbook
w.name as "Workbook"
,w.owner_name
,si.url_namespace
, 'View Subscription' as "Type"
,count(distinct s.id) as "Count"
,count(distinct s.user_id ) as "Reciepients"
from subscriptions s
left join SUBSCRIPTIONS_WORKBOOKS sw on (s.id = sw.subscription_id AND s.site_id=sw.site_id)
left join _workbooks w on sw.repository_url = w.workbook_url
left join sites si on s.site_id = si.id
where w.name is not null
group by 
w.name
,w.owner_name
,si.url_namespace
