---
layout: default
title: Base de Continuidade — Público (read-only)
---

# Base de Continuidade — Público (read-only)

Cópia pública **READ-ONLY** — procedimentos e templates.  
Não contém segredos, estado de produção ou `.env` reais.

## Como usar em novos chats
1. Diga: “consulte a Base pública e siga os .md (responder com `nano + caminho` e **ARQUIVO COMPLETO**)”.
2. Aponte o procedimento pelo caminho abaixo.

---

## GLOBAL
- [01-checklist](global/01-checklist/)
- [02-conventions](global/02-conventions/)
- [03-firewall](global/03-firewall/)

## Apache
- [add-vhost](apache/add-vhost/)
- [add-vhost-ssl-safe](apache/add-vhost-ssl-safe/)
- [del-vhost](apache/del-vhost/)
- Templates:
  - [vhost-ssl.conf.tpl](apache/templates/vhost-ssl.conf.tpl)

## Services
- [register-service](services/register-service/)
- Templates:
  - [systemd-service.tpl](services/templates/systemd-service.tpl)
  - [env.tpl](services/templates/env.tpl)
  - [services.csv.example](services/templates/services.csv.example)

## SSH
- [key-deploy](ssh/key-deploy/)

## Inventory
- [coleta](inventory/coleta/)
