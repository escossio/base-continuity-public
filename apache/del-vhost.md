# Procedimento: Remoção de VirtualHost (Apache) — determinístico

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: seguir o fluxo; não editar pedaços — substituir arquivos completos.

## Referências
- Convenções: global/02-conventions.md
- Firewall: global/03-firewall.md
- Logs por vhost: /srv/infra/apache/logs/<server>-{access,error}.log

---

## Fluxo de remoção segura

### 1) Desabilitar o(s) site(s)
Executar em ordem:
- a2dissite <dominio>-ssl    (se existir)
- a2dissite <dominio>
- systemctl reload apache2

Validação (consulta):
- apache2ctl -S  → <dominio> e <dominio>-ssl não devem aparecer
- apache2ctl -t  → “Syntax OK”

### 2) Remover arquivos de configuração
Caminhos padrão:
- /etc/apache2/sites-available/<dominio>.conf
- /etc/apache2/sites-available/<dominio>-ssl.conf

Ações:
- rm -f /etc/apache2/sites-available/<dominio>.conf
- rm -f /etc/apache2/sites-available/<dominio>-ssl.conf  (se existir)

Recarregar:
- systemctl reload apache2
- apache2ctl -t  (deve manter “Syntax OK”)

### 3) (Opcional) Limpeza de docroot
Se o docroot é exclusivo do vhost e pode ser removido:
- path: <docroot>
- ação: mover para retenção ou remover conforme política interna
  - mv <docroot> /srv/infra/apache/backup/<dominio>-$(date +%F)
  - ou rm -rf <docroot>

### 4) Logs
- Manter por retenção em /srv/infra/apache/logs/<dominio>-{access,error}.log
- (Opcional) arquivar com data ou rotacionar conforme política.

---

## Pós-condições (checklist)
- apache2ctl -S não lista <dominio> / <dominio>-ssl
- apache2ctl -t retorna “Syntax OK”
- Portas continuam em LISTEN apenas para os vhosts ativos
- Arquivos do site removidos dos diretórios de configuração
- Logs mantidos/arquivados

## Rollback mínimo
- Restaurar os arquivos .conf removidos (de backup) para /etc/apache2/sites-available/
- a2ensite <dominio>  e, se aplicável, a2ensite <dominio>-ssl
- systemctl reload apache2
- Validar com apache2ctl -t e apache2ctl -S
