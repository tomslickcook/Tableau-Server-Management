--maps out the parent projects up to the top checking for 9 levels, I only ever found items 7 deep in testing
select 
s.name as site
,p1.id as project_id
--,concat_ws(' -> ',p1.name,p2.name,p3.name,p4.name,p5.name,p6.name,p7.name,p8.name,p9.name) as path
,concat_ws(' -> ',p9.name,p8.name,p7.name,p6.name,p5.name,p4.name,p3.name,p2.name,p1.name) as path
,concat_ws(' -> ',p9.name,p8.name,p7.name,p6.name,p5.name,p4.name,p3.name,p2.name) as project_path
--,p1.name as P1Name 
--,p2.name as P2Name
--,p3.name as P3Name
--,p4.name as P4Name
--,p5.name as P5Name
--,p6.name as P6Name
--,p7.name as P7Name
--,p8.name as P8Name
--,p9.name as P9Name
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
