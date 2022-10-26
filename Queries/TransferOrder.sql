SELECT
  a.pick_slip_number ,
  b.source_header_number transfer_order_number,
  c.supply_order_number ,
  c.supply_order_reference_number
FROM
  INV_PICK_SLIP_NUMBERS a ,
  WSH_DELIVERY_DETAILS b ,
  DOS_SUPPLY_HEADERS c ,
  INV_TRANSFER_ORDER_HEADERS d,
  INV_TRANSFER_ORDER_LINES e
WHERE 1 =1
  AND a.PICK_SLIP_NUMBER = 3001
  AND a.pick_slip_batch_id = b.batch_id
  AND b.source_header_number = d.header_number
  AND d.header_id = e.header_id
  AND e.source_header_id = c.header_id
