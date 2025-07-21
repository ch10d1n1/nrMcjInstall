# 🚀 MCJ - Instalador Node-RED - 21/07/2025

Este repositório contém os arquivos necessários para realizar a **instalação automatizada do ambiente Node-RED personalizado** para clientes da **MCJ Automação Industrial**.

---

## 📦 O que o instalador faz

- Verifica e instala o **Node.js**, **Node-RED** e **Git** (se necessário)
- Clona o repositório de configurações padrão `nrMcjConfig`
- Solicita o nome do repositório do cliente e o instala
- Copia os arquivos de configuração (`settings.js`, flows, templates)
- Instala as dependências com `npm install`
- Configura o projeto ativo no Node-RED
- (Opcional) Instala e configura o **PM2** para execução em segundo plano

---

## 🧑‍💻 Como usar

### 👉 Método recomendado

1. **Baixe e execute** o arquivo [`start-installer.bat`](start-installer.bat)
2. O script irá baixar automaticamente o instalador principal `install.bat`
3. Siga as instruções exibidas no terminal

---

## 📂 Instalando repositórios individuais

Além do instalador completo, você pode usar o script auxiliar [`repo-install.bat`](repo-install.bat) para instalar ou reinstalar um repositório específico.

### ✅ O que `repo-install.bat` faz:

- Solicita o nome do repositório desejado (ex: `nr0000_testeRepo`)
- Remove qualquer instalação anterior do projeto (se existir)
- Clona o repositório informado do GitHub
- Instala as dependências com `npm install`
- Define o projeto como ativo no Node-RED
- Reinicia a instância via **PM2**, se instalado

> Útil para reinstalar projetos sem precisar executar toda a instalação base.

---

## 🌐 Requisitos

- 💻 Windows 10 ou superior
- 🌐 Conexão com a internet
- 🛠️ Permissão de administrador (para instalar dependências globais)

---

## ⚠️ Observações

- O instalador clona e configura projetos a partir de repositórios GitHub
- O repositório `nrMcjConfig` deve estar acessível (público ou com token, se privado)
- Os dados serão instalados em:

%USERPROFILE%.node-red\projects

