@echo off
setlocal enabledelayedexpansion

echo =======================================================
echo            Installation de ComfyUI Portable
echo =======================================================
echo.

:: --- Configuration ---
set "COMFY_ARCHIVE=ComfyUI_portable.7z"
set "COMFY_URL=https://github.com/Comfy-Org/ComfyUI/releases/download/v0.19.0/ComfyUI_windows_portable_nvidia.7z"
set "INSTALL_DIR=ComfyUI_windows_portable"
:: ---------------------

:: 1. Verifier si Git est installe
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Git n'est pas installe ou n'est pas dans le PATH.
    echo Veuillez installer Git pour Windows : https://git-scm.com/download/win
    pause
    exit /b
)

:: 2. Telecharger l'archive
if not exist "%COMFY_ARCHIVE%" (
    echo [1/4] Telechargement de ComfyUI Portable...
    curl -L -o "%COMFY_ARCHIVE%" "%COMFY_URL%"
) else (
    echo [1/4] L'archive "%COMFY_ARCHIVE%" existe deja, on passe le telechargement.
)

:: 3. Extraction de l'archive via un script PowerShell temporaire
::    (C'est plus fiable que tar pour les .7z sur les vieux Windows 10)
if not exist "%INSTALL_DIR%" (
    echo [2/4] Extraction de l'archive (cela peut prendre quelques minutes)...
    
    :: On utilise un script PowerShell pour extraire si 7z n'est pas dispo
    echo Expand-Archive -Path "%cd%\%COMFY_ARCHIVE%" -DestinationPath "%cd%" -Force > extract.ps1
    
    :: Note : Nativement Windows 11 lit les 7z avec Expand-Archive. 
    :: Sur Windows 10 plus ancien, il se peut que cela faille.
    :: L'alternative plus robuste est de demander a l'utilisateur d'avoir 7-zip installe.
    
    :: On essaie d'abord avec l'outil tar integré à windows (marche sur W11 et W10 recents pour les 7z)
    tar -xf "%COMFY_ARCHIVE%"
    
    if not exist "%INSTALL_DIR%" (
        echo [ERREUR] L'extraction a echoue. Assurez-vous d'utiliser Windows 11 ou un Windows 10 recent.
        pause
        exit /b
    )
) else (
    echo [2/4] Le dossier "%INSTALL_DIR%" existe deja, on passe l'extraction.
)

:: Optionnel : Nettoyage de l'archive pour gagner de la place
:: del "%COMFY_ARCHIVE%"


echo.
echo =======================================================
echo [4/4] INSTALLATION TERMINEE AVEC SUCCES !
echo =======================================================
echo.
echo Vous pouvez maintenant lancer ComfyUI en executant :
echo %INSTALL_DIR%\run_nvidia_gpu.bat
echo.
pause
