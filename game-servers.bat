@echo off
setlocal

:: Get the full path to the script
set "SCRIPT=%~dp0game-servers.ps1"

:: Run PowerShell as administrator
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%SCRIPT%""' -Verb RunAs"

endlocal