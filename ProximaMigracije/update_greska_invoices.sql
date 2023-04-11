USE [FineraTESTInterfin]
GO

DECLARE @SNUMBER INT;
DECLARE @SNAME NVARCHAR(255);
DECLARE @COMPANYCODE NVARCHAR(255);
DECLARE @COMPANY_ID UNIQUEIDENTIFIER;
DECLARE @YEAR INT;
DECLARE @JOURNAL_ID UNIQUEIDENTIFIER;
DECLARE @CurrencyId UNIQUEIDENTIFIER;
DECLARE @LedgerDocumentCategoryTypeId UNIQUEIDENTIFIER;
DECLARE @BranchId uniqueidentifier;

SET @COMPANYCODE = 'PROCON';
SET @SNAME = 'INVOICE_PAGE';
SET @YEAR = 2022;
SET @COMPANY_ID = (SELECT CompanyId from grg.Company where Code = @COMPANYCODE);
SET @JOURNAL_ID = (SELECT JournalId FROM crg.Journal where CompanyId = @COMPANY_ID and Year = @YEAR);
set @CurrencyId = (select CurrencyId FROM grg.Currency where Symbol='BAM');
set @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@COMPANY_ID AND NAME='KIF');
set @BranchId =  (select BranchId from crg.Branch where CompanyId=@COMPANY_ID and IsHeadquarter=cast(1 as bit));


--SELECT
--ip.Number,
--ip.Description,
--(select Name from crg.Party where Party.PartyId=ip.PartyID) as Party,
--ipe.GrossAmount Iznos_stavke,
--ip.GrossAmount Iznos_zaglavlje
--from
--inv.InvoicePageEntry ipe
--left outer join  inv.InvoicePage ip on ipe.InvoicePageId=ip.InvoicePageId
--where
--ip.JournalId=@JOURNAL_ID
--order by ip.Number

update ip
set ip.DocumentStatusId=1
from inv.InvoicePageEntry ipe 
left outer join  inv.InvoicePage ip on ipe.InvoicePageId=ip.InvoicePageId where ip.JournalId=@JOURNAL_ID
and ip.DocumentStatusId=2





