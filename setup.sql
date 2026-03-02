-- ============================================
-- SQL Server Database Setup Script
-- ============================================
-- Ovaj fajl kreira bazu podataka, tabele i početne podatke
-- **STUDENTI NE TREBAJU MIJENJATI OVAJ FAJL**

USE master;
GO

-- Kreiraj bazu ako ne postoji
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'TestDB')
BEGIN
    CREATE DATABASE TestDB;
END
GO

USE TestDB;
GO

-- ============================================
-- Tabele
-- ============================================

-- Obrisi postojece tabele ako postoje (za ponavljanje testova)
IF OBJECT_ID('Narudzbe', 'U') IS NOT NULL DROP TABLE Narudzbe;
IF OBJECT_ID('Kupci', 'U') IS NOT NULL DROP TABLE Kupci;
IF OBJECT_ID('Proizvodi', 'U') IS NOT NULL DROP TABLE Proizvodi;
GO

-- Tabela: Kupci
CREATE TABLE Kupci (
    KupacID INT PRIMARY KEY IDENTITY(1,1),
    Ime NVARCHAR(50) NOT NULL,
    Prezime NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Grad NVARCHAR(50),
    DatumRegistracije DATE DEFAULT GETDATE()
);
GO

-- Tabela: Proizvodi
CREATE TABLE Proizvodi (
    ProizvodID INT PRIMARY KEY IDENTITY(1,1),
    Naziv NVARCHAR(100) NOT NULL,
    Kategorija NVARCHAR(50),
    Cijena DECIMAL(10, 2) NOT NULL CHECK (Cijena >= 0),
    NaSkladistu INT DEFAULT 0 CHECK (NaSkladistu >= 0)
);
GO

-- Tabela: Narudzbe
CREATE TABLE Narudzbe (
    NarudzbaID INT PRIMARY KEY IDENTITY(1,1),
    KupacID INT NOT NULL FOREIGN KEY REFERENCES Kupci(KupacID),
    ProizvodID INT NOT NULL FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
    Kolicina INT NOT NULL CHECK (Kolicina > 0),
    DatumNarudzbe DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Nova' CHECK (Status IN ('Nova', 'Obradjuje se', 'Poslana', 'Isporucena', 'Otkazana'))
);
GO

-- ============================================
-- Pocetni podaci
-- ============================================

-- Unos kupaca
INSERT INTO Kupci (Ime, Prezime, Email, Grad, DatumRegistracije) VALUES
('Marko', 'Marković', 'marko.markovic@email.com', 'Zagreb', '2024-01-15'),
('Ana', 'Anić', 'ana.anic@email.com', 'Split', '2024-02-20'),
('Petar', 'Petrović', 'petar.petrovic@email.com', 'Zagreb', '2024-03-10'),
('Ivana', 'Ivanović', 'ivana.ivanovic@email.com', 'Rijeka', '2024-04-05'),
('Luka', 'Lukić', 'luka.lukic@email.com', 'Osijek', '2024-05-12');
GO

-- Unos proizvoda
INSERT INTO Proizvodi (Naziv, Kategorija, Cijena, NaSkladistu) VALUES
('Laptop Dell XPS 15', 'Elektronika', 7999.99, 10),
('iPhone 15 Pro', 'Elektronika', 8999.99, 15),
('Nike Air Max', 'Obuća', 899.99, 50),
('Adidas Superstar', 'Obuća', 699.99, 30),
('Sony WH-1000XM5', 'Elektronika', 2499.99, 20),
('Samsung Galaxy S24', 'Elektronika', 6999.99, 12),
('Knjiga "1984"', 'Knjige', 89.99, 100),
('Knjiga "Harry Potter"', 'Knjige', 129.99, 75);
GO

-- Unos narudzbi
INSERT INTO Narudzbe (KupacID, ProizvodID, Kolicina, DatumNarudzbe, Status) VALUES
(1, 1, 1, '2024-06-01', 'Isporucena'),
(1, 5, 1, '2024-06-02', 'Isporucena'),
(2, 3, 2, '2024-06-05', 'Isporucena'),
(3, 2, 1, '2024-06-10', 'Poslana'),
(3, 6, 1, '2024-06-11', 'Obradjuje se'),
(4, 7, 3, '2024-06-15', 'Isporucena'),
(4, 8, 2, '2024-06-15', 'Isporucena'),
(5, 4, 1, '2024-06-20', 'Nova'),
(1, 6, 1, '2024-06-22', 'Nova'),
(2, 2, 1, '2024-06-25', 'Obradjuje se');
GO

PRINT 'Setup completed successfully!';
PRINT 'Database: TestDB';
PRINT 'Tables: Kupci, Proizvodi, Narudzbe';
GO
