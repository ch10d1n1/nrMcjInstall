@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title MCJ Automação industrial
echo --------------------------
echo MCJ Automação Industrial 
echo --------------------------
color 07
:: 1. Verificar se Node.js está instalado
echo Verificando se o Node.js está instalado...
node -v >nul 2>&1

if %errorlevel% neq 0 (
	echo ❌ Node.js NÃO está instalado.
	pause
	exit
) else (
	for /f "delims=" %%i in ('node -v') do (
        	echo ✅ Node.js está instalado. %%i
	)
)
echo --------------------------
echo Instalando Node-RED...
call npm install -g --unsafe-perm node-red

if %errorlevel% neq 0 (
    echo ❌ Erro ao instalar o Node-RED.
    pause
    exit
) else (
    echo ✅ Node-RED instalado com sucesso.
)
echo --------------------------
:: 3. Instalar o Git 
echo Instalando Git...
winget install --id Git.Git -e --source winget
echo --------------------------
::4. Instalar o repositório base
echo Instalando repositório base...
::git clone https://github.com/ch10d1n1/nrMcjConfig.git
"%ProgramFiles%\Git\cmd\git.exe" clone https://github.com/ch10d1n1/nrMcjConfig.git
copy .\nrMcjConfig\settings.js "%USERPROFILE%\.node-red\" /Y
xcopy .\nrMcjConfig\mcj-settings "%USERPROFILE%\.node-red\mcj-settings" /E /I /Y
rmdir /S /Q nrMcjConfig
echo --------------------------
::5. Instalar o repositório do projeto
echo Instalando repositório do projeto...
set /p REPO_NAME=Digite o nome do repositório:
:: Verifica se a variável REPO_NAME está vazia
if "%REPO_NAME%"=="" (
    set "REPO_NAME=nr0000_testeRepo"
    echo Nenhum nome digitado. Instalando repositório padrão: !REPO_NAME!
)
set "TARGET_DIR=%USERPROFILE%\.node-red\projects\!REPO_NAME!"
if exist "!TARGET_DIR!" (
    rmdir /S /Q "!TARGET_DIR!"
    echo ℹ️ Repositório antigo "!REPO_NAME!" removido. Será reinstalado...
	pause
) else (
    echo ✅ Repositório "!REPO_NAME!" não existia. Nada foi removido.
)
"%ProgramFiles%\Git\cmd\git.exe" clone https://github.com/ch10d1n1/%REPO_NAME%.git "%USERPROFILE%\.node-red\projects\%REPO_NAME%"
echo Clonando repositório https://github.com/ch10d1n1/%REPO_NAME%.git...
if exist "%USERPROFILE%\.node-red\projects\%REPO_NAME%" (
    echo ✅ Repositório do projeto clonado com sucesso.
) else (
    echo ❌ Repositório do projeto não foi clonado ou não existe.
	pause
    exit
)
echo --------------------------
::6. Instalar as depêndencias do projeto
echo Instalando as depêndencias do projeto...
pushd "%USERPROFILE%\.node-red\projects\%REPO_NAME%"
call npm install
popd
::7. Configurar projeto ativo
echo Configurando projeto ativo no Node-RED...
set "PROJECTS_CONFIG=%USERPROFILE%\.node-red\.config.projects.json"
(
echo {
echo   "projects": {
echo     "%REPO_NAME%": {
echo       "credentialSecret": false
echo     }
echo   },
echo   "activeProject": "%REPO_NAME%"
echo }
) > "%PROJECTS_CONFIG%"

echo ✅ Projeto ativo definido como "%REPO_NAME%"
echo --------------------------
::8te. Instalar PM2 para inicializacao automática
echo Instalando e configurando PM2...
call npm install pm2 -g
call npm install pm2-windows-startup -g
call pm2-startup install
call pm2 delete all
call pm2 start "%APPDATA%\npm\node_modules\node-red\red.js" --name APLICATIVO --interpreter node
call pm2 save
echo --------------------------
echo CONCLUÍDO!
echo --------------------------
pause
