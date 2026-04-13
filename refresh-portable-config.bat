@echo off
setlocal
cd /d "%~dp0"

echo Creating updated portable bundle from your current machine...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0export-portable-config.ps1"

if errorlevel 1 (
  echo.
  echo Portable bundle export failed.
  exit /b 1
)

echo.
echo Portable bundle refreshed. Commit portable-config if you want it available after cloning on another PC.
exit /b 0
