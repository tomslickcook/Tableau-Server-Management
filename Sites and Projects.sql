Select 
*
from (
--All site admins for active sites
SELECT 
 -- users.id, 
  --users.admin_level, 
  --system_users.name,
    sites.name AS "Name",
   STRING_AGG(system_users.friendly_name, ';' ORDER BY system_users.id) AS "Owner",
      STRING_AGG( system_users.email, ';' ORDER BY system_users.id) AS email,
    NULL AS description,
    'Site' AS type

--,sites.url_namespace
 -- system_users.admin_level
FROM
    public.sites,
    public.users,
    public.system_users
WHERE
    users.site_id = sites.id
    AND users.system_user_id = system_users.id 
	--AND  users.admin_level=5
    AND users.site_role_id = 0
    AND system_users.email IS NOT NULL
    AND sites.status = 'active'
Group by 
    sites.name

UNION ALL

--all owners of Top Level projects in Default Site
SELECT
    p.name as "Name",
    u.friendly_name AS "Owner",
    u.name || '@domain.com' AS email,
    p.description,
    'Project' AS ype
FROM
    projects p
    INNER JOIN _users u ON p.owner_id = u.id
WHERE
    p.site_id = 1
    AND p.parent_project_id IS NULL
    AND p.id NOT IN ( --remove default  and some general project we don't want listed
        1,
        310,
        311,
        341
    ) 
    ) r
    order by 5 desc, 1 asc