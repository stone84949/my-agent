@echo off
setlocal EnableDelayedExpansion
REM thepopebot - AI Agent Startup Script
REM Run this to start your agent

cd /d "%~dp0"

set "APP_URL=http://localhost"
set "EVENT_HANDLER_CONTAINER=thepopebot-event-handler"
set /a MAX_ATTEMPTS=24
set /a WAIT_SECONDS=5
set "DOCKER_CMD=docker"

if exist "C:\Program Files\Docker\Docker\resources\bin\docker.exe" (
  set "DOCKER_CMD=C:\Program Files\Docker\Docker\resources\bin\docker.exe"
)

echo Starting thepopebot containers...
"%DOCKER_CMD%" compose up -d
if errorlevel 1 goto startup_failed

echo.
echo Waiting for event-handler to report healthy...
set /a ATTEMPT=0

:wait_for_health
powershell -NoProfile -Command "try { $response = Invoke-WebRequest -UseBasicParsing '%APP_URL%/api/ping' -TimeoutSec 3; if ($response.Content -match 'Pong') { exit 0 } else { exit 1 } } catch { exit 1 }"
if not errorlevel 1 goto startup_success

:try_again
set /a ATTEMPT+=1
if !ATTEMPT! geq !MAX_ATTEMPTS! goto startup_timeout
timeout /t !WAIT_SECONDS! /nobreak >nul
goto wait_for_health

:startup_success
echo.
echo ================================================
echo thepopebot is running!
echo.
echo Web Interface: %APP_URL%
echo.
echo NOTE: For external access (GitHub webhooks, Telegram),
echo you need to run ngrok: ngrok http 80
echo Then update .env with your ngrok URL as APP_HOSTNAME
echo ================================================
start %APP_URL%
exit /b 0

:startup_timeout
echo.
echo event-handler did not respond at %APP_URL%/api/ping in time.
echo.
echo Showing recent event-handler logs for troubleshooting...
"%DOCKER_CMD%" compose logs --tail 80 event-handler
exit /b 1

:startup_failed
echo.
echo docker compose up failed. Showing recent logs...
"%DOCKER_CMD%" compose logs --tail 80 event-handler
exit /b 1
