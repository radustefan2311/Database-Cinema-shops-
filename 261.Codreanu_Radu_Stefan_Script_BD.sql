--NUME: CODREANU
--PRENUME: RADU STEFAN
--GRUPA: 261


--CREARE ENTITATI

--TABELUL MAGAZIN

CREATE TABLE "Magazin"
(
Magazin_id number(4) CONSTRAINT Magazin_Magazin_id_PK PRIMARY KEY,
Nume varchar2(25) CONSTRAINT Magazin_Nume_c1 CHECK (LENGTH(Nume) >= 1) CONSTRAINT Magazin_Nume_nn NOT NULL CONSTRAINT Magazin_Nume_c2 CHECK (Nume NOT LIKE '%[^A-Z]%'),
Oras varchar2(15) CONSTRAINT Magazin_Oras_nn NOT NULL CONSTRAINT Magazin_Oras_c CHECK (Oras NOT LIKE '%[^A-Z]%'),
Numar_telefon varchar2(11) CONSTRAINT Magazin_Telefon_u UNIQUE CONSTRAINT Magazin_Telefon_c1 CHECK (Numar_telefon NOT LIKE '%[^0-9]%') CONSTRAINT Magazin_Telefon_nn NOT NULL CONSTRAINT Magazin_telefon_c2 CHECK (LENGTH (Numar_telefon)=10),
Email varchar2(25) CONSTRAINT Magazin_Email_nn NOT NULL CONSTRAINT Magazin_Email_u UNIQUE,
Website varchar2(25) CONSTRAINT Magazin_Website_nn NOT NULL CONSTRAINT Magazin_Website_u UNIQUE 
);

--TABELUL DISTRIBUITOR

CREATE TABLE "Distribuitor"
(
Distribuitor_id number(4) CONSTRAINT Distr_Distr_id_PK PRIMARY KEY,
Nume varchar2(25) CONSTRAINT Distr_Nume_nn NOT NULL CONSTRAINT Distr_Nume_c CHECK (Nume NOT LIKE '%[^A-Z]%'),
Sediu varchar2(20) CONSTRAINT Distr_Sediu_nn NOT NULL,
Data_fondarii date CONSTRAINT Distr_Data_fondarii_nn NOT NULL,
Proprietar varchar2(15) CONSTRAINT Distr_Proprietar_nn NOT NULL CONSTRAINT Distr_Proprietar_c CHECK (Proprietar NOT LIKE '%[^A-Z]%'), 
Website varchar2(25) CONSTRAINT Distr_Website_nn NOT NULL
);

-- Daca lasam Distribuitor la constraint-uri nu putea sa rulez din cauza lungimii

--TABELUL FILM 

CREATE TABLE "Film"
(
Film_id number(4) CONSTRAINT Film_Film_id_PK PRIMARY KEY,
Nume varchar2(25) CONSTRAINT Film_Nume_nn NOT NULL CONSTRAINT Film_Nume_c CHECK (LENGTH(Nume) >=1),
Durata number(3) CONSTRAINT Film_Durata_nn NOT NULL CONSTRAINT Film_Durata_c1 CHECK (Durata NOT LIKE '%[^0-9]%') CONSTRAINT Film_Durata_c2 CHECK (Durata >30),
Pegi varchar(10) CONSTRAINT Film_Pegi_nn NOT NULL,
Limba varchar(15) CONSTRAINT Film_Limba_nn NOT NULL CONSTRAINT Film_Limba_c CHECK (Limba NOT LIKE '%[^A-Z]%'),
Gen varchar(10) CONSTRAINT Film_Gen_nn NOT NULL,
Pret number(4) CONSTRAINT Film_Pret_nn NOT NULL CONSTRAINT Film_Pret_c CHECK (Pret >0),
Distribuitor_id number(4) CONSTRAINT Film_Distr_id_FK REFERENCES "Distribuitor" (Distribuitor_id) ON DELETE SET NULL
);

