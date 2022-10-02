-- Query to get Requisition to PO details in Oracle Fusion Cloud Application

-- This query will fetch link between requisition and PO details in Oracle Fusion Application

SELECT POH.PO_HEADER_ID,
       POH.SEGMENT1  ,
       PRHA.REQUISITION_NUMBER
FROM
       PO_HEADERS_ALL POH,
       PO_DISTRIBUTIONS_ALL PDA ,
       POR_REQ_DISTRIBUTIONS_ALL PRDA ,
       POR_REQUISITION_LINES_ALL PRLA ,
       POR_REQUISITION_HEADERS_ALL PRHA
WHERE  1=1
   AND POH.PO_HEADER_ID = PDA.PO_HEADER_ID
   AND PDA.REQ_DISTRIBUTION_ID = PRDA.DISTRIBUTION_ID
   AND PRDA.REQUISITION_LINE_ID = PRLA.REQUISITION_LINE_ID
   AND PRLA.REQUISITION_HEADER_ID = PRHA.REQUISITION_HEADER_ID
   AND PRHA.REQUISITION_NUMBER = :P_Req_Num;
