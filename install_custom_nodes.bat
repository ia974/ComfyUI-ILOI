@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "CUSTOM_NODES_DIR=%CD%\ComfyUI_windows_portable\ComfyUI\custom_nodes"
set "NODES_LIST=%~dp0custom_nodes.txt"

echo ============================================
echo   Installation des Custom Nodes ComfyUI
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

:: Vérification du fichier custom_nodes.txt
if not exist "%NODES_LIST%" (
    echo [ERREUR] Fichier introuvable : %NODES_LIST%
    pause
    exit /b 1
)

echo Dossier cible : %CUSTOM_NODES_DIR%
echo Liste source  : %NODES_LIST%
echo.

set "success=0"
set "skipped=0"
set "failed=0"

:: Lecture et traitement de chaque ligne du fichier
for /f "usebackq tokens=* delims=" %%L in ("%NODES_LIST%") do (
    set "url=%%L"

    :: Ignorer les lignes vides ou commençant par #
    if "!url!"=="" (
        rem ligne vide, on passe
    ) else if "!url:~0,1!"=="#" (
        rem commentaire, on passe
    ) else (
        :: Extraire le nom du repo (dernière partie de l'URL)
        for %%F in ("!url!") do set "repo_name=%%~nF"

        set "target_dir=%CUSTOM_NODES_DIR%\!repo_name!"

        if exist "!target_dir!" (
            echo [PASSE]  !repo_name! existe deja, mise a jour...
            cd /d "!target_dir!"
            git pull
            set /a skipped+=1
        ) else (
            echo [CLONE]  !repo_name!
            git clone "!url!.git" "!target_dir!"
            if !errorlevel! equ 0 (
                echo [OK]     !repo_name! installe avec succes.
                set /a success+=1
            ) else (
                echo [ERREUR] Echec du clone de !url!
                set /a failed+=1
            )
        )
        echo.
    )
)

echo ============================================
echo   Résumé de l'installation
echo ============================================
echo   Installes  : !success!
echo   Mis a jour : !skipped!
echo   Echecs     : !failed!
echo ============================================
echo.

if !failed! gtr 0 (
    echo Certains nodes n'ont pas pu etre installes. Verifiez votre connexion internet.
)

pause
endlocal