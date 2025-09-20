# Checklist de Verificação (GLOBAL)

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: este checklist deve ser executado no início de cada sessão/atividade.
Convenções: editar arquivos com “nano + caminho”; criar diretórios com “install -d -m 0755”.

---

## 1) Estrutura e permissões

Comandos de consulta:
- tree -L 2 /home/leonardo/ops /srv/infra || true
- getent group www-data >/dev/null && id www-data || true

Critério:
- Estruturas /home/leonardo/ops e /srv/infra existem.
- Usuário/grupo www-data presentes (ou o usuário de serviço padrão definido).

---

## 2) Tempo e disco

Comandos de consulta:
- timedatectl || true
- df -hT | grep -E '(/srv|/var|/)$|^Filesystem' -n || true

Critério:
- Data/hora corretas. Espaço livre suficiente nas partições /, /var e /srv.

---

## 3) Apache instalado e íntegro

Comandos de consulta:
- apache2 -v
- apache2ctl -t
- systemctl is-active --quiet apache2 && echo "apache2: ativo" || systemctl status apache2 --no-pager

Critério:
- apache2ctl -t retorna “Syntax OK”.
- Serviço ativo ou com status claro para iniciar/reiniciar.

---

## 4) Firewall (estado atual)

Documentação oficial: global/03-firewall.md

Comandos de consulta:
- nft list ruleset
- ss -ltn | grep -E ':(80|443)\b' || echo "80/443 não em LISTEN"

Critério:
- Regras carregadas no nftables (mesmo em modo policy accept).
- Portas 80 e 443 em LISTEN quando houver Apache ativo.

---

## 5) ACME (acme.sh) pronto

Comandos de consulta:
- command -v acme.sh || echo "acme.sh ausente"
- ls -ld /srv/infra/ssl /srv/infra/ssl/live 2>/dev/null || true

Critério:
- acme.sh instalado e diretórios de SSL existentes (ou prontos para criação).

---

## 6) Inventário de serviços (CSV)

Caminho oficial: /srv/infra/services/services.csv

Comandos de consulta:
- test -f /srv/infra/services/services.csv && column -s, -t /srv/infra/services/services.csv | head -n 10 || echo "CSV ausente"
- awk -F, 'NR>1{c[$2]++} END{for(p in c) if(c[p]>1) print "PORTA DUPLICADA:", p, "vezes:", c[p]}' /srv/infra/services/services.csv 2>/dev/null || true

Critério:
- CSV presente com cabeçalho name,port,user,dir,exec,envfile.
- Sem portas duplicadas (relatório vazio).

---

## 7) Logs críticos acessíveis

Comandos de consulta:
- ls -ld /srv/infra/apache/logs 2>/dev/null || true
- tail -n 50 /var/log/apache2/error.log 2>/dev/null || true
- journalctl -xn --no-pager 2>/dev/null || true

Critério:
- Diretório de logs acessível; erros recentes do Apache compreendidos/aceitáveis.

---

## 8) Verificação final

Comandos de consulta:
- apache2ctl -t && apache2ctl -S
- ss -ltn

Critério:
- Sintaxe/mapeamento de vhosts OK.
- Portas esperadas em LISTEN (80/443 e serviços do CSV).

---
