# Copy the sf-data binary to %USERPROFILE%\bin\sfdata.exe and add that folder to the user Path.
# Usage: .\scripts\install-sfdata.ps1 [path-to-binary]
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$binaryName = 'sf-data-win-x64.exe'
$given = if ($args.Count -gt 0) { $args[0] } else { $null }

if ($given) {
  if (-not (Test-Path -LiteralPath $given)) {
    throw "Binary not found: $given"
  }
  $binary = (Resolve-Path -LiteralPath $given).Path
} else {
  $beside = Join-Path $scriptDir $binaryName
  $inRepo = Join-Path $scriptDir "..\dist-exec\$binaryName"
  if (Test-Path -LiteralPath $beside) {
    $binary = (Resolve-Path -LiteralPath $beside).Path
  } elseif (Test-Path -LiteralPath $inRepo) {
    $binary = (Resolve-Path -LiteralPath $inRepo).Path
  } else {
    throw "Binary not found. Pass its path, place $binaryName next to this script, or run npm run build:executables."
  }
}

$destDir = Join-Path $env:USERPROFILE 'bin'
New-Item -ItemType Directory -Force -Path $destDir | Out-Null
Copy-Item -LiteralPath $binary -Destination (Join-Path $destDir 'sfdata.exe') -Force

$current = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not $current) { $current = '' }
$normalizedDest = $destDir.TrimEnd('\')
$already = $current -split ';' | Where-Object { $_.TrimEnd('\') -ieq $normalizedDest }
if (-not $already) {
  $updated = if ($current) { "$current;$destDir" } else { $destDir }
  [Environment]::SetEnvironmentVariable('Path', $updated, 'User')
}

Write-Host "Installed $destDir\sfdata.exe. Open a new terminal and run: sfdata --help"
