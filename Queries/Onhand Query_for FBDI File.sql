select 
egp.item_number,
egp.inventory_item_status_code,
sum(ioq.primary_transaction_quantity) primary_transaction_quantity
, egp.primary_uom_code
, hou.name
from INV_ONHAND_QUANTITIES_DETAIL ioq
, EGP_SYSTEM_ITEMS_B egp
, HR_ALL_ORGANIZATION_UNITS hou
where 1=1
and egp.item_number in (
'67529',
'67525',
'67521',
'67461',
'67935',
'67888',
'67514',
'67506',
'67510',
'67490',
'67483',
'67479'
)
and egp.organization_id = 300000002316706  -- ITMO
and egp.inventory_item_id = ioq.inventory_item_id
and hou.organization_id = ioq.organization_id 
--and ioq.transaction_uom_code = iumb.uom_code
--and iumb.unit_of_measure_id = iumt.unit_of_measure_id
group by egp.item_number, hou.name, egp.primary_uom_code, egp.inventory_item_status_code
order by egp.item_number, egp.primary_uom_code, hou.name;