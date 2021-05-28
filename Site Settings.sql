--a couple new settings I can't find in the repo
--Automatically Suspend Extract Refresh Tasks
--Site Time Zone for Extracts
--Enable Web Page objects

select
s.name
,s.id
,url_namespace as shortname 
,unnest(array[
	'Custom Email Address'
	,'Custom Email Footer'
	,'Workbook Web Authoring'
	,'Subscriptions'
	,'Version History'
	,'Notifications'
	,'Cache Warmup'
	,'Metrics'
	,'Data Alerts'
	,'Commenting'
	,'Commenting Mentions'
	,'Reccomendations'
	,'Reccomendations Usernames'
	,'Request Access'
	,'RServe'
	,'Dashboard Extentions'
	,'Dashboard Sandboxed Extentions'
	,'Subscription Attached PDF'
	,'Subscribe Other Users'
	,'Schedule Prep Flows'
	,'Data Catalog'
	,'Automatic Access to DB/Table Metadata'
	,'Sensitive Lineage Data'
	,'Encryption at Rest'
	,'Named Sharing'
	,'Flow Web Authoring'
	,'Site Time Zone for Extracts'
	,'Web Page Objects'
	,'Automatically Suspend Extract Refresh Tasks'
	,'Auto Suspend Inactive Window'
])as "configuration item"
,unnest(array[
	COALESCE(custom_subscription_email,'none')
	,COALESCE(custom_subscription_footer,'none')
	,CASE WHEN authoring_disabled=true then 'disabled' else 'enabled' end
	,CASE WHEN subscriptions_enabled then 'enabled' else 'disabled' end
	,CASE WHEN version_history_enabled then 'enabled' else 'disabled' end
	,CASE WHEN notification_enabled then 'enabled' else 'disabled' end
	,CASE WHEN cache_warmup_enabled then 'enabled' else 'disabled' end
	,CASE WHEN metrics_enabled then 'enabled' else 'disabled' end
	,CASE WHEN data_alerts_enabled then 'enabled' else 'disabled' end
	,CASE WHEN commenting_enabled then 'enabled' else 'disabled' end
	,CASE WHEN commenting_mentions_enabled then 'enabled' else 'disabled' end
	,CASE WHEN viz_recs_enabled then 'enabled' else 'disabled' end
	,CASE WHEN viz_recs_username_enabled then 'enabled' else 'disabled' end
	,case when request_access=0 then 'enabled' when request_access=1 then 'disabled' end
	,case when sv.extsvc_enabled  then 'enabled' else 'disabled' end
	,case when ss.extensions_enabled  then 'enabled' else 'disabled' end
	,case when ss.allow_sandboxed	  then 'enabled' else 'disabled' end
	,case when allow_subscriptions_attach_pdf then 'enabled' else 'disabled' end
	,case when subscribe_others_enabled then 'enabled' else 'disabled' end
	,case when flows_enabled then 'enabled' else 'disabled' end
	,case when cataloging_enabled then 'enabled' else 'disabled' end
	,case when derived_permissions_enabled then 'enabled' else 'disabled' end
	,case when obfuscation_enabled then 'Show complete lineage' ELSE 'Show partial lineage' END
	,case when extract_encryption_mode=1 then 'Enable: Let users selectively encrypt extracts' 
			WHEN extract_encryption_mode=2 then 'Enforce: Encrypt all extracts'
			ELSE 'Disable: Don’t allow encrypted extracts' END
	,case when named_sharing_enabled then 'enabled' else 'disabled' end
	,case when web_editing_enabled then 'enabled' else 'disabled' end
	,COALESCE(time_zone,'UTC')
	,case when web_zone_content_enabled then 'enabled' else 'disabled' end
	,case when auto_suspend_refresh_enabled then 'enabled' else 'disabled' end
	,auto_suspend_refresh_inactivity_window::text || ' Days'
])as "value"
,unnest(array[
	'Specify the From address in automatic emails for alerts and subscriptions.'
	,'Specify the footer in automatic emails for alerts and subscriptions.'
	,'Users with the appropriate permissions can edit and create workbooks in their browser.'
	,'Users can receive scheduled emails with updates on workbooks and views.'
	,'Revisions are versions of content previously published to the server.'
	,'Enable email notifications to inform content owners when there are updates to extract jobs or scheduled refreshes. '
	,'Recently viewed workbooks with scheduled refreshes can be pre-computed to open faster.'
	,'Metrics are a content type that allows users to track their data. When metrics are disabled, they wont appear on the site or continue to sync however, you can re-enable the feature to bring back previous metrics.'
	,'Users can create alerts to notify themselves and others when data meets specified conditions.'
	,'Users with the appropriate permissions can comment on views and notify others about their comments.'
	,'Let users @mention others to notify them by email.'
	,'Recommend potentially relevant views based on usage patterns at your organization.'
	,'Show users with similar content usage in recommendation tooltips'
	,'Users can send access request emails to content or project owners.'
	,'Allow users to use External RServe Service'
	,'Let users run extensions on this site'
	,'Let Sandboxed extensions run unless they are specifically blocked by a server administrator'
	,'Let users add PDF attachments to subscription emails'
	,'Let content owners subscribe other users.'
	,'Users with appropriate permissions can publish, manage, and schedule flows.'
	,'Turning on Catalog access enables users with appropriate permissions to see metadata, lineage, data quality information, and more.'
    ,'Based on users’ existing permissions for data sources, workbooks, and flows, you can automatically provide access to related database and table metadata'
    ,'Specify when to show lineage information that includes sensitive data. This setting affects users’ ability to perform complete impact analysis.'
	,'You can specify whether extracts stored on this site are encrypted.'
	,'Users can share content with others.'
	,'Users with the appropriate permissions can edit and create Prep Flows in their browser.'
	,'Set the time zone used for extract-based data sources.'
	,'Web Page objects display target URLs in dashboards.'
	,'Tableau can detect if refresh tasks are running on inactive workbooks and automatically suspend those tasks to save resources.'
	,'After how many days of inactivity should extract refresh tasks be suspended?'
])as "Description"
,unnest(array[
	'https://help.tableau.com/current/server/en-us/subscribe.htm#enable-subscriptions'
	,'https://help.tableau.com/current/server/en-us/subscribe.htm#enable-subscriptions'
	,'https://help.tableau.com/current/pro/desktop/en-us/getstarted_web_authoring.htm'
	,'https://help.tableau.com/current/online/en-us/subscribe_user.htm#set-up-a-subscription-for-yourself-or-others'
	,'https://help.tableau.com/current/server/en-us/revision_history_maintain.htm'
	,'https://help.tableau.com/current/online/en-us/to_refresh_enable_emails.htm'
	,'https://help.tableau.com/current/server/en-us/perf_workbook_scheduled_refresh.htm#turn-off-workbook-caching--for-a-site'
	,'https://help.tableau.com/current/pro/desktop/en-us/metrics_create.htm'
	,'https://help.tableau.com/current/pro/desktop/en-us/data_alerts.htm'
	,'https://help.tableau.com/current/pro/desktop/en-us/comment.htm'
	,'https://help.tableau.com/current/pro/desktop/en-us/comment.htm'
	,'https://www.tableau.com/about/blog/2019/11/discover-new-and-trending-vizzes-view-recommendations'
	,'https://www.tableau.com/about/blog/2019/11/discover-new-and-trending-vizzes-view-recommendations'
	,'https://help.tableau.com/current/server/en-us/Request_access.htm'
	,'https://docs.google.com/document/d/1IM5DQoSBj2wuGMkqwgsKb79qusdVMuanUz9wFoEF5E8/edit#'
	,'https://help.tableau.com/current/server/en-us/dashboard_extensions_server.htm#control-dashboard-extensions-and-access-to-data'
	,'https://help.tableau.com/current/server/en-us/dashboard_extensions_server.htm#change-the-default-settings-for-a-site'
	,'https://www.tableau.com/about/blog/2019/10/new-pdf-feature-20193-supports-report-bursting-workflow'
	,'https://help.tableau.com/current/online/en-us/subscribe_user.htm#set-up-a-subscription-for-yourself-or-others'
	,'https://help.tableau.com/current/prep/en-us/prep_conductor_publish_flow.htm'
	,'https://help.tableau.com/current/server/en-us/dm_catalog_overview.htm'
	,'https://help.tableau.com/v2020.2/server/en-us/dm_perms_assets.htm#perms'
	,'https://help.tableau.com/v2020.2/server/en-us/dm_perms_assets.htm#lineage_checkbox'
	,'https://help.tableau.com/current/server/en-us/security_ear.htm'
	,'https://help.tableau.com/current/pro/desktop/en-us/shareworkbooks.htm'
	,'https://help.tableau.com/current/server/en-us/web_author_flows.htm'
	,'https://help.tableau.com/v2020.4/server/en-us/tz_for_extracts.htm'
	,''
	,'https://help.tableau.com/current/server/en-us/extract_auto_suspend.htm'
	,'https://help.tableau.com/current/server/en-us/extract_auto_suspend.htm'
])as "URL"
from sites s
left outer join external_service_site_settings sv on s.id=sv.site_id
left outer join extensions_site_settings ss on s.id=ss.site_id
where s.status='active'
