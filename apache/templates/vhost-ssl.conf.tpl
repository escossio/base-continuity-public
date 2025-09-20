# TEMPLATE OFICIAL — Apache SSL VirtualHost (Debian2-1)
# Gerado/consumido pelo procedimento: apache/add-vhost-ssl-safe.md
# Placeholders: {{SERVER_NAME}}, {{SERVER_ALIASES}}, {{DOCROOT}}

<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName {{SERVER_NAME}}
    # Se houver aliases, descomente e preencha:
    # ServerAlias {{SERVER_ALIASES}}

    DocumentRoot {{DOCROOT}}

    # Logs padronizados
    ErrorLog  /srv/infra/apache/logs/{{SERVER_NAME}}-error.log
    CustomLog /srv/infra/apache/logs/{{SERVER_NAME}}-access.log combined

    # HTTP/2 + HTTP/1.1
    Protocols h2 http/1.1

    # SSL/TLS (certs instalados pelo ACME em /srv/infra/ssl/live/<dominio>/)
    SSLEngine on
    SSLCertificateFile    /srv/infra/ssl/live/{{SERVER_NAME}}/fullchain.pem
    SSLCertificateKeyFile /srv/infra/ssl/live/{{SERVER_NAME}}/privkey.pem
    # (Apache 2.4 usa fullchain; cadeia extra não é necessária)

    # Diretório raiz do site
    <Directory "{{DOCROOT}}">
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # ACME challenge exposto também em 443 (útil em renovações)
    Alias /.well-known/acme-challenge/ "/var/www/.well-known/acme-challenge/"
    <Directory "/var/www/.well-known/acme-challenge">
        Options None
        AllowOverride None
        Require all granted
    </Directory>

    # Cabeçalhos mínimos de segurança
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set Referrer-Policy "no-referrer-when-downgrade"
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"

    # Política TLS (moderna, sem protocolos legados)
    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:!aNULL:!MD5
    SSLHonorCipherOrder on
</VirtualHost>
</IfModule>
