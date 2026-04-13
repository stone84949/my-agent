param(
  [string]$BundlePath = (Join-Path $PSScriptRoot "portable-config\my-agent-portable.zip"),
  [switch]$StartAgent
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $BundlePath)) {
  throw "Portable bundle not found: $BundlePath"
}

$extractDir = Join-Path $PSScriptRoot ".portable-restore"

if (Test-Path $extractDir) {
  Remove-Item -LiteralPath $extractDir -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
Expand-Archive -LiteralPath $BundlePath -DestinationPath $extractDir -Force

Get-ChildItem -LiteralPath $extractDir -Force | ForEach-Object {
  $targetPath = Join-Path $PSScriptRoot $_.Name
  if (Test-Path $targetPath) {
    Remove-Item -LiteralPath $targetPath -Recurse -Force
  }
  Copy-Item -LiteralPath $_.FullName -Destination $targetPath -Recurse -Force
}

Remove-Item -LiteralPath $extractDir -Recurse -Force

if (Test-Path (Join-Path $PSScriptRoot "create-shortcuts.ps1")) {
  powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "create-shortcuts.ps1")
}

Write-Host "Portable config restored into:"
Write-Host "  $PSScriptRoot"
Write-Host ""
Write-Host "Restored:"
Write-Host "  - .env and startup files"
Write-Host "  - skills, agents, soul/crons/triggers"
Write-Host "  - traefik and LiteLLM config"
Write-Host "  - .claude, .omc, .pi folders"

if ($StartAgent) {
  Write-Host ""
  Write-Host "Starting thepopebot..."
  cmd /c (Join-Path $PSScriptRoot "start-agent.bat")
}
