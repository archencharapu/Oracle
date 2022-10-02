/******************************************************************* 
 *PURPOSE: SQL Query to find Oracle Fusion Instance name           *
 *AUTHOR: Shailender Thallam 				           *
 *******************************************************************/
SELECT
        external_virtual_host,
        SUBSTR (external_virtual_host, 1,instr(external_virtual_host,'.') -1)
FROM
        fusion.ask_deployed_domains ad
WHERE
        ad.deployed_domain_name='FADomain'