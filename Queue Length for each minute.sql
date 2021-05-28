--CTE pulls a list of all the tasks with some details
WITH tasks AS (
    SELECT
        j.id
--the timestamps are in UTC time but the database is America/Detroit, so you have to convert them twice to get local time
        ,
        ( j.created_at AT TIME ZONE 'UTC' ) AT TIME ZONE 'America/Detroit' AS created_at_local,
        ( j.started_at AT TIME ZONE 'UTC' ) AT TIME ZONE 'America/Detroit' AS started_at_local,
        ( j.completed_at AT TIME ZONE 'UTC' ) AT TIME ZONE 'America/Detroit' AS completed_at_local,
        j.job_name,
        j.subtitle,
        j.priority,
        j.processed_on_worker,
        j.backgrounder_id,
        j.correlation_id
    FROM
        background_jobs j
    WHERE --j.job_name IN('Refresh Extracts','Increment Extracts')
        j.job_name IN (
            'Subscription Notifications',
            'Refresh Extracts',
            'Increment Extracts'
        )
        AND j.progress = 100
    ORDER BY
        created_at_local DESC
)

-- Queued and Running jobs by minute
-- Generating a series of minutes and then joining the tasks to it to get the jobs that were running or queued for that minute

-- This only contains jobs that were queued for the ENTIRE minute. Any jobs that were added to the queued or started during that minute would not be counted. 
-- Any jobs that were queued or started during that minute would not be counted. 
-- This should be good enough for trending queue length

-- Queued Jobs for that minute. 
SELECT
    as_of_dt::timestamp 
--,r.job_name as r_job
,q.job_name as job_type
,q.id
,q.correlation_id
,q.priority
--,COUNT(DISTINCT r.id) as running_count
--,COUNT(DISTINCT q.id) as job_count
,'Queued' as type
from generate_series( --generate a list of the total that are in the queue for each minute Normally this is for 2 days ago (not yesterday but two ago) and focused on more historical analysis
	CASE 
		WHEN now()::timestamp<'2020-04-03 02:00:00'::TIMESTAMP THEN date_trunc('day',now())+ interval '-14 day' --start series with some historical data
		ELSE date_trunc('day',now())+ interval '-2 day' --normal start of series is 2 days ago
	END,
	date_trunc('day',now())+ interval '-1 day',       --end series yesterday
	'1 minute'::interval) as_of_DT --interval
--left outer join tasks r on   as_of_DT>=r.started_at_local AND as_of_DT<r.completed_at_local
left outer join tasks q on   as_of_DT>=q.created_at_local AND as_of_DT<q.started_at_local
where  q.job_name is not null
--AND as_of_dt='4/1/2020 7:15:00 AM'::TIMESTAMP
--group by as_of_DT::timestamp
--,r.job_name
--,q.job_name
--,q.id

UNION ALL

-- Running Jobs for that minute
-- jobs that run for less than a minute will probabbly be dropped. 
-- this is here for just in case, and not acutually looking at running jobs since it will be limited by the count of backgrounders
select 
as_of_DT::timestamp 
--,r.job_name as r_job
,r.job_name as q_job
,r.id
,r.correlation_id
,r.priority
--,COUNT(DISTINCT r.id) as running_count
--,COUNT(DISTINCT r.id) as queued_count
,'Running' as type
from generate_series(
	CASE 
		WHEN now()::timestamp<'2020-04-03 02:00:00'::TIMESTAMP THEN date_trunc('day',now())+ interval '-14 day' --start series
		ELSE date_trunc('day',now())+ interval '-2 day'
	END,
	date_trunc('day',now())+ interval '-1 day',       --end series
     '1 minute' : :interval ) as_of_dt --interval
LEFT OUTER JOIN tasks r ON as_of_dt >= r.started_at_local
                           AND as_of_dt < r.completed_at_local
--left outer join tasks q on   as_of_DT>=q.created_at_local AND as_of_DT<q.started_at_local
where r.job_name is NOT NULL 
--AND as_of_dt='4/1/2020 7:15:00 AM'::TIMESTAMP
--group by as_of_DT::timestamp
--,r.job_name
--,r.job_name
--,r.id
