param(
  [string]$BundleDir = (Join-Path $PSScriptRoot "portable-config"),
  [string]$BundleName = "my-agent-portable.zip",
  [switch]$IncludeData
)

$ErrorActionPreference = "Stop"

$stageDir = Join-Path $PSScriptRoot ".portable-stage"
$bundlePath = Join-Path $BundleDir $BundleName

$pathsToCopy = @(
  ".env",
  ".env.example",
  "package.json",
  "package-lock.json",
  "docker-compose.yml",
  "docker-compose.custom.yml",
  "start-agent.bat",
  "stop-agent.bat",
  "create-shortcuts.ps1",
  "skills",
  "agent-job",
  "agents",
  "event-handler\TRIGGERS.json",
  "event-handler\litellm",
  "traefik-config",
  ".claude",
  ".omc",
  ".pi"
)

if ($IncludeData) {
  $pathsToCopy += "data"
}

if (Test-Path $stageDir) {
  Remove-Item -LiteralPath $stageDir -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $stageDir | Out-Null
New-Item -ItemType Directory -Force -Path $BundleDir | Out-Null

foreach ($relativePath in $pathsToCopy) {
  $sourcePath = Join-Path $PSScriptRoot $relativePath
  if (-not (Test-Path $sourcePath)) {
    continue
  }

  $targetPath = Join-Path $stageDir $relativePath
  $targetParent = Split-Path -Parent $targetPath
  if ($targetParent) {
    New-Item -ItemType Directory -Force -Path $targetParent | Out-Null
  }

  Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Recurse -Force
}

$manifest = [ordered]@{
  created_at = (Get-Date).ToString("s")
  source_repo = $PSScriptRoot
  include_data = $IncludeData.IsPresent
  included_paths = $pathsToCopy
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $stageDir "portable-manifest.json")

$envPath = Join-Path $PSScriptRoot ".env"
if (Test-Path $envPath) {
  $envSummary = Get-Content $envPath | ForEach-Object {
    if ($_ -match '^\s*$' -or $_ -match '^\s*#') {
      $_
      return
    }

    $parts = $_ -split '=', 2
    if ($parts.Count -ne 2) {
      $_
      return
    }

    $key = $parts[0].Trim()
    $value = $parts[1]
    if ($key -match 'KEY|TOKEN|SECRET|PASSWORD') {
      "$key=<redacted>"
    }
    else {
      "$key=$value"
    }
  }
  $envSummary | Set-Content -Path (Join-Path $stageDir "env-summary.txt")
}

if (Test-Path $bundlePath) {
  Remove-Item -LiteralPath $bundlePath -Force
}

Compress-Archive -Path (Join-Path $stageDir "*") -DestinationPath $bundlePath
Remove-Item -LiteralPath $stageDir -Recurse -Force

Write-Host "Portable bundle created:"
Write-Host "  $bundlePath"
Write-Host ""
Write-Host "This bundle includes your current:"
Write-Host "  - .env and startup files"
Write-Host "  - skills, agents, soul/crons/triggers"
Write-Host "  - traefik and LiteLLM config"
Write-Host "  - .claude, .omc, .pi folders"
if ($IncludeData) {
  Write-Host "  - data directory"
}
Write-Host ""
Write-Host "If this repo is private, you can commit portable-config/$BundleName for one-click restore on another PC."
