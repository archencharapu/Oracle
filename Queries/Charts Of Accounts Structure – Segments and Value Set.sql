/*****************************************************************************************************
 Every Business Unit has something called "Set of Books". 
 This Set Of Books is nothing but the parent of Charts Of Accounts. 
 Other children of Set of books are Currency & Calendar. 
 Now further, this Chart Of accounts is nothing but segmented structure in which 
	various accounts are stored & used for reporting etc. 	
 Generally companies in US use 7 or 8 segment structure but of course, 
	it is not the eternal truth and can change company to company.
*****************************************************************************************************/

select hou.name BU_NAME,
led.NAME Ledger_Name,
Str.STRUCTURE_CODE CHART_OF_ACCOUNTS_Name,
SegInSt.SEGMENT_CODE COA_SEGMENT_NAME,
vs.value_set_code,
vs.description value_set_desc
from hr_operating_units hou,
xla_gl_ledgers led ,
fnd_kf_structures_b Str,
fnd_kf_str_instances_b StrInSt,
fnd_kf_segment_instances SegInSt,
fnd_vs_value_sets vs
where 1=1
and led.ledger_id = hou.set_of_books_id
AND led.CHART_OF_ACCOUNTS_ID = Str.Structure_id
AND Str.KEY_FLEXFIELD_CODE = 'GL#'
AND Str.Structure_id = StrInSt.Structure_id
and SegInSt.Structure_inStance_id = StrInSt.Structure_inStance_id 
and vs.VALUE_SET_ID = SegInSt.VALUE_SET_ID;




select * from fnd_vs_value_sets
where 1=1
and value_set_code like '% CHEWY INC';


select flex_value, description from FND_FLEX_VALUES_VL
where 1=1
and flex_value_set_id = 59012;