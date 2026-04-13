$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\thepopebot - Start Agent.lnk")
$Shortcut.TargetPath = "D:\05-Areas\GITHUB\thepopebot\my-agent\start-agent.bat"
$Shortcut.WorkingDirectory = "D:\05-Areas\GITHUB\thepopebot\my-agent"
$Shortcut.Description = "Start the thepopebot AI Agent"
$Shortcut.Save()

$Shortcut2 = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\thepopebot - Web Interface.lnk")
$Shortcut2.TargetPath = "http://localhost"
$Shortcut2.Description = "Open thepopebot web chat"
$Shortcut2.Save()

Write-Host "Desktop shortcuts created successfully!"
Write-Host "- thepopebot - Start Agent (starts the containers)"
Write-Host "- thepopebot - Web Interface (opens chat in browser)"