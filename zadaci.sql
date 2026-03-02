-- ============================================
-- SQL ZADACI - Student Solution File
-- ============================================
-- Ovdje studenti pišu svoje SQL upite
-- **VAŽNO:** Ne brišite komentare sa "-- ZADATAK X"!

USE TestDB;
GO

-- ============================================
-- ZADATAK 1: Basic SELECT
-- ============================================
-- Napišite upit koji vraća sve kupce iz Zagreba.
-- Sortirajte po prezimenu (A-Z).
-- Rezultat treba sadržavati kolone: Ime, Prezime, Email, Grad

-- ZADATAK 1
-- Vaše rješenje ovdje:




-- ============================================
-- ZADATAK 2: JOIN i Aggregation
-- ============================================
-- Napišite upit koji vraća broj narudžbi po kupcu.
-- Prikažite: Ime, Prezime, BrojNarudzbi
-- Prikaži samo kupce koji imaju više od 1 narudžbe.
-- Sortiraj po broju narudžbi (od najvećeg ka najmanjem).

-- ZADATAK 2
-- Vaše rješenje ovdje:




-- ============================================
-- ZADATAK 3: Subquery
-- ============================================
-- Napišite upit koji vraća proizvode skuplје od prosječne cijene.
-- Prikažite: Naziv, Kategorija, Cijena
-- Sortiraj po cijeni (od najskupljeg).

-- ZADATAK 3
-- Vaše rješenje ovdje:




-- ============================================
-- ZADATAK 4: Complex JOIN
-- ============================================
-- Napišite upit koji vraća ukupnu vrijednost narudžbi po gradu.
-- Formula: Kolicina * Cijena
-- Prikažite: Grad, UkupnaVrijednost
-- Sortiraj po ukupnoj vrijednosti (od najveće).

-- ZADATAK 4
-- Vaše rješenje ovdje:




-- ============================================
-- ZADATAK 5: UPDATE
-- ============================================
-- Napišite UPDATE upit koji povećava cijenu svih proizvoda
-- iz kategorije 'Elektronika' za 10%.
-- NAPOMENA: Koristite ROUND funkciju za zaokruživanje na 2 decimale.

-- ZADATAK 5
-- Vaše rješenje ovdje:




-- ============================================
-- ZADATAK 6: INSERT
-- ============================================
-- Unesite novog kupca sa sljedećim podacima:
-- Ime: 'Ivan', Prezime: 'Horvat', Email: 'ivan.horvat@email.com', Grad: 'Zagreb'

-- ZADATAK 6
-- Vaše rješenje ovdje:




-- ============================================
-- ZADATAK 7: DELETE
-- ============================================
-- Izbrišite sve proizvode koji imaju 0 komada na skladištu.

-- ZADATAK 7
-- Vaše rješenje ovdje:




GO

PRINT 'Zadaci su izvršeni!';
GO
