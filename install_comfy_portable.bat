@echo off
setlocal enabledelayedexpansion
echo ==========================================
echo Installation de ComfyUI Portable
echo ==========================================

set "ARCHIVE=ComfyUI_portable.7z"
set "URL=https://github.com/Comfy-Org/ComfyUI/releases/download/v0.19.0/ComfyUI_windows_portable_nvidia.7z"

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

:: 2. Extraire l'archive
echo Extraction en cours...
tar -xf "%ARCHIVE%"
if errorlevel 1 (
    echo ERREUR : L'extraction a echoue. Verifiez que tar est disponible sur votre systeme.
    pause
    exit /b 1
)
echo Extraction terminee.

:: 3. Nettoyage optionnel de l'archive
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