--TABELUL INTERMEDIAR VINDEFILM

CREATE TABLE "VindeFilm"
(
Magazin_id number(4) CONSTRAINT VindeFilm_Magazin_id_FK REFERENCES "Magazin" (Magazin_id) ON DELETE CASCADE,
Film_id number(4) CONSTRAINT VindeFilm_Film_id_FK REFERENCES "Film" (Film_id) ON DELETE CASCADE,
CONSTRAINT VindeFilm_PK PRIMARY KEY (Magazin_id, Film_id)
);

--TABELUL REGIZOR

CREATE TABLE "Regizor"
(
Regizor_id number(4) CONSTRAINT Regizor_Regizor_id_PK PRIMARY KEY,
Nume varchar2(20) CONSTRAINT Regizor_Nume_nn NOT NULL CONSTRAINT Regizor_Nume_c CHECK (Nume NOT LIKE '%[^A-Z]%'),
Prenume varchar2(20) CONSTRAINT Regizor_Prenume_nn NOT NULL CONSTRAINT Regizor_Prenume_c CHECK (Prenume NOT LIKE '%[^A-Z]%'),
Data_nasterii date CONSTRAINT Regizor_Data_nasterii_nn NOT NULL,
Email varchar2(25) CONSTRAINT Regizor_Email_nn NOT NULL CONSTRAINT Regizor_Email_u UNIQUE,
Studii_superioare char(1) CONSTRAINT Regizor_Studii_superioare_c CHECK (Studii_superioare IN ('D', 'N'))
);


--TABELUL REGIZEAZAFILM

CREATE TABLE "RegizeazaFilm"
(
Film_id number(4) CONSTRAINT RegizeazaFilm_Film_id_FK REFERENCES Film (Film_id) ON DELETE CASCADE,
Regizor_id number(4) CONSTRAINT RegizeazaFilm_Regizor_id_FK REFERENCES Regizor (Regizor_id) ON DELETE CASCADE,
CONSTRAINT RegizeazaFilm_PK PRIMARY KEY (Film_id, Regizor_id)
);

--TABELUL FORMAT

CREATE TABLE "Format"
(
Format_id number(4) CONSTRAINT Format_Format_id_PK PRIMARY KEY,
Tip varchar2 (10) CONSTRAINT Format_Tip_nn NOT NULL CONSTRAINT Format_Tip_c CHECK (Tip NOT LIKE '%[^A-Z]%')
);

--TABELUL INCADREAZAFILM

CREATE TABLE "IncadreazaFilm"
(
Film_id number(4) CONSTRAINT IncadreazaFilm_Film_id_FK REFERENCES Film (Film_id) ON DELETE CASCADE,
Format_id number(4) CONSTRAINT IncadreazaFilm_Format_id_FK REFERENCES "Format" (Format_id) ON DELETE CASCADE,
CONSTRAINT IncadreazaFilm_PK PRIMARY KEY (Film_id, Format_id)
);

--TABELUL COMANDA

CREATE TABLE "Comanda"
(
Comanda_id number(4) CONSTRAINT Comanda_Comanda_id_PK PRIMARY KEY,
Awb varchar2 (50) CONSTRAINT Comanda_Awb_nn NOT NULL CONSTRAINT Comanda_Awb_u UNIQUE,
Status varchar2 (15) CONSTRAINT Comanda_Status_nn NOT NULL CONSTRAINT Comanda_Status_c CHECK (Status NOT LIKE '%[^A-Z]%'),
Data_plasare date CONSTRAINT Comanda_Data_plasare_nn NOT NULL,
Data_livrare date CONSTRAINT Comanda_Data_livrare_nn NOT NULL,
CONSTRAINT Comanda_Data_plasare_c CHECK (Data_plasare < Data_livrare),
Curier_id number(4) CONSTRAINT Comanda_Curier_id_FK REFERENCES "Curier" (Curier_id) ON DELETE SET NULL,
Client_id number(4) CONSTRAINT Comanda_Client_id_FK REFERENCES "Client" (Client_id) ON DELETE CASCADE
);

