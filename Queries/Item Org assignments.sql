select egp.item_number, mp.organization_code from EGP_SYSTEM_ITEMS_B egp
, INV_ORG_PARAMETERS MP
where 1=1
and egp.organization_id = mp.organization_id
and mp.organization_code = 'RNO1'
and egp.item_number in (
'230365'
)