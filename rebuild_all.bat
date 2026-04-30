@echo off
title 2025_G Auto Build
chcp 65001 >nul
echo ========================================
echo   2025_G - Full Rebuild Automation
echo ========================================
echo.

REM ===== Initialize Vivado/Vitis environment =====
set VIVADO_PATH=D:\Tetro\Tools\Vivado\2025.2
call "%VIVADO_PATH%\Vivado\settings64.bat"
call "%VIVADO_PATH%\Vitis\settings64.bat"

REM ===== Step 1: Vivado Build =====
echo [1/3] Running Vivado: synthesis -^> implementation -^> bitstream -^> XSA ...
vivado -mode batch -source auto_build.tcl
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Vivado build failed! Check auto_build.tcl for details.
    pause
    exit /b %ERRORLEVEL%
)
echo [OK] Vivado build complete.
echo.

REM ===== Step 2: Update Platform XSA =====
echo [2/3] Updating platform with new XSA ...
copy /Y Test_Top.xsa platform\hw\Test_Top.xsa >nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to copy XSA to platform/hw/
    pause
    exit /b %ERRORLEVEL%
)
echo [OK] Platform XSA updated.
echo.

REM ===== Step 3: Rebuild Vitis Projects =====
echo [3/3] Running Vitis: update_hw -^> rebuild platform -^> rebuild hello_world ...

REM Use Vitis bundled Python (script sets its own PYTHONPATH internally)
set VITIS_PYTHON=%VIVADO_PATH%\tps\win64\python-3.13.0\python.exe
"%VITIS_PYTHON%" auto_rebuild_vitis.py
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Vitis build failed!
    pause
    exit /b %ERRORLEVEL%
)
echo [OK] Vitis rebuild complete.

echo.
echo ========================================
echo   All done! Build completed successfully.
echo ========================================
echo.
echo Output files:
echo   - Test_Top.bit (bitstream)
echo   - Test_Top.xsa (hardware platform)
echo   - hello_world\build\hello_world.elf (application)
echo.
pause
