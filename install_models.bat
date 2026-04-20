@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: ============================================================
::  install_models.bat
::  Télécharge les modèles listés dans models.csv vers :
::  <dossier actuel>\ComfyUI_windows_portable\ComfyUI\models\
:: ============================================================

set "SCRIPT_DIR=%~dp0"
set "MODELS_ROOT=%SCRIPT_DIR%ComfyUI_windows_portable\ComfyUI\models"
set "CSV_FILE=%SCRIPT_DIR%models.csv"

echo.
echo  =========================================
echo   Installation des modeles ComfyUI
echo  =========================================
echo.

:: --- Vérifications préalables ---

if not exist "%CSV_FILE%" (
    echo [ERREUR] Fichier models.csv introuvable : %CSV_FILE%
    pause
    exit /b 1
)

if not exist "%MODELS_ROOT%" (
    echo [ERREUR] Dossier models introuvable : %MODELS_ROOT%
    echo Verifiez que ComfyUI portable est bien installe.
    pause
    exit /b 1
)

:: Vérifier que curl est disponible
curl --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] curl n'est pas disponible sur ce systeme.
    echo Installez curl ou utilisez Windows 10/11 (curl est inclus).
    pause
    exit /b 1
)

echo  Lecture de : %CSV_FILE%
echo  Destination : %MODELS_ROOT%
echo.

:: --- Lecture du CSV ligne par ligne (on saute l'en-tête) ---

set "LINE_NUM=0"
set "SKIP=0"
set "COUNT_OK=0"
set "COUNT_SKIP=0"
set "COUNT_ERR=0"

for /f "usebackq tokens=1,2,3 delims=," %%A in ("%CSV_FILE%") do (

    set /a LINE_NUM+=1

    :: Ignorer la ligne d'en-tête
    if !LINE_NUM! EQU 1 goto :continue_loop

    set "SUB_PATH=%%A"
    set "FILE_NAME=%%B"
    set "URL=%%C"

    :: Ignorer les lignes vides ou incomplètes
    if "!SUB_PATH!"=="" goto :continue_loop
    if "!FILE_NAME!"=="" goto :continue_loop
    if "!URL!"=="" goto :continue_loop

    :: Supprimer les espaces/CR éventuels en bout de chaîne
    for /f "tokens=* delims= " %%X in ("!SUB_PATH!") do set "SUB_PATH=%%X"
    for /f "tokens=* delims= " %%X in ("!FILE_NAME!") do set "FILE_NAME=%%X"
    for /f "tokens=* delims= " %%X in ("!URL!") do set "URL=%%X"

    set "DEST_DIR=%MODELS_ROOT%\!SUB_PATH!"
    set "DEST_FILE=!DEST_DIR!\!FILE_NAME!"

    :: Créer le sous-dossier si nécessaire
    if not exist "!DEST_DIR!" (
        mkdir "!DEST_DIR!"
        echo [INFO] Dossier cree : !DEST_DIR!
    )

    :: Vérifier si le fichier existe déjà
    if exist "!DEST_FILE!" (
        echo [SKIP] Deja present : !SUB_PATH!\!FILE_NAME!
        set /a COUNT_SKIP+=1
        goto :continue_loop
    )

    echo [DOWNLOAD] !FILE_NAME!
    echo           -> !DEST_DIR!

    curl -L --progress-bar --retry 3 --retry-delay 5 ^
         -o "!DEST_FILE!" "!URL!"

    if errorlevel 1 (
        echo [ERREUR]  Echec du telechargement : !FILE_NAME!
        :: Supprimer le fichier partiel s'il existe
        if exist "!DEST_FILE!" del "!DEST_FILE!"
        set /a COUNT_ERR+=1
    ) else (
        echo [OK]      !FILE_NAME!
        set /a COUNT_OK+=1
    )

    echo.

    :continue_loop
)

:: --- Résumé ---
echo.
echo  =========================================
echo   Résumé
echo  =========================================
echo   Telecharges avec succes : %COUNT_OK%
echo   Deja presents (ignores)  : %COUNT_SKIP%
echo   Erreurs                  : %COUNT_ERR%
echo  =========================================
echo.

if %COUNT_ERR% GTR 0 (
    echo [ATTENTION] Certains modeles n'ont pas pu etre telecharges.
    echo Verifiez votre connexion et les URLs dans models.csv.
)

pause
endlocal