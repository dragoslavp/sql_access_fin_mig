USE [FineraTESTInterfin]
GO

DECLARE @MeasureUnitId uniqueidentifier;
DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;
DECLARE @SequenceNumeber INT;
DECLARE @Year int;
DECLARE @JournalID uniqueidentifier;
DECLARE @LedgerDocumentCategoryTypeId uniqueidentifier;
DECLARE @BranchId uniqueidentifier;
DECLARE @CurrencyId uniqueidentifier;


SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);
SET @Year = 2022;
SET @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@CompanyID AND NAME='Redovno knjiženje');
SET @JournalID = (SELECT JournalId FROM crg.Journal where CompanyId = @CompanyID and Year = @Year);
SET @SequenceNumeber = (SELECT Number FROM crg.SequencePerJournal where JournalId = @JournalID);
SET @BranchId = (select BranchId from crg.Branch where CompanyId=@CompanyID and IsHeadquarter=cast(1 as bit));
SET @CurrencyId = (select CurrencyId FROM grg.Currency where Symbol='BAM');
SET @MeasureUnitId=(select MeasureUnitId from crg.MeasureUnit where CompanyId=@CompanyID and Name='kom');


INSERT INTO [inv].[InvoicePageEntry]
           ([InvoicePageEntryId]
           ,[InvoicePageId]
           ,[ProductInvoiceId]
           ,[MeasureUnitId]
           ,[Quantity]
           ,[Price]
           ,[DiscountRate]
           ,[VatRate]
           ,[NetAmount]
           ,[VatAmount]
           ,[GrossAmount]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory])
select
newid() as InvoicePageEntryId,
ip.InvoicePageId as InvoicePageId,
(select ProductId from inv.Product where Code = f.SifraRobe) as ProductInvoiceId,
@MeasureUnitId as MeasureUnitId,
1 as Quantity,
f.Iznos as Price,
0 as DiscountRate,
0 as VatRate,
f.Iznos as NetAmount,
0 as VatAmount,
f.Iznos as GrossAmount,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory
from
mig.fakture f
--left outer join mig.ZaglavljeFakt zf on f.redbr = zf.redbr
left outer join inv.InvoicePage ip on f.redbr = ip.ExternalReference
where
1=1
and f.godina = @Year

GO


