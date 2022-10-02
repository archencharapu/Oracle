-- Value Sets Query
SELECT vs.value_set_code,
vb.value,
vt.description
FROM FND_VS_VALUE_SETS vs,
FND_VS_VALUES_B vb,
FND_VS_VALUES_TL vt
WHERE 1=1
AND vs.value_set_code = :VALUE_SET_CODE
AND vs.value_set_id = vb.value_set_id
AND vt.value_id = vb.value_id
AND vt.language = USERENV(‘LANG’)
order by vb.value