---
layout: default
title: Base de Continuidade — Público (read-only)
---

# Base de Continuidade — Público (read-only)

Esta cópia publica **documentação e templates**.  
> **Não** contém segredos, estado de produção ou `.env` reais.

## Como usar em novos chats
1. Diga: “consulte a Base pública e siga os .md (responder com nano + caminho e ARQUIVO COMPLETO)”.
2. Aponte o procedimento pelo caminho abaixo.

### GLOBAL
- [global/01-checklist.md](global/01-checklist.md)
- [global/02-conventions.md](global/02-conventions.md)
- [global/03-firewall.md](global/03-firewall.md)

### Apache
- [apache/add-vhost.md](apache/add-vhost.md)
- [apache/add-vhost-ssl-safe.md](apache/add-vhost-ssl-safe.md)
- [apache/del-vhost.md](apache/del-vhost.md)
- Templates:
  - [apache/templates/vhost-ssl.conf.tpl](apache/templates/vhost-ssl.conf.tpl)

### Services
- [services/register-service.md](services/register-service.md)
- Templates:
  - [services/templates/systemd-service.tpl](services/templates/systemd-service.tpl)
  - [services/templates/env.tpl](services/templates/env.tpl)
  - [services/templates/services.csv.example](services/templates/services.csv.example)

### SSH
- [ssh/key-deploy.md](ssh/key-deploy.md)

### Inventory
- [inventory/coleta.md](inventory/coleta.md)

---

Manifesto de integridade: [manifest.txt](manifest.txt)
