SELECT
*
FROM
MIG.dnevnik;

SELECT
*
FROM
MIG.nalozi;



SELECT
*
FROM
fin.JournalPage
where LedgerId=9
;


select
*
from
fin.JournalPageEntry;

select 
broj,
sum(DUGUJE) over (PARTITION BY broj) as D,
sum(POTRAZUJE) over (PARTITION BY broj) as P
from mig.dnevnik
where
1=1
and GODINA=2022;

select 
convert (int, BROJ) as rb, 
sum(DUGUJE) as d,
sum(POTRAZUJE) as p,
sum(DUGUJE) - sum(POTRAZUJE) as saldo
from mig.dnevnik
where
1=1
and GODINA=2023
group by BROJ
having  sum(DUGUJE) - sum(POTRAZUJE) <>0
order by rb
;

--TRUNCATE TABLE mig.dnevnikAccess;


select
*
from
mig.ZaglavljeFakt;

select
*
from
mig.fakture;

select
*
from
mig.nalozi n
where
(n.BROJ not in (select JournalPageNumber FROM mig.KUF where datum >= CAST('01/01/'+ CAST(@Year as varchar) as date) and datum <= CAST('12/31'+CAST(@Year as varchar) as date))
or n.BROJ not in (select distinct nalog from mig.ZaglavljeFakt where datum >= CAST('01/01/'+ CAST(@Year as varchar) as date) and datum <= CAST('12/31'+CAST(@Year as varchar) as date)))

select
*
from
mig.dnevnik d
--left outer join mig.nalozi n on d.BROJ=n.BROJ
left outer join fin.JournalPage jp on d.BROJ = jp.ExternalReference
--where d.broj=13
and jp.ExternalReference is not null


select
*
from
mig.dnevnik d
--left outer join mig.nalozi n on d.BROJ=n.BROJ
where
1=1
and godina = 2022
and d.BROJ not in (select JournalPageNumber FROM mig.KUF where datum >= CAST('01/01/2022' as date) and datum <= CAST('12/31/2022'  as date))
and d.BROJ not in (select distinct nalog from mig.ZaglavljeFakt where datum >= CAST('01/01/2022' as date) and datum <= CAST('12/31/2022' as date))
;


select
*
from
fin.JournalPage jp
order by cast(ExternalReference as int)