-- ============================================
-- SQL AUTOMATED TESTS
-- ============================================
-- Automatski testovi koji validiraju studentska rješenja
-- **PROFESORI**: Prilagodite testove prema vašim zadacima

USE TestDB;
GO

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'Starting Automated Test Suite';
PRINT '========================================';
PRINT '';

-- ============================================
-- Helper: Extract query za svaki zadatak iz zadaci.sql
-- ============================================
-- NAPOMENA: U produkciji, test runner će parsirati zadaci.sql
-- i izdvojiti upite između zadataka. Ovo je pojednostavljena verzija.

-- ============================================
-- TEST ZADATAK 1: Basic SELECT
-- ============================================
PRINT 'Testing ZADATAK 1: Basic SELECT from Zagreb...';

-- Kreiraj temp tabelu za rezultat
IF OBJECT_ID('tempdb..#Zadatak1Result') IS NOT NULL DROP TABLE #Zadatak1Result;
CREATE TABLE #Zadatak1Result (
    Ime NVARCHAR(50),
    Prezime NVARCHAR(50),
    Email NVARCHAR(100),
    Grad NVARCHAR(50)
);

-- Simulacija studentskog upita (u stvarnom scenariju se izvlači iz zadaci.sql)
-- Student bi trebao napisati nešto slično:
INSERT INTO #Zadatak1Result
SELECT Ime, Prezime, Email, Grad 
FROM Kupci 
WHERE Grad = 'Zagreb'
ORDER BY Prezime;

-- Validacija rezultata
DECLARE @count1 INT, @expectedCount1 INT = 2;
SELECT @count1 = COUNT(*) FROM #Zadatak1Result;

IF @count1 != @expectedCount1
BEGIN
    PRINT '❌ ZADATAK 1 FAILED: Očekivano ' + CAST(@expectedCount1 AS VARCHAR) + ' redova, dobiveno ' + CAST(@count1 AS VARCHAR);
END
ELSE
BEGIN
    -- Provjeri da li su svi iz Zagreba
    DECLARE @wrongCity INT;
    SELECT @wrongCity = COUNT(*) FROM #Zadatak1Result WHERE Grad != 'Zagreb';
    
    IF @wrongCity > 0
    BEGIN
        PRINT '❌ ZADATAK 1 FAILED: Rezultat sadrži kupce koji nisu iz Zagreba';
    END
    ELSE
    BEGIN
        PRINT '✅ ZADATAK 1 PASSED';
    END
END
PRINT '';

-- ============================================
-- TEST ZADATAK 2: JOIN i Aggregation
-- ============================================
PRINT 'Testing ZADATAK 2: JOIN and Aggregation...';

IF OBJECT_ID('tempdb..#Zadatak2Result') IS NOT NULL DROP TABLE #Zadatak2Result;
CREATE TABLE #Zadatak2Result (
    Ime NVARCHAR(50),
    Prezime NVARCHAR(50),
    BrojNarudzbi INT
);

-- Simulacija studentskog upita
INSERT INTO #Zadatak2Result
SELECT k.Ime, k.Prezime, COUNT(n.NarudzbaID) as BrojNarudzbi
FROM Kupci k
JOIN Narudzbe n ON k.KupacID = n.KupacID
GROUP BY k.Ime, k.Prezime
HAVING COUNT(n.NarudzbaID) > 1
ORDER BY BrojNarudzbi DESC;

DECLARE @count2 INT, @expectedCount2 INT = 3;
SELECT @count2 = COUNT(*) FROM #Zadatak2Result;

IF @count2 != @expectedCount2
BEGIN
    PRINT '❌ ZADATAK 2 FAILED: Očekivano ' + CAST(@expectedCount2 AS VARCHAR) + ' redova, dobiveno ' + CAST(@count2 AS VARCHAR);
END
ELSE
BEGIN
    -- Provjeri da li svi imaju više od 1 narudžbe
    DECLARE @wrongCount INT;
    SELECT @wrongCount = COUNT(*) FROM #Zadatak2Result WHERE BrojNarudzbi <= 1;
    
    IF @wrongCount > 0
    BEGIN
        PRINT '❌ ZADATAK 2 FAILED: Rezultat sadrži kupce sa 1 ili manje narudžbi';
    END
    ELSE
    BEGIN
        PRINT '✅ ZADATAK 2 PASSED';
    END
END
PRINT '';

-- ============================================
-- TEST ZADATAK 3: Subquery
-- ============================================
PRINT 'Testing ZADATAK 3: Subquery (above average price)...';

IF OBJECT_ID('tempdb..#Zadatak3Result') IS NOT NULL DROP TABLE #Zadatak3Result;
CREATE TABLE #Zadatak3Result (
    Naziv NVARCHAR(100),
    Kategorija NVARCHAR(50),
    Cijena DECIMAL(10,2)
);

DECLARE @avgPrice DECIMAL(10,2);
SELECT @avgPrice = AVG(Cijena) FROM Proizvodi;

INSERT INTO #Zadatak3Result
SELECT Naziv, Kategorija, Cijena
FROM Proizvodi
WHERE Cijena > @avgPrice
ORDER BY Cijena DESC;

DECLARE @count3 INT;
SELECT @count3 = COUNT(*) FROM #Zadatak3Result;

IF @count3 = 0
BEGIN
    PRINT '❌ ZADATAK 3 FAILED: Nema rezultata';
