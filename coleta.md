---
layout: default
---

# Procedimento: Coleta de Inventário (SO/Serviços/Portas)

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: seguir este fluxo determinístico. Não editar pedaços — substituir arquivos completos.

Referências obrigatórias:
- global/02-conventions.md
- global/03-firewall.md
- /srv/infra/services/services.csv (inventário oficial de serviços)

---

## 1) Estrutura de saída

Diretório base:
- /srv/infra/inventory

Arquivos gerados:
- /srv/infra/inventory/host.txt
- /srv/infra/inventory/services.csv      (snapshot do oficial)
- /srv/infra/inventory/ports.txt
- /srv/infra/inventory/apache-vhosts.txt

Criar diretório (se necessário):
- install -d -m 0755 /srv/infra/inventory

---

## 2) Coletas pontuais (consultas)

### 2.1) Host e SO
- hostnamectl > /srv/infra/inventory/host.txt
- date >> /srv/infra/inventory/host.txt
- uname -a >> /srv/infra/inventory/host.txt

Critério: arquivo contém hostname, data/hora e kernel.

### 2.2) Serviços registrados (snapshot)
- cp -f /srv/infra/services/services.csv /srv/infra/inventory/services.csv

Critério: snapshot igual ao CSV oficial no momento da coleta.

### 2.3) Portas em LISTEN
- ss -ltn | sort -k4 > /srv/infra/inventory/ports.txt

Critério: lista ordenada por endereço/porta.

### 2.4) VHosts do Apache
- apache2ctl -S > /srv/infra/inventory/apache-vhosts.txt || echo "apache2ctl -S falhou" > /srv/infra/inventory/apache-vhosts.txt

Critério: mapeamento de vhosts presente (ou falha registrada).

---

## 3) Agendamento opcional (timer systemd)

Arquivos:
- /usr/local/sbin/inventory-collect.sh
- /etc/systemd/system/inventory-collect.service
- /etc/systemd/system/inventory-collect.timer

Script (/usr/local/sbin/inventory-collect.sh):
- install -d -m 0755 /srv/infra/inventory
- executar as coletas do item 2 (sobrescrevendo os arquivos)
- chmod 0755 /usr/local/sbin/inventory-collect.sh

Service (inventory-collect.service):
- [Unit] Description=Inventory collection
- [Service] Type=oneshot
- ExecStart=/usr/local/sbin/inventory-collect.sh

Timer (inventory-collect.timer):
- [Unit] Description=Run inventory collection hourly
- [Timer] OnCalendar=hourly
- Persistent=true
- [Install] WantedBy=timers.target

Ativar:
- systemctl daemon-reload
- systemctl enable --now inventory-collect.timer

Critério: `systemctl list-timers` exibe o timer ativo; arquivos atualizados ao menos 1x por hora.

---

## 4) Validação rápida

- ls -l /srv/infra/inventory
- grep -E ':(80|443)\b' /srv/infra/inventory/ports.txt || echo "80/443 ausentes"
- awk -F,
