USE [FineraTESTInterfin]
GO

--Name='Proxima Consulting d.o.o.'
--Code='PROCON'

DECLARE @CompanyCode nvarchar(255);
DECLARE @CompanyID uniqueidentifier;
DECLARE @SequenceNumeber INT;

SET @CompanyCode = 'PROCON';
SET @CompanyID = (SELECT CompanyId from grg.Company where Code=@CompanyCode);
set @SequenceNumeber = (select number from crg.SequencePerCompany where name = 'Party' and CompanyId=@CompanyID);

INSERT INTO [crg].[Party]
           ([PartyId]
           ,[CompanyId]
           ,[CompanySequenceNumber]
           ,[Name]
           ,[Code]
           ,[UID]
           ,[ExternalClientId]
           ,[PersonTypeId]
           ,[IsEmployee]
           ,[IsBank]
           ,[ChangedBy]
           ,[ChangedTime]
           ,[RowVersion]
           ,[ChangeHistory]
           ,[Deleted])
SELECT
newid() as PartyId,
@CompanyID as CompanyId,
Row_number() over (ORDER BY pa.SIFRA ASC)  + @SequenceNumeber as CompanySequenceNumber,
NAZIV as Name,
SIFRA as Code,
SIFRA as UID,
'' as ExternalClientId,
case pa.TIP
	when '1' then 1
	else 2
end as PersonTypeId,
0 as IsEmployee,
0 as IsBank,
'dragoslav.pajic' as ChangedBy,
GETDATE() as ChangedTime,
1 as RowVersion,
null as ChangedHistory,
0 as Deleted
from 
mig.PartneriAccess pa



UPDATE crg.SequencePerCompany
SET Number = (select 
				max(p.CompanySequenceNumber)
				from crg.Party p
				where CompanyId = @CompanyID)
WHERE CompanyId=@CompanyID and Name = 'PARTY'

