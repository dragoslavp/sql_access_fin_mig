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
SET @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@CompanyID AND NAME='Redovno knjienje');
SET @JournalID = (SELECT JournalId FROM crg.Journal where CompanyId = @CompanyID and Year = @Year);
SET @SequenceNumeber = (SELECT Number FROM crg.SequencePerJournal where JournalId = @JournalID and Name='INVOICE_PAGE');
SET @BranchId = (select BranchId from crg.Branch where CompanyId=@CompanyID and IsHeadquarter=cast(1 as bit));
SET @CurrencyId = (select CurrencyId FROM grg.Currency where Symbol='BAM');
SET @MeasureUnitId=(select MeasureUnitId from crg.MeasureUnit where CompanyId=@CompanyID and Name='kom');


--INSERT INTO [inv].[BillPageEntry]
--           ([BillPageEntryId]
--           ,[BillPageId]
--           ,[ProductBillId]
--           ,[MeasureUnitId]
--           ,[Quantity]
--           ,[Price]
--           ,[DiscountRate]
--           ,[VatRate]
--           ,[VatNonDeductible]
--           ,[NetAmount]
--           ,[VatAmount]
--           ,[GrossAmount]
--           ,[ChangedBy]
--           ,[ChangedTime]
--           ,[RowVersion]
--           ,[ChangeHistory]
--           ,[CustomVatAmount]
--           ,[FixedAssetId])
select
newid() as BillPageEntryId,
bp.BillPageId as BillPageId,
1 as ProductBillId,
@MeasureUnitId as MeasureUnitId,
1 as Quantity,
k.IznosBezPDV as Price,
0 as DiscountRate,
0 as VatRate,
1 as VatNonDeductible,
k.IznosBezPDV as NetAmount,
k.PDV as VatAmount,
k.Iznos as GrossAmount,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory,
null as CustomVatAmount,
null as FixedAssetId
from
mig.KUF k
left outer join inv.BillPage bp on k.rb=bp.ExternalReference
where
1=1
and k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2022')

GO


