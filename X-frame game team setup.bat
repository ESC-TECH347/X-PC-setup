@echo off
REM ============================================================
REM  X-Frame PC Setup script
REM
REM  Prompts the technician for:
REM    1) Which X-Frame game is being installed
REM    2) Which PC (PC1-PC6)
REM    3) The local M3 server IP address
REM
REM  There is NO formula for the game URLs - each game/PC
REM  combination uses its own fixed path, hardcoded in the
REM  LOOKUP section below. Full table:
REM
REM    Saving Santa   (PC1-PC5 only, no PC6):
REM      PC1: savingsanta-tv-1.msp
REM      PC2: savingsanta-tv-2.msp
REM      PC3: savingsanta-tv-large.msp
REM      PC4: savingsanta-projector.msp
REM      PC5: savingsanta-tv-42.msp
REM
REM    Crime Scene    (PC1, PC2, PC3, PC6 only - no PC4/PC5):
REM      PC1: tv-1.msp
REM      PC2: tv-2.msp
REM      PC3: tv-large.msp
REM      PC6: TWO monitors - window id 1 = precinct-monitor-1.msp
REM                            window id 2 = precinct-monitor-2.msp
REM           (this is the only combo where window id 2 is touched;
REM            every other combo leaves window id 2 alone)
REM
REM    Now You See Me (PC1-PC6, all six):
REM      PC1: nysm-tv-1.msp
REM      PC2: nysm-tv-2.msp
REM      PC3: nysm-tv-large.msp
REM      PC4: nysm-projector.msp
REM      PC5: nysm-tv-42.msp
REM      PC6: nysm-painting.msp
REM
REM  Full URL pattern: http://<M3 IP>:1860/<path from table above>
REM
REM  Assumptions baked into this script (change here if wrong):
REM    - settings.xml always lives at the path in SETTINGS_PATH below.
REM    - Window id 1 is ALWAYS updated with the game URL.
REM    - Except for the Crime Scene + PC6 case (two monitors), window
REM      id 2 is REMOVED from settings.xml entirely (single-monitor
REM      setups only need window id 1).
REM    - For Crime Scene + PC6, window id 2 is required: if it's
REM      missing (e.g. a previous run removed it), the script adds it
REM      back with screen=1, fullscreen=true, span=false before
REM      setting its last-url.
REM    - Portrait vs. Landscape (PC1/PC2 vs PC3-PC6) does NOT change
REM      anything inside settings.xml - it's shown only as a reminder
REM      to the technician to double check the monitor is physically
REM      rotated correctly.
REM ============================================================

setlocal EnableDelayedExpansion
title X-Frame PC Setup

set "SETTINGS_PATH=C:\Program Files (x86)\MythricClient\settings.xml"

:GAME_MENU
cls
echo ============================================
echo   X-Frame PC Setup
echo ============================================
echo.
echo  Which X-Frame game is being installed?
echo.
echo   1. Saving Santa
echo   2. Crime Scene
echo   3. Now You See Me
echo.
set "GAME_CHOICE="
set /p "GAME_CHOICE=Enter 1-3: "

if "%GAME_CHOICE%"=="1" (set "GAME_NAME=Saving Santa" & set "GAME_KEY=SANTA" & goto PC_MENU)
if "%GAME_CHOICE%"=="2" (set "GAME_NAME=Crime Scene" & set "GAME_KEY=CRIMESCENE" & goto PC_MENU)
if "%GAME_CHOICE%"=="3" (set "GAME_NAME=Now You See Me" & set "GAME_KEY=NYSM" & goto PC_MENU)

echo.
echo Invalid selection. Please enter a number 1-3.
pause >nul
goto GAME_MENU

