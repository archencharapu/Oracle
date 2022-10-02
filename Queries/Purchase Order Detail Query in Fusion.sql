-- Purchase Order Detail Query in Fusion
--https://oraclebytes.com/purchase-order-detail-query-in-fusion/

/***************
1. PO_HEADERS_ALL –> To store the Purchase Order header info.
2. PO_LINES_ALL –> Captures the line level details
3. PO_LINE_LOCATIONS_ALL –> To keep the shipment related details
4. PO_DISTRIBUTIONS_ALL –> Mainly to keep the account related info
****************/

SELECT iop.organization_code,
po_hdr.segment1 po_number,
po_hdr.comments ,
hp.party_name supplier,
pvsa.vendor_site_code supplier_site,
po_hdr.document_status order_status,
po_hdr.CREATION_DATE order_creation_date,
po_hdr.revision_num,
po_line.line_num,
esib.item_number,
ESIB.ITEM_TYPE,
(SELECT SEGMENT1 || ‘.’ ||
SEGMENT2 || ‘.’ ||
SEGMENT3 || ‘.’ ||
SEGMENT4 || ‘.’ ||
SEGMENT5 || ‘.’ ||
SEGMENT6 || ‘.’ ||
SEGMENT7
FROM Gl_CODE_COMBINATIONS gcc,
PO_DISTRIBUTIONS_ALL pda
WHERE 1 = 1
and pda.po_line_id = po_line.po_line_id
and gcc.CODE_COMBINATION_ID = pda.CODE_COMBINATION_ID
and rownum = 1) INV_EXP_DEFATUL_ACCT,
(SELECT SEGMENT1 || ‘.’ ||
SEGMENT2 || ‘.’ ||
SEGMENT3 || ‘.’ ||
SEGMENT4 || ‘.’ ||
SEGMENT5 || ‘.’ ||
SEGMENT6 || ‘.’ ||
SEGMENT7
FROM Gl_CODE_COMBINATIONS gcc,
PO_DISTRIBUTIONS_ALL pda
WHERE 1 = 1
and pda.po_line_id = po_line.po_line_id
and gcc.CODE_COMBINATION_ID = pda.ACCRUAL_ACCOUNT_ID
and rownum = 1) ACCRUAL_DEFAULT_ACCT,
(SELECT SEGMENT1 || ‘.’ ||
SEGMENT2 || ‘.’ ||
SEGMENT3 || ‘.’ ||
SEGMENT4 || ‘.’ ||
SEGMENT5 || ‘.’ ||
SEGMENT6 || ‘.’ ||
SEGMENT7
FROM Gl_CODE_COMBINATIONS gcc,
PO_DISTRIBUTIONS_ALL pda
WHERE 1 = 1
and pda.po_line_id = po_line.po_line_id
and gcc.CODE_COMBINATION_ID = pda.VARIANCE_ACCOUNT_ID
and rownum = 1) VARIANCE_DEFAULT_ACCT,
po_line.item_description,
po_line.quantity order_qty,
po_line.unit_price,
line_loc.requested_ship_date,
line_loc.need_by_date,
po_line.line_status,
po_hdr.agent_id buyer_id,
(select ppf.full_name
from per_person_names_f ppf
where ppf.person_name_id = po_hdr.agent_id
and TRUNC(SYSDATE) BETWEEN trunc(ppf.effective_start_date)
AND trunc(ppf.effective_end_date) and rownum=1) buyer,
rsh.SHIPMENT_NUM SHIPMENT_NUM,
rsh.receipt_num receipt_number,
rsl.quantity_received quantity_received,
rsl.quantity_delivered quantity_delivered, rsl.quantity_shipped quantity_shipped,
rsh.creation_date receipt_date,
po_hdr.created_by,
line_loc.destination_type_code destination_type,
line_loc.sales_order_number customer_sales_order,
(SELECT prha.requisition_number
FROM por_req_distributions_all prda
,por_requisition_lines_all prla
,por_requisition_headers_all prha
,po_distributions_all pda
WHERE prda.requisition_line_id = prla.requisition_line_id
AND prla.requisition_header_id = prha.requisition_header_id
AND prda.distribution_id = pda.req_distribution_id
AND pda.line_location_id = line_loc.line_location_id
AND rownum = 1) requisition,
rsl.shipment_line_status_code shipment_status_code
FROM po_headers_all po_hdr,
poz_suppliers pv,
hz_parties hp,
poz_supplier_sites_all_m pvsa,
po_lines_all po_line,
po_line_locations_all line_loc,
egp_system_items_b esib,
inv_org_parameters iop,
rcv_shipment_headers rsh,
rcv_shipment_lines rsl,
hr_operating_units hou
WHERE po_hdr.po_header_id = po_line.po_header_id
AND pv.vendor_id = po_hdr.vendor_id
AND pv.party_id = hp.party_id
AND pvsa.vendor_site_id = po_hdr.vendor_site_id
AND po_line.po_line_id = line_loc.po_line_id
AND po_line.item_id = esib.inventory_item_id
AND line_loc.ship_to_organization_id = esib.organization_id
AND iop.organization_id = line_loc.ship_to_organization_id
AND esib.organization_id = iop.organization_id
AND rsh.shipment_header_id(+) = rsl.shipment_header_id
AND line_loc.po_line_id = rsl.po_line_id(+)
AND line_loc.po_header_id = rsl.po_header_id(+)
AND rsl.po_line_location_id = line_loc.line_location_id
AND rsl.source_document_code = ‘PO’
AND hou.organization_id = po_hdr.PRC_BU_ID
;