--TABELUL CURIER

CREATE TABLE "Curier"
(
Curier_id number(4) CONSTRAINT Curier_Curier_id_PK PRIMARY KEY,
Nume varchar2(20) CONSTRAINT Curier_Nume_nn NOT NULL CONSTRAINT Curier_Nume_c CHECK (Nume NOT LIKE '%[^A-Z]%') CONSTRAINT Curier_Nume_u UNIQUE,
Prenume varchar2(20) CONSTRAINT Curier_Prenume_nn NOT NULL CONSTRAINT Curier_Prenume_c CHECK (Prenume NOT LIKE '%[^A-Z]%') CONSTRAINT Curier_Prenume_u UNIQUE,
Cost_transport number(10) CONSTRAINT Curier_Cost_transport_nn NOT NULL,
Firma_curierat varchar2(20) CONSTRAINT Curier_Firma_curierat_nn NOT NULL,
Telefon varchar2(11) CONSTRAINT Curier_Telefon_u UNIQUE CONSTRAINT Curier_Telefon_c1 CHECK (Telefon NOT LIKE '%[^0-9]%') CONSTRAINT Curier_Telefon_nn NOT NULL
);

--TABELUL ADRESA

CREATE TABLE "Adresa"
(
Adresa_id number(4) CONSTRAINT Adresa_Adresa_id_PK PRIMARY KEY,
Judet varchar(15) CONSTRAINT Adresa_Judet_nn NOT NULL CONSTRAINT Adresa_Judet_c CHECK (Judet NOT LIKE '%[^A-Z]%'),
Oras varchar(15) CONSTRAINT Adresa_Oras_nn NOT NULL CONSTRAINT Adresa_Oras_c CHECK (Oras NOT LIKE '%[^A-Z]%'),
Strada varchar(15) CONSTRAINT Adresa_Strada_nn NOT NULL CONSTRAINT Adresa_Strada_c CHECK (Strada NOT LIKE '%[^A-Z]%'),
Numar number(5) CONSTRAINT Adresa_Numar_nn NOT NULL CONSTRAINT Adresa_Numar_c CHECK (Numar NOT LIKE '%[^0-9]%'),
"Bloc" varchar(5),
Cod_postal number(20) CONSTRAINT Adresa_Cod_postal_nn NOT NULL CONSTRAINT Adresa_Cod_postal_c CHECK (Cod_postal NOT LIKE '%[^0-9]%')
);

--TABELUL CLIENT

CREATE TABLE "Client"
(
Client_id number(4) CONSTRAINT Client_Client_id_PK PRIMARY KEY,
Nume varchar2(20) CONSTRAINT Client_Nume_nn NOT NULL CONSTRAINT Client_Nume_c CHECK (Nume NOT LIKE '%[^A-Z]%') CONSTRAINT Client_Nume_u UNIQUE,
Prenume varchar2(20) CONSTRAINT Client_Prenume_nn NOT NULL CONSTRAINT Client_Prenume_c CHECK (Prenume NOT LIKE '%[^A-Z]%') CONSTRAINT Client_Prenume_u UNIQUE,
Email varchar(20) CONSTRAINT Client_Email_nn NOT NULL CONSTRAINT Client_Email_u UNIQUE,
Telefon varchar(11) CONSTRAINT Client_Telefon_nn NOT NULL,
Data_nasterii date CONSTRAINT Client_Data_nasterii_nn NOT NULL,
Adresa_id number(4) CONSTRAINT Client_Adresa_id_FK REFERENCES "Adresa" (Adresa_id) ON DELETE CASCADE
);

--TABELUL FILMCOMANDA

