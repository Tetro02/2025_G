@echo off
setlocal
cd /d "%~dp0"
where vivado >nul 2>nul
if errorlevel 1 (
  echo Load Vivado 2025.2 settings64.bat before running this file.
  exit /b 1
)
if not exist logs mkdir logs
call vivado -mode batch -source auto_build.tcl -log logs/vivado.log -journal logs/vivado.jou
exit /b %errorlevel%
