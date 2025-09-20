---
layout: default
title: 04 publish
permalink: /global/04-publish/
---
# Publicação da Base — GitHub Pages (read-only)

Objetivo: publicar a Base de Continuidade em um repositório público **somente leitura**, para que novos chats consultem direto da fonte.

## Pré-requisitos
- Conta GitHub com repositório criado (ex.: SEU_USUARIO/base-continuity-public).
- Acesso SSH ou HTTPS para `git push`.

## Pipeline de publicação

1) Ajuste o remoto no harness:
- Arquivo: /home/leonardo/ops/sync/harness.sh
- Variáveis padrão:
  - REMOTE_DEFAULT="git@github.com:SEU_USUARIO/base-continuity-public.git"
  - BRANCH_DEFAULT="main"

2) DRY-RUN (não envia nada):
- Executar:  /home/leonardo/ops/sync/harness.sh
- Critério: exibe tree, index.md, _config.yml e manifest.txt no STAGE.

3) Publicar de verdade:
- Executar:
  /home/leonardo/ops/sync/bin/publish-base.sh --remote git@github.com:SEU_USUARIO/base-continuity-public.git --branch main

4) Habilitar GitHub Pages (uma vez):
- GitHub → repositório → Settings → Pages
- Build and deployment: **Deploy from a branch**
- Branch: **main** ; Folder: **/(root)**
- Salvar. A URL pública aparecerá na própria página.

## Estrutura publicada
- index.md — página inicial com navegação
- _config.yml — tema `jekyll-theme-cayman`
- manifest.txt — hash/mtime dos arquivos
- global/, apache/, services/, ssh/, inventory/ — diretórios com os `.md` e templates `.tpl`

## Segurança & higiene
- Sem segredos: o pipeline remove arquivos .env/.key/.pem/.crt por precaução.
- Estado real (logs, certs, /etc) **não** é publicado.

## Frase para novos chats
> Consulte a Base de Continuidade pública em <URL_DO_SITE> e siga estritamente os `.md`. Responda sempre com “nano + caminho” e o **ARQUIVO COMPLETO**; crie diretórios com “install -d -m 0755”. Não peça testes soltos: validações ficam dentro dos docs. Se faltar algo, pare e peça para eu atualizar a Base antes de prosseguir.
