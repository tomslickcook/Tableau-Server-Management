--Sometimes you need a list of content to do analysis for tasks or permisisons

--Joins to workbooks, views, etc should use both:
-- id is the workbook/view/metric/etc id
-- use the task column to determine what type of object we are listing with something like task='Workbook' when joining in the workbooks table.
-- left outer join workbooks on id=workbook.id AND type='Workbook'
-- left outer join metrics on id=metric.id AND type='Metric'

Select 
	o.id,
	'Metric' as type,
	o.name,
	o.owner_id,
	o.project_id,
    u.name as owner_name,
    p.name as project_name,
	s.name AS site,
	o.site_id 
	,workbook_id as parent_workbook_id
from 
	metrics o 
	INNER JOIN sites s ON o.site_id = s.id
	INNER JOIN _users u on o.owner_id=u.id
	INNER JOIN projects p on o.project_id=p.id and o.site_id=p.site_id
UNION ALL 
Select
	o.id,
	'Datasource' as type,
	o.name,
	o.owner_id,
	o.project_id,
    o.owner_name,
    o.project_name,
	s.name AS site,
	o.site_id 
	,d.parent_workbook_id
FROM
	_datasources o
	INNER JOIN sites s ON o.site_id = s.id
	INNER JOIN datasources d on o.id=d.id
Where d.parent_workbook_id is null --only published datasources
UNION ALL
SELECT
    o.id,
    'Workbook' AS type,
    o.name,
	o.owner_id,
	o.project_id,
    o.owner_name,
    o.project_name,
    s.name AS site,
	o.site_id 
	,o.id as parent_workbook_id
FROM
    _workbooks   o
    INNER JOIN sites s ON o.site_id = s.id
UNION ALL
select 
 	o.id,
    'View' AS type,
    o.name,
	o.owner_id,
	w.project_id,
    o.owner_name,
    w.project_name,
    s.name AS site,
	o.site_id 
	,o.workbook_id as parent_workbook_id
FROM 
	_views o
	INNER JOIN sites s ON o.site_id = s.id
	INNER JOIN _workbooks w on o.workbook_id=w.id

UNION ALL

Select 
	o.id,
    'Project' AS type,
    o.name,
	o.owner_id,
	p.parent_project_id,
    o.owner_name,
    null as project_name,-- w.project_name,
    s.name AS site,
	o.site_id 
	,null as parent_workbook_id
from 
	_projects o
	INNER JOIN sites s ON o.site_id = s.id
	INNER JOIN projects p on o.id=p.id;
