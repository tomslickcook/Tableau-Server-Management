--All the alerts and reciepients
SELECT
    a.id,
    a.title,
    u.name AS "Alert Creator",
    w.name AS "Workbook",
    v.name AS "View",
    u2.name AS "Alert Reciepient",
    s.name AS site
    ,a.data_specification --big XML column with some of the alert criteria. 
    
FROM
    data_alerts a
    LEFT OUTER JOIN _workbooks w ON a.workbook_id = w.id
    LEFT OUTER JOIN views v ON a.view_id = v.id
    LEFT OUTER JOIN _users u ON a.creator_id = u.id
    LEFT OUTER JOIN data_alerts_recipients r ON a.id = r.data_alert_id --on alert can have 1 to N reciepients
    LEFT OUTER JOIN _users u2 ON r.recipient_id = u2.id
                                 AND recipient_type = 'USER' --as of version 2019.2 the UI doesn't allow groups to be added to an alert, but looks like there is the back end infrastructure to support it
    LEFT OUTER JOIN sites s on a.site_id=s.id     