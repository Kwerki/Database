-- Erstelle Tabellen
create table Kategorie
(
    KategorieID integer,
    Name varchar(20) not null,
    primary key (KategorieID)
);

create table Artikel
(
    ArtikelID integer,
    KategorieID integer,
    Name varchar(20) not null,
    Beschreibung varchar(100) not null,
    Preis REAL not null CHECK (Preis >= 0),
    primary key (ArtikelID),
    foreign key (KategorieID) references Kategorie(KategorieID)
);

create table Kunde
(
    KundeID integer,
    Vorname varchar(20) not null,
    Nachname varchar(20) not null,
    EMail varchar(30) not null,
    primary key (KundeID)
);

create table Adresse
(
    AdresseID integer,
    KundeID integer,
    Postleitzahl integer not null,
    Stadt varchar(15) not null,
    Adresse varchar(30) not null,
    primary key (AdresseID),
    foreign key (KundeID) references Kunde(KundeID)
);

create table Bestellung
(
    BestellungID integer,
    KundeID integer,
    AdresseID integer not null,
    Datum date not null,
    primary key (BestellungID),
    foreign key (KundeID) references Kunde(KundeID),
    foreign key (AdresseID) references Adresse(AdresseID)
);

create table Rechnung
(
    RechnungID integer,
    BestellungID integer,
    Gesamtpreis REAL,
    AdresseID integer not null,
    Bezahlmethode integer not null,
    primary key (RechnungID),
    foreign key (BestellungID) references Bestellung(BestellungID),
    foreign key (AdresseID) references Adresse(AdresseID)
);

create table ArtikelBestellung
(
    ArtikelBestellungID integer,
    ArtikelID integer,
    BestellungID integer not null,
    Menge integer not null CHECK (Menge > 0),
    primary key (ArtikelBestellungID),
    foreign key (ArtikelID) references Artikel(ArtikelID),
    foreign key (BestellungID) references Bestellung(BestellungID)
);

create table Retoure
(
    RetoureID integer,
    BestellungID integer,
    Grund varchar(100) not null,
    Datum date not null,
    primary key (RetoureID),
    foreign key (BestellungID) references Bestellung(BestellungID)
);

-- Erstelle Trigger
create TRIGGER gesamtpreis
    BEFORE INSERT ON rechnung
    FOR EACH ROW
    BEGIN
        SELECT SUM(artikel.preis * artikelbestellung.menge) INTO :new.gesamtpreis
        FROM Artikelbestellung, Artikel
        WHERE artikelbestellung.bestellungid = :new.bestellungid AND artikelbestellung.artikelid = artikel.artikelid;
    END;
/

-- Erstelle Sequenzen
create sequence IDgen minvalue 1 start with 1 increment by 1 cache 2;

-- Erstelle Test Eintr�ge
alter sequence IDgen restart;
insert into Kategorie values (IDgen.nextval, 'K�che');
insert into Kategorie values (IDgen.nextval, 'Bad');
insert into Kategorie values (IDgen.nextval, 'Wohnzimmer');
insert into Kategorie values (IDgen.nextval, 'Schlafzimmer');
insert into Kategorie values (IDgen.nextval, 'Aufbewahrung');

alter sequence IDgen restart;
insert into Artikel values (IDgen.nextval, 1, 'Herd', 'Toller Herd', 356.28);
insert into Artikel values (IDgen.nextval, 2, 'Waschmaschine', 'Coole Waschmaschine', 499.99);
insert into Artikel values (IDgen.nextval, 4, 'Bett', 'Stabieles Bett', 289.67);
insert into Artikel values (IDgen.nextval, 5, 'Regal', 'Gro�es Regal', 90.05);
insert into Artikel values (IDgen.nextval, 4, 'Kleiderschrank', 'Hoher Kleiderschrank', 210.56);
insert into Artikel values (IDgen.nextval, 1, 'Toaster', 'Nicer Toaster', 45.00);
insert into Artikel values (IDgen.nextval, 3, 'Couch', 'Bequeme Couch', 370.10);
insert into Artikel values (IDgen.nextval, 5, 'Kiste', 'Kleine Kiste', 14.99);
insert into Artikel values (IDgen.nextval, 2, 'Kopapierhalter', 'Kopapierhalter', 19.99);
insert into Artikel values (IDgen.nextval, 3, 'Tisch', 'Toller Couchtisch', 180.99);

