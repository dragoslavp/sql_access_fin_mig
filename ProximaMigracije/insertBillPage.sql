USE [FineraTESTInterfin]
GO


USE [FineraTESTInterfin]
GO

DECLARE @SNUMBER INT;
DECLARE @SNAME NVARCHAR(255);
DECLARE @COMPANYNAME NVARCHAR(255);
DECLARE @COMPANY_ID UNIQUEIDENTIFIER;
DECLARE @YEAR INT;
DECLARE @JOURNAL_ID UNIQUEIDENTIFIER;
DECLARE @CurrencyId UNIQUEIDENTIFIER;
DECLARE @LedgerDocumentCategoryTypeId UNIQUEIDENTIFIER;
DECLARE @BranchId uniqueidentifier;

SET @COMPANYNAME = 'Proxima Consulting d.o.o.';
SET @SNAME = 'BILL_PAGE';
SET @YEAR = 2022;
SET @COMPANY_ID = (SELECT CompanyId from grg.Company where Name = @COMPANYNAME);
SET @JOURNAL_ID = (SELECT JournalId FROM crg.Journal where CompanyId = @COMPANY_ID and Year = @YEAR);
set @CurrencyId = (select CurrencyId FROM grg.Currency where Symbol='BAM');
set @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@COMPANY_ID AND NAME='KUF');
set @BranchId =  (select BranchId from crg.Branch where CompanyId=@COMPANY_ID and IsHeadquarter=cast(1 as bit));


IF NOT EXISTS (SELECT 1 FROM crg.SequencePerJournal where JournalId=@JOURNAL_ID and name = @SNAME)
	INSERT INTO [crg].[SequencePerJournal]
			   ([SequencePerJournalId]
			   ,[JournalId]
			   ,[Name]
			   ,[Number])
		 VALUES
				(
				NEWID(),
				@JOURNAL_ID,
				@SNAME,
				1
				)

SET @SNUMBER = (SELECT Number FROM crg.SequencePerJournal where JournalId = @JOURNAL_ID and name=@SNAME);

INSERT INTO [inv].[BillPage]
           ([BillPageId]
           ,[JournalId]
           ,[JournalSequenceNumber]
           ,[Revision]
           ,[DocumentStatusId]
           ,[LedgerDocumentCategoryTypeId]
           ,[Date]
           ,[Description]
           ,[RevisionDate]
           ,[RevisionDescription]
           ,[ActivationDate]
           ,[JournalPageId]
           ,[MaturityDate]
           ,[Number]
           ,[CancellationNumber]
           ,[FiscalNumber]
           ,[BranchId]
           ,[PaymentMethodId]
           ,[PartyId]
           ,[AdvancePaymentPageId]
           ,[NetAmount]
           ,[VatAmount]
           ,[GrossAmount]
           ,[CurrencyId]
           ,[CurrencyDate]
           ,[CurrencyRate]
           ,[ReceptionDate]
           ,[DateFrom]
           ,[DateTo]
           ,[Note]
           ,[HasImportDeclaration]
           ,[IsExported]
           ,[AutoCreated]
           ,[ExternalReference]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory]
           ,[CustomsDeclarationNumber])
select
newid() as BillPageId,
@JOURNAL_ID as JournalId,
ROW_NUMBER() over (ORDER BY k.rb) as JournalSequenceNumber,
1 as Revision,
1 as DocumentStatusId,
@LedgerDocumentCategoryTypeId as LedgerDocumentCategoryTypeId,
k.Datum as Date,
'KUF ' + cast(k.rb as nvarchar(10)) as Description,
null as RevisionDate,
null as RevisionDescription,
null as ActivationDate,
null as JournalPageId,
k.[Rok placanja] as MaturityDate,
k.[Broj racuna] as Number,
null as CancellationNumber,
null as FiscalNumber,
@BranchId as BranchId,
2 as PaymentMethodId,
(select PartyId from crg.Party where Party.Code=k.Dobavljac) as PartyId,
null as AdvancePaymentPageId,
k.IznosBezPDV as NetAmount,
k.PDV as VatAmount,
k.Iznos as GrossAmount,
@CurrencyId as CurrencyId,
k.Datum as CurrencyDate,
1 as CurrencyRate,
k.[Datum prijema] as ReceptionDate,
null as DateFrom,
null as DateTo,
null as Note,
0 as HasImportDeclaration,
0 as IsExported,
0 as AutoCreated,
k.rb as ExternalReference,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory,
null as CustomsDeclarationNumber
from
mig.KUF k
where
1=1
and k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2022')
;


UPDATE crg.SequencePerJournal
SET Number = (select 
				max(bp.JournalSequenceNumber)
				from inv.BillPage bp
				where JournalId = @Journal_ID
				--and jp.Date >= CAST('01/01/2022' as date) and jp.Date <= CAST('12/31/2022'  as date)				
				)
WHERE JournalId = @Journal_ID and Name = @SNAME;


GO


