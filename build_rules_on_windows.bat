@echo off

REM Set the path to the Git repository dynamically
set REPO_PATH=%CD%

REM Convert backslashes to forward slashes in WSL paths
set REPO_PATH=%REPO_PATH:\=/%

REM Replace C: with /mnt/c/
set REPO_PATH=%REPO_PATH:C:=/mnt/c%

echo Running commands in WSL...

REM Check if dos2unix is installed in WSL
wsl dos2unix --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing dos2unix...
    REM Add installation command for dos2unix here
    wsl sudo apt-get update
    wsl sudo apt-get install dos2unix
)

REM Create temporary copies of .sh scripts with Linux-style line endings using wsl cp
wsl cp %REPO_PATH%/.ci/adoc-to-tex.sh %REPO_PATH%/.ci/adoc-to-tex-temp.sh
wsl cp %REPO_PATH%/.ci/tex-to-pdf.sh %REPO_PATH%/.ci/tex-to-pdf-temp.sh

REM Convert line endings to LF (Linux-style)
wsl dos2unix %REPO_PATH%/.ci/adoc-to-tex-temp.sh
wsl dos2unix %REPO_PATH%/.ci/tex-to-pdf-temp.sh

REM Run commands in WSL with sudo for Docker
@echo Building rules
wsl sudo docker run -v %REPO_PATH%:/documents asciidoctor/docker-asciidoctor .ci/adoc-to-tex-temp.sh onstage_rules
wsl sudo docker run -v %REPO_PATH%:/documents mrshu/texlive-dblatex .ci/tex-to-pdf-temp.sh onstage_rules

REM Clean up temporary files
wsl rm %REPO_PATH%/.ci/adoc-to-tex-temp.sh
wsl rm %REPO_PATH%/.ci/tex-to-pdf-temp.sh

echo WSL commands completed.

REM Pause the script and wait for any key to be pressed
pause
