--Value Sets based on table:
--This Query gives details of value sets that are based on a oracle application tables.
select ffvs.flex_value_set_id ,
    ffvs.flex_value_set_name ,
    ffvs.description set_description ,
    ffvs.validation_type,
    ffvt.value_column_name ,
    ffvt.meaning_column_name ,
    ffvt.id_column_name ,
    ffvt.application_table_name ,
    ffvt.additional_where_clause
FROM fnd_flex_value_sets ffvs ,
    fnd_flex_validation_tables ffvt
WHERE ffvs.flex_value_set_id = ffvt.flex_value_set_id;


-- Independent Value set Details:
-- This query gives details of independent FND Value sets i.e. Values are static and these are not derived from any application table.
SELECT ffvs.flex_value_set_id ,
    ffvs.flex_value_set_name ,
    ffvs.description set_description ,
    ffvs.validation_type,
    ffv.flex_value_id ,
    ffv.flex_value ,
    ffvt.flex_value_meaning ,
    ffvt.description value_description
FROM fnd_flex_value_sets ffvs ,
    fnd_flex_values ffv ,
    fnd_flex_values_tl ffvt
WHERE
    ffvs.flex_value_set_id     = ffv.flex_value_set_id
    and ffv.flex_value_id      = ffvt.flex_value_id
    AND ffvt.language          = USERENV('LANG');