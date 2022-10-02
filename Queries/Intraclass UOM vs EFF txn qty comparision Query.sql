select 
egp.item_number,iop.organization_code, ioq.date_received mtl_date_received
, eff.creation_date eff_creation_date
, iumt.unit_of_measure transaction_uom
, sum(ioq.transaction_quantity) transaction_quantity
, DECODE(ioq.transaction_uom_code, 'EA', 1, uom.conversion_rate)  uom_conv_rate
, sum(ioq.primary_transaction_quantity) uom_primary_transaction_quantity
, eff.attribute_number1 eff_conv_rate
, sum(ioq.transaction_quantity)*eff.attribute_number1 eff_primary_transaction_quantity
, sum(ioq.primary_transaction_quantity) - sum(ioq.transaction_quantity)*eff.attribute_number1 uom_to_eff_diff
from inv_onhand_quantities_detail ioq
, egp_system_items_b egp
, inv_org_parameters iop
, inv_units_of_measure_b iumb
, inv_units_of_measure_tl iumt
, inv_uom_conversions uom
, ego_item_eff_b eff
where 1=1
-- and egp.item_number = '183304'
and egp.organization_id = 300000002316706  -- itmo
and egp.inventory_item_id = ioq.inventory_item_id
and iop.organization_id = ioq.organization_id 
and ioq.transaction_uom_code = iumb.uom_code
and iumb.unit_of_measure_id = iumt.unit_of_measure_id
and ioq.inventory_item_id = uom.inventory_item_id
and ioq.transaction_uom_code = uom.uom_code
and ioq.inventory_item_id = eff.inventory_item_id
and ioq.inventory_item_id = eff.inventory_item_id
and ioq.transaction_uom_code = eff.attribute_char1
and eff.context_code = 'UOM_Conversion_Rate'
and ioq.date_received >= eff.creation_date
group by egp.item_number, ioq.transaction_uom_code, ioq.date_received, iumt.unit_of_measure, iop.organization_code, uom.conversion_rate, eff.attribute_number1, eff.creation_date
order by egp.item_number, ioq.transaction_uom_code, iop.organization_code;
