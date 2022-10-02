/******************************************************************************
-- When Bank Account is created in Supplier UI (Sypplier > Payment > Banks), a record is
created in IBY_EXT_BANK_ACCOUNTS. this table only have Bank Account Number.
-- Bank name, branch and routing number is stored in CE_BANK_BRANCHES_V
-- CE_BANK_BRANCHES_V has data from ce_banks, ce_bank_branches and hz_parties

-- When a bank is cerated in Cash Management to make payments, a record is
created in ce_banks and ce_bank_brances

Example:
CE Banks, Branches, Supplier Bank Details
1)     SELECT *FROM CE_BANKS_V WHERE BANK_NAME LIKE 'Oversea%Chinese%';
---bank_PARTY_ID=300000249183064
2)     SELECT *FROM IBY_EXT_BANK_ACCOUNTS WHERE BANK_ID='300000249183064';
---BANK_ID=CE_BANKS_V.BANK_PARTY_ID
SELECT *FROM CE_BANK_BRANCHES_V WHERE bank_PARTY_ID=300000249183064;


*****************************************************************************/





-- Query to fetch Bank details
SELECT bank_name
,country
,to_char(start_date,'RRRR-MM-DD') start_date
,to_char(end_date,'RRRR-MM-DD') end_date
FROM ce_banks_v
WHERE :p_effective_date BETWEEN start_date AND end_date
AND NVL(:p_bank_name,bank_name) = bank_name;


-- Query to fetch Bank Branch details
SELECT bank_name
,bank_branch_name
,branch_number
,country
,to_char(start_date,'RRRR-MM-DD') start_date
,to_char(end_date,'RRRR-MM-DD') end_date
FROM ce_bank_branches_v
WHERE :p_effective_date BETWEEN start_date AND end_date
/AND nvl(:p_bank_name,bank_name) = bank_name/
AND nvl(:p_branch_name
,bank_branch_name) = bank_branch_name
/AND :p_branch_name = bank_branch_name/

-- Query to fetch External Bank Account details
SELECT country_code
,bank_id
,branch_party_id
,bank_account_num
,iban
,bank_account_type
,to_char(eba.start_date,'RRRR-MM-DD') start_date
,to_char(eba.end_date,'RRRR-MM-DD') end_date
,cb.bank_name
,cbbv.bank_branch_name
,cb.country
FROM ce_banks_v cb
,ce_bank_branches_v cbbv
,iby_ext_bank_accounts eba
WHERE cb.bank_party_id = eba.bank_id
AND cbbv.branch_party_id = eba.branch_id
and :p_effective_Date between eba.start_date and eba.end_date