-- Long Running Custom BI Publsiher Reports
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
             erp.value Report_Path,
             erh.processend end_date,
             erh.processstart start_date,
             erh.elapsedtime elapsed_time,
             erh.processend - erh.processstart processing_time,
             ROUND((cast(processend as Date) - cast(processstart as date))* 24,2) processing_time1,
             (erh.processend - erh.processstart)*60 processing_time2,
          --   ROUND((erh.processend - erh.processstart) * 24*60 ,2) processing_time,
         erh.*
    FROM fusion.ess_request_history erh, fusion.ess_request_property erp
   WHERE     1 = 1
         AND erh.requestid = erp.requestid
         AND erp.name = 'report_url'
         AND processstart > sysdate-1
       --  AND erp.VALUE LIKE  '/Custom/Chewy/PPA_Reports%'
         AND ROUND((cast(processend as Date) - cast(processstart as date))* 24,2) > 4
         --AND erh.requestid = 140974
ORDER BY erh.elapsedtime DESC;