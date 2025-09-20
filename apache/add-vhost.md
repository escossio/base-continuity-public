# Procedimento: Criação de VirtualHost HTTP (padrão, anti-bomba)

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: seguir este fluxo determinístico. Não editar pedaços — substituir arquivos completos.

## Referências obrigatórias
- Convenções: global/02-conventions.md
- Firewall (nftables): global/03-firewall.md
- Script auxiliar: /home/leonardo/ops/apache/bin/add-vhost.sh
- Logs por vhost: /srv/infra/apache/logs/<server>-{access,error}.log

## Pré-requisitos
- apache2 instalado e ativo.
- Diretórios existentes:
  - /srv/infra/apache/logs
  - /var/www/.well-known/acme-challenge
  (Criar com: install -d -m 0755 <dir>)

---

## Fluxo anti-bomba (determinístico)

### 1) Listen e firewall
- Não editar ports.conf. Criar conf dedicada por porta e habilitar:
  - Arquivo: /etc/apache2/conf-available/listen-<PORTA>.conf
  - Conteúdo:
    - Para HTTP padrão:  Listen 80
    - Para porta dedicada: Listen <PORTA_HTTP>
  - Habilitar: a2enconf listen-<PORTA>  (uma por arquivo)
  - Recarregar: systemctl reload apache2
- Liberar no nftables conforme global/03-firewall.md:
  - 80 e (quando aplicável) <PORTA_HTTP>

Validações:
- apache2ctl -t  → deve retornar “Syntax OK”
- ss -ltn | grep -E ':(80|<PORTA_HTTP>)\b'  → porta(s) em LISTEN

### 2) VHost HTTP mínimo
- Criar arquivo: /etc/apache2/sites-available/<dominio>.conf
- Conteúdo recomendado:
  <VirtualHost *:<PORTA_HTTP>>
      ServerName <dominio>
      # (Opcional) ServerAlias <alias1> <alias2>

      DocumentRoot <docroot>

      ErrorLog  /srv/infra/apache/logs/<dominio>-error.log
      CustomLog /srv/infra/apache/logs/<dominio>-access.log combined

      Alias /.well-known/acme-challenge/ "/var/www/.well-known/acme-challenge/"

      <Directory "<docroot>">
          Options -Indexes +FollowSymLinks
          AllowOverride All
          Require all granted
      </Directory>
  </VirtualHost>

- Habilitar e recarregar:
  - a2ensite <dominio>
  - systemctl reload apache2

Validações:
- apache2ctl -S  → mapeamento do vhost aparece em <PORTA_HTTP>
- ss -ltn | grep -E ':(<PORTA_HTTP>)\b'  → porta do site em LISTEN

### 3) (Opcional) Redirecionar HTTP → HTTPS
- Após emitir certificado e criar o vhost 443, pode redirecionar:
  - Em /etc/apache2/sites-available/<dominio>.conf:
    Redirect permanent / https://<dominio>/
  - Recarregar Apache.
- Para HTTPS, seguir: apache/add-vhost-ssl-safe.md

---

## Comando padrão (script auxiliar)

Executa a criação do vhost HTTP com verificações básicas:

/home/leonardo/ops/apache/bin/add-vhost.sh <dominio> <porta_http> <docroot> [owner=www-data]

---

## Pós-condições (checklist)
- apache2ctl -t → “Syntax OK”.
- apache2ctl -S lista <dominio> em <PORTA_HTTP>.
- ss -ltn mostra <PORTA_HTTP> (e 80 quando usado).
- Logs do vhost existem em /srv/infra/apache/logs/<dominio>-{access,error}.log.

## Rollback mínimo
- a2dissite <dominio> && systemctl reload apache2
- Remover /etc/apache2/sites-available/<dominio>.conf quando necessário (ver apache/del-vhost.md).
