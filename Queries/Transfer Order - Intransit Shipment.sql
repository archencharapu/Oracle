select imt.shipment_number transfer_order, imt.creation_date, esi.item_number, imt.transaction_quantity, imt.transaction_uom, mp_from.organization_code from_org_code, imt.subinventory_code
, mp_to.organization_code to_org_code, imt.transfer_subinventory, imt.primary_quantity, imt.transaction_date
from inv_material_txns imt
    ,egp_system_items esi
    ,inv_org_parameters mp_from
    ,inv_org_parameters mp_to
where 1=1
and imt.transaction_type_id = 21 -- intransit shipment
and imt.shipment_number = 'TR40000419'
and imt.creation_date > sysdate-1
and esi.inventory_item_id = imt.inventory_item_id
and esi.organization_id = 300000002316706  -- itmo
and imt.organization_id = mp_from.organization_id
and imt.transfer_organization_id = mp_to.organization_id
order by 1,2 desc