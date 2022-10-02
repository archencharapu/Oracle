-- Oracle Fusion Tables

--Oracle Fusion Cloud Applications Suite
https://docs.oracle.com/en/cloud/saas/index.html


CMP_TCS_ALL_OBJECTS_IN_CAT

https://docs.oracle.com/en/cloud/saas/supply-chain-management/21d/oedsc/SCM-Tables-and-Views-Overview.html
-- Tables and Views for Oracle SCM Cloud

-- 9 Cost Management
CST_STD_COSTS
CST_COST_DISTRIBUTIONS 

-- 12 Inventory Management
INV_ONHAND_QUANTITIES_DETAIL -- similar to MTL_ONHAND_QUANTITIES. on hand information by control level and location
INV_MATERIAL_TXNS  -- similar to mtl_material_transactions (Material Transactions)
INV_ORG_PARAMETERS -- similar to org_organization_definitions
INV_LOT_NUMBERS -- stores the definition and expiration date of all lot numbers in inventory
INV_SECONDARY_INVENTORIES -- definition table for the subinventory


-- 16 Order Management
DOO_HEADERS_ALL
DOO_LINES_ALL

-- 24 Product Model
-- Schema: FUSION, Object owner: EGP, Object type: TABLE, Tablespace: TRANSACTION_TABLES
1.EGP_SYSTEM_ITEMS_B
2.EGP_SYSTEM_ITEMS_TL
3.EGP_ITEM_REVISIONS_B 
4.EGP_ITEM_CAT_ASSIGNMENTS
5.EGP_CATEGORY_SETS_B
6.INV_ORG_PARAMETERS 
7.EGP_CATEGORIES_TL

-- 26 Product and Catalog Management
EGO_ITEM_EFF_TL
EGO_ITEM_EFF_B

EGO_ITEM_REVISION_EFF_TL
EGO_ITEM_REVISION_EFF_B


-- 31 Receiving
RCV_SHIPMENT_HEADERS
RCV_SHIPMENT_LINES
RCV_TRANSACTIONS

RCV_HEADERS_INTERFACE
RCV_TRANSACTIONS_INTERFACE
RCV_INTERFACE_ERRORS

-- 33 Shipping
WSH_NEW_DELIVERIES
WSH_DELIVERY_ASSIGNMENTS
WSH_DELIVERY_DETAILS


-- 37 Supply Chain Management Common Components
INV_UNITS_OF_MEASURE_B
INV_UNITS_OF_MEASURE_TL
INV_UOM_CLASSES_B
INV_UOM_CLASS_CONVERSIONS
INV_UOM_CONVERSIONS
WSH_CARRIERS
WSH_TRANSIT_TIMES

INV_ITEM_UOMS_V

-- Tables and Views for Oracle Procurement Cloud
https://docs.oracle.com/en/cloud/saas/procurement/21d/oedmp/index.html


-- 2 Purchasing
PO_ACTION_HISTORY
PO_APPROVED_SUPPLIER_LIST
PO_HEADERS_ALL
PO_LINES_ALL
PO_LINE_LOCATIONS_ALL
PO_DISTRIBUTIONS_ALL
PO_ATTRIBUTE_VALUES (For Item attributes at Line Level)

PO_HEADERS_ARCHIVE_ALL
PO_HEADERS_DRAFT_ALL
PO_LINES_ARCHIVE_ALL -- contains archived purchase order line information
PO_LINES_DRAFT_ALL -- stores draft changes to PO lines that have not been accepted by buyer
PO_LINE_LOCATIONS_ARCHIVE_ALL
PO_LINE_LOCATIONS_DRAFT_ALL
PO_DISTRIBUTIONS_DRAFT_ALL
PO_DISTRIBUTIONS_ARCHIVE_ALL

PO_HEADERS_INTERFACE
PO_LINES_INTERFACE
PO_DISTRIBUTIONS_INTERFACE
PO_LINE_LOCATIONS_INTERFACE
PO_ATTR_VALUES_INTERFACE (Attribute values interface table.)
PO_ATTR_VALUES_TLP_INTERFACE (Translated Attribute values interface table)
PO_INTERFACE_ERRORS


