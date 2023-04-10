declare @Description nvarchar(255);
declare @FxAssetClassId uniqueidentifier;
declare @CompanyId uniqueidentifier;
declare @CompanyName nvarchar(250);
declare @FxAssetClassName nvarchar(250);
declare @JournalId uniqueidentifier;
declare @Year int;
declare @DocumentTypeId uniqueidentifier;
declare @DocumentType nvarchar(250);



set @Description = 'Amortizacija na dan 31.3.2022.';
set @FxAssetClassName = 'Automobili';
set @CompanyName = 'Premium';
set @CompanyId = (select companyid from Company where Name=@CompanyName);
set @FxAssetClassId = (select FixedAssetClassId from fa.FixedAssetClass where Description=@FxAssetClassName and CompanyId=@CompanyId);
set @Year = 2022;
set @JournalId = (select JournalID from [fin].[Journal] where Year=@Year and CompanyId=@CompanyId);
set @DocumentType = 'Amortizacija OS'
set @DocumentTypeId = (select DocumentTypeId FROM [dbo].[DocumentType] where TypeDescription=@DocumentType and CompanyId=@CompanyId)

print @CompanyId
print @FxAssetClassId

select
fajp.Description,
fajp.Date,
--fxa.FixedAssetNumber,
--fxa.Description,
--faje.Value,
--sum(faje.ValueCorrection) over (partition by ou.OrganizationalUnitId),
sum(faje.ValueCorrection) as ValueCorrection,
--faje.ValueCorrection,
--fal.Description,
--fal.OrganizationalUnitId,
faae.AccountToDebit,
faae.AccountToCredit,
ou.Name
from
fa.FixedAssetJournalEntry faje
left outer join fa.FixedAsset fxa on faje.FixedAssetId=fxa.FixedAssetId
left outer join fa.FixedAssetJournalPage fajp on faje.FixedAssetJournalPageId=fajp.FixedAssetJournalPageId
left outer join fa.FixedAssetResponsibility far on fxa.FixedAssetId = far.FixedAssetId
left outer join fa.FixedAssetLocation fal on far.FixedAssetLocationId = fal.FixedAssetLocationId
left outer join fin.OrganizationalUnit ou on fal.OrganizationalUnitId = ou.OrganizationalUnitId
left outer join fa.FixedAssetAccountingRule faar on fxa.FixedAssetClassId = faar.FixedAssetClassId
left outer join fa.FixedAssetAccountingRuleEntry faae on faar.FixedAssetAccountingRuleId = faae.FixedAssetAccountingRuleId
where
1=1
--and fajp.Description = @Description
and fajp.JournalId = @JournalId
and fajp.PageNumber = 22
and faar.JournalId = @JournalId
and faar.FixedAssetClassId = @FxAssetClassId
and faar.DocumentTypeId  = @DocumentTypeId
--and fa.FixedAssetClassId = @FxAssetClassId
--and fa.CompanyId = @CompanyId
--order by FixedAssetNumber
group by
fajp.Description,
fajp.Date,
faae.AccountToDebit,
faae.AccountToCredit,
ou.Name

