/*******************************************************************************************************************************
What are the Tables Where the ESS Jobs and Custom Job Sets are Stored? (Doc ID 2430380.1)
1. The Jobset and Job Definitions are not stored in any DB tables to query. They are xml documents stored in MDS DB which cannot be queried using SQL.
2. Once the jobs or job sets are run users can use the following queries to check the properties of the job.

ess_request_history: stores job history and details
ess_request_property: stores job properties like parameters, etc.

*********************************************************************************************************************************/

-- ESS job Schedule processes
Select r.requestid, r.name "ESS Job Name",r.EXECUTABLE_STATUS "JOB  STATUS",R.USERNAME,R.APPLICATION,R.PRODUCT,R.REQUESTEDSTART,R.COMPLETEDTIME 
from fusion.ess_request_history r,fusion.ess_request_property v
where 1=1  and r.requestid = v.requestid
order by r.requestid, v.name

-- Find Children of a Parent ESS Job
SELECT requestid, 
       scheduled scheduled_time, 
       absparentid parent_id,
DECODE(state,
       1,'Wait', 
       11,'Warning',
       2,'Ready', 
       12,'Succeeded',
       3,'Running', 
       13,'Paused',
       4,'Completed', 
       14,'Pending Validation',
       5,'Blocked', 
       15,'Validation Failed',
       6,'Hold', 
       16,'Schedule Ended',
       7,'Canceling', 
       17,'Finished',
       8,'Expired', 
       18,'Error Auto-Retry',
       9,'Canceled', 
       19,'Error Manual Recovery',
       10,'Error',
       state) status
FROM FUSION.ESS_REQUEST_HISTORY
WHERE absparentid = '489329'; --parent Process ID


/*******************************************************
 *PURPOSE: SQL Query to find BIP Report Jobs History   *
 *******************************************************/
SELECT (CASE
              WHEN state = 1 THEN 'Wait'
              WHEN state = 2 THEN 'Ready'
              WHEN state = 3 THEN 'Running'
              WHEN state = 4 THEN 'Completed'
              WHEN state = 9 THEN 'Cancelled'
              WHEN state = 10 THEN 'Error'
              WHEN state = 12 THEN 'Succeeded'
              WHEN state = 13 THEN 'Paused'
              ELSE TO_CHAR (state)
          END)
             request_state,
         erh.*
    FROM fusion.ess_request_history erh, fusion.ess_request_property erp
   WHERE     1 = 1
         AND erh.requestid = erp.requestid
         AND erp.name = 'report_url'
         AND erp.VALUE LIKE
                 '/Custom/Procurement/XX Order Confirmation Report.xdo'
         --AND erh.requestid = 140974
ORDER BY erh.requestid DESC;


-- Scheduled BI Publisher Reports
SELECT 
        (CASE
              WHEN state = 1 THEN 'Wait'
              WHEN state = 2 THEN 'Ready'
              WHEN state = 3 THEN 'Running'
              WHEN state = 4 THEN 'Completed'
              WHEN state = 9 THEN 'Cancelled'
              WHEN state = 10 THEN 'Error'
              WHEN state = 12 THEN 'Succeeded'
              WHEN state = 13 THEN 'Paused'
              ELSE TO_CHAR (state)
          END) request_state,
          erp.value Report_Path,
         erh.username,
         erh.requestedstart,
         erh.requestedend,
         erh.submission
    FROM fusion.ess_request_history erh, fusion.ess_request_property erp
   WHERE     1 = 1
         AND erh.requestid = erp.requestid
         AND erp.name = 'report_url'
		 AND erh.definition = 'JobDefinition://oracle/bip/ess/EssBipJob'
       --  AND upper(erp.value) like '%P2P%'
         ANd erh.scheduled is not null
      --   AND erp.VALUE LIKE '/Custom/Procurement/XX Order Confirmation Report.xdo'
         --AND erh.requestid = 140974
         AND state in (1,2,3)
ORDER BY erh.requestid DESC;


-- Statuses by Each Job Definition
select /* SR  3-29284634221   */ DECODE(state,1,'Wait', 11,'Warning',2,'Ready', 12,'Succeeded',
3,'Running', 13,'Paused',4,'Completed', 14,'Pending Validation',
5,'Blocked', 15,'Validation Failed',6,'Hold', 16,'Schedule Ended',
7,'Canceling', 17,'Finished',8,'Expired', 18,'Error Auto-Retry',
9,'Canceled', 19,'Error Manual Recovery',10,'Error', state) Status, APPLICATION, definition, username,
count(*)
from FUSION.ESS_REQUEST_HISTORY
where 1=1
and state in ('1','2','3','5','6','7','13', '19')
and definition = 'JobDefinition://oracle/apps/ess/fnd/applcore/FndOSCSBulkIngestJob'
group by STATE,APPLICATION,definition,username;