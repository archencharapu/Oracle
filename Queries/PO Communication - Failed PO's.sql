SELECT
poh.segment1,
poh.po_header_id,
poa.creation_date,
poh.vendor_id,
poh.vendor_site_id,
poh.soldto_le_id,
poa.error_code,
poa.note
FROM
po_action_history poa,
po_headers_all poh
WHERE
poh.po_header_id = poa.object_id
AND poh.type_lookup_code='STANDARD'
AND error_code = 'PDF_GENERATION_FAILED'
AND poa.creation_date > poa.creation_date - 10
ORDER BY
poa.creation_date desc