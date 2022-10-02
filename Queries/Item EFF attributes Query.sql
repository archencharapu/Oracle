-- Item EFF attributes Query
-- How to query Inherited EFF attributes to create a report? (Doc ID 2174084.1)
SELECT item.inventory_item_id as inventory_item_id,
  item.organization_id as organization_id
  FROM EGP_SYSTEM_ITEMS_B item,
  (SELECT itemeff.Inventory_Item_Id ,
  itemeff.Organization_Id,
  Context.C_Ext_Attribute1 style_sku_inherited,
  Context.C_Ext_Attribute2 master_child_inherited
  FROM Ego_Item_Eff_b itemeff,
  Fnd_Ef_Context_Usages Context
  WHERE context.context_code =itemeff.CONTEXT_CODE
  AND Context.DESCRIPTIVE_FLEXFIELD_CODE = 'EGO_ITEM_EFF'
  AND context.application_id = 10010
  AND context.flexfield_usage_code = 'EGO_ITEM_DL'
  AND itemeff.ACD_TYPE = 'PROD'
  AND itemeff.CHANGE_LINE_ID = -1
  AND itemeff.VERSION_ID = -1
  AND (CONTEXT.C_Ext_Attribute1 ='I' OR
CONTEXT.C_Ext_Attribute2='I'))eff
  WHERE ( (eff.inventory_item_id = item.inventory_item_id AND
eff.master_child_inherited ='I')
  OR(eff.inventory_item_id = item.style_item_id AND
eff.style_sku_inherited ='I'
  AND item.style_item_id!=item.inventory_item_id AND
eff.organization_id = item.organization_id))
  AND (item.approval_status = 'A')
 