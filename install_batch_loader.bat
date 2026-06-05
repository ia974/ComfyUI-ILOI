@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "CUSTOM_NODES_DIR=%CD%\ComfyUI_windows_portable\ComfyUI\custom_nodes"
set "REPO_URL=https://github.com/ia974/ComfyUI-BatchPairLoader"
set "REPO_NAME=ComfyUI-BatchPairLoader"
set "TARGET_DIR=%CUSTOM_NODES_DIR%\%REPO_NAME%"

echo ============================================
echo   Installation de ComfyUI-BatchPairLoader
echo ============================================
echo.

:: Vérification de Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Git n'est pas installe ou introuvable dans le PATH.
    echo Veuillez installer Git depuis https://git-scm.com/download/win
    pause
    exit /b 1
)

:: Vérification du dossier custom_nodes
if not exist "%CUSTOM_NODES_DIR%" (
    echo [INFO] Creation du dossier custom_nodes...
    mkdir "%CUSTOM_NODES_DIR%"
    if %errorlevel% neq 0 (
        echo [ERREUR] Impossible de creer le dossier : %CUSTOM_NODES_DIR%
        pause
        exit /b 1
    )
)

echo Dossier cible : %CUSTOM_NODES_DIR%
echo Depot source : %REPO_URL%
echo.

if exist "%TARGET_DIR%" (
    echo [INFO] Le depot existe deja, mise a jour en cours...
    cd /d "%TARGET_DIR%"
    git pull
    if %errorlevel% equ 0 (
        echo [OK] Mise a jour terminee.
    ) else (
        echo [ERREUR] Echec de la mise a jour du depot.
    )
) else (
    echo [CLONE]  %REPO_URL%
    git clone "%REPO_URL%" "%TARGET_DIR%"
    if %errorlevel% equ 0 (
        echo [OK] Depot installe avec succes.
    ) else (
        echo [ERREUR] Echec du clone du depot.
    )
)

echo.
echo ============================================
echo   Installation terminee
echo ============================================

pause
endlocal