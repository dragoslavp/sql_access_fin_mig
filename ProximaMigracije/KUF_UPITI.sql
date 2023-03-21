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
mig.KUF k
where
1=1
and k.Datum >= convert(datetime, '01-01-2022') and k.Datum <= convert(datetime, '12-31-2023')
;