-- https://rpforacle.blogspot.com/2020/07/query-to-get-po-details-in-oracle-fusion.html
SELECT DISTINCT
POHA.SEGMENT1,
HP.PARTY_NAME as VENDOR_NAME,
HPS.PARTY_SITE_NAME,
PSS.VENDOR_SITE_CODE,
APT.NAME,
PPNF.LAST_NAME||', '||PPNF.FIRST_NAME "Buyer Name",
POHA.DOCUMENT_STATUS,
PSS.VENDOR_SITE_CODE,
HAOT.NAME as Procurement_BU,
XEP.NAME as SOLDTO_LE_ID,
HRLA1.LOCATION_NAME as BILL_TO_LOCATION_ID,
HRLA.LOCATION_NAME as SHIP_TO_LOCATION_ID
FROM
PO_HEADERS_ALL POHA,
HR_ORGANIZATION_UNITS_F_TL HAOT,
XLE_ENTITY_PROFILES XEP,
HR_LOCATIONS_ALL HRLA,
HR_LOCATIONS_ALL HRLA1,
POZ_SUPPLIERS PS,
HZ_PARTIES HP,
HZ_PARTY_SITES HPS,
AP_TERMS_TL APT,
PER_PERSON_NAMES_F PPNF,
POZ_SUPPLIER_SITES_ALL_M PSS
WHERE HAOT.ORGANIZATION_ID = POHA.BILLTO_BU_ID
AND HAOT.ORGANIZATION_ID = POHA.PRC_BU_ID
AND HAOT.ORGANIZATION_ID = POHA.REQ_BU_ID
AND XEP.LEGAL_ENTITY_ID = POHA.SOLDTO_LE_ID
AND HRLA.LOCATION_ID=POHA.SHIP_TO_LOCATION_ID
AND HRLA1.LOCATION_ID=POHA.BILL_TO_LOCATION_ID
AND PS.VENDOR_ID=POHA.VENDOR_ID
AND PS.PARTY_ID=HP.PARTY_ID
AND HP.PARTY_ID=HPS.PARTY_ID
AND APT.TERM_ID=POHA.TERMS_ID
AND PPNF.PERSON_ID=POHA.AGENT_ID
AND PSS.VENDOR_SITE_ID=POHA.VENDOR_SITE_ID
ORDER BY POHA.SEGMENT1
