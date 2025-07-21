@echo off
chcp 65001 >nul
title Instalador MCJ Automação Industrial

:: Caminho onde o script está sendo executado
set "BASE_DIR=%~dp0"
set "TARGET_DIR=%BASE_DIR%mcj-installer-temp"

:: Cria a pasta se não existir
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)

:: Vai para a pasta de trabalho
cd /d "%TARGET_DIR%"

echo -------------------------------
echo Baixando instalador oficial MCJ...
echo -------------------------------

set "INSTALL_URL=https://raw.githubusercontent.com/ch10d1n1/nrMcjInstall/main/install.bat"

:: Tenta baixar com curl
curl -L -o install.bat %INSTALL_URL% >nul 2>&1

if exist install.bat (
    echo ✅ Instalador baixado com sucesso via curl.
    call install.bat
    del install.bat
    cd /d "%BASE_DIR%"
    rmdir /s /q "%TARGET_DIR%"
    exit /b
)

echo ❌ Falha ao baixar com curl. Tentando com PowerShell...
powershell -Command "Invoke-WebRequest -Uri '%INSTALL_URL%' -OutFile 'install.bat'" >nul 2>&1

if exist install.bat (
    echo ✅ Instalador baixado com sucesso via PowerShell.
    call install.bat
    del install.bat
    cd /d "%BASE_DIR%"
    rmdir /s /q "%TARGET_DIR%"
) else (
    echo ❌ Falha ao baixar o instalador via PowerShell também.
    echo Verifique sua conexão com a internet ou entre em contato com o suporte MCJ.
    pause
    cd /d "%BASE_DIR%"
    rmdir /s /q "%TARGET_DIR%"
    exit /b
)