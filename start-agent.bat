@echo off
REM thepopebot - AI Agent Startup Script
REM Run this to start your agent

cd /d "%~dp0"

echo Starting thepopebot containers...
docker compose up -d

echo.
echo Waiting for services to be ready...
timeout /t 5 /nobreak >nul

echo.
echo ================================================
echo thepopebot is running!
echo.
echo Web Interface: http://localhost
echo.
echo NOTE: For external access (GitHub webhooks, Telegram),
echo you need to run ngrok: ngrok http 80
echo Then update .env with your ngrok URL as APP_HOSTNAME
echo ================================================

start http://localhost