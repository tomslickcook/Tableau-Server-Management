--Find all the customized views that users have made. 
--The bummer is that we can see that they exist, but not what is cusomized
SELECT
    cv.name AS "CustomView Name",
    MAX(cv.updated_at) update_date,
    cv.public,
    u.name AS "Creator Username",
    u.friendly_name AS "Creator",
    v.owner_name "Content Owner",
    v.view_url AS "Workbook/View",
    s.url_namespace AS site
FROM
    customized_views cv
    LEFT OUTER JOIN _users u ON cv.creator_id = u.id
    LEFT OUTER JOIN sites s ON cv.site_id = s.id
    LEFT OUTER JOIN _views v ON cv.start_view_id = v.id --the start_view_id is the view the users was on when they saved the custom view
-- WHERE s.id = 40  --just one site

GROUP BY --grouping since there is a row for each view in the workbook.
    cv.name,
    cv.public,
    u.name,
    u.friendly_name,
    v.owner_name,
    v.view_url,
    s.url_namespace
