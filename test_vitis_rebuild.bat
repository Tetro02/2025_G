@echo off
title Test Vitis Rebuild Only
chcp 65001 >nul
echo ========================================
echo   Test: Vitis Rebuild Only
echo   (Skips Vivado, assumes XSA already copied)
echo ========================================
echo.

REM ===== Initialize Vitis environment =====
set VIVADO_PATH=D:\Tetro\Tools\Vivado\2025.2
call "%VIVADO_PATH%\Vitis\settings64.bat"

REM ===== Run Vitis rebuild =====
echo [Running] auto_rebuild_vitis.py via Vitis Python ...
set VITIS_PYTHON=%VIVADO_PATH%\tps\win64\python-3.13.0\python.exe
"%VITIS_PYTHON%" auto_rebuild_vitis.py
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Vitis build failed!
    pause
    exit /b %ERRORLEVEL%
)
echo [OK] Vitis rebuild complete.
echo.
pause