CREATE TABLE "FilmComanda"
(
Film_id number(4) CONSTRAINT FilmComanda_Film_id_FK REFERENCES "Film" (Film_id) ON DELETE CASCADE,
Comanda_id number(4) CONSTRAINT FilmComanda_Comanda_id_FK REFERENCES "Comanda" (Comanda_id) ON DELETE CASCADE,
CONSTRAINT FilmComanda_PK PRIMARY KEY (Comanda_id, Film_id),
Cantitate number(5) CONSTRAINT FilmComanda_Cantitate_nn NOT NULL
);


--INSERARE DATE IN TABELE

--1-MAGAZIN

INSERT INTO "Magazin" 
VALUES (1000,'Blockbuster','Bucuresti','0712453687','blockbuster@gmail.com','www.blockbuster.ro'); 
INSERT INTO "Magazin" 
VALUES (1001,'CinemaTown','Targoviste','0712458587','cinematown@gmail.com','www.cinematown.ro');
INSERT INTO "Magazin" 
VALUES (1002,'MiracleMovie','Constanta','0710528587','miraclemovie@gmail.com','www.miraclemovie.ro');
INSERT INTO "Magazin" 
VALUES (1003,'IMOVIE','Cluj-Napoca','0712973487','imovie@gmail.com','www.imovie.ro');
INSERT INTO "Magazin" 
VALUES (1004,'Super-Movie','Timisoara','0717948587','supermovie@gmail.com','www.supermovie.ro');
INSERT INTO "Magazin" 
VALUES (1005,'Cinefil','Iasi','0774358587','cinefil@gmail.com','www.cinefil.ro');

commit;

--2-DISTRIBUITOR

INSERT INTO "Distribuitor"
VALUES (2000,'Sony Pictures','Toronto','15-01-1967','Sony','www.sonypictures.com');
INSERT INTO "Distribuitor"
VALUES (2001,'Disney Pictures','Paris','12-11-1921','Walt Disney','www.disneypictures.com');
INSERT INTO "Distribuitor"
VALUES (2002,'20th Century Fox','Los Angeles','31-05-1935','Walt Disney','www.20thfoxcom');
INSERT INTO "Distribuitor"
VALUES (2003,'Paramount Pictures','Hollywood','08-05-1912','ViacomCBS','www.paramountpictures.com');
INSERT INTO "Distribuitor"
VALUES (2004,'A24','New York City','20-08-2012','A24 Films','www.a24.com');
INSERT INTO "Distribuitor"
VALUES (2005,'New Line Productions','Burbank','18-06-1967','New Line Cinema','www.newlineprod.com');

commit;

--3-FILM

INSERT INTO "Film"
VALUES (3000, 'Spider-Man 2', 185, 'PG-8', 'Engleza', 'Superhero', 20, 2000);
INSERT INTO "Film"
VALUES (3001, 'Regele Leu', 128, 'PG-3', 'Romana', 'Aventura', 25, 2001);
INSERT INTO "Film"
VALUES (3002, 'Deadpool', 145, 'R-18', 'Engleza', 'Actiune', 30, 2002);
INSERT INTO "Film"
VALUES (3003, 'Scream', 110, 'NC-17', 'Engleza', 'Horror', 15, 2003);
INSERT INTO "Film"
VALUES (3004, 'Ex Machina', 158, 'PG-13', 'Germana', 'Sci-Fi', 20, 2004);
INSERT INTO "Film"
VALUES (3005, 'The Lord of the Rings', 210, 'PG-13', 'Romana', 'Fantasy', 35, 2005);

commit;

--4-VINDEFILM

INSERT INTO "VindeFilm"
VALUES (1000, 3000);
INSERT INTO "VindeFilm"
VALUES (1001, 3001);
INSERT INTO "VindeFilm"
VALUES (1002, 3002);
INSERT INTO "VindeFilm"
VALUES (1003, 3003);
INSERT INTO "VindeFilm"
VALUES (1004, 3004);
INSERT INTO "VindeFilm"
VALUES (1005, 3005);

