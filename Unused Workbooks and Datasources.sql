--Workbooks
select * from (select 
max(s.last_view_time) as last_access
,'workbook' as object
,s.views_workbook_id as object_id
,si.name as site
,w.name as "Object Name"
,u.name as "Owner"
,u.friendly_name as "Owner Name"
,w.size/1024/1024 as size_mb
,p.project
,p.project_path
, CASE WHEN p.project_path='' then 
	'tabcmd delete --workbook "' ||  w.name || '" -r "' || p.project || '"'
	ELSE
	'tabcmd delete --workbook "' ||  w.name || '" -r "' || p.project || '" --parent-project-path "' || p.project_path || '"' END as script
from _views_stats s
left join _sites si on s.site_id = si.id
left join workbooks w on s.views_workbook_id = w.id
left join _users u on w.owner_id = u.id
left join (
						--maps out the parent projects up to the top checking for 9 levels, I only ever found items 7 deep in testing
			select 
			s.name as site
			,p1.id as project_id
			--,concat_ws('/',p1.name,p2.name,p3.name,p4.name,p5.name,p6.name,p7.name,p8.name,p9.name) as path
			,p1.name as project
			,concat_ws('/',p9.name,p8.name,p7.name,p6.name,p5.name,p4.name,p3.name,p2.name) as project_path
			from  projects p1 
			inner join sites s on p1.site_id=s.id
			left outer join projects p2 on p1.parent_project_id=p2.id
			left outer join projects p3 on p2.parent_project_id=p3.id
			left outer join projects p4 on p3.parent_project_id=p4.id
			left outer join projects p5 on p4.parent_project_id=p5.id
			left outer join projects p6 on p5.parent_project_id=p6.id
			left outer join projects p7 on p6.parent_project_id=p7.id
			left outer join projects p8 on p7.parent_project_id=p8.id
			left outer join projects p9 on p8.parent_project_id=p9.id
) p	on w.project_id = p.project_id 
--where w.name='deleteme'   
group by 2,3,4,5,6,7,8,9,10,11

having    max(last_view_time) < CURRENT_DATE - INTERVAL '6 months'
order by 8 desc) as Workbooks

union all

--datasources
select * from (select 
max(s.last_access_time) as last_access
,'datasource' as Object
,s.datasource_id as object_id
,si.name as site
,d.name as "Object Name"
,u.name as "Owner"
,u.friendly_name as "Owner Name"
,d.size/1024/1024 as size_mb
,p.project
,p.project_path
   , CASE WHEN p.project_path='' then 
	'tabcmd delete --datasource "' ||  d.name || '" -r "' || p.project || '"'
   ELSE
	'tabcmd delete --datasource "' ||  d.name || '" -r "' || p.project || '" --parent-project-path "' || p.project_path || '"' END as script
from _datasources_stats s
left join _sites si on s.site_id = si.id
inner join datasources d on s.datasource_id = d.id
left join _users u on d.owner_id = u.id
left join (
						--maps out the parent projects up to the top checking for 9 levels, I only ever found items 7 deep in testing
			select 
			s.name as site
			,p1.id as project_id
			--,concat_ws(' -> ',p1.name,p2.name,p3.name,p4.name,p5.name,p6.name,p7.name,p8.name,p9.name) as path
			,p1.name as project
			,concat_ws('/',p9.name,p8.name,p7.name,p6.name,p5.name,p4.name,p3.name,p2.name) as project_path
			from  projects p1 
			inner join sites s on p1.site_id=s.id
			left outer join projects p2 on p1.parent_project_id=p2.id
			left outer join projects p3 on p2.parent_project_id=p3.id
			left outer join projects p4 on p3.parent_project_id=p4.id
			left outer join projects p5 on p4.parent_project_id=p5.id
			left outer join projects p6 on p5.parent_project_id=p6.id
			left outer join projects p7 on p6.parent_project_id=p7.id
			left outer join projects p8 on p7.parent_project_id=p8.id
			left outer join projects p9 on p8.parent_project_id=p9.id
) p	on d.project_id = p.project_id 
--where w.name='deleteme'   
group by 2,3,4,5,6,7,8,9,10,11
having    max(last_access_time) < CURRENT_DATE - INTERVAL '6 months'
order by 8 desc) as Datasources