:PC_MENU
cls
echo ============================================
echo   X-Frame PC Setup  -  Game: !GAME_NAME!
echo ============================================
echo.
echo  Which PC is this?
echo.
echo   1. PC1  (Portrait)
echo   2. PC2  (Portrait)
echo   3. PC3  (Landscape)
echo   4. PC4  (Landscape)
echo   5. PC5  (Landscape)
echo   6. PC6  (Landscape)
echo.
set "PC_CHOICE="
set /p "PC_CHOICE=Enter 1-6: "

if "%PC_CHOICE%"=="1" (set "PC_NAME=PC1" & set "ORIENTATION=Portrait" & goto LOOKUP)
if "%PC_CHOICE%"=="2" (set "PC_NAME=PC2" & set "ORIENTATION=Portrait" & goto LOOKUP)
if "%PC_CHOICE%"=="3" (set "PC_NAME=PC3" & set "ORIENTATION=Landscape" & goto LOOKUP)
if "%PC_CHOICE%"=="4" (set "PC_NAME=PC4" & set "ORIENTATION=Landscape" & goto LOOKUP)
if "%PC_CHOICE%"=="5" (set "PC_NAME=PC5" & set "ORIENTATION=Landscape" & goto LOOKUP)
if "%PC_CHOICE%"=="6" (set "PC_NAME=PC6" & set "ORIENTATION=Landscape" & goto LOOKUP)

echo.
echo Invalid selection. Please enter a number 1-6.
pause >nul
goto PC_MENU

:LOOKUP
set "UPDATE_WINDOW2=0"
set "PATH_1="
set "PATH_2="

