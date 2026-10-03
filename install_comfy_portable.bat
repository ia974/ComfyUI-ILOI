@echo off
setlocal enabledelayedexpansion
echo ==========================================
echo Installation de ComfyUI Portable
echo ==========================================

set "ARCHIVE=ComfyUI_portable.7z"
set "URL=https://github.com/Comfy-Org/ComfyUI/releases/download/v0.38.0/ComfyUI_windows_portable_nvidia.7z"

:: Verifier si le dossier ComfyUI_windows_portable existe deja
if exist "ComfyUI_windows_portable" (
    echo Le dossier ComfyUI_windows_portable existe deja. Installation annulee.
    pause
    exit /b 0
)

:: 1. Verifier si l'archive est deja presente
if exist "%ARCHIVE%" (
    echo Archive "%ARCHIVE%" deja presente, telechargement ignore.
    echo Si vous souhaitez re-telecharger, supprimez le fichier manuellement.
) else (
    echo Telechargement de ComfyUI Portable...
    curl -L -o "%ARCHIVE%" "%URL%"
    if errorlevel 1 (
        echo ERREUR : Le telechargement a echoue.
        pause
        exit /b 1
    )
    echo Telechargement termine.
)

:: 2. Trouver un extracteur 7z (le tar de Windows 10 ne supporte pas LZMA)
set "SEVENZIP="
if exist "%ProgramFiles%\7-Zip\7z.exe" set "SEVENZIP=%ProgramFiles%\7-Zip\7z.exe"
if not defined SEVENZIP if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" set "SEVENZIP=%ProgramFiles(x86)%\7-Zip\7z.exe"
if not defined SEVENZIP for %%I in (7z.exe) do if not "%%~$PATH:I"=="" set "SEVENZIP=%%~$PATH:I"
if not defined SEVENZIP if exist "7zr.exe" set "SEVENZIP=%CD%\7zr.exe"
if not defined SEVENZIP (
    echo 7-Zip introuvable, telechargement de 7zr.exe depuis 7-zip.org...
    curl -L -o "7zr.exe" "https://www.7-zip.org/a/7zr.exe"
    if errorlevel 1 (
        echo ERREUR : Impossible de telecharger 7zr.exe. Installez 7-Zip depuis https://www.7-zip.org
        pause
        exit /b 1
    )
    set "SEVENZIP=%CD%\7zr.exe"
)

:: 3. Extraire l'archive
echo Extraction en cours avec "!SEVENZIP!"...
"!SEVENZIP!" x "%ARCHIVE%" -y
if errorlevel 1 (
    echo ERREUR : L'extraction a echoue.
    pause
    exit /b 1
)
echo Extraction terminee.

:: 4. Nettoyage optionnel de l'archive
set /p CLEAN="Supprimer l'archive .7z pour liberer de l'espace ? (O/N) : "
if /i "%CLEAN%"=="O" (
    del /f /q "%ARCHIVE%"
    echo Archive supprimee.
) else (
    echo Archive conservee.
)

echo.
echo ==========================================
echo Termine ! Lancez Comfy UI.exe pour demarrer.
echo ==========================================
pause
endlocal