@echo off
setlocal enabledelayedexpansion

REM Set the path to the Git repository dynamically
set REPO_PATH=%CD%

REM Convert backslashes to forward slashes in WSL paths
set REPO_PATH=%REPO_PATH:\=/%

REM Replace C: with /mnt/c/
set REPO_PATH=%REPO_PATH:C:=/mnt/c%

wsl which dos2unix > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    goto installdos2unix
 ) else (
    goto selectrules
 )

:installdos2unix
echo dos2unix is required to build the rules. Do you want to install it?
set /p performInstallationNew=Type 'y' for yes: 
if "%performInstallationNew%"=="y" (
    echo Installing dos2unix...
    wsl sudo apt-get update
    wsl sudo apt-get install dos2unix
    echo.
    echo.
    goto checkinstallation
) else (
    echo.
    echo.
    echo Skipped dos2unix installation. Can not build rules.
    goto :end
)

:checkinstallation
wsl which dos2unix > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installation failed. Can not build the rules.
    goto end
) else goto selectrules

:selectrules
echo Available rule folders:
set "folderIndex=1"
rem Initialize an array to store folder names
setlocal enabledelayedexpansion
set "folderArray="
for /d %%i in (*) do (
    set "folderName=%%i"
    rem Skip folders starting with a dot or named "icons", "media", or "rules_documents"
    if "!folderName:~0,1!" neq "." (
        if /i "!folderName!" neq "icons" (
            if /i "!folderName!" neq "media" (
                if /i "!folderName!" neq "rules_documents" (
                    if /i "!folderName!" neq "general-rules" (
                        if /i "!folderName!" neq "tmp" (
                            echo [!folderIndex!] %%i
                            rem Store folder name in array with corresponding index
                            set "folderArray[!folderIndex!]=%%i"
                            set /a "folderIndex+=1"
                        )
                    )
                )
            )
        )
    )
)

echo.
set /p selection=Enter the number corresponding to the folder you want to select: 

rem Get the selected folder name based on user input
set "selectedFolder="
if defined folderArray[%selection%] (
    set "selectedFolder=!folderArray[%selection%]!"
) else (
    echo Invalid selection.
    pause
    goto :eof
)

echo.
echo You selected: %selectedFolder%
echo.
echo.

REM Create temporary copies of .sh scripts with Linux-style line endings using wsl cp (because Github checkout might automatically change them to Windows style which will stop the scripts from working)
wsl cp %REPO_PATH%/.ci/adoc-to-tex.sh %REPO_PATH%/.ci/adoc-to-tex-temp.sh
wsl cp %REPO_PATH%/.ci/tex-to-pdf.sh %REPO_PATH%/.ci/tex-to-pdf-temp.sh

REM Convert line endings to LF (Linux-style)
wsl dos2unix %REPO_PATH%/.ci/adoc-to-tex-temp.sh
wsl dos2unix %REPO_PATH%/.ci/tex-to-pdf-temp.sh

REM Run commands in WSL with sudo for Docker
@echo Building rules
wsl sudo docker run -v %REPO_PATH%:/documents asciidoctor/docker-asciidoctor .ci/adoc-to-tex-temp.sh %selectedFolder%
wsl sudo docker run -v %REPO_PATH%:/documents mrshu/texlive-dblatex .ci/tex-to-pdf-temp.sh %selectedFolder%

REM Clean up temporary files
wsl rm %REPO_PATH%/.ci/adoc-to-tex-temp.sh
wsl rm %REPO_PATH%/.ci/tex-to-pdf-temp.sh

echo.
echo.
echo.
echo.

:end
REM Pause the script and wait for any key to be pressed
pause

endlocal