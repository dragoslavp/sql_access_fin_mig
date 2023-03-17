USE [FineraTESTInterfin]
GO

DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;

SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);

INSERT INTO [crg].[PartyHistory]
           ([PartyHistoryId]
           ,[PartyId]
           ,[EffectiveDate]
           ,[DefectiveDate]
           ,[IsEmployee]
           ,[PersonLocationId]
           ,[EntityLegalFormId]
           ,[Name]
           ,[UID]
           ,[VatPayer]
           ,[VatNumber]
           ,[LegalEntityStatisticNumber]
           ,[LegalEntityConnectedEntity]
           ,[CountryId]
           ,[CountryStateId]
           ,[CountryRegionId]
           ,[CountryMunicipalityId]
           ,[Place]
           ,[Address]
           ,[Phone]
           ,[MobilePhone]
           ,[Fax]
           ,[EMail]
           ,[WebSiteUrl]
           ,[AccountingInstructions]
           ,[BankAccount]
           ,[BankSubAccount]
           ,[Note]
           ,[Deactivated]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory]
           ,[Deleted])
SELECT
newid() as PartyHistoryId,
p.PartyId as PartyId,
CAST('01/01/2022' as date) as EffectiveDate,
null as DefectiveDate,
0 as IsEmployee,
1 as PersonLocationId,
null as EntityLegalFormId,
p.Name as NAME,
pa.JIB as UID,
case pa.INVATSYSTEM
	when 'FALSE' then 0
	else 1
end as VatPayer,
case pa.INVATSYSTEM
	when 'FALSE' then ''
	else pa.PIB 
end as VatNumber,
pa.MATICNIBROJ as LegalEntityStatisticNumber,
0 as LegalEntityConnectedEntity,
(select CountryId from grg.Country where Name='Bosna i Hercegovina') as CountryId,
case pa.ENTITET
	when 'FBIH' then (select CountryStateId from grg.CountryState where Name='Federacija Bosne i Hercegovine')
	when 'Republika Srpska' then (select CountryStateId from grg.CountryState where Name='Republika Srpska')
	when 'Brčko Distrikt' then (select CountryStateId from grg.CountryState where Name='Brčko distrikt')
	else null
end as  CountryStateId,
null as  CountryRegionId,
null as  CountryMunicipalityId,
pa.MJESTO as  Place,
pa.ULICA as  Address,
pa.TELEFON as  Phone,
pa.MOBILNITELEFON as  MobilePhone,
pa.FAX as  Fax,
pa.EMAIL as  EMail,
null as  WebSiteUrl,
null as  AccountingInstructions,
null as  BankAccount,
null as  BankSubAccount,
null as  Note,
'0' as Deactivated,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory,
0 as Deleted
FROM
mig.PartneriAccess pa left outer join crg.Party p on pa.SIFRA = p.Code
where 
1=1
and p.CompanyId=@CompanyID
and p.PersonTypeId=2

GO

