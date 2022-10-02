-- Query To Get AP Payments Detail
SELECT      aia.invoice_id,
             aia.invoice_num,
             aia.DOC_SEQUENCE_VALUE  Voucher_num,
             aca.payment_method_code,
             aca.check_number payment_reference,
             aca.check_date payment_date,
             aca.amount,
             aca.status_lookup_code payment_status,
             cbv.bank_name,
             aip.attribute1 UTR_NO
      FROM   ap_invoices_all aia,
             ap_invoice_payments_all aip,
             ap_checks_all aca,
             ce_bank_acct_uses_all cbau,
             ce_bank_accounts cba,
             ce_banks_v cbv
     WHERE   aia.invoice_id = aip.invoice_id
             AND aca.check_id = aip.check_id
             AND cbau.bank_acct_use_id = aca.ce_bank_acct_use_id
             AND cbau.bank_account_id = cba.bank_account_id
             AND cba.bank_id = cbv.bank_party_id	
			 
			 
-- Query Can Be Used to List All Invoices That Are Selected for Payment
SELECT SUP.vendor_name SUPPLIER, INV.invoice_num INVOICE, INV.invoice_date, PS.payment_num, PS.checkrun_id, INV.invoice_id
  FROM ap_suppliers SUP, ap_invoices_all INV, ap_payment_schedules_all PS
 WHERE INV.vendor_id = SUP.vendor_id
  AND INV.invoice_id = PS.invoice_id
  AND PS.checkrun_id IS NOT NULL
;


/***********************************************************************************************************************
-- Query to identify the various components that a Payables Invoice goes through a P2P process. 
-- Below query provides the details like Invoice, Supplier, Supplier Sites, Payment Method codes, 
-- terms, Distribution details, Payment schedules, Check details, Internal Bank Payment and Internal Bank details.
***********************************************************************************************************************/
SELECT aia.invoice_num                 "Invoice Number",
       aps.vendor_name                 "Vendor Name" -- get vendor name from ap_suppliers table
                                                    ,
       assa.vendor_site_code           "Vendor Site Code",
       aia.invoice_id                  "Invoice ID",
       aia.invoice_currency_code       "Currency Code",
       aia.invoice_amount              "Invoice Amount",
       aia.amount_paid                 "Amount Paid",
       aia.invoice_type_lookup_code    "Invoice Type", -- values are derived from ap_lookup_codes and lookup_type = 'INVOICE TYPE'.
                                                       --STANDARD, CREDIT, DEBIT, EXPENSE REPORT, PREPAYMENT, MIXED, RETAINAGE RELEASE are other Invoice Types
       aia.description,
       aia.payment_method_lookup_code, -- values are derived from ap_lookup_codes table and lookup_type = 'PAYMENT METHOD'
                                       -- Check, Clearing, Electronic, Wire
       aia.terms_id                    "Terms ID", -- get terms name from ap_terms table
       aia.pay_group_lookup_code,                  -- values are derived from the fnd_lookup_values_vl and lookup_type = 'PAY GROUP'
       aia.org_id                      "Operating Unit ID", -- values are derived from hr_operating_units table - organization_id column
       aia.gl_date                     "GL Date",
       aia.wfapproval_status,
       ail.line_number                 "Line Number",
       ail.line_type_lookup_code       "Line Type", -- values are derived from ap_lookup_codes and lookup_type = 'INVOICE LINE TYPE'
                                                    -- Item, Freigh, Miscellaneous, Tax
       ail.amount                      "Line Amount",
       aid.dist_code_combination_id    "Distribution Code Comb ID", -- segment information can be derived from gl_code_combinations_kfv
       aid.accounting_event_id         "Invoice Accounting Event ID", -- will be used to link to SLA tables
       apsa.amount_remaining           "Remaining Invoice Amount",
       apsa.due_date                   "Due Date",
       aipa.accounting_event_id        "Payment Accounting Event ID",
       aca.amount                      "Check Amount",
       aca.check_number                "Check Number",
       aca.checkrun_name               "Payment Process Request",
       idpa.document_amount            "Payment Amount",
       idpa.pay_proc_trxn_type_code    "Payment Processing Document",
       idpa.calling_app_doc_ref_number "Invoice Number",
       ipa.paper_document_number       "Payment Number",
       ipa.payee_name                  "Paid to Name",
       ipa.payee_address1              "Paid to Address",
       ipa.payee_city                  "Paid to City",
       ipa.payee_postal_code           "Payee Postal Code",
       ipa.payee_state                 "Payee State",
       ipa.payee_country               "Payee Country",
       ipa.payment_profile_acct_name   "Payment Process Profile",
       ipa.int_bank_name               "Payee Bank Name",
       ipa.int_bank_number             "Payee Bank Number",
       ipa.int_bank_account_name       "Payee Bank Account Name",
       ipa.int_bank_account_number     "Payee Bank Account Number"
  FROM ap_invoices_all               aia,
       ap_invoice_lines_all          ail,
       ap_invoice_distributions_all  aid,
       ap_suppliers                  aps,
       ap_supplier_sites_all         assa,
       ap_payment_schedules_all      apsa,
       ap_invoice_payments_all       aipa,
       ap_checks_all                 aca,
       iby_docs_payable_all          idpa,
       iby_payments_all              ipa
 WHERE     1 = 1
       AND aia.invoice_id = ail.invoice_id
       AND aia.invoice_id = aid.invoice_id
       AND aia.vendor_id = aps.vendor_id
       AND aps.vendor_id = assa.vendor_id
       AND aia.invoice_id = apsa.invoice_id
       AND aia.invoice_id = aipa.invoice_id
       AND aipa.check_id = aca.check_id
       AND aia.invoice_id = idpa.calling_app_doc_unique_ref2
       AND idpa.calling_app_id = 200
       AND aps.party_id = idpa.payee_party_id
       AND ipa.payment_id = idpa.payment_id
       AND aps.segment1 = ipa.payee_supplier_number
       -- and assa.vendor_site_id = ipa.supplier_site_id
       AND assa.org_id = aia.org_id
       AND aca.vendor_site_id = assa.vendor_site_id
       AND invoice_num = p_invoice_num; -- Enter Invoice number here. 