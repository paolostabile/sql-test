# Vodič za profesore

Ovaj dokument objašnjava kako prilagoditi ovaj template za vaše specifične potrebe.

## Struktura template-a

```
├── .github/
│   ├── workflows/
│   │   └── test.yml          # GitHub Actions workflow za CI/CD
│   └── classroom/
│       └── autograding.json  # Konfiguracija za GitHub Classroom ocjenjivanje
├── setup.sql                 # Kreiranje baze i početnih podataka
├── zadaci.sql                # Zadaci koje studenti rješavaju
├── tests.sql                 # Automatski testovi
├── run-tests.ps1             # Lokalni test runner (Windows)
├── docker-compose.yml        # Docker setup za lokalno testiranje
├── README.md                 # Upute za studente
└── LICENSE                   # MIT licenca

```

## Kako prilagoditi template

### 1. Izmjena baze podataka (setup.sql)

U `setup.sql` fajlu definišite:

- **Schema**: Tabele, kolone, podatkovnu tipove
- **Constrainte**: Primary keys, foreign keys, CHECK constrainte
- **Početne podatke**: INSERT statements sa test podacima

**Primjer:**
```sql
CREATE TABLE Student (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    Ime NVARCHAR(50) NOT NULL,
    BrojIndeksa VARCHAR(20) UNIQUE
);

INSERT INTO Student (Ime, BrojIndeksa) VALUES
('Ana Anić', 'SW1-2024'),
('Marko Marković', 'SW2-2024');
```

### 2. Kreiranje zadataka (zadaci.sql)

U `zadaci.sql` fajlu:

- Svaki zadatak treba imati komentar `-- ZADATAK X`
- Ostavite prazan prostor za studentska rješenja
- Dodajte opis šta upit treba da uradi

**Primjer:**
```sql
-- ZADATAK 1
-- Napišite upit koji vraća sve studente sa prosjekom preko 8.0
-- Kolone: Ime, Prezime, Prosjek
-- Sortiraj po prosjeku (od najvećeg)

-- Vaše rješenje ovdje:



```

### 3. Pisanje testova (tests.sql)

Za svaki zadatak, napišite test koji validira:

- **Broj redova**: Da li rezultat ima očekivan broj redova?
- **Sadržaj**: Da li podaci zadovoljavaju uslove?
- **Sortiranje**: Da li je sortiranje ispravno?
- **Kalkulacije**: Da li su izračunate vrijednosti točne?

**Template za test:**
```sql
PRINT 'Testing ZADATAK X...';

-- Kreiraj temp tabelu
IF OBJECT_ID('tempdb..#ZadatakXResult') IS NOT NULL DROP TABLE #ZadatakXResult;
CREATE TABLE #ZadatakXResult (
    -- Definiši kolone koje očekuješ
    Kolona1 NVARCHAR(50),
    Kolona2 INT
);

-- Unesi očekivani rezultat (ili iskopiraj studentski upit)
INSERT INTO #ZadatakXResult
-- OVDJE IDE OČEKIVANI UPIT

-- Validacija
DECLARE @count INT, @expected INT = 5;
SELECT @count = COUNT(*) FROM #ZadatakXResult;

IF @count != @expected
BEGIN
    PRINT '❌ ZADATAK X FAILED: Očekivano ' + CAST(@expected AS VARCHAR) + ' redova';
END
ELSE
BEGIN
    PRINT '✅ ZADATAK X PASSED';
END
PRINT '';
```

**Best practices za testove:**
- Testirajte svaki zadatak nezavisno
- Koristite temp tabele (`#TabName`) da ne zagadite glavnu bazu
- Dajte jasne poruke o grešci
- Koristite `PRINT` za output, a `RAISERROR` za kritične greške

### 4. Konfiguracija GitHub Actions

U `.github/workflows/test.yml` možete:

- Promijeniti SQL Server verziju (default: 2022-latest)
- Dodati timeout-e
- Dodati dodatne korake (code quality, linting)

**Primjer dodavanja timeout-a:**
```yaml
- name: Run tests
  timeout-minutes: 5  # Dodaj timeout
  run: |
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd123 -i tests.sql
```

### 5. Ocjenjivanje (Autograding)

U `.github/classroom/autograding.json` možete:

- Dodati više testova
- Promijeniti bodove po zadatku
- Dodati parcijalno bodovanje

**Primjer sa više testova:**
```json
{
  "tests": [
    {
      "name": "Zadaci 1-3",
      "run": "sqlcmd ... -i tests-part1.sql",
      "points": 50
    },
    {
      "name": "Zadaci 4-7",
      "run": "sqlcmd ... -i tests-part2.sql",
      "points": 50
    }
  ]
}
```

## GitHub Classroom setup

### Kreiranje Assignment-a

1. Idite na [classroom.github.com](https://classroom.github.com)
2. Odaberite vaš Classroom
3. Kliknite **New Assignment**
4. Postavke:
   - **Title**: "SQL Vjezbe 1"
   - **Deadline**: Postavite rok
   - **Repository visibility**: Private (preporučeno)
   - **Grant students admin**: Ne (preporučeno)
5. U **Starter code** sekciji:
   - Odaberite **Import a repository**
   - Unesite URL vašeg template repozitorija
6. U **Grading and feedback**:
   - Enable autograding
   - Import `.github/classroom/autograding.json`
7. Kreirajte assignment i kopirajte link

### Distribucija studentima

Pošaljite link studentima putem:
- Email-a
- LMS sistema (Moodle, Canvas, etc.)
- Objave na kursu

## Lokalno testiranje

Prije nego što distribuirate zadatak, testirajte ga lokalno:

### Windows (SQL Server)
```powershell
.\run-tests.ps1 -Server "localhost" -Username "sa" -Password "VašPassword"
```

### Docker (Linux/Mac/Windows)
```bash
docker-compose up -d
sleep 30  # Pričekaj da se SQL Server pokrene
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /sql/setup.sql
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /sql/zadaci.sql
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /sql/tests.sql
docker-compose down
```

## Česta pitanja

### Kako dodati više zadataka?

1. U `zadaci.sql` dodaj novi zadatak sa komentarom `-- ZADATAK X`
2. U `tests.sql` dodaj novi test blok za taj zadatak
3. Testiraj lokalno

### Kako omogućiti parcijalno bodovanje?

U `tests.sql`, umjesto `RAISERROR` koristite bodovni sistem:

```sql
DECLARE @score INT = 0, @maxScore INT = 100;

-- Test 1 (20 bodova)
IF (uslovi_testirani)
    SET @score = @score + 20;

-- Test 2 (30 bodova)
IF (uslovi_testirani)
    SET @score = @score + 30;

PRINT 'Final Score: ' + CAST(@score AS VARCHAR) + '/' + CAST(@maxScore AS VARCHAR);
```

### Kako koristiti različite verzije SQL Servera?

U `.github/workflows/test.yml` i `docker-compose.yml`, promijenite image:

```yaml
image: mcr.microsoft.com/mssql/server:2019-latest  # Za SQL Server 2019
```

### Kako ograničiti vrijeme izvršenja?

U workflow fajlu, dodajte:

```yaml
- name: Run tests
  timeout-minutes: 10
  run: ...
```

## Podrška

Za pitanja i probleme:
- Otvorite issue na GitHub-u
- Kontaktirajte IT podršku vaše ustanove

## Doprinosi

Pull request-ovi su dobrodošli! Ako imate ideje za poboljšanja:
1. Forkujte repozitorij
2. Napravite feature branch
3. Commit-ujte promjene
4. Kreirajte pull request
