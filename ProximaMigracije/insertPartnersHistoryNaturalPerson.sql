USE [FineraTESTInterfin]
GO

DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;

SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);


INSERT INTO [crg].[PartyHistoryNaturalPerson]
           ([PartyHistoryNaturalPersonId]
           ,[FirstName]
           ,[ParentName]
           ,[LastName]
           ,[DateOfBirth]
           ,[BirthPlace]
           ,[NationalityCountryId]
           ,[IdDocumentTypeId]
           ,[IdDocumentNumber]
           ,[IdDocumentValidFrom]
           ,[IdDocumentValidTo]
           ,[IdIsPermanent]
           ,[GenderId]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory]
           ,[Deleted]
           ,[HasDisability])
select
ph.PartyHistoryId as PartyHistoryNaturalPersonId,
pa.IME as FirstName,
pa.IMERODITELJA as ParentName,
pa.PREZIME as LastName,
pa.BIRTHDATE as DateOfBirth,
null as BirthPlace,
null as NationalityCountryId,
null as IdDocumentTypeId,
null as IdDocumentNumber,
null as IdDocumentValidFrom,
null as IdDocumentValidTo,
0 as IdIsPermanent,
case pa.POL           
when 'MUSKI' then 1
when 'ZENSKI' then 2
else null
end as GenderId,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory,
0 as Deleted,
null as HasDisability
FROM
mig.PartneriAccess pa 
left outer join crg.Party p on pa.SIFRA = p.Code
left outer join crg.PartyHistory ph on p.PartyId=ph.PartyId
where 
1=1
and p.CompanyId=@CompanyID
and p.PersonTypeId=2


GO


