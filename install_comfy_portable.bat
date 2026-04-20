@echo off
echo ==========================================
echo Installation de ComfyUI Portable
echo ==========================================

:: 1. Télécharger la version portable officielle
echo Telechargement de ComfyUI Portable...
curl -L -o ComfyUI_portable.7z https://github.com/comfyanonymous/ComfyUI/releases/latest/download/ComfyUI_windows_portable_nvidia.7z

:: 2. Extraire l'archive (nécessite d'avoir tar ou 7z installé)
echo Extraction...
tar -xf ComfyUI_portable.7z

:: Nettoyage optionnel de l'archive
set /p CLEAN="Supprimer l'archive .7z pour libérer de l'espace ? (O/N) : "
if /i "%CLEAN%"=="O" (
    del /f /q "ComfyUI_portable.7z"
    echo     Archive supprimée.
)

echo Termine ! Lancez run_nvidia_gpu.bat pour demarrer.
pause
endlocal