commit;

--5-REGIZOR

INSERT INTO "Regizor"
VALUES (4000, 'Raimi','Sam', '23-10-1959', 'samraimi@gmail.com','D');
INSERT INTO "Regizor"
VALUES (4001, 'Roger','Allers', '29-06-1949', 'rogerallers@gmail.com','N');
INSERT INTO "Regizor"
VALUES (4002, 'Minkoff','Robert', '11-08-1962', 'rpbertminkoff@yahoo.com','N');
INSERT INTO "Regizor"
VALUES (4003, 'Miller','Tim', '10-10-1964', 'tmiller@gmail.com','N');
INSERT INTO "Regizor"
VALUES (4004, 'Craven','Wesley', '02-08-1939', 'wescraven@yahoo.com','D');
INSERT INTO "Regizor"
VALUES (4005, 'Garland','Alexander', '26-05-1970', 'alexgarland@yahoo.com','D');
INSERT INTO "Regizor"
VALUES (4006, 'Jackson','Peter', '31-10-1961', 'petejck@yahoo.com','D');

commit;

--6-REGIZEAZAFILM

INSERT INTO "RegizeazaFilm"
VALUES (3000, 4000);
INSERT INTO "RegizeazaFilm"
VALUES (3001, 4001);
INSERT INTO "RegizeazaFilm"
VALUES (3001, 4002);
INSERT INTO "RegizeazaFilm"
VALUES (3002, 4003);
INSERT INTO "RegizeazaFilm"
VALUES (3003, 4004);
INSERT INTO "RegizeazaFilm"
VALUES (3004, 4005);
INSERT INTO "RegizeazaFilm"
VALUES (3005, 4006);

commit;

--7-FORMAT

INSERT INTO "Format"
VALUES (5000, 'Dvd');
INSERT INTO "Format"
VALUES (5001, 'blu-ray');
INSERT INTO "Format"
VALUES (5002, 'VHS');
INSERT INTO "Format"
VALUES (5003, 'Videotape');
INSERT INTO "Format"
VALUES (5004, 'Cassette');
INSERT INTO "Format"
VALUES (5005, 'Betamax');
INSERT INTO "Format"
VALUES (5006, 'Video CD');

commit;

--8-INCADREAZAFILM

INSERT INTO "IncadreazaFilm"
VALUES (3000, 5000);
INSERT INTO "IncadreazaFilm"
VALUES (3000, 5001);
INSERT INTO "IncadreazaFilm"
VALUES (3001, 5002);
INSERT INTO "IncadreazaFilm"
VALUES (3002, 5003);
INSERT INTO "IncadreazaFilm"
VALUES (3003, 5004);
INSERT INTO "IncadreazaFilm"
VALUES (3003, 5005);
INSERT INTO "IncadreazaFilm"
VALUES (3004, 5001);
INSERT INTO "IncadreazaFilm"
VALUES (3004, 5006);
INSERT INTO "IncadreazaFilm"
VALUES (3005, 5002);
INSERT INTO "IncadreazaFilm"
VALUES (3005, 5003);
INSERT INTO "IncadreazaFilm"
VALUES (3005, 5004);

commit;

--9-CURIER

INSERT INTO "Curier"
VALUES (6000, 'Dumitrascu','Marian', '15', 'FedEx','0726495703');
INSERT INTO "Curier"
VALUES (6001, 'Condurache','George', '10', 'Cargus','0726432754');
INSERT INTO "Curier"
VALUES (6002, 'Cristache','Andrei', '20', 'Fan Courier','0724856103');
INSERT INTO "Curier"
VALUES (6003, 'Negut','Radu', '10', 'SameDay','0723215773');
INSERT INTO "Curier"
VALUES (6004, 'Matache','Rares', '30', 'NemoExperss','0726437733');

