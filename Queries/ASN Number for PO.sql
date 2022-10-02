/**
-- 	Information About Advance Shipment Notices (ASN) Functionality (Doc ID 601787.1)

For a successfully processed ASN, RTP populates the RCV_SHIPMENT_HEADERS (RSH) table with the ASN header information 
and the RCV_SHIPMENT_LINES(RSL) table for each shipment line in the ASN. The following fields are populated to 
indicate that the shipment is an ASN.
RSH.ASN_TYPE = ASN (or ASBN)
RSL.ASN_LINE_FLAG = Y
**/

SELECT
    ph.segment1 po_number,
    esib.item_number,
    pl.line_num po_line,
    pl.po_line_id,
    pl.created_by,
    pl.creation_date,
    pl.quantity line_qty,
    rt.quantity rec_qty,
    rt.transaction_type,
    rsh.receipt_num,
    rsl.line_num receipt_line,
    rsh.shipment_num ASN_NUM,
    rsl.ASN_LINE_FLAG,
    RSH.ASN_TYPE,
    pl.line_status
FROM
    rcv_transactions rt,
    rcv_shipment_headers rsh,
    rcv_shipment_lines rsl,
    PO_HEADERS_ALL ph,
    PO_LINES_ALL PL,
    egp_system_items_b esib,
    inv_org_parameters io,
    HR_ORGANIZATION_UNITS_F_TL HU
WHERE
    1=1
    --and rt.po_header_id = 300001344836567
AND rt.shipment_header_id = rsh.shipment_header_id
AND rt.shipment_line_id = rsl.shipment_line_id
AND rsh.shipment_header_id = rsl.shipment_header_id
AND rt.po_header_id = ph.po_header_id
AND ph.po_header_id = pl.po_header_id
AND rt.po_line_id = pl.po_line_id
AND pl.item_id = esib.inventory_item_id
AND esib.organization_id = 300000002316706
AND ph.segment1 = 'DS1026054611-1'
AND rt.organization_id = io.organization_id
AND ph.prc_bu_id = HU.organization_id
AND rt.transaction_type in ('RECEIVE', 'CORRECT')
ORDER BY
    po_number,
    item_number ;
