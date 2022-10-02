-- Query
select iumb.uom_code, iumt.unit_of_measure from inv_units_of_measure_b iumb,
inv_units_of_measure_tl iumt
where 1=1
and iumb.unit_of_measure_id = iumt.unit_of_measure_id
and iumb.uom_code = 'PK'

-- This view have all the details
select * from INV_UNITS_OF_MEASURE_ALL_VL