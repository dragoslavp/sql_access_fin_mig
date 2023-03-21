# Migracija podataka iz Access fajla u bazu Finera

***Prije izvršavanja skripti potrebno je podatke iz Access fajla učitati u migracione tabele***

Redoslijed izvršavanja skripti.

1. insertPartners.sql
2. insertPartnersHistory.sql
3. insertPartnersHistoryNaturalPerson.sql
4. insertJournalPage.sql ***(kreira naloge u statusu Aktivan)***
5. insertJournalPageEntry.sql
6. insertBillPage.sql ***(kreira račune/KUF u statusu Radno)***
7. insertBillPageEntry.sql 
8. insertInvoicePage.sql ***(kreira fakture/KIF u statusu Radno)***
9. insertInvoicePageEntry.sql 
