select egp.item_number
, sum(ioq.primary_transaction_quantity) primary_transaction_quantity
from INV_ONHAND_QUANTITIES_DETAIL ioq
, EGP_SYSTEM_ITEMS_B egp
where 1=1
-- and egp.item_number = '183304'
and egp.organization_id = 300000002316706  -- ITMO
and egp.inventory_item_id = ioq.inventory_item_id
group by egp.item_number
having sum(ioq.primary_transaction_quantity) = 0