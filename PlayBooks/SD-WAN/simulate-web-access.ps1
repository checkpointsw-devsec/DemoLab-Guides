param(
    [int]$Count = 200,
    [int]$MinPauseSec = 25,
    [int]$MaxPauseSec = 75,
    [int]$MinDwellSec = 8,
    [int]$MaxDwellSec = 20
)

$ErrorActionPreference = "Stop"

# --- Verify curl ---
$curl = "$env:SystemRoot\System32\curl.exe"
if (-not (Test-Path $curl)) {
    throw "curl.exe not found"
}

Write-Host "[*] Using curl: $curl"

# --- Download Tranco top sites ---
$tmp = Join-Path $env:TEMP ("tranco_" + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tmp | Out-Null

$zip = Join-Path $tmp "top.zip"
Invoke-WebRequest "https://tranco-list.eu/top-1m.csv.zip" -OutFile $zip -UseBasicParsing
Expand-Archive $zip $tmp -Force

$csv = Get-ChildItem $tmp -Filter *.csv | Select-Object -First 1

$domains =
    Get-Content $csv.FullName |
    ForEach-Object { ($_ -split ",")[1] } |
    Where-Object { $_ -match "\." } |
    Select-Object -First $Count

Remove-Item $tmp -Recurse -Force

Write-Host "[*] Loaded $($domains.Count) domains"

# --- Browser-like headers ---
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0"

# --- Browse ---
$i = 0
foreach ($domain in $domains) {

    $i++
    $pause = Get-Random -Minimum $MinPauseSec -Maximum ($MaxPauseSec + 1)
    $dwell = Get-Random -Minimum $MinDwellSec -Maximum ($MaxDwellSec + 1)

    Start-Sleep $pause

    $url = "https://$domain/"
    Write-Host "[$i/$Count] Visiting $url (pause=$pause dwell=$dwell)"

    try {
        & $curl `
            --silent `
            --location `
            --max-time 20 `
            --user-agent "$userAgent" `
            --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" `
            "$url" | Out-Null
    }
    catch {
        Write-Warning "Failed to access $url"
    }

    Start-Sleep $dwell
}

Write-Host "[*] Done"
