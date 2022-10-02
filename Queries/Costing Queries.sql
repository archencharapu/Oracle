select csn.scenario_number, ccb.cost_book_code, CSC.* 
from CST_STD_COSTS CSC
   , CST_SCENARIOS CSN
   , CST_COST_BOOKS_B ccb
where 1=1 
and csc.inventory_item_id = 100000037315459 -- 'RX5-000-01'
and csc.total_cost = 31.56
and csc.scenario_id = csn.scenario_id
and csc.cost_book_id = ccb.cost_book_id
;


SELECT csn.scenario_number,
       esi.item_number,
       csc.total_cost "total unit cost",
       (SELECT cscd.unit_cost
		  FROM   cst_std_cost_details cscd,
				 cst_cost_elements_b cce
		  WHERE  1=1
		  AND    cscd.std_cost_id = csc.std_cost_id
		  AND    cce.cost_element_code = 'Direct Material'
		  AND    cscd.cost_element_id = cce.cost_element_id) direct_material_cost,
       (SELECT cscd.unit_cost
		  FROM   cst_std_cost_details cscd,
				 cst_cost_elements_b cce
		  WHERE  1=1
		  AND    cscd.std_cost_id = csc.std_cost_id
		  AND    cce.cost_element_code = 'Labor Cost'
		  AND    cscd.cost_element_id = cce.cost_element_id) labor_cost,
	   csc.effective_start_date,
       csc.effective_end_date
FROM   cst_std_costs csc ,
       cst_scenarios csn ,
       egp_system_items esi
WHERE  1=1
AND    esi.item_number = 'RX5-000-01'
AND    esi.organization_id = csc.inventory_org_id
AND    csc.inventory_item_id = esi.inventory_item_id
       --and csc.total_cost = 31.56
AND    csc.scenario_id = csn.scenario_id ;


select * from CST_ORGANIZATION_DEFINITIONS_V
where 1=1
and organization_id = 300000585186481
;

select * from HR_ALL_ORGANIZATION_UNITS_X
where 1=1
and organization_id = 300000585186481
;

select * from CST_STD_COSTS_V;

select * from EGP_SYSTEM_ITEMS_B
where 1=1
and item_number = 'RX5-000-01';
