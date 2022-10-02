/********************************************************* 
 *PURPOSE: SQL Query to find ESS Job History  *
 *********************************************************/
SELECT
   p.requestid parent_request_id,
   m.requestid request_id,
   NVL(p.name, substr(p.DEFINITION, instr(p.DEFINITION, '/', - 1) + 1, LENGTH(p.DEFINITION))) parent_job_name,
   NVL(m.name, substr(m.DEFINITION, instr(m.DEFINITION, '/', - 1) + 1, LENGTH(m.DEFINITION))) job_name,
   FLV1.MEANING parent_request_state,
   FLV2.MEANING child_request_state,
   TO_CHAR(m.processstart, 'DD-MM-YYYY HH24:MI:SS') START_DATE,
   TO_CHAR(m.processend, 'DD-MM-YYYY HH24:MI:SS') END_DATE,
   (
      m.processend - m.processstart 
   )
   "TIME_TOOK_TO_RUN",
   m.username 
FROM
   ess_request_history p,
   ess_request_history m,
   fnd_lookup_values flv1,
   fnd_lookup_values flv2 
WHERE
   p.requestid = decode(m.parentrequestid, 0, m.requestid, m.parentrequestid) 
   AND sysdate BETWEEN nvl(flv1.start_date_active, sysdate) AND nvl(flv1.end_date_active, sysdate) 
   AND sysdate BETWEEN nvl(flv2.start_date_active, sysdate) AND nvl(flv2.end_date_active, sysdate) 
   AND flv1.lookup_type = 'ORA_EGP_ESS_REQUEST_STATUS' 
   AND flv2.lookup_type = 'ORA_EGP_ESS_REQUEST_STATUS' 
   AND flv1.lookup_code = p.state 
   AND flv2.lookup_code = m.state 
ORDER BY
   m.requestid DESC;
   
   
   
SELECT
   p.requestid parent_request_id,
   m.requestid request_id,
   NVL(p.name, substr(p.DEFINITION, instr(p.DEFINITION, '/', - 1) + 1, LENGTH(p.DEFINITION))) parent_job_name,
   NVL(m.name, substr(m.DEFINITION, instr(m.DEFINITION, '/', - 1) + 1, LENGTH(m.DEFINITION))) job_name,
   FLV1.MEANING parent_request_state,
   FLV2.MEANING child_request_state,
   TO_CHAR(m.processstart, 'DD-MM-YYYY HH24:MI:SS') START_DATE,
   TO_CHAR(m.processend, 'DD-MM-YYYY HH24:MI:SS') END_DATE,
   (sysdate - m.processstart) "TIME_TOOK_TO_RUN",
   SUBSTR((sysdate - m.processstart), 3,2) substr_time,
  -- SUBSTR( TO_CHAR((sysdate - m.processstart), 'HH'), 3,2) substr_time1,
   lpad(floor((CAST(sysdate AS DATE )-CAST(m.PROCESSSTART AS DATE)) * 24),2,'0')||':'||
       lpad(floor(mod((CAST(sysdate AS DATE )-CAST(m.PROCESSSTART AS DATE)) * 24,1)*60),2,'0')||':'||
       lpad(FLOOR(MOD(mod((CAST(sysdate AS DATE )-CAST(m.PROCESSSTART AS DATE)) * 24,1)*60,1)*60),2,'0') time_cast,
   m.username,
   sysdate
FROM
   ess_request_history p,
   ess_request_history m,
   fnd_lookup_values flv1,
   fnd_lookup_values flv2 
WHERE
   p.requestid = decode(m.parentrequestid, 0, m.requestid, m.parentrequestid) 
   AND sysdate BETWEEN nvl(flv1.start_date_active, sysdate) AND nvl(flv1.end_date_active, sysdate) 
   AND sysdate BETWEEN nvl(flv2.start_date_active, sysdate) AND nvl(flv2.end_date_active, sysdate) 
   AND flv1.lookup_type = 'ORA_EGP_ESS_REQUEST_STATUS' 
   AND flv2.lookup_type = 'ORA_EGP_ESS_REQUEST_STATUS' 
   AND flv1.lookup_code = p.state 
   AND flv2.lookup_code = m.state 
  -- aND m.requestid  = 6106247
  AND m.processstart is not null
  and m.processend is null
 -- and TO_CHAR((sysdate - m.processstart), 'HH') > 2
 and 
 lpad(floor((CAST(sysdate AS DATE )-CAST(m.PROCESSSTART AS DATE)) * 24),2,'0')||':'||
       lpad(floor(mod((CAST(sysdate AS DATE )-CAST(m.PROCESSSTART AS DATE)) * 24,1)*60),2,'0')||':'||
       lpad(FLOOR(MOD(mod((CAST(sysdate AS DATE )-CAST(m.PROCESSSTART AS DATE)) * 24,1)*60,1)*60),2,'0') > '01'
ORDER BY
   m.requestid asc; 