commit;

--10-ADRESA

INSERT INTO "Adresa"
VALUES (7000, 'Dambovita','Targoviste', 'Cal.Domeneasca', 13,'null',130167);
INSERT INTO "Adresa"
VALUES (7001, 'Ilfov','Bucuresti', 'Str.Jiului', 45,'null',111357);
INSERT INTO "Adresa"
VALUES (7002, 'Cluj','Cluj-Napoca', 'Str.Prutului', 10,'E3',400058);
INSERT INTO "Adresa"
VALUES (7003, 'Timis','Timisoara', 'Str.Corvinilor', 143,'null',300081);
INSERT INTO "Adresa"
VALUES (7004, 'Dolj','Craiova', 'Cal.Voievozilor', 49,'A4',200122);
INSERT INTO "Adresa"
VALUES (7005, 'Constanta','Constanta', 'Str.Sighetului', 32,'null',900227);

commit;

--11-CLIENT

INSERT INTO "Client"
VALUES (8000, 'Codreanu','Radu', 'raducod@gmail.com', '0735947589','19-12-2000',7000);
INSERT INTO "Client"
VALUES (8001, 'Dovincescu','Adrian', 'dovadrian@gmail.com', '0705768589','29-04-1980',7001);
INSERT INTO "Client"
VALUES (8002, 'Rotaru','Mircea', 'mircear@gmail.com', '0732547569','14-11-2002',7002);
INSERT INTO "Client"
VALUES (8003, 'Dumitrache','Aurel', 'aurel11@yahoo.com', '0796447540','10-07-1992',7003);
INSERT INTO "Client"
VALUES (8004, 'Manea','Luca', 'luca231@gmail.com', '0745943581','30-03-1998',7004);

commit;

--12-COMANDA

INSERT INTO "Comanda"
VALUES (9000, '2181010250175', 'Nelivrat', '13-01-2022','19-01-2022',6000, 8000);
INSERT INTO "Comanda"
VALUES (9001, '1183210240435', 'Nelivrat', '15-01-2022','21-01-2022',6001, 8001);
INSERT INTO "Comanda"
VALUES (9002, '32143014355435', 'Livrat', '10-11-2021','12-11-2021',6002, 8002);
INSERT INTO "Comanda"
VALUES (9003, '613201435576', 'Nelivrat', '16-01-2022','22-01-2022',6003, 8003);
INSERT INTO "Comanda"
VALUES (9004, '7132010450438', 'Livrat', '01-06-2021','05-06-2021',6004, 8004);
INSERT INTO "Comanda"
VALUES (9005, '1133265450438', 'Livrat', '23-09-2021','29-09-2021',6003, 8004);

commit;

--13-FILMCOMANDA

INSERT INTO "FilmComanda"
VALUES (3000, 9000, 2);
INSERT INTO "FilmComanda"
VALUES (3001, 9001, 3);
INSERT INTO "FilmComanda"
VALUES (3002, 9002, 1);
INSERT INTO "FilmComanda"
VALUES (3003, 9003, 5);
INSERT INTO "FilmComanda"
VALUES (3004, 9004, 10);
INSERT INTO "FilmComanda"
VALUES (3005, 9005, 4);

commit;

select c.Nume "Nume Client",Client_id,Comanda_id,Film_id,f.Nume "Nume Film",Magazin_id,m.Nume "Nume Magazin"
from "Client" c join "Comanda" using (Client_id)
join "FilmComanda" using(Comanda_id)
join "Film" f using(Film_id)
join "VindeFilm" using(Film_id)
join "Magazin" m using(Magazin_id)
where Magazin_id = 1000 and c.Nume like ('C%'); --Toti clientii al caror nume incepe cu C si au o comanda la magazinul cu id 1000.

select Nume, count(Pret) "Conditie"
from "Film"
group by Nume
having avg(pret) > 25;




