select 
egp.item_number,
sum(ioq.primary_transaction_quantity) primary_transaction_quantity
, ioq.transaction_uom_code
, iumt.unit_of_measure, sum(ioq.transaction_quantity) transaction_quantity, iop.organization_code
from INV_ONHAND_QUANTITIES_DETAIL ioq
, EGP_SYSTEM_ITEMS_B egp
, INV_ORG_PARAMETERS iop
, INV_UNITS_OF_MEASURE_B iumb
, INV_UNITS_OF_MEASURE_TL iumt
where 1=1
and egp.item_number = '183304'
and egp.organization_id = 300000002316706  -- ITMO
and egp.inventory_item_id = ioq.inventory_item_id
and iop.organization_id = ioq.organization_id 
and ioq.transaction_uom_code = iumb.uom_code
and iumb.unit_of_measure_id = iumt.unit_of_measure_id
group by egp.item_number, ioq.transaction_uom_code, iumt.unit_of_measure, iop.organization_code
order by egp.item_number, ioq.transaction_uom_code, iop.organization_code;





select * from inv_org_parameters
where 1=1
--and organization_code = 'CFC1'
and organization_id in (300000002316814);
