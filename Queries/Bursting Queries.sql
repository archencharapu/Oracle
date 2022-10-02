/*=====================================================
	Delivery Channel: EMAIL
  =====================================================*/
SELECT trx_number  KEY, -- it must be same as split by column it should exist in xmloutput
       'XXNAME'  TEMPLATE,  -- template name (layout name, get this from catalog)
       :xdo_user_report_locale LOCALE, -- get this from xdo_user_report_locale or hard code it as 'en-us', 'en' etc.
       'PDF' OUTPUT_FORMAT,  -- PDF,XML,ETEXT,CSV,EXCEL,HTL,RTF,etc.
       'EMAIL' DEL_CHANNEL, -- EMAIL,FAX,FTP,FILE,SFTP,PRINT,WEBDAV
	   'AR INVOICE_'||trx_number OUTPUT_NAME, -- output file name
       'ravireddy2632@gmail.com'    parameter1,  -- To Email Address
       'ravireddy263@gmail.com'     parameter2,  -- CC email address
       'testmail@gmail.com'         parameter3,  -- From Email Address
       'Ar Invoice'|| trx_number    parameter4,  -- Subject
       'Please Find the attached Invoice.
          Thanks & Regards,
           XXabc Company'           parameter5,  -- Message body
       'true'                       parameter6,  -- Attachment value ('true' or 'false'). If your output format is PDF, you must set this parameter to "true" to attach the PDF to the e-mail.
       'donotreply@gmail.com'       parameter7  -- Reply-To
	   'ravireddy263@gmail.com'     parameter8,  -- BCC email address
	   -- (PARAMETER 9-10 are not used)
FROM (  
select 
distinct b.trx_number
from  ra_customer_trx_lines_all a,								
      ra_customer_trx_all b 							
where a.customer_trx_id= b.customer_trx_id
and   a.customer_trx_id in (1002,1))


/*=====================================================
	Delivery Channel: FILE - saves the file in local PC
  =====================================================*/
SELECT trx_number  KEY, -- it must be same as split by column it should exist in xmloutput
       'XXNAME'  TEMPLATE,  -- template name (layout name, get this from catalog)
       'en' LOCALE, -- get this from xdo_user_report_locale or hard code it as 'en-us', 'en' etc.
       'EXCEL' OUTPUT_FORMAT,  -- PDF,XML,ETEXT,CSV,EXCEL,HTL,RTF,etc.
       'FILE' DEL_CHANNEL, -- EMAIL,FAX,FTP,FILE,SFTP,PRINT,WEBDAV
       'C:\Aravind_Drive\BI Reports'    parameter1,  -- Directory
       'AR INVOICE_'||trx_number||'.xls'     parameter2  -- File Name
	   -- (PARAMETER 3-10 are not used)
FROM (  
select 
distinct b.trx_number
from  ra_customer_trx_lines_all a,								
      ra_customer_trx_all b 						||'.xls'	
where a.customer_trx_id= b.customer_trx_id
and   a.customer_trx_id in (1002,1))


/*=====================================================
	Delivery Channel: FTP
  =====================================================*/
SELECT trx_number  KEY, -- it must be same as split by column it should exist in xmloutput
       'XXNAME'  TEMPLATE,  -- template name (layout name, get this from catalog)
       'en' LOCALE, -- get this from xdo_user_report_locale or hard code it as 'en-us', 'en' etc.
       'EXCEL' OUTPUT_FORMAT,  -- PDF,XML,ETEXT,CSV,EXCEL,HTL,RTF,etc.
       'FTP' DEL_CHANNEL, -- EMAIL,FAX,FTP,FILE,SFTP,PRINT,WEBDAV
       'FulcrumSFTP'    parameter1,  -- Server name
       'user_not_needed'     parameter2,  -- Username, not needed if using the predefined SFTP server in XMLP
       'password_not_needed' parameter3,  -- Password, not needed if using the predefined SFTP server in XMLP
       '/BIP_Extracts/AUDIT_REPORTS/PO_HEADERS_ALL'    parameter4,  -- Remote Directory
       'PO_HEADERS_ALL_'||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24MISS')||'.xls' parameter5,  -- Remote File Name
       'true' parameter6  -- set this value to 'true' to enable Secure FTP
	   -- (PARAMETER 7-10 are not used)
FROM (  
select 
distinct b.trx_number
from  ra_customer_trx_lines_all a,								
      ra_customer_trx_all b 							
where a.customer_trx_id= b.customer_trx_id
and   a.customer_trx_id in (1002,1))