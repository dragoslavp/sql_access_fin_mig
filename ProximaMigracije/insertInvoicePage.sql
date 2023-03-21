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
SET @SNAME = 'INVOICE_PAGE';
SET @YEAR = 2022;
SET @COMPANY_ID = (SELECT CompanyId from grg.Company where Name = @COMPANYNAME);
SET @JOURNAL_ID = (SELECT JournalId FROM crg.Journal where CompanyId = @COMPANY_ID and Year = @YEAR);
set @CurrencyId = (select CurrencyId FROM grg.Currency where Symbol='BAM');
set @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@COMPANY_ID AND NAME='KIF');
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

INSERT INTO [inv].[InvoicePage]
           ([InvoicePageId]
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
           ,[DeliveryDate]
           ,[DateFrom]
           ,[DateTo]
           ,[Note]
           ,[HasExportDeclaration]
           ,[CustomsBill]
           ,[IsEmailSent]
           ,[TurnoverDate]
           ,[AutoCreated]
           ,[ExternalReference]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory])

SELECT
newid() as InvoicePageId,
@JOURNAL_ID as JournalId,
ROW_NUMBER() over (ORDER BY redbr) as JournalSequenceNumber,
1 as Revision,
1 as DocumentStatusId,
@LedgerDocumentCategoryTypeId as LedgerDocumentCategoryTypeId,
zf.datum   as Date,
'KIF' + cast(ZF.InvoiceNumber as nvarchar(10)) as Description,
null as RevisionDate,
null as RevisionDescription,
null as ActivationDate,
null as JournalPageId,
zf.valuta  as MaturityDate,
zf.redbr as Number,
null as CancellationNumber,
null as FiscalNumber,
@BranchId as BranchId,
2 as PaymentMethodId,
(select PartyId from crg.Party where Party.Code=zf.SifraKupca) as PartyId,
null as AdvancePaymentPageId,
zf.TotalAmmount as NetAmount,
0 as VatAmount,
zf.TotalAmmount  as GrossAmount,
@CurrencyId as CurrencyId,
zf.datum as CurrencyDate,
1 as CurrencyRate,
null as DeliveryDate,
zf.Od as DateFrom,
zf.Do as DateTo,
zf.napomena as Note,
0 as HasExportDeclaration,
null as CustomsBill,
0 as IsEmailSent,
null as TurnoverDate,
0 as AutoCreated,
zf.InvoiceNumber as ExternalReference,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory
FROM
mig.ZaglavljeFakt zf
where 
1=1
and zf.InvoiceNumber<>0
and godina = @YEAR


UPDATE crg.SequencePerJournal
SET Number = (select 
				max(ip.JournalSequenceNumber)
				from inv.InvoicePage ip
				where JournalId = @Journal_ID
				--and jp.Date >= CAST('01/01/2022' as date) and jp.Date <= CAST('12/31/2022'  as date)				
				)
WHERE JournalId = @Journal_ID and Name = 'INVOICE_PAGE'



GO


