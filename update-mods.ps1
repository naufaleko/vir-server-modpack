# Menyamakan mod untuk server Vir's Server. Jalankan lewat Update-Mods.bat.
# Hanya mengunduh dari cdn.modrinth.com, dan setiap file dicek SHA-1-nya sebelum dipakai.
param(
  [string]$ModsDir = (Join-Path $env:APPDATA '.minecraft\mods')
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ManifestUrl = 'https://raw.githubusercontent.com/naufaleko/vir-server-modpack/main/mods.json'
$AllowedHost = 'https://cdn.modrinth.com/'
$StateName = '.modpack-sync.json'

function Get-Sha1([string]$Path) {
  (Get-FileHash -Algorithm SHA1 -LiteralPath $Path).Hash.ToLowerInvariant()
}

Write-Host 'Mengambil daftar mod dari GitHub...'
$manifest = Invoke-RestMethod -UseBasicParsing -Uri ($ManifestUrl + '?t=' + [DateTimeOffset]::UtcNow.ToUnixTimeSeconds())
$mods = @($manifest.mods)

foreach ($mod in $mods) {
  if ([string]$mod.filename -notmatch '^[^\\/:*?"<>|]+\.jar$') { throw "Nama file tidak valid di daftar: $($mod.filename)" }
  if (-not ([string]$mod.url).StartsWith($AllowedHost)) { throw "Alamat unduhan di luar Modrinth ditolak: $($mod.url)" }
}

New-Item -ItemType Directory -Force -Path $ModsDir | Out-Null
$statePath = Join-Path $ModsDir $StateName
$wanted = @($mods | ForEach-Object { [string]$_.filename })
$previous = @()

if (Test-Path -LiteralPath $statePath) {
  $previous = @((Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json).files)
} else {
  # Pertama kali: mod lain yang sudah ada biasanya untuk versi lain dan bikin bentrok.
  # Dipindah ke folder cadangan, tidak dihapus.
  $others = @(Get-ChildItem -LiteralPath $ModsDir -Filter '*.jar' -File | Where-Object { $wanted -notcontains $_.Name })
  if ($others.Count -gt 0) {
    $backup = Join-Path (Split-Path $ModsDir -Parent) ('mods-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
    New-Item -ItemType Directory -Force -Path $backup | Out-Null
    $others | Move-Item -Destination $backup
    Write-Host ('{0} mod lama dipindah ke {1}' -f $others.Count, $backup)
  }
}

$added = 0
$kept = 0
foreach ($mod in $mods) {
  $target = Join-Path $ModsDir ([string]$mod.filename)
  if ((Test-Path -LiteralPath $target) -and ((Get-Sha1 $target) -eq $mod.sha1)) { $kept++; continue }
  Write-Host ('Mengunduh {0} {1}...' -f $mod.name, $mod.version)
  $part = $target + '.part'
  Invoke-WebRequest -UseBasicParsing -Uri $mod.url -OutFile $part
  if ((Get-Sha1 $part) -ne $mod.sha1) {
    Remove-Item -LiteralPath $part -Force
    throw ('File {0} tidak cocok dengan daftar, jadi dibuang.' -f $mod.filename)
  }
  Move-Item -LiteralPath $part -Destination $target -Force
  $added++
}

# Mod yang dulu dipasang skrip ini tapi sudah tidak ada di daftar.
$removed = 0
foreach ($old in $previous) {
  if ($wanted -contains $old) { continue }
  if ([string]$old -notmatch '^[^\\/:*?"<>|]+\.jar$') { continue }
  $path = Join-Path $ModsDir $old
  if (Test-Path -LiteralPath $path) {
    Remove-Item -LiteralPath $path -Force
    Write-Host ('Dihapus: {0}' -f $old)
    $removed++
  }
}

@{ files = $wanted; syncedAt = (Get-Date).ToString('o') } | ConvertTo-Json | Set-Content -LiteralPath $statePath -Encoding UTF8

Write-Host ''
Write-Host ('Selesai: {0} baru atau diperbarui, {1} sudah cocok, {2} dihapus.' -f $added, $kept, $removed)
if ($manifest.server) { Write-Host ('Alamat server: {0}' -f $manifest.server) }
