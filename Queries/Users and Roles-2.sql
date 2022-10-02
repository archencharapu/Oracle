--Table FUN_USER_ROLE_DATA_ASGNMNTS is used for “Manage data access for users”.
--it will store use and role assignment to data security.

--These queries will only work for FSCM and not HCM.  HCM roles, security model and underlying tables are different so you may need another sql. 

-- Table name  – FUN_USER_ROLE_DATA_ASGNMNTS
1.user– username to find out from which base table through USER_GUID (FUN_USER_ROLE_DATA_ASGNMNTS)
2.role — rolename column FUN_USER_ROLE_DATA_ASGNMNTS
3.security context –security context to find out from which base table through ACCESS_SET_ID (FUN_USER_ROLE_DATA_ASGNMNTS)


Based on Security Context set in UI, Column will be populated.
For Example, If context is set as Business Unit then field Org Id is populated with Business Unit ID. LEDGER_ID for Security Context Ledger.
Please refer below link for Table information

-- Query that returns User and Role Assignment
SELECT
a.USERNAME,
c.ROLE_NAME,
b.CREATION_DATE,
b.CREATED_BY,
b.LAST_UPDATE_DATE
b.last_updated_by
FROM fusion.PER_USERS a,
fusion.PER_USER_ROLES b,
fusion.PER_ROLES_DN_VL c
WHERE a.USER_ID = b.USER_ID
AND b.ROLE_ID = c.ROLE_ID;

-- Query that returns User, Role assignment and Security Roles
SELECT
a.USERNAME,
c.ROLE_COMMON_NAME,
c.ROLE_DISTINGUISHED_NAME,
b.CREATION_DATE,
b.CREATED_BY,
b.LAST_UPDATE_DATE
b.last_updated_by
d.*
FROM fusion.PER_USERS a,
fusion.PER_USER_ROLES b,
fusion.PER_ROLES_DN_VL c,
fusion.FUN_USER_ROLE_DATA_ASGNMNTS d
WHERE a.USER_ID = b.USER_ID
AND b.ROLE_ID = c.ROLE_ID
and d.USER_GUID=a.user_guid
and d.ROLE_NAME=c.ROLE_COMMON_NAME



