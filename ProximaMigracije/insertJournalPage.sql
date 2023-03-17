USE [FineraTESTInterfin]
GO

DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;
DECLARE @SequenceNumeber INT;
DECLARE @Year int;
declare @JournalID uniqueidentifier;
declare @LedgerDocumentCategoryTypeId uniqueidentifier;

SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);
set @Year = 2022;
set @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@CompanyID AND NAME='Redovno knjienje');
SET @JournalID = (SELECT JournalId FROM crg.Journal where CompanyId = @CompanyID and Year = @Year);
set @SequenceNumeber = (SELECT Number FROM crg.SequencePerJournal where JournalId = @JournalID);

INSERT INTO [fin].[JournalPage]
           ([JournalPageId]
           ,[LedgerId]
           ,[JournalId]
           ,[LedgerDocumentCategoryTypeId]
           ,[DocumentStatusId]
           ,[JournalSequenceNumber]
           ,[Date]
           ,[Description]
           ,[Revision]
           ,[RevisionDescription]
           ,[ActivationDate]
           ,[RevisionDate]
           ,[SourceLedgerPageId]
           ,[SourceLedgerPageNumber]
           ,[AutoCreated]
           ,[ExternalReference]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory])
select
newid() as JournalPageId,
9  as LedgerId,
@JournalID as JournalId,
@LedgerDocumentCategoryTypeId as LedgerDocumentCategoryTypeId,
2  as DocumentStatusId,
ROW_NUMBER() over (ORDER BY n.Broj) +  @SequenceNumeber as JournalSequenceNumber,
n.DATUM    as Date,
'MIGRACIJA PODATAKA NALOG BR. '+ cast(N.BROJ as nvarchar) as Description,
1 as Revision,
null as RevisionDescription,
n.DATUM as ActivationDate,
null as RevisionDate,
null as SourceLedgerPageId,
null as SourceLedgerPageNumber,
0    as AutoCreated,
n.BROJ as ExternalReference,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory
from
mig.nalozi n
where 
1=1
and n.godina = @Year
and n.BROJ not in (select JournalPageNumber FROM mig.KUF where datum >= CAST('01/01/2022' as date) and datum <= CAST('12/31/2022'  as date))
and n.BROJ not in (select distinct nalog from mig.ZaglavljeFakt where datum >= CAST('01/01/2022' as date) and datum <= CAST('12/31/2022' as date))
;



UPDATE crg.SequencePerJournal
SET Number = (select 
				max(jp.JournalSequenceNumber)
				from fin.JournalPage jp
				where JournalId = @JournalID
				--and jp.Date >= CAST('01/01/2022' as date) and jp.Date <= CAST('12/31/2022'  as date)				
				)
WHERE JournalId = @JournalID and Name = 'JOURNAL_PAGE'

GO