@echo off
setlocal enabledelayedexpansion
echo ==========================================
echo Installation de ComfyUI Portable
echo ==========================================

set "ARCHIVE=ComfyUI_portable.7z"
set "URL=https://github.com/Comfy-Org/ComfyUI/releases/download/v0.19.0/ComfyUI_windows_portable_nvidia.7z"

:: 1. Vérifier si l'archive est déjà présente
if exist "%ARCHIVE%" (
    echo Archive "%ARCHIVE%" déjà présente, téléchargement ignoré.
    echo Si vous souhaitez re-télécharger, supprimez le fichier manuellement.
) else (
    echo Telechargement de ComfyUI Portable...
    curl -L -o "%ARCHIVE%" "%URL%"
    if errorlevel 1 (
        echo ERREUR : Le téléchargement a échoué.
        pause
        exit /b 1
    )
    echo Téléchargement terminé.
)

:: 2. Extraire l'archive
echo Extraction en cours...
tar -xf "%ARCHIVE%"
if errorlevel 1 (
    echo ERREUR : L'extraction a échoué. Vérifiez que tar est disponible sur votre système.
    pause
    exit /b 1
)
echo Extraction terminée.

:: 3. Nettoyage optionnel de l'archive
set /p CLEAN="Supprimer l'archive .7z pour libérer de l'espace ? (O/N) : "
if /i "%CLEAN%"=="O" (
    del /f /q "%ARCHIVE%"
    echo Archive supprimée.
) else (
    echo Archive conservée.
)

echo.
echo ==========================================
echo Terminé ! Lancez run_nvidia_gpu.bat pour démarrer.
echo ==========================================
pause
endlocal