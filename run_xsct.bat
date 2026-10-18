@echo off
setlocal
cd /d "%~dp0"
where xsct >nul 2>nul
if errorlevel 1 (
  echo Load the matching AMD tool environment and review run_app.tcl first.
  exit /b 1
)
call xsct run_app.tcl
exit /b %errorlevel%