alter sequence IDgen restart;
insert into Kunde values (IDgen.nextval, 'Peter', 'Hanz', 'peterhanz@gmail.com');
insert into Kunde values (IDgen.nextval, 'Klaus', 'Muster', 'KlausMuster@gmail.com');
insert into Kunde values (IDgen.nextval, 'Paul', 'Zimmer', 'PaulZimmer@gmail.com');
insert into Kunde values (IDgen.nextval, 'Florian', 'Frohe', 'FlorianFrohe@gmail.com');
insert into Kunde values (IDgen.nextval, 'Tim', 'Hufele', 'TimH�ufele@gmail.com');
insert into Kunde values (IDgen.nextval, 'Emma', 'Lopez', 'emmalopez@gmail.com');
insert into Kunde values (IDgen.nextval, 'Olivia', 'Smith', 'oliviasmith@gmail.com');
insert into Kunde values (IDgen.nextval, 'Ava', 'Johnson', 'avajohnson@gmail.com');
insert into Kunde values (IDgen.nextval, 'Isabella', 'Williams', 'isabellawilliams@gmail.com');
insert into Kunde values (IDgen.nextval, 'Sophia', 'Brown', 'sophiabrown@gmail.com');
insert into Kunde values (IDgen.nextval, 'Mia', 'Jones', 'miajones@gmail.com');
insert into Kunde values (IDgen.nextval, 'Charlotte', 'Miller', 'charlottemiller@gmail.com');
insert into Kunde values (IDgen.nextval, 'Amelia', 'Davis', 'ameliadavis@gmail.com');
insert into Kunde values (IDgen.nextval, 'Harper', 'Garcia', 'harpergarcia@gmail.com');
insert into Kunde values (IDgen.nextval, 'Evelyn', 'Rodriguez', 'evelynrodriguez@gmail.com');

alter sequence IDgen restart;
insert into Adresse values (IDgen.nextval, 3, 04103, 'Leipzig', 'Karl-Heine Stra�e 1');
insert into Adresse values (IDgen.nextval, 1, 34735, 'M�nchen', 'Musterstra�e 2');
insert into Adresse values (IDgen.nextval, 2, 08175, 'Hamburg', 'Dorfstra�e 7');
insert into Adresse values (IDgen.nextval, 5, 17680, 'Berlin', 'Bunte Stra�e 1');
insert into Adresse values (IDgen.nextval, 3, 93356, 'K�ln', 'Schwarzstra�e 9');
insert into Adresse values (IDgen.nextval, 4, 04103, 'Leipzig', 'Karl-Heine Stra�e 1');
insert into Adresse values (IDgen.nextval, 4, 34735, 'M�nchen', 'Musterstra�e 2');
insert into Adresse values (IDgen.nextval, 5, 08175, 'Hamburg', 'Dorfstra�e 7');
insert into Adresse values (IDgen.nextval, 1, 17680, 'Berlin', 'Bunte Stra�e 1');
insert into Adresse values (IDgen.nextval, 2, 93356, 'K�ln', 'Schwarzstra�e 9');
insert into Adresse values (IDgen.nextval, 6, 12073, 'Berlin', 'Sonnenallee 10');
insert into Adresse values (IDgen.nextval, 7, 70469, 'Stuttgart', 'Hauptstra�e 1');
insert into Adresse values (IDgen.nextval, 8, 60323, 'Frankfurt', 'Bahnhofstra�e 2');
insert into Adresse values (IDgen.nextval, 9, 80636, 'M�nchen', 'Am Olympiapark 1');
insert into Adresse values (IDgen.nextval, 10, 40237, 'D�sseldorf', 'Rheinuferstra�e 3');
insert into Adresse values (IDgen.nextval, 11, 80336, 'M�nchen', 'Schwanthalerstra�e 4');
insert into Adresse values (IDgen.nextval, 12, 10999, 'Berlin', 'Kreuzbergstra�e 5');
insert into Adresse values (IDgen.nextval, 13, 20146, 'Hamburg', 'Alsterstra�e 6');
insert into Adresse values (IDgen.nextval, 14, 50667, 'K�ln', 'Hohe Stra�e 7');
insert into Adresse values (IDgen.nextval, 15, 80333, 'M�nchen', 'Marienplatz 8');

