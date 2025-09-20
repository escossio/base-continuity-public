# Procedimento: Criação de VirtualHost com HTTPS (ordem blindada)

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: seguir estritamente este fluxo determinístico. Não editar pedaços — substituir arquivos completos.

## Referências obrigatórias
- Convenções: global/02-conventions.md
- Firewall (nftables): global/03-firewall.md
- Template SSL: apache/templates/vhost-ssl.conf.tpl
- Certificados: /srv/infra/ssl/live/<dominio>/{fullchain.pem,privkey.pem}
- Script auxiliar: /home/leonardo/ops/apache/bin/add-vhost-ssl-safe.sh

## Pré-requisitos
- apache2 instalado e ativo.
- acme.sh disponível no PATH.
- Diretórios existentes:
  - /srv/infra/apache/logs
  - /var/www/.well-known/acme-challenge
  (Criar com: install -d -m 0755 <dir>)

---

## Fluxo blindado (determinístico)

### 1) Listen e firewall
- Não editar ports.conf. Criar conf dedicada e habilitar:
  - Arquivo: /etc/apache2/conf-available/listen-<PORTA>.conf
  - Conteúdo mínimo:
    - Para HTTP padrão: `Listen 80`
    - Para porta dedicada: `Listen <PORTA_HTTP>`
  - Habilitar: `a2enconf listen-<PORTA>` (uma por arquivo) e `systemctl reload apache2`
- Liberar no nftables (modo permissivo já organizado):
  - 80, 443 e <PORTA_HTTP> (ver global/03-firewall.md)
- Validação:
  - `apache2ctl -t` → “Syntax OK”
  - `ss -ltn | grep -E ':(80|443|<PORTA_HTTP>)\b'`

### 2) VHost HTTP mínimo (para ACME)
- Objetivo: responder `/.well-known/acme-challenge/` e servir o site em HTTP antes do TLS.
- Criar arquivo: `/etc/apache2/sites-available/<dominio>.conf`
- Conteúdo mínimo:
  - `<VirtualHost *:<PORTA_HTTP>>`
  - `ServerName <dominio>`
  - `DocumentRoot <docroot>`
  - `Alias /.well-known/acme-challenge/ "/var/www/.well-known/acme-challenge/"`
  - `<Directory "<docroot>"> Options -Indexes +FollowSymLinks; AllowOverride All; Require all granted </Directory>`
  - `</VirtualHost>`
- Habilitar e recarregar:
  - `a2ensite <dominio>`
  - `systemctl reload apache2`
- Validação:
  - `apache2ctl -S`
  - `ss -ltn | grep -E ":(<PORTA_HTTP>)\b"`

### 3) Emissão do certificado (ACME HTTP-01)
- Com webroot do site:
  - `acme.sh --issue -d <dominio> -w <docroot>`
- Instalar chaves/cadeia no caminho padrão:
  - `acme.sh --install-cert -d <dominio> \
     --fullchain-file /srv/infra/ssl/live/<dominio>/fullchain.pem \
     --key-file       /srv/infra/ssl/live/<dominio>/privkey.pem`
- Validação:
  - `test -f /srv/infra/ssl/live/<dominio>/fullchain.pem && test -f /srv/infra/ssl/live/<dominio>/privkey.pem`

### 4) VHost HTTPS (443) a partir do template
- Gerar o arquivo `/etc/apache2/sites-available/<dominio>-ssl.conf` usando o template oficial:
  - Template: `/home/leonardo/ops/base-continuity/apache/templates/vhost-ssl.conf.tpl`
  - Substituições:
    - `{{SERVER_NAME}}` → `<dominio>`
    - `{{DOCROOT}}` → `<docroot>`
    - (opcional) `{{SERVER_ALIASES}}`
- Habilitar e recarregar:
  - `a2ensite <dominio>-ssl`
  - `systemctl reload apache2`
- Validação:
  - `apache2ctl -t && apache2ctl -S`
  - `ss -ltn | grep -E ':(443)\b'`

### 5) (Opcional) Redirecionar HTTP → HTTPS
- Em `<dominio>.conf` (porta <PORTA_HTTP>), adicionar:
  - `Redirect permanent / https://<dominio>/`
- Recarregar Apache e validar com `apache2ctl -S`.

---

## Comando padrão (script auxiliar)

Executa a sequência acima com validações intermediárias:

`/home/leonardo/ops/apache/bin/add-vhost-ssl-safe.sh <dominio> <porta_http> <docroot> [owner=www-data]`

---

## Pós-condições (checklist)
- `apache2ctl -t` retorna “Syntax OK”.
- `apache2ctl -S` lista `<dominio>` em <PORTA_HTTP> e `<dominio>-ssl` em 443.
- `ss -ltn` mostra 80/443 e <PORTA_HTTP> (quando aplicável).
- Certificados presentes em `/srv/infra/ssl/live/<dominio>/`.
- Logs do vhost em `/srv/infra/apache/logs/<dominio>-{access,error}.log`.

## Rollback mínimo
- `a2dissite <dominio>-ssl && systemctl reload apache2`
- `a2dissite <dominio> && systemctl reload apache2`
- Remover os arquivos de site em `/etc/apache2/sites-available/` se necessário (ver apache/del-vhost.md).