END
ELSE
BEGIN
    -- Provjeri da li su svi iznad prosjeka
    DECLARE @wrongPrice INT;
    SELECT @wrongPrice = COUNT(*) FROM #Zadatak3Result WHERE Cijena <= @avgPrice;
    
    IF @wrongPrice > 0
    BEGIN
        PRINT '❌ ZADATAK 3 FAILED: Rezultat sadrži proizvode ispod ili na prosjeku';
    END
    ELSE
    BEGIN
        PRINT '✅ ZADATAK 3 PASSED';
    END
END
PRINT '';

-- ============================================
-- TEST ZADATAK 4: Complex JOIN
-- ============================================
PRINT 'Testing ZADATAK 4: Total value by city...';

IF OBJECT_ID('tempdb..#Zadatak4Result') IS NOT NULL DROP TABLE #Zadatak4Result;
CREATE TABLE #Zadatak4Result (
    Grad NVARCHAR(50),
    UkupnaVrijednost DECIMAL(18,2)
);

INSERT INTO #Zadatak4Result
SELECT k.Grad, SUM(n.Kolicina * p.Cijena) as UkupnaVrijednost
FROM Kupci k
JOIN Narudzbe n ON k.KupacID = n.KupacID
JOIN Proizvodi p ON n.ProizvodID = p.ProizvodID
GROUP BY k.Grad
ORDER BY UkupnaVrijednost DESC;

DECLARE @count4 INT;
SELECT @count4 = COUNT(*) FROM #Zadatak4Result;

IF @count4 = 0
BEGIN
    PRINT '❌ ZADATAK 4 FAILED: Nema rezultata';
END
ELSE
BEGIN
    -- Provjeri da li su vrijednosti pozitivne
    DECLARE @negativeValues INT;
    SELECT @negativeValues = COUNT(*) FROM #Zadatak4Result WHERE UkupnaVrijednost <= 0;
    
    IF @negativeValues > 0
    BEGIN
        PRINT '❌ ZADATAK 4 FAILED: Rezultat sadrži negativne vrijednosti';
    END
    ELSE
    BEGIN
        PRINT '✅ ZADATAK 4 PASSED';
    END
END
PRINT '';

-- ============================================
-- TEST ZADATAK 5: UPDATE
-- ============================================
PRINT 'Testing ZADATAK 5: UPDATE price increase...';

-- Sačuvaj originalne cijene
IF OBJECT_ID('tempdb..#OriginalPrices') IS NOT NULL DROP TABLE #OriginalPrices;
SELECT ProizvodID, Cijena INTO #OriginalPrices FROM Proizvodi WHERE Kategorija = 'Elektronika';

-- Izvršenje student UPDATE-a (simulacija)
UPDATE Proizvodi
SET Cijena = ROUND(Cijena * 1.10, 2)
WHERE Kategorija = 'Elektronika';

-- Validacija
DECLARE @correctUpdates INT, @totalElectronics INT;
SELECT @totalElectronics = COUNT(*) FROM #OriginalPrices;

SELECT @correctUpdates = COUNT(*)
FROM Proizvodi p
JOIN #OriginalPrices o ON p.ProizvodID = o.ProizvodID
WHERE p.Cijena = ROUND(o.Cijena * 1.10, 2);

IF @correctUpdates = @totalElectronics
BEGIN
    PRINT '✅ ZADATAK 5 PASSED';
END
ELSE
BEGIN
    PRINT '❌ ZADATAK 5 FAILED: Cijene nisu pravilno ažurirane';
END
PRINT '';

-- ============================================
-- TEST ZADATAK 6: INSERT
-- ============================================
PRINT 'Testing ZADATAK 6: INSERT new customer...';

-- Prvo obrisi ako postoji (za ponovljene testove)
DELETE FROM Kupci WHERE Email = 'ivan.horvat@email.com';

-- Izvršenje student INSERT-a (simulacija)
INSERT INTO Kupci (Ime, Prezime, Email, Grad)
VALUES ('Ivan', 'Horvat', 'ivan.horvat@email.com', 'Zagreb');

-- Validacija
IF EXISTS (SELECT 1 FROM Kupci WHERE Email = 'ivan.horvat@email.com' AND Ime = 'Ivan' AND Prezime = 'Horvat' AND Grad = 'Zagreb')
BEGIN
    PRINT '✅ ZADATAK 6 PASSED';
END
ELSE
BEGIN
    PRINT '❌ ZADATAK 6 FAILED: Kupac nije ispravno unesen';
END
PRINT '';

-- ============================================
-- TEST ZADATAK 7: DELETE
-- ============================================
PRINT 'Testing ZADATAK 7: DELETE zero stock products...';

-- Dodaj privremeni proizvod sa 0 na stanju za test
INSERT INTO Proizvodi (Naziv, Kategorija, Cijena, NaSkladistu)
VALUES ('Test Proizvod', 'Test', 99.99, 0);

DECLARE @countBefore INT;
SELECT @countBefore = COUNT(*) FROM Proizvodi WHERE NaSkladistu = 0;

-- Izvršenje student DELETE-a (simulacija)
DELETE FROM Proizvodi WHERE NaSkladistu = 0;

DECLARE @countAfter INT;
SELECT @countAfter = COUNT(*) FROM Proizvodi WHERE NaSkladistu = 0;

IF @countAfter = 0 AND @countBefore > 0
BEGIN
    PRINT '✅ ZADATAK 7 PASSED';
END
ELSE
BEGIN
    PRINT '❌ ZADATAK 7 FAILED: Proizvodi sa 0 na skladištu nisu obrisani';
END
PRINT '';

-- ============================================
-- Test Summary
-- ============================================
PRINT '========================================';
PRINT 'Test Suite Completed';
PRINT '========================================';

SET NOCOUNT OFF;
GO
