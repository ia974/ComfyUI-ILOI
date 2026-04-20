@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION DES CHEMINS ---
set "ROOT_DIR=%~dp0"
set "DESKTOP=%USERPROFILE%\Desktop"

:: Nom du dossier ComfyUI (si ton dossier s'appelle différemment, change-le ici)
set "COMFY_FOLDER=%ROOT_DIR%ComfyUI_windows_portable\ComfyUI"

echo ---------------------------------------------------
echo      CREATION DES RACCOURCIS COMFY UI
echo ---------------------------------------------------
echo.

:: ==========================================
:: 1. RACCOURCI APPLICATION (.EXE)
:: ==========================================
set "TARGET_APP=%ROOT_DIR%Comfy UI.exe"
set "SHORTCUT_APP=%DESKTOP%\Comfy UI.lnk"

if exist "%TARGET_APP%" (
    echo [1/3] Creation du raccourci Application...
    powershell -NoProfile -Command ^
        "$ws = New-Object -ComObject WScript.Shell; " ^
        "$s = $ws.CreateShortcut('%SHORTCUT_APP%'); " ^
        "$s.TargetPath = '%TARGET_APP%'; " ^
        "$s.WorkingDirectory = '%ROOT_DIR%'; " ^
        "$s.Save()"
) else (
    echo [ERREUR] "Comfy UI.exe" introuvable. Raccourci app ignore.
)

:: ==========================================
:: 2. RACCOURCI DOSSIER OUTPUT
:: ==========================================
set "TARGET_OUT=%ROOT_DIR%%COMFY_FOLDER%\output"
set "SHORTCUT_OUT=%DESKTOP%\Comfy Output.lnk"

:: Création du dossier s'il n'existe pas
if not exist "%TARGET_OUT%" mkdir "%TARGET_OUT%"

echo [2/3] Creation du raccourci Output...
powershell -NoProfile -Command ^
    "$ws = New-Object -ComObject WScript.Shell; " ^
    "$s = $ws.CreateShortcut('%SHORTCUT_OUT%'); " ^
    "$s.TargetPath = '%TARGET_OUT%'; " ^
    "$s.Save()"

:: ==========================================
:: 3. RACCOURCI DOSSIER MODELS
:: ==========================================
set "TARGET_MOD=%ROOT_DIR%%COMFY_FOLDER%\models"
set "SHORTCUT_MOD=%DESKTOP%\Comfy Models.lnk"

:: Création du dossier s'il n'existe pas
if not exist "%TARGET_MOD%" mkdir "%TARGET_MOD%"

echo [3/3] Creation du raccourci Models...
powershell -NoProfile -Command ^
    "$ws = New-Object -ComObject WScript.Shell; " ^
    "$s = $ws.CreateShortcut('%SHORTCUT_MOD%'); " ^
    "$s.TargetPath = '%TARGET_MOD%'; " ^
    "$s.Save()"

echo.
echo ---------------------------------------------------
echo TERMINE ! Trois raccourcis ont ete places sur le bureau.
timeout /t 3 >nul