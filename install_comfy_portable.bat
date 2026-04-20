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

:: ── 1. Vérification de PowerShell ───────────────────────────
where powershell >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] PowerShell est introuvable. Impossible de continuer.
    pause
    exit /b 1
)

:: ── 2. Vérification de tar ───────────────────────────────────
echo [1/3] Vérification de tar...
where tar >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] La commande tar est introuvable.
    echo          Elle est disponible nativement sur Windows 10/11.
    pause
    exit /b 1
)
echo     OK

:: ── 3. Téléchargement de l'archive ──────────────────────────
echo.
echo [2/3] Téléchargement de l'archive ComfyUI Portable...
echo       Source  : %ARCHIVE_URL%
echo       Dossier : %INSTALL_DIR%
echo.

if exist "%INSTALL_DIR%%ARCHIVE_NAME%" (
    echo     Archive déjà présente, téléchargement ignoré.
) else (
    powershell -NoProfile -Command ^
        "& { $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%ARCHIVE_URL%' -OutFile '%INSTALL_DIR%%ARCHIVE_NAME%' -UseBasicParsing }"
    if errorlevel 1 (
        echo [ERREUR] Le téléchargement a échoué.
        pause
        exit /b 1
    )
    echo     Téléchargement terminé.
)

:: ── 4. Décompression de l'archive ───────────────────────────
echo.
echo [3/3] Décompression de l'archive...
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