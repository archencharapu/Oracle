SELECT DISTINCT
    poh.segment1                                    "PO Number",
--pol.LINE_TYPE_ID,
    pol.line_num                                    "PO Line Number",
    to_char(poh.approved_date, 'mm/dd/yyyy')        "PO Approval Date",
    inv.invoice_num                                 "Invoice Number",
    inv.line_number                                 "Invoice Line number",
    inv.inv_status                                  "Invoice Validation Status",
	to_char(inv.invoice_date, 'mm/dd/yyyy')         "Invoice Date",
    inv.invoice_due_date                            "Invoice Due Date",
	    (
        SELECT
            MAX(to_char(ah.hold_date, 'mm/dd/yyyy'))
        FROM
            ap_holds_all ah
        WHERE
                1 = 1
            AND ah.line_location_id = pll.line_location_id
            AND ah.invoice_id = inv.invoice_id
			AND (:p_hold_name IS NULL OR ah.hold_lookup_code = :p_hold_name)
    )                                               "Hold Date",
    (
        SELECT
            displayed_field
        FROM
            ap_lookup_codes  alc,
            ap_holds_all     ah
        WHERE
                alc.lookup_code = ah.hold_lookup_code
            AND ah.line_location_id = pll.line_location_id
            AND ah.invoice_id = inv.invoice_id
			AND (:p_hold_name IS NULL OR ah.hold_lookup_code = :p_hold_name)
            AND ROWNUM = 1
    )                                               "Hold Name",  
    nvl(pol.unit_price ,pol.list_price)                                "PO Line Unit Price",	
    pol.uom_code                                    "PO Line UOM",    
    inv.unit_price                                  "Invoice Line Unit Price",
    pda.QUANTITY_ORDERED    "Ordered Quantity",
    pll.quantity_received                           "Received Quantity",
	inv.QUANTITY_INVOICED                             "Invoiced Quantity",
    (
        CASE
            WHEN pll.quantity_received > pda.quantity_ordered THEN
                'Y'
            ELSE
                'N'
        END
    )                                               "Over Receipt Flag",
    
    nvl((select round(sum(pla.quantity* pla.unit_price ),2) 
	 from po_headers_all pha,po_lines_all pla 
	 where pha.po_header_id=pla.po_header_id
         and pha.po_header_id=poh.po_header_id),pol.amount) "Total PO Amount", 
case when pol.LINE_TYPE_ID=6 then 
(select sum(decode(ail.match_type, 'ITEM_TO_PO', ail.amount, 'ITEM_TO_SERVICE_PO', ail.amount,0))  amount
from ap_invoice_lines_all ail where inv.invoice_id=ail.invoice_id)
else		 
    (NVL(inv.QUANTITY_INVOICED,0) * NVL(inv.unit_price,0) )  end                           "Total Invoice Amount",
 /*	case when pol.LINE_TYPE_ID=6 then 
	(pll.AMOUNT_RECEIVED-pda.AMOUNT_BILLED)
else	
	 ( nvl(inv.quantity_invoiced, 0) - (
        SELECT
            nvl(SUM(rt.quantity), 0)
        FROM
            rcv_transactions      rt,
            rcv_shipment_headers  rsh,
            rcv_shipment_lines    rsl
        WHERE
                rsh.shipment_header_id = rt.shipment_header_id
            AND rsl.shipment_header_id = rsh.shipment_header_id
            AND rsl.po_header_id = rt.po_header_id
            AND rsl.po_line_id = rt.po_line_id
            AND rsl.po_line_location_id = rt.po_line_location_id
            AND rsl.po_header_id = pll.po_header_id
            AND rsl.po_line_id = pll.po_line_id
            AND rsl.po_line_location_id = pll.line_location_id
            AND rt.transaction_type = 'RECEIVE'
    ) ) * pol.unit_price     end                        "Open Ordered Amount", */
	inv.matched_amount                              "Matched Amount",
    (
        CASE
            WHEN pll.receipt_required_flag = 'N' THEN
                '2 Way'
            WHEN pll.receipt_required_flag = 'Y'
                 AND pll.inspection_required_flag = 'N' THEN
                '3 Way'
            WHEN pll.receipt_required_flag = 'Y'
                 AND pll.inspection_required_flag = 'Y' THEN
                '4 Way'
        END
    )                                               "Match Approval Level",
    poh.document_status                             "PO Header Status",
    pol.line_status                                 "PO Line Status",
    (
        SELECT
            ppl.full_name
        FROM
            per_person_names_f ppl
        WHERE
                ppl.person_id = poh.agent_id
            AND ROWNUM = 1
    )                                               "Buyer",
    --poh.attribute9                                  "CAR",
(
        SELECT
            prha.attribute9
        FROM
            por_req_distributions_all    prda,
            por_requisition_lines_all    prla,
            por_requisition_headers_all  prha
        WHERE
                pda.req_distribution_id = prda.distribution_id
            AND prda.requisition_line_id = prla.requisition_line_id
            AND prla.requisition_header_id = prha.requisition_header_id
            AND ROWNUM = 1 )                      "CAR",
    (
        SELECT
            fvv.description
        FROM
            fnd_vs_value_sets  fvs,
            fnd_vs_values_vl   fvv
        WHERE
                fvs.value_set_code = 'CHW_CAR_NUMBER'
            AND fvs.value_set_id = fvv.value_set_id
            AND fvv.value = poh.attribute9
            AND ROWNUM = 1
    )                                               "CAR Description",
    psv.vendor_name                                 "Supplier Name",
    (
        SELECT
            ppl.full_name
        FROM
            por_req_distributions_all    prda,
            por_requisition_lines_all    prla,
            per_person_names_f           ppl,
            por_requisition_headers_all  prha
        WHERE
                pda.req_distribution_id = prda.distribution_id
            AND prda.requisition_line_id = prla.requisition_line_id
            AND prla.requisition_header_id = prha.requisition_header_id
            AND ppl.person_id = prla.requester_id
            AND ROWNUM = 1
    )                                               "Requestor",
    (
        SELECT
            prha.requisition_number
        FROM
            por_req_distributions_all    prda,
            por_requisition_lines_all    prla,
            por_requisition_headers_all  prha
        WHERE 
                pda.req_distribution_id = prda.distribution_id
            AND prda.requisition_line_id = prla.requisition_line_id
            AND prla.requisition_header_id = prha.requisition_header_id
            AND ROWNUM = 1
    )                                               "Requisition Number",
    ( gcc.segment1
      || '.'
      || gcc.segment2
      || '.'
      || gcc.segment3
      || '.'
      || gcc.segment4
      || '.'
      || gcc.segment5
      || '.'
      || gcc.segment6
      || '.'
      || gcc.segment7 )                               "PO Line Charge Account",
    fa.asset_number                                 "Asset Number",
    fa.category                                     "Asset Category",
    fa.description                                  "Asset Description",
    (
        SELECT
            location_code
        FROM
            hr_locations_all hl
        WHERE
                hl.location_id = pll.ship_to_location_id
            AND ROWNUM = 1
    )                                               "Ship-to Location",
    (
        SELECT
            category_name
        FROM
            egp_categories_vl
        WHERE
                category_id = pol.category_id
            AND ROWNUM = 1
    )                                               "Category Name",
    pol.vendor_product_num                          "Supplier Item",
    pol.item_description                            "Item Description",
    (
        SELECT
            name
        FROM
            ap_terms_vl
        WHERE
                term_id = inv.terms_id
            AND nvl(end_date_active, sysdate + 1) > sysdate
            AND ROWNUM = 1
    )                                               "Payment Terms",
    inv.paymentdate                                 "Payment Date",
    inv.paymentamount                               "Payment Amount",
   /* (
        SELECT
            prha.justification
        FROM
            por_req_distributions_all    prda,
            por_requisition_lines_all    prla,
            por_requisition_headers_all  prha
        WHERE
                pda.req_distribution_id = prda.distribution_id
            AND prda.requisition_line_id = prla.requisition_line_id
            AND prla.requisition_header_id = prha.requisition_header_id
            AND ROWNUM = 1
    )                                               "Requisition Justification",*/
	(nvl(pol.unit_price ,pol.list_price)) *  (nvl(pol.quantity,1)) "Po Line Amount",
	--(pol.unit_price * nvl(pol.quantity,0)) "Po Line Amount",
	case when pol.LINE_TYPE_ID=6 then 
	inv.amount
    else null end 	"Invoice Line Amount",
	case when pol.LINE_TYPE_ID=6 then 
	pda.AMOUNT_BILLED
    else null end 	"Amount Billed",
	case when pol.LINE_TYPE_ID=6 then 
	pll.AMOUNT_RECEIVED
    else null end 	"Amount Received",
	case when pol.LINE_TYPE_ID=6 then 
	pda.amount_ordered
    else null end	"Amount Ordered",
	inv.invoicepaidstatus                           "Invoice Paid Status",
to_char(poh.CREATION_DATE, 'mm/dd/yyyy')        "PO Creation Date",--ERP-1889
poh.attribute9                                  "PO CAR Number"--ERP-1885

