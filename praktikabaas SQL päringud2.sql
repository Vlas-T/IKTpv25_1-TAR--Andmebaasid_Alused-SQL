CREATE Database VlTr
use VlTr

--1. Loo kolm tabelit
CREATE TABLE firma
(
    firmaID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    firmanimi VARCHAR(20),
    aadress VARCHAR(20),
    telefon VARCHAR(20)
);

INSERT INTO firma (firmanimi, aadress, telefon) VALUES
    ('Telia Eesti', 'Tallinn', '6009000'),
    ('Swedbank', 'Tallinn', '6310310'),
    ('Elisa', 'Tartu', '6006000'),
    ('Eesti Energia', 'Tallinn', '7152222'),
    ('LHV Pank', 'Tallinn', '6800400'),
    ('Nortal', 'Tallinn', '6661234'),
    ('Transferwise', 'Tallinn', '6005500'),
	('VaipadePesu', 'Tartu', '5770443');

	Select * from firma;
	--tabel – praktikajuhendaja
CREATE TABLE praktikajuhendaja
(
    praktikajuhendajaID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    eesnimi VARCHAR(30),
    perekonnanimi VARCHAR(30),
    synniaeg DATE,
    telefon VARCHAR(20)
);

INSERT INTO praktikajuhendaja (eesnimi, perekonnanimi, synniaeg, telefon) VALUES
    ('Mati', 'Tamm', '1985-09-12', '5001234'),
    ('Kati', 'Sepp', '1990-10-22', '5005678'),
    ('Jaan', 'Kask', '1978-11-03', '5009876'),
    ('Mari', 'Lepp', '1995-03-15', '5003456'),
    ('Peeter', 'Magi', '1988-06-28', '5007890'),
    ('Anna', 'Puu', '1992-09-05', '5001111'),
    ('Toomas', 'Rand', '1983-07-17', '5002222'),
	('Vlas','Taratõnov','2009-06-29','5660522');

		Select * from praktikajuhendaja;

--3. tabel – praktikabaas
CREATE TABLE praktikabaas(
    praktikabaasID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    firmaID INT,
    praktikatingimused VARCHAR(20),
    arvutiprogramm VARCHAR(20),
    juhendajaID INT,
    FOREIGN KEY (firmaID) REFERENCES firma(firmaID),
    FOREIGN KEY (juhendajaID) REFERENCES praktikajuhendaja(praktikajuhendajaID)
);

INSERT INTO praktikabaas (firmaID, praktikatingimused, arvutiprogramm, juhendajaID) VALUES
    (1, 'Hea', 'Excel', 1),
    (2, 'Kesine', 'Word', 2),
    (3, 'Suurepärane', 'Python', 3),
    (1, 'Hea', 'SQL', 4),
    (4, 'Rahuldav', 'Java', 5),
    (5, 'Suurepärane', 'C#', 6),
    (1, 'Hea', 'Excel', 7),
	(8, 'Rahuldav', 'Excel', 8);

	Select * from praktikabaas;

--SELECT päringute ülesanded
	--1. Leia kõik firmad, mille nimes sisaldub täht „e“
	SELECT * FROM firma
   WHERE firmanimi LIKE '%e%';
   --2. Kuva andmed kahest tabelist, arvestades nende seost ja sorteeri firmade nimede järgi
   SELECT *FROM praktikabaas, firma
WHERE firma.firmaID = praktikabaas.firmaID
ORDER BY firmanimi;
   --3. Leia, mitu korda iga firma on praktikabaas
  SELECT firmanimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas, firma
WHERE firma.firmaID = praktikabaas.firmaID
GROUP BY firmanimi;
   --4. Leia kõik juhendajad, kes on sündinud sügisel (september, oktoober, november)
   --Variant 1:
SELECT * FROM praktikajuhendaja
WHERE MONTH(synniaeg) = 9 
   OR MONTH(synniaeg) = 10 
   OR MONTH(synniaeg) = 11;
   --Variant 2:
SELECT * FROM praktikajuhendaja
WHERE MONTH(synniaeg) IN (9, 10, 11);
--5.  Edasised ülesanded (koosta ise SQL päringud)
	-- 1. Mitu praktikakohta on igal juhendajal
	SELECT perekonnanimi, eesnimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas, praktikajuhendaja
