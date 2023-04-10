select
k.*,
d.BROJ,
d.KONTO,
d.DUGUJE,
d.POTRAZUJE
from
mig.KUF k
left outer join mig.dnevnik d on k.JournalPageNumber=d.BROJ
where 
1=1
and k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2022')
and d.godina=2022








select
*
from
inv.BillPageEntry;



with proizvodi as 
(
select
Opis as opis,
JournalPageNumber jpn
from mig.KUF k
where 
1=1
and k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2023')
),
b as (
select
a.opis,
d.konto
from
proizvodi a left outer join mig.dnevnik d on a.jpn = d.broj
where 
1=1
and substring(d.konto,1,1)='5'
)
select
 *
from
b;


select
*
from 
mig.dnevnik d
where
1=1
and substring(d.konto,1,1)='5'

select
*
from 
mig.dnevnik d
where
1=1
and substring(d.opis,1,3)='KUF'
and VD='UR'


with a as (
select
k.Opis,
d.Konto
from 
mig.dnevnik d 
left outer join mig.KUF k on d.BROJ=k.JournalPageNumber and d.godina = year(k.datum)
where
1=1
and d.broj in (select k.JournalPageNumber
			   from
			   mig.KUF k where k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2022') )
and substring(d.konto,1,1)='5'
and d.godina=2022
)
select
distinct opis, konto
from
a

select
*
from
mig.KUF k
where
1=1
and k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2022')
;

