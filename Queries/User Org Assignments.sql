select pu.username, pu.person_id, hafut.name, hafut.organization_id
from 
per_all_assignments_m paam,
     per_all_people_f papf,
     per_users pu,
     hr_organization_units_f_tl hafut
where 1=1
and hafut.language = 'US'
and hafut.effective_end_date > sysdate
and hafut.organization_id = paam.business_unit_id
and paam.effective_end_date > sysdate
and paam.person_id = papf.person_id
and papf.person_id = pu.person_id
and pu.username = 'CHEWY.INTEGRATION'
;
    
    
    
select * from per_users
where 1=1
and username = 'CHEWY.OIC'
and lower(username) like 'chewy%'
;

select hafut.* from HR_ORGANIZATION_UNITS_F_TL hafut
where 1=1
--and effective_end_date > sysdate
and hafut.language = 'US'
and organization_id = 300000006366440;

select paam.business_unit_id bu_id, paam.* from per_all_assignments_m paam
where 1=1
and person_id = 300000032338442


and effective_end_date > sysdate;