if "%GAME_KEY%"=="SANTA" if "%PC_CHOICE%"=="1" (set "PATH_1=savingsanta-tv-1.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="SANTA" if "%PC_CHOICE%"=="2" (set "PATH_1=savingsanta-tv-2.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="SANTA" if "%PC_CHOICE%"=="3" (set "PATH_1=savingsanta-tv-large.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="SANTA" if "%PC_CHOICE%"=="4" (set "PATH_1=savingsanta-projector.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="SANTA" if "%PC_CHOICE%"=="5" (set "PATH_1=savingsanta-tv-42.msp" & goto LOOKUP_OK)

if "%GAME_KEY%"=="CRIMESCENE" if "%PC_CHOICE%"=="1" (set "PATH_1=tv-1.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="CRIMESCENE" if "%PC_CHOICE%"=="2" (set "PATH_1=tv-2.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="CRIMESCENE" if "%PC_CHOICE%"=="3" (set "PATH_1=tv-large.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="CRIMESCENE" if "%PC_CHOICE%"=="6" (set "PATH_1=precinct-monitor-1.msp" & set "PATH_2=precinct-monitor-2.msp" & set "UPDATE_WINDOW2=1" & goto LOOKUP_OK)

if "%GAME_KEY%"=="NYSM" if "%PC_CHOICE%"=="1" (set "PATH_1=nysm-tv-1.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="NYSM" if "%PC_CHOICE%"=="2" (set "PATH_1=nysm-tv-2.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="NYSM" if "%PC_CHOICE%"=="3" (set "PATH_1=nysm-tv-large.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="NYSM" if "%PC_CHOICE%"=="4" (set "PATH_1=nysm-projector.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="NYSM" if "%PC_CHOICE%"=="5" (set "PATH_1=nysm-tv-42.msp" & goto LOOKUP_OK)
if "%GAME_KEY%"=="NYSM" if "%PC_CHOICE%"=="6" (set "PATH_1=nysm-painting.msp" & goto LOOKUP_OK)

goto LOOKUP_INVALID

:LOOKUP_INVALID
echo.
echo !GAME_NAME! is not set up on !PC_NAME!.
if "%GAME_KEY%"=="SANTA" echo Saving Santa is only set up on PC1, PC2, PC3, PC4, and PC5 (no PC6).
if "%GAME_KEY%"=="CRIMESCENE" echo Crime Scene is only set up on PC1, PC2, PC3, and PC6 (no PC4 or PC5).
if "%GAME_KEY%"=="NYSM" echo Now You See Me should be available on all of PC1-PC6 - if you are seeing this, something is wrong with the script.
echo.
echo Please choose a different PC.
pause >nul
goto PC_MENU

:LOOKUP_OK
goto IP_ENTRY

:IP_ENTRY
cls
echo ============================================
echo   X-Frame PC Setup  -  !PC_NAME! (!ORIENTATION!)
echo   Game: !GAME_NAME!
echo ============================================
echo.
set "M3_IP="
set /p "M3_IP=Enter the M3 server IP address (e.g. 192.168.1.50): "

echo !M3_IP!| findstr /r "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$" >nul
if errorlevel 1 goto BAD_IP
goto BUILD_URL

:BAD_IP
echo.
echo "!M3_IP!" does not look like a valid IP address (expected e.g. 192.168.1.50). Please try again.
pause >nul
goto IP_ENTRY

:BUILD_URL
set "GAME_URL_1=http://!M3_IP!:1860/!PATH_1!"
if "%UPDATE_WINDOW2%"=="1" set "GAME_URL_2=http://!M3_IP!:1860/!PATH_2!"

if "%UPDATE_WINDOW2%"=="1" goto CONFIRM_DUAL
goto CONFIRM_SINGLE

:CONFIRM_SINGLE
cls
echo ============================================
echo   Confirm Setup
echo ============================================
echo.
echo   Game:        !GAME_NAME!
echo   PC:          !PC_NAME!  (!ORIENTATION!)
echo   M3 Server:   !M3_IP!
echo   URL to set:  !GAME_URL_1!
echo.
echo   This will update window id 1's last-url in settings.xml.
echo   Window id 2 will be REMOVED from settings.xml if present.
echo.
goto CONFIRM_PROMPT

:CONFIRM_DUAL
cls
echo ============================================
echo   Confirm Setup
echo ============================================
echo.
echo   Game:        !GAME_NAME!
echo   PC:          !PC_NAME!  (!ORIENTATION!)
echo   M3 Server:   !M3_IP!
echo   Monitor 1 URL (window id 1):  !GAME_URL_1!
echo   Monitor 2 URL (window id 2):  !GAME_URL_2!
echo.
echo   NOTE: !PC_NAME! + !GAME_NAME! uses two monitors, so THIS WILL
echo   UPDATE BOTH window id 1 and window id 2 in settings.xml
echo   (window id 2 will be added back automatically if it isn't
echo   already there).
echo.
goto CONFIRM_PROMPT

:CONFIRM_PROMPT
echo   (settings.xml location is fixed at the top of this script.)
echo.
set "CONFIRM_CHOICE="
set /p "CONFIRM_CHOICE=Apply these settings? (Y/N): "
if /i "%CONFIRM_CHOICE%"=="Y" goto CHECK_FILE
if /i "%CONFIRM_CHOICE%"=="N" goto GAME_MENU
goto CONFIRM_PROMPT

:CHECK_FILE
if not exist "%SETTINGS_PATH%" goto NO_FILE
goto BACKUP

:NO_FILE
echo.
echo ERROR: settings.xml was not found at:
echo   %SETTINGS_PATH%
echo.
echo Nothing was changed. Please verify MythricClient is installed on this PC,
echo or edit SETTINGS_PATH near the top of this script if it installs elsewhere.
echo.
pause
exit /b 1

:BACKUP
set "TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "BACKUP_PATH=%SETTINGS_PATH%.%TIMESTAMP%.bak"

copy /y "%SETTINGS_PATH%" "%BACKUP_PATH%" >nul
if errorlevel 1 goto BACKUP_FAILED
goto WRITE_PS1

:BACKUP_FAILED
echo.
echo ERROR: Could not create a backup copy of settings.xml. Aborting - no changes made.
echo.
pause
exit /b 1

:WRITE_PS1
set "PS_SCRIPT=%TEMP%\xframe_update_settings.ps1"
if exist "%PS_SCRIPT%" del "%PS_SCRIPT%"

echo $ErrorActionPreference = 'Stop' >> "%PS_SCRIPT%"
echo $path = '%SETTINGS_PATH%' >> "%PS_SCRIPT%"
echo [xml]$xml = Get-Content -LiteralPath $path -Raw >> "%PS_SCRIPT%"
echo $windowsNode = $xml.resource.windows >> "%PS_SCRIPT%"
echo $w1 = $windowsNode.window ^| Where-Object { $_.id -eq '1' } >> "%PS_SCRIPT%"
echo if ($w1 -eq $null) { Write-Error 'Could not find a window with id 1 in settings.xml'; exit 1 } >> "%PS_SCRIPT%"
echo $w1.'last-url' = '%GAME_URL_1%' >> "%PS_SCRIPT%"
echo $w2 = $windowsNode.window ^| Where-Object { $_.id -eq '2' } >> "%PS_SCRIPT%"

if "%UPDATE_WINDOW2%"=="1" goto WRITE_PS1_NEED_W2
goto WRITE_PS1_REMOVE_W2

:WRITE_PS1_NEED_W2
echo if ($w2 -eq $null) { >> "%PS_SCRIPT%"
echo   $newWindow = $xml.CreateElement('window') >> "%PS_SCRIPT%"
echo   $idNode = $xml.CreateElement('id'); $idNode.InnerText = '2'; [void]$newWindow.AppendChild($idNode) >> "%PS_SCRIPT%"
echo   $screenNode = $xml.CreateElement('screen'); $screenNode.InnerText = '1'; [void]$newWindow.AppendChild($screenNode) >> "%PS_SCRIPT%"
echo   $urlNode = $xml.CreateElement('last-url'); $urlNode.InnerText = '%GAME_URL_2%'; [void]$newWindow.AppendChild($urlNode) >> "%PS_SCRIPT%"
echo   $fsNode = $xml.CreateElement('fullscreen'); $fsNode.InnerText = 'true'; [void]$newWindow.AppendChild($fsNode) >> "%PS_SCRIPT%"
echo   $spanNode = $xml.CreateElement('span'); $spanNode.InnerText = 'false'; [void]$newWindow.AppendChild($spanNode) >> "%PS_SCRIPT%"
echo   [void]$windowsNode.AppendChild($newWindow) >> "%PS_SCRIPT%"
echo } else { >> "%PS_SCRIPT%"
echo   $w2.'last-url' = '%GAME_URL_2%' >> "%PS_SCRIPT%"
echo } >> "%PS_SCRIPT%"
goto WRITE_PS1_SAVE

:WRITE_PS1_REMOVE_W2
echo if ($w2 -ne $null) { [void]$windowsNode.RemoveChild($w2) } >> "%PS_SCRIPT%"

:WRITE_PS1_SAVE
echo $xml.Save($path) >> "%PS_SCRIPT%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
if errorlevel 1 goto UPDATE_FAILED
goto DONE

:UPDATE_FAILED
echo.
echo ERROR: Failed to update settings.xml. A backup of the original was saved at:
echo   %BACKUP_PATH%
echo.
pause
exit /b 1

:DONE
del "%PS_SCRIPT%" >nul 2>&1

echo.
echo ============================================
echo   Done!
echo ============================================
echo.
echo   !PC_NAME! is now configured for !GAME_NAME!.
if "%UPDATE_WINDOW2%"=="1" (
echo   settings.xml window id 1 last-url set to: !GAME_URL_1!
echo   settings.xml window id 2 last-url set to: !GAME_URL_2!
echo   ^(window id 2 was added back if it wasn't already there^)
) else (
echo   settings.xml window id 1 last-url set to: !GAME_URL_1!
echo   settings.xml window id 2 has been removed ^(if it was present^).
)
echo.
echo   A backup of the original file was saved as:
echo     %BACKUP_PATH%
echo.
echo   Reminder: !PC_NAME! should be physically set to !ORIENTATION! mode.
echo.
pause
exit /b 0