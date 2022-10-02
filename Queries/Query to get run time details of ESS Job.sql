-- Query to get run time details of ESS Job

SELECT 
requestid,
PRODUCT,
SUBSTR(DEFINITION,INSTR(DEFINITION,'/', -1)+1) short_name,
name,
DEFINITION,
count(1) number_of_exe,
ROUND(Min(((cast(processend as Date) - cast(processstart as date)) * 24*60 )),2)min_time,
ROUND(Max(((cast(processend as Date) - cast(processstart as date)) * 24*60 )),2)max_time,
ROUND(Avg(((cast(processend as Date) - cast(processstart as date)) * 24*60)),2)avg_time
from fusion_ora_ess.request_history_view rh
where PROCESSEND is not null
AND TRUNC(rh.processstart) between NVL(:P_START_DATE,SYSDATE-90) AND NVL(:P_END_DATE,SYSDATE)
group by requestid, PRODUCT,name, SUBSTR(DEFINITION,INSTR(DEFINITION,'/', -1)+1),DEFINITION
ORDER BY Max(((cast(processend as Date) - cast(processstart as date)) * 24*60 )) desc