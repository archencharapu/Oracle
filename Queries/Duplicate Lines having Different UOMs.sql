SELECT
  SUP.VENDOR_SITE_CODE,
  ITM.ITEM_NUMBER ITEM_CODE,
  ITM.INVENTORY_ITEM_STATUS_CODE,
  POH.Segment1 BPA_NUM,
  POL.LINE_NUM BPA_LINE_NUM,
  POL.UOM_CODE,
  POL.EXPIRATION_DATE,
  POL.LAST_UPDATE_DATE,
  POL.LAST_UPDATED_BY
  FROM
  INV_ORG_PARAMETERS ORG,
  EGP_SYSTEM_ITEMS ITM,
  POZ_SUPPLIER_SITES_ALL_X SUP,
  PO_LINES_ALL POL,
  PO_HEADERS_ALL POH,
  EGP_ITEM_CLASSES_B CLS
   WHERE
ITM.INVENTORY_ITEM_STATUS_CODE ='Active'
 AND  POL.PO_HEADER_ID = POH.PO_HEADER_ID
  AND SUP.VENDOR_SITE_ID = POH.VENDOR_SITE_ID
  AND ITM.INVENTORY_ITEM_ID = POL.ITEM_ID
  AND ORG.ORGANIZATION_ID = ITM.ORGANIZATION_ID
  AND POH.TYPE_LOOKUP_CODE = 'BLANKET'
  AND POH.DOCUMENT_STATUS = 'OPEN'
  AND ORG.ORGANIZATION_CODE = 'ITM0'
  AND POL.LAST_UPDATE_DATE >= '2019-07-08'
  AND POL.ITEM_ID IS NOT NULL
  AND NVL(POL.EXPIRATION_DATE, SYSDATE+1) > SYSDATE
  AND POL.LINE_STATUS != 'CANCELED'
  AND CLS.ITEM_CLASS_CODE = 'Retail'
  AND CLS.ITEM_CLASS_ID = ITM.ITEM_CATALOG_GROUP_ID
 AND (POH.PO_HEADER_ID, ITM.INVENTORY_ITEM_ID) in (SELECT
                                      POH.PO_HEADER_ID, ITM.INVENTORY_ITEM_ID
                                     -- POH.SEGMENT1, ITM.ITEM_NUMBER
                                      FROM
                                      INV_ORG_PARAMETERS ORG,
                                      EGP_SYSTEM_ITEMS ITM,
                                      PO_LINES_ALL POL,
                                      PO_HEADERS_ALL POH,
                                      EGP_ITEM_CLASSES_B CLS
                                       WHERE 1=1
                                      AND ITM.INVENTORY_ITEM_STATUS_CODE ='Active'
                                      AND POL.PO_HEADER_ID = POH.PO_HEADER_ID
                                      AND ITM.INVENTORY_ITEM_ID = POL.ITEM_ID
                                      AND ORG.ORGANIZATION_ID = ITM.ORGANIZATION_ID
                                      AND POH.TYPE_LOOKUP_CODE = 'BLANKET'
                                      AND POH.DOCUMENT_STATUS = 'OPEN'
                                      AND ORG.ORGANIZATION_CODE = 'ITM0'
                                      AND POL.LAST_UPDATE_DATE >= '2019-07-08'
                                      AND NVL(POL.EXPIRATION_DATE, SYSDATE+1) > SYSDATE
                                      AND POL.LINE_STATUS != 'CANCELED'
                                      AND CLS.ITEM_CLASS_CODE = 'Retail'
                                    -- AND ITM.ITEM_NUMBER IN ('237660','230672')
                                      AND CLS.ITEM_CLASS_ID = ITM.ITEM_CATALOG_GROUP_ID
                                      GROUP BY POH.PO_HEADER_ID, ITM.INVENTORY_ITEM_ID
                                      HAVING   count(DISTINCT POL.UOM_CODE) > 1)
order by POH.segment1 ,ITM.item_number,POL.UOM_CODE