--find all the subscriptions
--This can get a bit wonky since you can subscribe to n views in a WB or the whole WB
SELECT
    s.subject,
    sv.repository_url    AS "Subscribed Views",
    sw.repository_url    AS "Subscribed Workbook",
    v.name               AS view,
    w.name               AS workbook,
    s.created_at,
    u1.name              AS "Subscribed Username",
    u1.friendly_name     AS "Subscribed Name",
    u1.name              AS "Subscription Creator",
    s.data_condition_type,
    sch.name             AS "Schedule",
    v.owner_name         v_owner,
    w.owner_name         AS wb_owner,
    CASE
        WHEN s.site_id = 40    THEN
            'ED'
        WHEN s.site_id = 20    THEN
            'MCIT'
    END                  AS site
FROM
    subscriptions            s
    LEFT OUTER JOIN _users                   u1 ON s.user_id = u1.id --subscribed user
    LEFT OUTER JOIN _users                   u2 ON s.creator_id = u2.id--creator, which may or may not get the subscription
    LEFT OUTER JOIN schedules                sch ON s.schedule_id = sch.id
    LEFT OUTER JOIN subscriptions_views      sv ON s.id = sv.subscription_id
    LEFT OUTER JOIN subscriptions_workbooks  sw ON s.id = sw.subscription_id
    LEFT OUTER JOIN _views                   v ON replace(
        sv.repository_url,
        '/sheets/',
        '/'
    ) = v.view_url --this join is sketchy since we are matching the workbook and view name in theory there could be dups across sites. 
    LEFT OUTER JOIN _workbooks               w ON sw.repository_url = w.workbook_url -- this join is better since we can use site and the WB url name
                                    AND sw.site_id = w.site_id