param(
  [string]$OutputRoot = (Join-Path $PSScriptRoot ".backups"),
  [switch]$IncludeData
)

$ErrorActionPreference = "Stop"

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupName = "custom-$timestamp"
$backupDir = Join-Path $OutputRoot $backupName
$zipPath = Join-Path $OutputRoot "$backupName.zip"

$pathsToCopy = @(
  ".env",
  ".env.example",
  "package.json",
  "package-lock.json",
  "docker-compose.yml",
  "docker-compose.custom.yml",
  "start-agent.bat",
  "stop-agent.bat",
  "skills",
  "agent-job",
  "agents",
  "event-handler\TRIGGERS.json",
  "event-handler\litellm"
)

if ($IncludeData) {
  $pathsToCopy += "data"
}

New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

foreach ($relativePath in $pathsToCopy) {
  $sourcePath = Join-Path $PSScriptRoot $relativePath
  if (-not (Test-Path $sourcePath)) {
    continue
  }

  $targetPath = Join-Path $backupDir $relativePath
  $targetParent = Split-Path -Parent $targetPath
  if ($targetParent) {
    New-Item -ItemType Directory -Force -Path $targetParent | Out-Null
  }

  Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Recurse -Force
}

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

  $envSummary | Set-Content -Path (Join-Path $backupDir "env-summary.txt")
}

$notes = @(
  "Backup created: $backupName",
  "Created: $(Get-Date -Format s)",
  "Source: $PSScriptRoot",
  "Included data directory: $($IncludeData.IsPresent)"
)
$notes | Set-Content -Path (Join-Path $backupDir "backup-notes.txt")

if (Test-Path $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}
Compress-Archive -Path (Join-Path $backupDir "*") -DestinationPath $zipPath

Write-Host "Custom backup created:"
Write-Host "  Folder: $backupDir"
Write-Host "  Zip:    $zipPath"
Write-Host ""
Write-Host "Included:"
Write-Host "  - .env and env summary"
Write-Host "  - skills, agent-job, agents"
Write-Host "  - TRIGGERS.json and LiteLLM config"
Write-Host "  - compose files and startup scripts"
if ($IncludeData) {
  Write-Host "  - data directory"
}