FROM
    poz_suppliers_v        psv,
    po_headers_all         poh,
    po_lines_all           pol,
    po_line_locations_all  pll,
    po_distributions_all   pda,
    gl_code_combinations   gcc,
    (
        SELECT 
            aia.invoice_id,
            aia.invoice_num,
            ail.line_number,
			decode(ap_invoices_pkg.get_approval_status(aia.invoice_id, aia.invoice_amount, aia.payment_status_flag, aia.invoice_type_lookup_code),
                   'NEVER APPROVED',
                   'Never Validated',
                   'NEEDS REAPPROVAL',
                   'Needs Revalidation',
                   'CANCELLED',
                   'Cancelled',
                   'Validated')                  inv_status,
            aia.invoice_date,
            (
                SELECT
                    MAX(to_char(due_date, 'mm/dd/yyyy')) due_date -- Added 04022021Das
                FROM
                    ap_payment_schedules_all apsa
                WHERE apsa.invoice_id = aia.invoice_id
                      --and      apsa.payment_num=ail.line_number -- Added 04022021Das
            )                                    invoice_due_date,
            decode(ail.match_type, 'ITEM_TO_PO', ail.amount, 'ITEM_TO_SERVICE_PO', ail.amount,
                   0)                            matched_amount,
            nvl(ail.quantity_invoiced, 0)        quantity_invoiced,
            aia.invoice_amount,
            ail.unit_price,
            decode(aia.payment_status_flag, 'Y', 'Paid', 'N', 'Unpaid',
                   'P', 'Partially Paid')        invoicepaidstatus,
            (
                SELECT
                    to_char(MIN(creation_date), 'mm/dd/yyyy')
                FROM
                    ap_invoice_payments_all
                WHERE
                    invoice_id = aia.invoice_id
            )                                    paymentdate,
            (
                SELECT
                    amount_header
                FROM
                    (
                        SELECT
                            amount amount_header
                        FROM
                            ap_invoice_payments_all
                        WHERE
                                1 = 1
                            AND invoice_id = aia.invoice_id
                        ORDER BY
                            invoice_payment_id
                    )
                WHERE
                    ROWNUM = 1
            )                                    paymentamount,
            aid.po_distribution_id,
            aia.terms_id,
			ail.amount
        FROM
            ap_invoices_all               aia,
            ap_invoice_lines_all          ail,
            ap_invoice_distributions_all  aid
        WHERE
                aia.invoice_id = ail.invoice_id
            AND ail.invoice_id = aid.invoice_id
            AND ail.line_number = aid.invoice_line_number
            AND aid.line_type_lookup_code = 'ITEM'
            --AND rownum=1            
AND ap_invoices_pkg.get_approval_status(aia.invoice_id, aia.invoice_amount, aia.payment_status_flag, aia.invoice_type_lookup_code) <> 'CANCELLED'
           -- AND nvl(ail.cancelled_flag, 'N') != 'Y'
    )                      inv,
    (
        SELECT
            fai.po_number,
            ( fcb.segment1
              || '.'
              || fcb.segment2 ) category,
            fav.description,
            fav.asset_number
        FROM
            fa_asset_invoices  fai,
            fa_additions_vl    fav,
            fa_categories_b    fcb
        WHERE
                fav.asset_id = fai.asset_id
            AND fav.asset_category_id = fcb.category_id
            AND fai.po_number IS NOT NULL
    )                      fa
WHERE
        psv.vendor_id = poh.vendor_id
    AND poh.po_header_id = pol.po_header_id
    AND pda.po_header_id = pol.po_header_id
    AND POH.agent_id != 300000739173505 --chewy dropship
    AND pda.po_line_id = pol.po_line_id
    AND pol.po_line_id = pll.po_line_id
    AND pda.line_location_id = pll.line_location_id
    AND pda.code_combination_id = gcc.code_combination_id (+)
    AND pll.destination_type_code != 'INVENTORY'
    AND pda.po_distribution_id = inv.po_distribution_id (+)
    AND poh.segment1 = fa.po_number (+)
	and poh.DOCUMENT_STATUS <>'CANCELED'
	and pol.LINE_STATUS <>'CANCELED'
  /*  AND ( :p_from_date IS NULL
          OR poh.approved_date BETWEEN :p_from_date AND :p_to_date )*/
    AND (:p_hold_name IS NULL
              OR EXISTS ( 
        SELECT
            1
        FROM
            ap_holds_all ah
        WHERE ah.hold_lookup_code = :p_hold_name 
            AND ah.line_location_id = pll.line_location_id
            AND ah.invoice_id = inv.invoice_id
        ))
----and poh.segment1 IN ('CRP101859')
---and pol.line_type_id=6
order by poh.segment1,pol.line_num ASC