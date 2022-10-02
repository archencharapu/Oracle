select * from ess_request_history
where 1=1
--and name = 'Job for processing errored rows to Oracle Search Cloud Service' -- scheduled by FAAdmin
and name = 'FndOSCSBulkIngestJob' -- triggered by individual users like DSinghal, CHEWY.OIC, etc.
--and definition = 'JobDefinition://oracle/apps/ess/fnd/applcore/FndOSCSBulkIngestJob'
--and requestid = 5554849
order by 1 desc;

/*****
JobDefinition://oracle/apps/ess/fnd/applcore/FndOSCSBulkIngestJob
JobDefinition://oracle/apps/ess/fnd/applcore/FndOSCSBulkIngestJob
******/


-- ESS job with parameter values
select erh.requestid, erp.value argument1, erh.username, erh.name, erh.processstart, erh.processend 
from ess_request_history erh
    ,ess_request_property erp
where 1=1
--and name = 'Job for processing errored rows to Oracle Search Cloud Service' -- scheduled by FAAdmin
and erh.name = 'FndOSCSBulkIngestJob' -- triggered by individual users like DSinghal, CHEWY.OIC, etc.
--and definition = 'JobDefinition://oracle/apps/ess/fnd/applcore/FndOSCSBulkIngestJob'
--and requestid = 5554849
and erh.requestid = erp.requestid(+)
and (erp.name(+) = 'submit.argument1' -- Prod
        or 
     erp.name(+) = 'submit.argument1.attributeValue'  -- Dev1
     )
and erh.processstart > sysdate-20
order by 1 desc;


-- ESS job run count by day
select trunc(processstart), count(1) from ess_request_history
where 1=1
--and name = 'Job for processing errored rows to Oracle Search Cloud Service' -- scheduled by FAAdmin
and name = 'FndOSCSBulkIngestJob' -- triggered by individual users like DSinghal, CHEWY.OIC, etc.
--and definition = 'JobDefinition://oracle/apps/ess/fnd/applcore/FndOSCSBulkIngestJob'
--and requestid = 5554849
group by trunc(processstart)
order by 1 desc;


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


-- Receipts Query
select rh.receipt_num, rl.line_num, rt.*
from rcv_transactions rt,
    rcv_shipment_headers rh,
    rcv_shipment_lines rl
where 1=1
and rt.shipment_header_id = rh.shipment_header_id
and rt.shipment_line_id = rl.shipment_line_id
and rt.transaction_id in (
23640309,
23640308,
23639524,
23640305,
23640304
)
order by 1,3;