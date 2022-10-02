/*****************************************************************************************************
-- Business Unit – Legal Entity – COA (Charts Of Accts)

At a high level, this is how the enterprise structure looks like in Fusion:
https://oraclebytes.com/legal-entity-query-in-fusion/

To get into a bit of details: every Business Unit is attached to a legal entity and a ledger. 
Ledger in other terms is also called "set of books". 
Every ledger here has a unique Charts Of Accounts. 
This charts of accounts is nothing but a structure of accounts (like 7 segment structure).
*****************************************************************************************************/


select hou.name BU_NAME, hou.SHORT_CODE , le.NAME Legal_ENtity, led.NAME Ledger_Name
from hr_operating_units hou,
xla_gl_ledgers led,
Xle_entity_profiles le
where hou.default_legal_context_id = le.legal_entity_id
and led.ledger_id = hou.set_of_books_id