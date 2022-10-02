SELECT
  POH.SEGMENT1 PO_NUM,
  POH.DOCUMENT_STATUS STATUS,
  NVL(POH.ATTRIBUTE8, 'Mercury') SOURCE,
  POL.LINE_NUM,
  ITM.ITEM_NUMBER,
  POL.ATTRIBUTE4 Exception,
  PLL.QUANTITY ORIG_QTY,
  PLL.QUANTITY_RECEIVED,
  CASE
      WHEN (PLL.QUANTITY - NVL(PLL.QUANTITY_RECEIVED, 0)) < 0
      THEN 0
      ELSE (PLL.QUANTITY - NVL(PLL.QUANTITY_RECEIVED, 0))
  END REMAINING_QTY_TO_RCV,
  POL.UOM_CODE,
  NULL EXC_LINE_NUM,
  POL.UNIT_PRICE,
  POL.creation_date,
  POL.last_update_date,
  PLL.creation_date loc_creation_dt
FROM
  EGP_SYSTEM_ITEMS ITM,
  PO_HEADERS_ALL POH,
  PO_LINE_LOCATIONS_ALL PLL,
  PO_LINES_ALL POL
WHERE 1=1
  --POL.ATTRIBUTE4 IS NULL
  AND POL.LINE_STATUS != 'CANCELED'
  AND PLL.PO_LINE_ID = POL.PO_LINE_ID
  AND NVL(POH.ATTRIBUTE8, 'Mercury') != 'NAV'
  AND POH.PO_HEADER_ID = POL.PO_HEADER_ID
  AND ITM.ORGANIZATION_ID = 300000002316706
  AND ITM.INVENTORY_ITEM_ID = POL.ITEM_ID
  and POL.UOM_CODE != 'EA'
  and PLL.QUANTITY_RECEIVED = 0
  and poh.creation_date > sysdate-7
  and  POH.SEGMENT1 = 'RS2329633' -- CRP113589 -- RX1-122-05 -- RS2667397 -- 202250
  and ITM.ITEM_NUMBER in ('181604');