-- 3 Self Service Procurement
POR_REQUISITION_HEADERS_ALL
POR_REQUISITION_LINES_ALL
POR_REQ_DISTRIBUTIONS_ALL

-- 4 Sourcing
PON_ACCEPTANCES
PON_AUCTION_HEADERS_ALL
PON_AUCTION_ITEM_PRICES_ALL
PON_AWARD_ALLOCATIONS
PON_BIDDING_PARTIES
PON_BID_HEADERS
PON_BID_PO_LINES

-- 6 Supplier Model
POZ_APPROVAL_HISTORY
POZ_SUPPLIERS
POZ_SUPPLIER_CONTACTS
POZ_SUPPLIER_SITES_ALL_M 

POZ_SUPPLIERS_V
POZ_SUPPLIER_SITES_V


-- Tables and Views for Common Features
https://docs.oracle.com/en/cloud/saas/applications-common/21d/oedma/index.html

-- 2 Application Toolkit

-- 3 Middleware Extensions for Applications
ADF_METADATA_REVISIONS
FND_DOCUMENTS (stores the information about documents stored in the document repository.)
FND_DF_FLEXFIELDS_B (stores Category definitions for Descriptive Flexfields)
FND_EF_CATEGORIES_B (stores Category definitions for Extensible Flexfields)
FND_LOOKUP_TYPES
FND_LOOKUP_VALUES_B
FND_MENUS
FND_OBJECTS (Stores the object defintion of the object (table or view) that needs to be secured.)
FND_PROFILE_LEVELS
FND_PROFILE_OPTIONS_B
FND_SESSIONS
FND_TABLES
FND_VIEWS (Contains the list of Views registered with Applications.)


-- Tables and Views for Financials
https://docs.oracle.com/en/cloud/saas/financials/21d/oedmf/index.html


-- 6 Cash Management


-- 13 General Ledger
GL_BALANCES
GL_JE_BATCHES
GL_JE_HEADERS
GL_JE_LINES
GL_LEDGERS
GL_PERIODS
GL_JE_SOURCES
GL_JE_CATEGORIES


GL_INTERFACE -- contains journal entry batches through Journal Import
GL_INTERFACE_HISTORY -- contains the rows that are successfully imported from the GL_INTERFACE table through Journal Import. Always blank at Chewy!!
GL_JE_ERROR_CODES -- contains the error code of the journal lines.

-- 15 Legal Entity Configurator
XLE_JURISDICTIONS_B


-- 18 Payables
AP_HOLDS_ALL
AP_INVOICES_ALL
AP_INVOICE_LINES_ALL
AP_INVOICE_DISTRIBUTIONS_ALL

AP_TERMS
AP_TERMS_TL

AP_INVOICES_INTERFACE

-- 19 Payments


-- 20 Receivables


-- 22 Subledger Accounting


-- 23 Tax



-- Tables and Views for HCM
https://docs.oracle.com/en/cloud/saas/human-resources/21d/oedmh/index.html

-- 8 Global Human Resources
HR_ALL_ORGANIZATION_UNITS_F
HR_ORGANIZATION_UNITS_F_TL
HR_ORGANIZATION_INFORMATION_F
HR_ORG_UNIT_CLASSIFICATIONS_F

PER_ALL_PEOPLE_F
PER_USERS  -- User Info
PER_USER_ROLES -- roles associated with users
PER_ROLES_DN_VL -- role names with role id
PER_USER_HISTORY  -- user history

-- Views
HR_ALL_POSITIONS
HR_ALL_ORGANIZATION_UNITS




-- EDW TABLES
-- oracle_erp schema
-- pvo: private view object

item -- items table
uomintraclasspvo -- uom intraclass
standardlinepvo -- po lines
invmaterialtransaction
inventorytransactiondetailpvo
inv_org_parameters