alter sequence IDgen restart;
insert into Bestellung values(IDgen.nextval, 5, 8, '06-MAI-2022');
insert into Bestellung values(IDgen.nextval, 4, 7, '22-JUL-2022');
insert into Bestellung values(IDgen.nextval, 1, 2, '27-MRZ-2022');
insert into Bestellung values(IDgen.nextval, 3, 1, '02-JAN-2023');
insert into Bestellung values(IDgen.nextval, 4, 6, '23-DEZ-2022');
insert into Bestellung values(IDgen.nextval, 2, 3, '10-DEZ-2022');
insert into Bestellung values(IDgen.nextval, 2, 10, '23-NOV-2022');

alter sequence IDgen restart;
insert into ArtikelBestellung values(IDgen.nextval, 3, 7, 1);
insert into ArtikelBestellung values(IDgen.nextval, 5, 6, 3);
insert into ArtikelBestellung values(IDgen.nextval, 6, 6, 5);
insert into ArtikelBestellung values(IDgen.nextval, 8, 4, 6);
insert into ArtikelBestellung values(IDgen.nextval, 6, 3, 1);
insert into ArtikelBestellung values(IDgen.nextval, 2, 2, 1);
insert into ArtikelBestellung values(IDgen.nextval, 7, 1, 1);
insert into ArtikelBestellung values(IDgen.nextval, 4, 2, 1);
insert into ArtikelBestellung values(IDgen.nextval, 7, 4, 1);
insert into ArtikelBestellung values(IDgen.nextval, 1, 5, 3);

alter sequence IDgen restart;
insert into Rechnung values(IDgen.nextval, 4, null, 1, 2);
insert into Rechnung values(IDgen.nextval, 3, null, 2, 0);
insert into Rechnung values(IDgen.nextval, 1, null, 8, 1);
insert into Rechnung values(IDgen.nextval, 2, null, 7, 2);
insert into Rechnung values(IDgen.nextval, 7, null, 10, 1);
insert into Rechnung values(IDgen.nextval, 6, null, 3, 0);
insert into Rechnung values(IDgen.nextval, 5, null, 6, 1);

alter sequence IDgen restart;
insert into Retoure values(IDgen.nextval, 3, 'Defekt', '02-APR-2022');
insert into Retoure values(IDgen.nextval, 6, 'Fehlkauf', '30-DEZ-2022');
insert into Retoure values(IDgen.nextval, 1, 'Falscher Artikel', '10-MAI-2022');

-- Erstelle Views
-- Zu welchem Artikel gehört welche Kategorie
CREATE VIEW artikel_kategorie AS
    SELECT kategorie.name as Kategorie, artikel.name as Artikel
    FROM Kategorie
    INNER JOIN Artikel ON artikel.kategorieid = kategorie.kategorieid;

-- Bestellung ab 2023
CREATE VIEW bestellung_ab_2023 AS
    SELECT Datum, BestellungID, KundeID
    FROM Bestellung
    WHERE datum >= '31-DEZ-2022';

--Z�hlt wie of Artiekl verkauft wurde
CREATE VIEW artikel_verkaufe AS
    select artikel.name as Artikel, sum(artikelbestellung.menge) as Anzahl
    from Artikel, Artikelbestellung
    where artikelbestellung.artikelid = artikel.artikelid
    group by artikel.name;
    
--Z�hlt h�ufigsten St�dte
CREATE VIEW kunden_standort AS
    select adresse.stadt as Stadt, count(adresse.stadt) as Anzahl
    from Adresse
    group by adresse.stadt;
    
commit;