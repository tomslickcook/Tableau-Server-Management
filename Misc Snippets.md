
#### Who deleted a project?
```sql
select 
p.name as Project_name
,t.name as action
,e.created_at as date
,u.name as username
from HISTORICAL_EVENTS e
left join HISTORICAL_EVENT_TYPES t on e.historical_event_type_id = t.type_id
left join hist_projects p on e.hist_project_id = p.id
left join HIST_USERS u on e.hist_actor_user_id = u.id
Where t.type_id=31 --delete project action type
;
```


#### SQL for Calculating Workbook Render
```sql
SELECT 
q.SITE_ID, w.PROJECT_ID, MAX(w. ID) as Workbook_ID, s.Name as Site,
p.name as Project_Name, w.name as Workbook, q.VIZQL_SESSION,
(DATE_PART('minutes',  (q.COMPLETED_AT - MIN(r.CREATED_AT)))*60 )
+ DATE_PART('seconds',  (q.COMPLETED_AT - MIN(r.CREATED_AT))) 
as Num_Seconds, 
1 as ViewEvents, MAX(r.user_ID) as SiteUserID, 
MAX(u.System_User_ID) as SysUserID, MAX(z.friendly_name) as Username,
date_trunc('day', (q.COMPLETED_AT - interval '6 hours')) as RenderDate
FROM 
(Select  r.SITE_ID,  r.VIZQL_SESSION, r.CURRENTSHEET, 
    MIN(r.COMPLETED_AT) as Completed_AT
From HTTP_REQUESTS r
WHERE r.COMPLETED_AT  >= '01-JAN-15'
    and r.ACTION = 'performPostLoadOperations'
    and r.VIZQL_SESSION is not null
GROUP BY r.SITE_ID,  r.VIZQL_SESSION, r.CURRENTSHEET ) q
INNER JOIN 
HTTP_REQUESTS r ON q.VIZQL_SESSION=r.VIZQL_SESSION and
r.COMPLETED_AT <= q.COMPLETED_AT
LEFT OUTER JOIN _sites s ON q.SITE_ID = s.ID
LEFT OUTER JOIN _views v ON q.CURRENTSHEET = v.VIEW_URL and
r.SITE_ID = v.SITE_ID
LEFT OUTER JOIN _workbooks w ON v.WORKBOOK_ID = w.ID 
LEFT OUTER JOIN _projects p ON w.PROJECT_ID = p.ID
LEFT OUTER JOIN users u ON r.USER_ID = u.ID
LEFT OUTER JOIN system_users z ON u.SYSTEM_USER_ID = z.ID
GROUP BY q.SITE_ID, w.PROJECT_ID, s.Name, p.Name, w.Name, q.VIZQL_SESSION, q.COMPLETED_AT;
```
#### who viewed underlying or summary data
```sql
SELECT "_users"."id" AS "id",
  "_users"."name" AS "name",
  "_users"."login_at" AS "login_at",
  "_users"."friendly_name" AS "friendly_name",
  "_users"."licensing_role_id" AS "licensing_role_id",
  "_users"."licensing_role_name" AS "licensing_role_name",
  "_users"."domain_id" AS "domain_id",
  "_users"."system_user_id" AS "system_user_id",
  "_users"."domain_name" AS "domain_name",
  "_users"."domain_short_name" AS "domain_short_name",
  "_users"."site_id" AS "site_id",
  "_http_requests"."controller" AS "controller",
  "_http_requests"."action" AS "action",
  "_http_requests"."http_referer" AS "http_referer",
  "_http_requests"."http_user_agent" AS "http_user_agent",
  CAST("_http_requests"."http_request_uri" AS TEXT) AS "http_request_uri",
  "_http_requests"."remote_ip" AS "remote_ip",
  "_http_requests"."created_at" AS "created_at",
  "_http_requests"."session_id" AS "session_id",
  "_http_requests"."completed_at" AS "completed_at",
  "_http_requests"."port" AS "port",
  "_http_requests"."user_id" AS "user_id",
  "_http_requests"."worker" AS "worker",
  CAST("_http_requests"."vizql_session" AS TEXT) AS "vizql_session",
  "_http_requests"."user_ip" AS "user_ip",
  "_http_requests"."currentsheet" AS "currentsheet",
  "_http_requests"."site_id" AS "site_id (_http_requests)",
  "_sessions"."session_id" AS "session_id (_sessions)",
  "_sessions"."updated_at" AS "updated_at",
  "_sessions"."user_id" AS "user_id (_sessions)",
  "_sessions"."user_name" AS "user_name",
  "_sessions"."system_user_id" AS "system_user_id (_sessions)",
  "_sessions"."site_id" AS "site_id (_sessions)",
  "_sites"."id" AS "id (_sites)",
  "_sites"."name" AS "name (_sites)",
  "_sites"."url_namespace" AS "url_namespace",
  "_sites"."status" AS "status"
FROM "public"."_users" "_users"
  RIGHT JOIN "public"."_http_requests" "_http_requests" ON ("_users"."id" = "_http_requests"."user_id")
  LEFT JOIN "public"."_sessions" "_sessions" ON ("_http_requests"."session_id" = "_sessions"."session_id")
  LEFT JOIN "public"."_sites" "_sites" ON ("_http_requests"."site_id" = "_sites"."id")
Where 

"_http_requests"."created_at" > current_date -1
AND _users.name IS NOT NULL
AND "_http_requests"."action" IN ('exportcrosstab','viewData');
```