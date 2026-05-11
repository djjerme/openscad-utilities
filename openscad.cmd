@echo off
set "OPENSCAD_ROOT=%~dp0tools\OpenSCAD\OpenSCAD-2021.01-x86-64\openscad-2021.01"
if not exist "%OPENSCAD_ROOT%\openscad.com" (
    echo OpenSCAD is not installed in this workspace.
    echo Run: powershell -ExecutionPolicy Bypass -File "%~dp0setup-openscad.ps1"
    exit /b 1
)
"%OPENSCAD_ROOT%\openscad.com" %*
