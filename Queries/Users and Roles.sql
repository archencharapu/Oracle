select username, prd.*
from per_users pu,
	per_user_roles pur,
	per_roles_dn_vl prd
where 1=1
and pu.user_id = pur.user_id
and pur.role_id = prd.role_id
and pu.username = :p_user_name


-- Query 1
select a1.USERNAME,
a1.ACTIVE_FLAG,
a1.CREDENTIALS_EMAIL_SENT,
a2.START_DATE,USER_ROLE_ID,
ROLE_ID,
ROLE_GUID,
ABSTRACT_ROLE,
JOB_ROLE,
DATA_ROLE,
ROLE_COMMON_NAME
from  per_users a1, per_user_roles a2,per_roles_dn a3
where a1.user_id=a2.USER_ID
and a2.ROLE_ID=a3.ROLE_ID
and a2.ROLE_GUID=a3.ROLE_GUID


-- Query 2
SELECT prdt.role_id, prdt.role_name,
              prdt.description RoleDescription,
              prdt.source_lang
FROM per_roles_dn_tl prdt


-- Query 3
SELECT pu.user_id,
         pu.username,
         ppnf.full_name,
         prdt.role_id,
         prdt.role_name,
         prd.role_common_name,
         prdt.description,
         TO_CHAR (pur.start_date, 'DD-MON-YYYY') role_start_date,
         TO_CHAR (pur.end_date, 'DD-MON-YYYY') role_end_date,
         prd.abstract_role,
         prd.job_role,
         prd.data_role,
         prd.duty_role,
         prd.active_flag
    FROM per_user_roles    pur,
         per_users         pu,
         per_roles_dn_tl   prdt,
         per_roles_dn      prd,
         per_person_names_f ppnf
   WHERE     1 = 1
         AND pu.user_id = pur.user_id
         AND prdt.role_id = pur.role_id
         AND prdt.language = USERENV ('lang')
         AND prdt.role_id = prd.role_id
         AND NVL (pu.suspended, 'N') = 'N'
   AND pu.username =:p_username
         AND ppnf.person_id = pu.person_id
         AND ppnf.name_type = 'GLOBAL'
         AND pu.active_flag = 'Y'
         AND NVL (pu.start_date, SYSDATE) <= SYSDATE
         AND NVL (pu.end_date, SYSDATE) >= SYSDATE
ORDER BY pu.username, prdt.role_name;
