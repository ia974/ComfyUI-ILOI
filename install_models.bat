@echo off
setlocal enabledelayedexpansion

:: Définition du chemin de base
set "BASE_MODELS_DIR=%~dp0ComfyUI_windows_portable\ComfyUI\models"
set "CSV_FILE=models.csv"

echo ======================================================
echo   Installation des Modeles pour ComfyUI
echo ======================================================

:: Vérifier si le fichier CSV existe
if not exist "%CSV_FILE%" (
    echo [ERREUR] Le fichier %CSV_FILE% est introuvable.
    pause
    exit /b
)

:: Lecture du fichier CSV (saute la première ligne d'en-tête)
:: tokens=1,2,3 : 1=Path, 2=Checkpoint Name, 3=Link
for /f "usebackq skip=1 tokens=1,2,3 delims=," %%A in ("%CSV_FILE%") do (
    set "SUB_FOLDER=%%A"
    set "FILE_NAME=%%B"
    set "DOWNLOAD_URL=%%C"
    
    set "TARGET_DIR=%BASE_MODELS_DIR%\!SUB_FOLDER!"
    
    echo.
    echo Traitement de : !FILE_NAME!
    echo Destination : !TARGET_DIR!
    
    :: Créer le dossier s'il n'existe pas
    if not exist "!TARGET_DIR!" (
        echo [INFO] Creation du dossier !TARGET_DIR!
        mkdir "!TARGET_DIR!"
    )
    
    :: Vérifier si le fichier existe déjà pour éviter de retélécharger
    if exist "!TARGET_DIR!\!FILE_NAME!" (
        echo [SKIP] Le fichier !FILE_NAME! existe deja.
    )
    
    :: Si le fichier n'existe pas, on lance le téléchargement
    if not exist "!TARGET_DIR!\!FILE_NAME!" (
        echo [DOWNLOAD] Telechargement en cours...
        :: Utilisation de curl (inclus dans Windows 10/11)
        :: -C - : Reprend le téléchargement s'il a été coupé
        :: -L : Suit les redirections (important pour HuggingFace)
        :: -o : Definit le nom de sortie
        curl -C - -L "!DOWNLOAD_URL!" -o "!TARGET_DIR!\!FILE_NAME!"
        
        if !errorlevel! equ 0 (
            echo [OK] Telechargement termine avec succes.
        ) else (
            echo [ERREUR] Echec du telechargement pour !FILE_NAME!.
        )
    )
)

echo.
echo ======================================================
echo   Operation terminee !
echo ======================================================
pause