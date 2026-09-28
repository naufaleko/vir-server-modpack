@echo off
rem Syncs the mods for Vir's Server. Double-click before playing.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-mods.ps1" %*
echo.
pause
