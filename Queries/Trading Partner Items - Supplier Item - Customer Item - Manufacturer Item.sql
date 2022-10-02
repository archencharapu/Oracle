select distinct c.trading_partner_id, b.inventory_item_id, b.item_number, c.tp_item_number supplier_item
from egp_item_relationships_b a
,egp_system_items_b b
,EGP_TRADING_PARTNER_ITEMS c
where a.inventory_item_id = b.inventory_item_id
and a.tp_item_id = c.tp_item_id
and b.inventory_item_id = 100000009887100



SELECT PartyPEO.PARTY_ID,
PartyPEO.PARTY_NAME TRADING_PARTNER_NAME,
PartyUsageAssignmentPEO.PARTY_USAGE_CODE,
PartyUsageAssignmentPEO.PARTY_USG_ASSIGNMENT_ID,
PartyPEO.PARTY_NUMBER
FROM HZ_PARTIES PartyPEO, HZ_PARTY_USG_ASSIGNMENTS PartyUsageAssignmentPEO
WHERE PartyPEO.PARTY_ID = PartyUsageAssignmentPEO.PARTY_ID AND PartyUsageAssignmentPEO.STATUS_FLAG = 'A' and PartyUsageAssignmentPEO.PARTY_USAGE_CODE in('CUSTOMER','MANUFACTURER', 'SUPPLIER')
and PartyPEO.PARTY_ID IN
(
select distinct c.trading_partner_id--CUSTOMER_ITEM_XREF, MFG_PART_NUM, SUPPLIER_ITEM_XREF
from egp_item_relationships_b a
,egp_system_items_b b
,EGP_TRADING_PARTNER_ITEMS c
where a.inventory_item_id = b.inventory_item_id
and a.tp_item_id = c.tp_item_id
and b.inventory_item_id = 100000009887100
);

