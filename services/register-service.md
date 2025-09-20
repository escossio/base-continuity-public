---
layout: default
title: Register service
permalink: /services/register-service/
---
# Procedimento: Registro/Consulta de Serviços (CSV + systemd)

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: seguir este fluxo determinístico. Não editar pedaços — substituir arquivos completos.

## Referências obrigatórias
- Convenções: global/02-conventions.md
- Firewall (nftables): global/03-firewall.md
- Templates:
  - services/templates/systemd-service.tpl
  - services/templates/env.tpl
  - services/templates/services.csv.example
- Inventário CSV oficial: /srv/infra/services/services.csv

---

## Colunas obrigatórias do CSV

Ordem exata:
