SELECT
*
FROM
INV.InvoicePage;

select
*
from
mig.ZaglavljeFakt


SELECT
*
FROM
INV.InvoicePageEntry;


SELECT 
JournalId 
FROM 
crg.Journal 
where CompanyId = (SELECT CompanyId from grg.Company where Code='PROCON') 
and Year = 2022

SELECT 1 
FROM 
crg.SequencePerJournal 
where JournalId=(SELECT 
JournalId 
FROM 
crg.Journal 
where CompanyId = (SELECT CompanyId from grg.Company where Code='PROCON') 
and Year = 2022)
and name = 'INVOICE_PAGE'