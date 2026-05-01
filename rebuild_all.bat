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

REM ===== Step 1: Vivado Build =====
echo [1/1] Running Vivado: synthesis -^> implementation -^> bitstream -^> XSA ...
vivado -mode batch -source auto_build.tcl
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Vivado build failed! Check auto_build.tcl for details.
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
pause
