@echo off
setlocal
cd /d "%~dp0"

echo Restoring portable config into this clone...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0restore-portable-config.ps1" -StartAgent

if errorlevel 1 (
  echo.
  echo Setup failed. Make sure portable-config\my-agent-portable.zip exists in this repo clone.
  exit /b 1
)

echo.
echo Setup complete.
exit /b 0
