# Opis problemu
Projekt dotyczy systemu wspomagania działalności firmy świadczącej usługi gastronomiczne dla klientów
indywidualnych oraz firm.
# Ogólne informacje
W ofercie jest żywność (np. ciastka, lunch, drobne przekąski) oraz napoje bezalkoholowe (np. kawa, koktajle, woda).
Usługi świadczone są na miejscu oraz na wynos. Zamówienie na wynos może być zlecone na miejscu lub
z wyprzedzeniem (z wykorzystaniem formularza WWW i wyboru preferowanej daty i godziny odbioru zamówienia).
Firma dysponuje ograniczoną liczbą stolików, w tym miejsc siedzących. Istnieje możliwość wcześniejszej rezerwacji
stolika dla co najmniej dwóch osób.
Klientami są osoby indywidualne oraz firmy (odbierają większe ilości posiłków w porze lunchu lub jako catering, bez
dostawy). Istnieje możliwość wystawienia faktury dla danego zamówienia lub faktury zbiorczej raz na miesiąc.
# Menu
Menu ustalane jest co najmniej dziennym wyprzedzeniem. W firmie panuje zasada, że co najmniej połowa pozycji
menu zmieniana jest co najmniej raz na dwa tygodnie.
W dniach czwartek-piątek-sobota istnieje możliwość wcześniejszego zamówienia dań zawierających owoce morza.
Z uwagi na indywidualny import takie zamówienie winno być złożone maksymalnie do poniedziałku
poprzedzającego zamówienie.
# Wcześniejsza rezerwacja zamówienia/stolika
Internetowy formularz umożliwia klientowi indywidualnemu rezerwację stolika, przy jednoczesnym złożeniu
zamówienia, z opcją płatności przed lub po zamówieniu, przy minimalnej wartości zamówienia WZ (np. WZ=50 zł),
w przypadku klientów, którzy dokonali wcześniej co najmniej WK zamówień (np. WK=5). Informacja wraz z
potwierdzeniem zamówienia oraz wskazaniem stolika; wysyłana jest po akceptacji przez obsługę.
Internetowy formularz umożliwia także rezerwację stolików dla firm, w dwóch opcjach: rezerwacji stolików na firmę
i/lub rezerwację stolików dla konkretnych pracowników firmy (imiennie).
# Rabaty
System umożliwia realizację programów rabatowych dla klientów indywidualnych:
• Po realizacji ustalonej liczby zamówień Z1 (przykładowo Z1=10) za co najmniej określoną kwotę K1 (np. 30
zł każde zamówienie): R1% (np. 3%) zniżki na wszystkie zamówienia;
• Po realizacji zamówień za łączną kwotę K2 (np. 1000 zł): jednorazowa zniżka R2% (np. 5%) na zamówienia
złożone przez D1 dni (np. D1 = 7), począwszy od dnia przyznania zniżki (zniżki nie łączą się).
# Raporty
System umożliwia generowanie raportów miesięcznych i tygodniowych, dotyczących rezerwacji stolików, rabatów,
menu, a także statystyk zamówienia – dla klientów indywidualnych oraz firm – dotyczących kwot oraz czasu
składania zamówień.
System umożliwia także generowanie raportów dotyczących zamówień oraz rabatów dla klienta indywidualnego
oraz firm.
# Wymagane elementy w projekcie
1. propozycja funkcji realizowanych przez system – wraz z określeniem który użytkownik jakie funkcje może
realizować (krótka lista);
2. projekt bazy danych;
3. zdefiniowanie bazy danych;
4. zdefiniowanie warunków integralności: wykorzystanie wartości domyślnych, ustawienie dopuszczalnych
zakresów wartości, unikalność wartości w polach, czy dane pole może nie zostać wypełnione, złożone warunki
integralnościowe;
5. propozycja oraz zdefiniowanie operacji na danych (procedury składowane, triggery, funkcje) - powinny zostać
zdefiniowane procedury składowane do wprowadzania danych (także do zmian konfiguracyjnych). Należy
stworzyć także funkcje zwracające istotne ilościowe informacje. Triggery należy wykorzystać do zapewnienia
spójności oraz spełnienia przez system specyficznych wymagań klienta;
6. propozycja oraz zdefiniowanie struktury widoków ułatwiających dostęp do danych – widoki powinny
prezentować dla użytkowników to, co ich najbardziej interesuje. Ponadto powinny zostać zdefiniowane widoki
dla różnego typu raportów;  
    * propozycja oraz zdefiniowanie indeksów;
    * propozycja oraz określenie uprawnień do danych - należy zaproponować role oraz ich uprawnienia do operacji,
widoków, procedur.
# Sprawozdanie powinno zawierać:
1. opis funkcji systemu wraz z informacją, co jaki użytkownik może wykonywać w systemie  
2. schemat bazy danych (w postaci diagramu) + opis poszczególnych tabel (nazwy pól, typ danych i znaczenie każdego pola, a także opis warunków integralności, jakie zostały zdefiniowane dla danego pola + kod generujący daną tabelę);
3. spis widoków wraz z kodem, który je tworzy oraz informacją co one przedstawiają;  
4. spis procedur składowanych, triggerów, funkcji wraz z ich kodem i informacją co one robią;  
5. informacje odnośnie wygenerowanych danych;  
6. określenie uprawnień do danych - opis ról wraz z przyporządkowaniem do jakich elementów dana rola powinna
mieć uprawnienia;  
7. informacja, do jakich pól stworzone są indeksy.  