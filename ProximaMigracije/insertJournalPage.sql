USE [FineraTESTInterfin]
GO

DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;
DECLARE @SequenceNumeber INT;
DECLARE @Year int;
declare @JournalID uniqueidentifier;
declare @LedgerDocumentCategoryTypeId uniqueidentifier;
declare @JOURNAL_ID uniqueidentifier;
declare @SNAME nvarchar(255);

SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);
set @Year = 2023;
set @SNAME = 'JOURNAL_PAGE';

SET @JOURNAL_ID = (SELECT JournalId FROM crg.Journal where CompanyId = @CompanyID and Year = @YEAR);
SET @LedgerDocumentCategoryTypeId = (SELECT LedgerDocumentCategoryTypeId FROM CRG.LedgerDocumentCategoryType WHERE CompanyId=@CompanyID AND NAME='Redovno knjienje');
SET @JournalID = (SELECT JournalId FROM crg.Journal where CompanyId = @CompanyID and Year = @Year);


--IF NOT EXISTS (SELECT 1 FROM crg.SequencePerJournal where JournalId=@JOURNAL_ID and name = @SNAME)
--	INSERT INTO [crg].[SequencePerJournal]
--			   ([SequencePerJournalId]
--			   ,[JournalId]
--			   ,[Name]
--			   ,[Number])
--		 VALUES
--				(
--				NEWID(),
--				@JOURNAL_ID,
--				@SNAME,
--				1
--				)

set @SequenceNumeber = (SELECT Number FROM crg.SequencePerJournal where JournalId = @JournalID and name='JOURNAL_PAGE');

--INSERT INTO [fin].[JournalPage]
--           ([JournalPageId]
--           ,[LedgerId]
--           ,[JournalId]
--           ,[LedgerDocumentCategoryTypeId]
--           ,[DocumentStatusId]
--           ,[JournalSequenceNumber]
--           ,[Date]
--           ,[Description]
--           ,[Revision]
--           ,[RevisionDescription]
--           ,[ActivationDate]
--           ,[RevisionDate]
--           ,[SourceLedgerPageId]
--           ,[SourceLedgerPageNumber]
--           ,[AutoCreated]
--           ,[ExternalReference]
--           ,[ChangedBy]
--           ,[ChangedTime]
--           ,[RowVersion]
--           ,[ChangeHistory])
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
and n.BROJ not in (select JournalPageNumber FROM mig.KUF where datum >= CAST('01/01/2023' as date) and datum <= CAST('12/31/2023'  as date))
and n.BROJ not in (select distinct nalog from mig.ZaglavljeFakt where datum >= CAST('01/01/2023' as date) and datum <= CAST('12/31/2023' as date))
;



--UPDATE crg.SequencePerJournal
--SET Number = (select 
--				max(jp.JournalSequenceNumber)
--				from fin.JournalPage jp
--				where JournalId = @JournalID				
--				)
--WHERE JournalId = @JournalID and Name = 'JOURNAL_PAGE'

GO