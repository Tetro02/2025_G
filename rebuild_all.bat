@echo off
title 2025_G Vivado Build Only
chcp 65001 >nul
echo ========================================
echo   2025_G - Vivado Rebuild
echo   (synthesis -^> implementation -^> bitstream -^> XSA)
echo ========================================
echo.

REM ===== Initialize Vivado environment =====
set VIVADO_PATH=D:\Tetro\Tools\Vivado\2025.2
call "%VIVADO_PATH%\Vivado\settings64.bat"

REM ===== Create logs directory =====
if not exist "logs\" mkdir logs

REM ===== Clean up old backup logs from previous runs =====
if exist vivado_*.backup.jou move /Y vivado_*.backup.jou logs\ >nul 2>&1
if exist vivado_*.backup.log move /Y vivado_*.backup.log logs\ >nul 2>&1

REM ===== Step 1: Vivado Build =====
echo [1/1] Running Vivado: synthesis -^> implementation -^> bitstream -^> XSA ...
vivado -mode batch -source auto_build.tcl -log logs/vivado.log -journal logs/vivado.jou
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Vivado build failed! Check logs/vivado.log for details.
    pause
    exit /b %ERRORLEVEL%
)
echo [OK] Vivado build complete.
echo.

echo ========================================
echo   Done! Build completed successfully.
echo ========================================
echo.
echo Output files:
echo   - Test_Top.bit (bitstream)
echo   - Test_Top.xsa (hardware platform)
echo.
echo Logs: logs/vivado.log
echo.
pause
