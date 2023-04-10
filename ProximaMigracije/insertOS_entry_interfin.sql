USE [iKontCODS]
GO

DECLARE @year int;
DECLARE @compName nvarchar(255);
DECLARE @companyid uniqueidentifier;
DECLARE @journalid uniqueidentifier;
DECLARE @documentTypeId uniqueidentifier;

set @year=2023;
set @compName='Premium'
set @companyid = (select companyid from [dbo].[Company] where Name=@compName);
set @journalid = (select JournalID from [fin].[Journal] where Year=@Year and CompanyId=@companyid);
set @documentTypeId = (select DocumentTypeId from [dbo].[DocumentType] where DocumentTypeId='931018FE-4FD2-4DA4-A5B2-0E54440E76D9');


--INSERT INTO [fa].[FixedAssetJournalEntry]
--           ([FixedAssetJournalEntryId]
--           ,[DocumentStatus]
--           ,[PartyId]
--           ,[JournalLinkDescription]
--           ,[Value]
--           ,[ValueCorrection]
--           ,[Revaluation]
--           ,[RevaluationCorrection]
--           ,[VolumeIn]
--           ,[VolumeOut]
--           ,[ExternalReference]
--           ,[DateFrom]
--           ,[DateTo]
--           ,[Rate]
--           ,[FixedAssetId]
--           ,[FixedAssetJournalPageId]
--           ,[CreatedByUserId]
--           ,[UpdatedByUserId]
--           ,[TimeCreated]
--           ,[TimeUpdated])
select * from
(select
newid() as FixedAssetJournalEntryId,
0 as DocumentStatus,
null as PartyId,
null as JournalLinkDescription,
[dbo].[OS].Vrijednost as Value,
[dbo].[OS].[Ispravka vrijednosti] as ValueCorrection,
0           as Revaluation,
0           as RevaluationCorrection,
[dbo].[OS].Ulaz as VolumeIn,
null as VolumeOut,
null as ExternalReference,
null as DateFrom,
null as DateTo,
null as Rate,
(select FixedAssetId from [fa].[FixedAsset] where FixedAssetNumber=substring([dbo].[OS].[Osnovno sredstvo],1,5) and CompanyId=@companyid) as FixedAssetId,
(select FixedAssetJournalPageId from [fa].FixedAssetJournalPage where Description='Pocetno stanje OS' and PageNumber = 1 and Date = convert(datetime, '01-01-2023') and JournalId=@journalid) as FixedAssetJournalPageId,
(select UserId from [iKontCODS].[dbo].[User] where Email='dario.vasilic@premiumosiguranje.com') as CreatedByUserId,
null as UpdatedByUserId,
GETDATE() as TimeCreated,
null as TimeUpdated
from
[dbo].[OS]) as a
where a.FixedAssetId is not null

GO


