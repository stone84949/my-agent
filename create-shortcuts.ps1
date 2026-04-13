$repoRoot = $PSScriptRoot
$desktop = [Environment]::GetFolderPath("Desktop")
$WshShell = New-Object -ComObject WScript.Shell

$Shortcut = $WshShell.CreateShortcut((Join-Path $desktop "thepopebot - Start Agent.lnk"))
$Shortcut.TargetPath = (Join-Path $repoRoot "start-agent.bat")
$Shortcut.WorkingDirectory = $repoRoot
$Shortcut.Description = "Start the thepopebot AI Agent"
$Shortcut.Save()

$Shortcut2 = $WshShell.CreateShortcut((Join-Path $desktop "thepopebot - Web Interface.lnk"))
$Shortcut2.TargetPath = "http://localhost"
$Shortcut2.Description = "Open thepopebot web chat"
$Shortcut2.Save()

$Shortcut3 = $WshShell.CreateShortcut((Join-Path $desktop "thepopebot - Backup Custom Config.lnk"))
$Shortcut3.TargetPath = "powershell.exe"
$Shortcut3.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$repoRoot\backup-custom.ps1`""
$Shortcut3.WorkingDirectory = $repoRoot
$Shortcut3.Description = "Backup thepopebot custom config and skills"
$Shortcut3.Save()

$Shortcut4 = $WshShell.CreateShortcut((Join-Path $desktop "thepopebot - Refresh Portable Bundle.lnk"))
$Shortcut4.TargetPath = (Join-Path $repoRoot "refresh-portable-config.bat")
$Shortcut4.WorkingDirectory = $repoRoot
$Shortcut4.Description = "Update the portable restore bundle for this repo"
$Shortcut4.Save()

$Shortcut5 = $WshShell.CreateShortcut((Join-Path $desktop "thepopebot - Setup New PC.lnk"))
$Shortcut5.TargetPath = (Join-Path $repoRoot "setup-new-pc.bat")
$Shortcut5.WorkingDirectory = $repoRoot
$Shortcut5.Description = "Restore thepopebot settings into this clone and start it"
$Shortcut5.Save()

Write-Host "Desktop shortcuts created successfully!"
Write-Host "- thepopebot - Start Agent (starts the containers)"
Write-Host "- thepopebot - Web Interface (opens chat in browser)"
Write-Host "- thepopebot - Backup Custom Config (creates a restore snapshot)"
Write-Host "- thepopebot - Refresh Portable Bundle (updates the GitHub-safe restore zip)"
Write-Host "- thepopebot - Setup New PC (restores config into this clone and starts it)"
