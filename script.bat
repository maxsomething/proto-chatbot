@echo off
setlocal enabledelayedexpansion

rem Get the current script directory
set "script_dir=%~dp0"

rem Define the directory where your Node.js program is located
set "program_directory=%script_dir%"

rem Check if curl is installed, and if not, download and install it
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo curl is not installed. Installing curl...
    set "curl_url=https://curl.se/windows/dl-7.80.0/curl-7.80.0-win64-mingw.zip"
    set "curl_zip=%temp%\curl.zip"
    set "curl_dir=%program_directory%\curl"

    rem Download curl
    bitsadmin /transfer "CurlInstaller" "!curl_url!" "!curl_zip!"

    rem Extract curl
    powershell -command "Expand-Archive -Path '!curl_zip!' -DestinationPath '!curl_dir!'"

    rem Clean up the downloaded zip file
    del "!curl_zip!"
)

rem Download and install the latest LTS version of Node.js
echo Checking for the latest LTS version of Node.js...
for /f "tokens=2" %%i in ('curl -sL https://nodejs.org/dist/index.json ^| jq -r ".[].version" ^| sort -V ^| tail -n 1') do (
    set "latest_version=%%i"
)

if not exist "%program_directory%" (
    mkdir "%program_directory%"
)

cd "%program_directory%"

rem Check if Node.js is already installed
if not exist "%program_directory%\node.exe" (
    echo Node.js is not installed. Installing the latest LTS version...

    rem Download the latest LTS version of Node.js
    curl -o node_installer.msi https://nodejs.org/dist/%latest_version%/node-%latest_version%-x64.msi

    rem Install Node.js
    msiexec /i node_installer.msi /qn

    if %errorlevel% neq 0 (
        echo Failed to install Node.js.
        exit /b 1
    )

    rem Clean up the installer
    del node_installer.msi
)

rem Check if npm is already installed
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo npm is not installed. Installing npm...
    
    rem Install npm
    "%program_directory%\npm.cmd" install npm@latest -g

    if %errorlevel% neq 0 (
        echo Failed to install npm.
        exit /b 1
    )
)

cd "%program_directory%"

rem Run your Node.js program directly using Node.js

echo Running Node.js program...

node .\index.js

endlocal
