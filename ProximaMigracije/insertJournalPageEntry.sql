USE [FineraTESTInterfin]
GO

DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;
DECLARE @SequenceNumeber INT;
DECLARE @Year int;
declare @JournalID uniqueidentifier;
declare @LedgerDocumentCategoryTypeId uniqueidentifier;
declare @BranchId uniqueidentifier;
declare @CurrencyId uniqueidentifier;


SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);
set @Year = 2023;
set @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@CompanyID AND NAME='Početno stanje');
SET @JournalID = (SELECT JournalId FROM crg.Journal where CompanyId = @CompanyID and Year = @Year);
set @SequenceNumeber = (SELECT Number FROM crg.SequencePerJournal where JournalId = @JournalID);
set @BranchId = (select BranchId from crg.Branch where CompanyId=@CompanyID and IsHeadquarter=cast(1 as bit));
set @CurrencyId = (select CurrencyId FROM grg.Currency where Symbol='BAM');


--INSERT INTO [fin].[JournalPageEntry]
--           ([JournalPageEntryId]
--           ,[JournalPageId]
--           ,[PartyId]
--           ,[CurrencyId]
--           ,[BranchId]
--           ,[AccountingPlanAccountId]
--           ,[DocumentDate]
--           ,[MaturityDate]
--           ,[Description]
--           ,[JournalLinkDescription]
--           ,[CurrencyRate]
--           ,[CurrencyRateDate]
--           ,[ForeignDebit]
--           ,[ForeignCredit]
--           ,[Debit]
--           ,[Credit]
--           ,[SortNumber]
--           ,[ExternalReference]
--           ,[LabelCodes]
--           ,[ChangedBy]
--           ,[ChangedTime]
--           ,[RowVersion]
--           ,[ChangeHistory])
select
newid() as JournalPageEntryId,
jp.JournalPageId as JournalPageId,
(select PartyId from crg.Party where Party.Code=d.SIFRA) as PartyId,
@CurrencyId as CurrencyId,
@BranchId  as BranchId,
(select AccountingPlanAccountId from crg.AccountingPlanAccount where Code=d.KONTO) as AccountingPlanAccountId,
jp.Date as DocumentDate,
d.Rok  as MaturityDate,
d.OPIS as Description,
d.BRVD as JournalLinkDescription,
1 as CurrencyRate,
jp.Date as CurrencyRateDate,
case d.DUGUJE
	when null then null
	when 0 then null
	else d.DUGUJE
end as ForeignDebit,
case d.POTRAZUJE
	when null then null
	when 0 then null
	else d.POTRAZUJE           		   
end as ForeignCredit,
case d.DUGUJE
	when null then null
	when 0 then null
	else d.DUGUJE
end  as Debit,
case d.POTRAZUJE
	when null then null
	when 0 then null
	else d.POTRAZUJE           		   
end as Credit,
null as SortNumber,
jp.ExternalReference as ExternalReference,
null as LabelCodes,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory
from
mig.dnevnik d
--left outer join mig.nalozi n on d.BROJ=n.BROJ
left outer join fin.JournalPage jp on d.BROJ = jp.ExternalReference
where
1=1
and jp.JournalPageId is not null
and d.godina=2023
and d.BROJ=1

GO


