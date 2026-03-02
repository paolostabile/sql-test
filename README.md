# SQL Server - GitHub Classroom Template

Ovaj repozitorij je template za testiranje SQL upita kroz GitHub Classroom sa automatskim testiranjem.

## Struktura projekta

- `setup.sql` - Skripta za kreiranje baze podataka i inicijalne podatke
- `zadaci.sql` - **Ovdje studenti pišu svoje SQL upite**
- `tests.sql` - Automatski testovi koji provjeravaju studentske rješenja
- `.github/workflows/test.yml` - GitHub Actions workflow za automatsko testiranje

## Upute za studente

### 1. Prihvatite zadatak

Kliknite na link koji vam je dao profesor. GitHub će automatski kreirati vaš repozitorij.

### 2. Klonirajte repozitorij

```bash
git clone <vaš-repozitorij-url>
cd <ime-repozitorija>
```

### 3. Riješite zadatke

Otvorite `zadaci.sql` i napišite SQL upite za svaki zadatak. Svaki zadatak je označen kao `-- ZADATAK X`.

**VAŽNO:** Nemojte brisati komentare sa nazivima zadataka (npr. `-- ZADATAK 1`)!

### 4. Testirajte lokalno (opcionalno)

Ako imate SQL Server instaliran lokalno:

```bash
# Windows PowerShell
.\run-tests.ps1
```

Ili koristite Docker:

```bash
docker-compose up -d
# Pričekajte ~30 sekundi da se SQL Server pokrene
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /sql/setup.sql
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /sql/zadaci.sql
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /sql/tests.sql
```

### 5. Commit i push

```bash
git add zadaci.sql
git commit -m "Rješenje zadataka"
git push
```

### 6. Provjerite rezultate

- Idite na vaš GitHub repozitorij
- Kliknite na tab **Actions**
- Vidjet ćete status testiranja (✅ uspješno ili ❌ neuspješno)
- Kliknite na run da vidite detalje testova

## Za profesore

### Prilagodba template-a

1. **setup.sql** - Definirajte schema baze i početne podatke
2. **zadaci.sql** - Definirajte zadatke kao komentare, studenti će ovdje pisati upite
3. **tests.sql** - Napišite testove koji validiraju rješenja studenata

### Kreiranje GitHub Classroom zadatka

1. Idite na GitHub Classroom
2. Kliknite "New Assignment"
3. Odaberite ovaj repozitorij kao template
4. Konfigurirajte deadline i druge postavke
5. Distribuitre link studentima

### Primjer test strukture

Testovi koriste `RAISERROR` za prijavljivanje grešaka:

```sql
-- Test 1: Provjeri broj redova
DECLARE @count INT;
SELECT @count = COUNT(*) FROM rezultat_zadatak1;
IF @count != 5
BEGIN
    RAISERROR('ZADATAK 1 FAILED: Očekivano 5 redova, dobiveno %d', 16, 1, @count);
END
ELSE
BEGIN
    PRINT 'ZADATAK 1 PASSED';
END
```

## Tehnički detalji

- **SQL Server verzija:** 2022 (latest)
- **GitHub Actions:** Automatski se pokreće pri svakom push-u
- **Timeout:** 10 minuta
- **Docker image:** mcr.microsoft.com/mssql/server:2022-latest

## Licenca

MIT License - Slobodno prilagodite za vaše potrebe.