WHERE praktikajuhendaja.praktikajuhendajaID = praktikabaas.juhendajaID
GROUP BY perekonnanimi, eesnimi;
	-- 2. Lisa uus veerg palk
	ALTER TABLE praktikajuhendaja
ADD palk DECIMAL(10, 2);
	-- 3. Täida palk väärtustega
UPDATE praktikajuhendaja SET palk = 2500.00 WHERE praktikajuhendajaID = 1;
UPDATE praktikajuhendaja SET palk = 3100.00 WHERE praktikajuhendajaID = 2;
UPDATE praktikajuhendaja SET palk = 2800.00 WHERE praktikajuhendajaID = 3;
UPDATE praktikajuhendaja SET palk = 3500.00 WHERE praktikajuhendajaID = 4;
UPDATE praktikajuhendaja SET palk = 2200.00 WHERE praktikajuhendajaID = 5;
UPDATE praktikajuhendaja SET palk = 2900.00 WHERE praktikajuhendajaID = 6;
UPDATE praktikajuhendaja SET palk = 3200.00 WHERE praktikajuhendajaID = 7;
UPDATE praktikajuhendaja SET palk = 2899.89 WHERE praktikajuhendajaID = 8;
SELECT * FROM praktikajuhendaja
	-- 4 & 5. Keskmine ja kogupalk
SELECT AVG(palk) AS kesminePalk, SUM(palk) AS kogupalk
FROM praktikajuhendaja;
	-- 6. Enda päring — juhendajad, kelle palk on üle 2900
SELECT eesnimi, perekonnanimi, palk
FROM praktikajuhendaja
WHERE palk > 2900
ORDER BY palk DESC;
--VIEW loomine
	-- 6.1. VIEW
		CREATE VIEW v_firma_praktikakohad AS
SELECT firmanimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas, firma
WHERE firma.firmaID = praktikabaas.firmaID
GROUP BY firmanimi;

SELECT * FROM v_firma_praktikakohad;
	-- 6.2. VIEW
	CREATE VIEW v_sugisel_syndinud AS
SELECT * FROM praktikajuhendaja
WHERE MONTH(synniaeg) IN (9, 10, 11);

SELECT * FROM v_sugisel_syndinud;
--7. Protseduurid
	--1.  lisab uue kirje tabelisse (nt tabel Firma)
	CREATE PROCEDURE lisaFirma
    @nimi VARCHAR(20),
    @adr VARCHAR(20),
    @tel VARCHAR(20)
AS
BEGIN
    INSERT INTO firma (firmanimi, aadress, telefon)
    VALUES (@nimi, @adr, @tel);
    SELECT * FROM firma;
END;

EXEC lisaFirma 'DataTech', 'Tallinn 12', '5559900';
	-- muudab tabeli struktuuri (nt lisab uue veeru)(sõna lisamine e-posti teel)
	CREATE PROCEDURE muudaStruktuuri
AS
BEGIN
    ALTER TABLE firma ADD email VARCHAR(50);
END;

EXEC muudaStruktuuri;
	--arvutab juhendajate keskmise palga
	CREATE PROCEDURE arvutaKeskminePalk
AS
BEGIN
    SELECT AVG(palk) AS Keskmine_Juhendaja_Palk FROM praktikajuhendaja;
END;

EXEC arvutaKeskminePalk;



-- funktsiooni tegemine
create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
		select @tempdate = @DOB

		select @years = datediff(year, @tempdate, getdate()) - case when (month(@DOB) > month(GETDATE())) or (MONTH(@DOB)
		= month (getdate()) and day(@DOB) > DAY(getdate())) then 1 else 0 end
		select @tempdate = dateadd(year, @years, @tempdate)

		select @months = datediff(month, @tempdate, getdate()) - case when day(@DOB) > day(getdate()) then 1 else 0 end
		select @tempdate = dateadd(MONTH, @months, @tempdate)

		select @days = datediff(day, @tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2)) + 
		' Months ' + cast(@days as nvarchar(2)) + ' Days old'
	return @Age
end


--
create function dbo.CalculateAge(@DOB date)
returns int
as begin
declare @Age int

set @Age = DATEDIFF(YEAR, @DOB, GETDATE()) -
	case
		when (MONTH(@DOB) > MONTH(getdate())) or
			 (MONTH(@DOB) > MONTH(GETDATE()) and DAY(@DOB) > day(GETDATE()))
		then 1
		else 0
		end
	return @Age
end

