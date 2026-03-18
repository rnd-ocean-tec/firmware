@echo off
setlocal enabledelayedexpansion

REM Usage:
REM   flash.bat COM5
REM   flash.bat COM5 921600

if "%~1"=="" (
  echo Usage: %~nx0 ^<COM_PORT^> [BAUD]
  echo Example: %~nx0 COM5 921600
  exit /b 1
)

set "PORT=%~1"
set "BAUD=%~2"
if "%BAUD%"=="" set "BAUD=921600"

echo ==^> Flashing ESP32-S3 firmware to %PORT% at %BAUD% baud

python -m esptool --chip esp32s3 --port %PORT% --baud %BAUD% --before default_reset --after hard_reset write_flash -z ^
  0x1000 bootloader.bin ^
  0x8000 partitions.bin ^
  0x10000 firmware.bin

if errorlevel 1 (
  echo Flash failed.
  exit /b 1
)

echo Flash successful.
exit /b 0
