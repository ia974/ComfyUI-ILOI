@echo off
setlocal

echo ============================================
echo        Installation de ComfyUI ILOI
echo ============================================
echo.

:: -- Etape 1 : Installation de ComfyUI Portable --
echo [1/4] Installation de ComfyUI Portable...
call "%~dp0install_comfy_portable.bat"
if %errorlevel% neq 0 (
    echo [ERREUR] install_comfy_portable.bat a echoue. Abandon.
    pause
    exit /b %errorlevel%
)
echo.

:: -- Etape 2 : Creation des raccourcis --
echo [2/4] Creation des raccourcis...
call "%~dp0raccourcis.bat"
if %errorlevel% neq 0 (
    echo [ERREUR] raccourcis.bat a echoue. Abandon.
    pause
    exit /b %errorlevel%
)
echo.

:: -- Etape 3 : Installation des custom nodes --
echo [3/4] Installation des custom nodes...
call "%~dp0install_custom_nodes.bat"
if %errorlevel% neq 0 (
    echo [ERREUR] install_custom_nodes.bat a echoue. Abandon.
    pause
    exit /b %errorlevel%
)
echo.

:: -- Etape 4 : Installation des modeles --
echo [4/4] Installation des modeles...
call "%~dp0install_models.bat"
if %errorlevel% neq 0 (
    echo [ERREUR] install_models.bat a echoue. Abandon.
    pause
    exit /b %errorlevel%
)
echo.

echo ============================================
echo     Installation terminee avec succes !
echo ============================================
pause
endlocal