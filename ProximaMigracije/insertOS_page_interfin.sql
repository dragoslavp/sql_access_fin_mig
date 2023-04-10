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

--INSERT INTO [fa].[FixedAssetJournalPage]
--           ([FixedAssetJournalPageId]
--           ,[PageNumber]
--           ,[Revision]
--           ,[DocumentStatusId]
--           ,[Date]
--           ,[Description]
--           ,[RevisionDescription]
--           ,[GeneralJournalPageNumber]
--           ,[ExternalReference]
--           ,[JournalId]
--           ,[DocumentTypeId]
--           ,[PublishDate]
--           ,[RevisionDate]
--           ,[CreatedByUserId]
--           ,[UpdatedByUserId]
--           ,[TimeCreated]
--           ,[TimeUpdated]
--           ,[Deleted]
--           ,[TimeDeleted]
--           ,[DeletedByUserId])
select
NEWID() as FixedAssetJournalPageId,
1 as [PageNumber],
1 as Revision,
0 as DocumentStatusId,
convert(datetime, '01-01-2023') as Date,
'Pocetno stanje OS' as Description,
null as RevisionDescription,
null as GeneralJournalPageNumber,
null as ExternalReference,
@journalid as JournalId,
@documentTypeId as DocumentTypeId,
getdate() as PublishDate,
null as RevisionDate,
(select UserId from [iKontCODS].[dbo].[User] where Email='dario.vasilic@premiumosiguranje.com') as CreatedByUserId,
null as UpdatedByUserId,
getdate() as TimeCreated,
null as TimeUpdated,
0 as Deleted,
null as TimeDeleted,
null as DeletedByUserId

GO


