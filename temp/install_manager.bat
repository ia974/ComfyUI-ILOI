@echo off
setlocal enabledelayedexpansion

REM Install ComfyUI Manager Requirements
"%~dp0ComfyUI_windows_portable\python_embeded\python.exe" -m pip install -r "%~dp0ComfyUI_windows_portable\ComfyUI\manager_requirements.txt"

pause
