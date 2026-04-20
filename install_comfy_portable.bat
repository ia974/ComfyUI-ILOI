@echo off
setlocal enabledelayedexpansion

:: ============================================================
::  Télécharge et installe ComfyUI Portable (NVIDIA)
:: ============================================================

set "ARCHIVE_URL=https://github.com/Comfy-Org/ComfyUI/releases/download/v0.19.0/ComfyUI_windows_portable_nvidia.7z"
set "ARCHIVE_NAME=ComfyUI_windows_portable_nvidia.7z"
set "INSTALL_DIR=%~dp0"

echo.
echo  ============================================================
echo   ComfyUI Portable - Installation
echo  ============================================================
echo.

:: ── 1. Vérification de curl ──────────────────────────────────
echo [1/3] Vérification de curl...
where curl >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] curl est introuvable.
    echo          Il est disponible nativement sur Windows 10/11.
    pause
    exit /b 1
)
echo     OK

:: ── 2. Vérification de tar ───────────────────────────────────
echo [2/3] Vérification de tar...
where tar >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] tar est introuvable.
    echo          Il est disponible nativement sur Windows 10/11.
    pause
    exit /b 1
)
echo     OK

:: ── 3. Téléchargement de l'archive ──────────────────────────
echo.
echo [3/4] Téléchargement de l'archive ComfyUI Portable...
echo       Source  : %ARCHIVE_URL%
echo       Dossier : %INSTALL_DIR%
echo.

if exist "%INSTALL_DIR%%ARCHIVE_NAME%" (
    echo     Archive déjà présente, téléchargement ignoré.
) else (
    curl -L --progress-bar -o "%INSTALL_DIR%%ARCHIVE_NAME%" "%ARCHIVE_URL%"
    if errorlevel 1 (
        echo [ERREUR] Le téléchargement a échoué.
        pause
        exit /b 1
    )
    echo     Téléchargement terminé.
)

:: ── 4. Décompression de l'archive ───────────────────────────
echo.
echo [4/4] Décompression de l'archive...
echo       Destination : %INSTALL_DIR%
echo.

tar -xf "%INSTALL_DIR%%ARCHIVE_NAME%" -C "%INSTALL_DIR%"
if errorlevel 1 (
    echo [ERREUR] La décompression a échoué.
    pause
    exit /b 1
)

echo.
echo  ============================================================
echo   Installation terminée avec succès !
echo   ComfyUI se trouve dans : %INSTALL_DIR%ComfyUI_windows_portable
echo  ============================================================
echo.

:: Nettoyage optionnel de l'archive
set /p CLEAN="Supprimer l'archive .7z pour libérer de l'espace ? (O/N) : "
if /i "%CLEAN%"=="O" (
    del /f /q "%INSTALL_DIR%%ARCHIVE_NAME%"
    echo     Archive supprimée.
)

echo.
pause
endlocal