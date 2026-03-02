# ============================================
# PowerShell Test Runner Script
# ============================================
# Pokreće SQL testove lokalno na Windows mašini

param(
    [string]$Server = "localhost",
    [string]$Username = "sa",
    [string]$Password = "YourStrong@Passw0rd"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SQL Server Test Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Provjeri da li postoji sqlcmd
$sqlcmd = Get-Command sqlcmd -ErrorAction SilentlyContinue
if (-not $sqlcmd) {
    Write-Host "❌ Error: sqlcmd nije pronađen!" -ForegroundColor Red
    Write-Host "Instalirajte SQL Server Command Line Tools:" -ForegroundColor Yellow
    Write-Host "https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility" -ForegroundColor Yellow
    exit 1
}

# 1. Setup
Write-Host "Step 1: Running setup.sql..." -ForegroundColor Yellow
try {
    sqlcmd -S $Server -U $Username -P $Password -i "setup.sql" -b
    Write-Host "✅ Setup completed successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Setup failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
Write-Host ""

# 2. Student Solutions
Write-Host "Step 2: Running zadaci.sql (student solutions)..." -ForegroundColor Yellow
try {
    sqlcmd -S $Server -U $Username -P $Password -i "zadaci.sql" -b
    Write-Host "✅ Student solutions executed" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Some queries in zadaci.sql failed" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}
Write-Host ""

# 3. Tests
Write-Host "Step 3: Running tests.sql..." -ForegroundColor Yellow
try {
    $testOutput = sqlcmd -S $Server -U $Username -P $Password -i "tests.sql" -b 2>&1
    Write-Host $testOutput
    
    # Provjeri da li ima neuspjelih testova
    if ($testOutput -match "FAILED") {
        Write-Host ""
        Write-Host "❌ Some tests FAILED! Check output above." -ForegroundColor Red
        exit 1
    } else {
        Write-Host ""
        Write-Host "✅ All tests PASSED!" -ForegroundColor Green
        exit 0
    }
} catch {
    Write-Host "❌ Test execution failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
