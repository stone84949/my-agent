@echo off
REM thepopebot - Stop Script

cd /d "%~dp0"

echo Stopping thepopebot containers...
docker compose down

echo Done.