---
layout: default
title: README
permalink: /README/
---
# Base de Continuidade — Debian2-1

Fonte única de verdade (single source of truth) para procedimentos, templates e critérios de validação.  
Regra de ouro: **nunca editar pedaços** — substituir o **arquivo completo**.

## Como usar
1) Abra o procedimento com **nano + caminho** (sempre mostrado no topo de cada doc).  
2) Siga o fluxo **determinístico** do arquivo: criação → aplicação → validação → rollback.  
3) Se faltar algo, **pare** e atualize a Base antes de executar no sistema.  
4) Quando precisar validar vários comandos, utilizar **harness.sh** (script de teste único) referenciado no próprio doc.

---

## GLOBAL (ler primeiro)
- `global/01-checklist.md` — Checklist inicial do ambiente e critérios de aprovação.
- `global/02-conventions.md` — Convenções: “nano + caminho”, `install -d -m 0755`, layouts oficiais, princípios anti-bomba.
- `global/03-firewall.md` — Firewall padrão **nftables** (policy accept organizada; flip único para policy drop).

---

## Apache
- `apache/add-vhost.md` — VirtualHost **HTTP** (padrão, anti-bomba).
- `apache/add-vhost-ssl-safe.md` — VirtualHost **HTTPS** (ordem blindada + ACME HTTP-01 + template oficial).
- `apache/del-vhost.md` — Remoção segura de vhost.

**Templates**
- `apache/templates/vhost-ssl.conf.tpl`

**Scripts auxiliares (fora da Base, referenciados)**
- `/home/leonardo/ops/apache/bin/add-vhost.sh`
- `/home/leonardo/ops/apache/bin/add-vhost-ssl-safe.sh`
- `/home/leonardo/ops/apache/bin/del-vhost.sh`

**Caminhos padrão**
- Certs: `/srv/infra/ssl/live/<dominio>/{fullchain.pem,privkey.pem}`
- Logs por vhost: `/srv/infra/apache/logs/<server>-{access,error}.log`

---

## Services
- `services/register-service.md` — Registro/consulta (CSV + systemd + .env), com validações embutidas.

**Templates**
- `services/templates/systemd-service.tpl`
- `services/templates/env.tpl`
- `services/templates/services.csv.example`

**Inventário CSV oficial**
- `/srv/infra/services/services.csv`  (cabeçalho: `name,port,user,dir,exec,envfile`)

---

## SSH
- `ssh/key-deploy.md` — Deploy de chaves SSH (Termux/Servidor), endurecimento opcional e rollback.

## Inventory
- `inventory/coleta.md` — Coleta de inventário (SO/serviços/portas) + agendamento opcional via timer systemd.

---

## Princípios
- **Determinismo** — cada doc contém passos de criação, aplicação, validação e rollback.  
- **Templates versionados** — não editar direto em `/etc` quando existir template na Base.  
- **Sincronia** — CSV de serviços, firewall e units systemd devem refletir o mesmo estado.  
- **Auditoria** — mudanças relevantes devem ser registradas no bunker central da Base.
