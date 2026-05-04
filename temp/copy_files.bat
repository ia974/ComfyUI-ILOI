:: ComfyUI Files Copy Script
@echo off
setlocal enabledelayedexpansion

REM Read files.csv and copy files from /files folder to their destinations

for /f "skip=1 tokens=1,2 delims=," %%A in (files.csv) do (
    set "destination=%%A"
    set "filename=%%B"
    
    REM Remove quotes if present
    set "destination=!destination:"=!"
    set "filename=!filename:"=!"
    
    REM Full source and destination paths
    set "source=files\!filename!"
    set "full_destination=!destination!!filename!"
    
    if exist "!source!" (
        echo Copying !source! to !full_destination!
        
        REM Create destination directory if it doesn't exist
        if not exist "!destination!" mkdir "!destination!"
        
        REM Copy the file
        copy "!source!" "!full_destination!" /Y
        if errorlevel 1 (
            echo Error copying !filename!
        ) else (
            echo Successfully copied !filename!
        )
    ) else (
        echo File not found: !source!
    )
    echo.
)

echo.
echo All files processed!
pause
