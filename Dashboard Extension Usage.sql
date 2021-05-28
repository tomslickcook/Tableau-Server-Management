/*
This is useful for tracking usage of extensions. 

It will list all the workbooks that are using extensions with some basic information 
about the location, owner, workbook, and extension.

Tested in Tableau Server v2020.4
*/
SELECT
    w.name    AS "Workbook",
    e.created_at AS "Workbook Created Date",
    u.name    AS "Workbook Owner",
    s.name    AS site,
	m.resources::json->'name' ->>'en_US' as "Extension", --parsing the JSON to get the english name
	m.resources, --this is the closest thing to a name that I can find
	m.extension_id,
    m.desc_locale_value as "Description",
    m.author_name as "Author",
    m.author_website as "Author Website"
FROM
    extensions_instances e
    INNER JOIN workbooks            w ON e.workbook_luid = w.luid
    INNER JOIN extensions_metadata  m ON m.luid = e.extension_luid
    INNER JOIN _users               u ON w.owner_id = u.id
    INNER JOIN sites                s ON w.site_id = s.id
