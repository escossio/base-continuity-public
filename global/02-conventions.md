# Convenções Operacionais (GLOBAL)

Estas regras valem para todos os procedimentos da Base de Continuidade.

---

## Edição e criação

- Editar arquivos sempre com: nano + caminho
- Criar diretórios com: install -d -m 0755 <path>  (não usar mkdir -p)
- Permissões padrão: diretórios 0755; arquivos 0644 (salvo exceções)
- Sem edição direta em /etc quando houver template → gerar a partir da Base

---

## Layouts e caminhos oficiais

- Templates Apache (SSL/HTTP): /home/leonardo/ops/base-continuity/apache/templates/
- Certificados ACME instalados: /srv/infra/ssl/live/<dominio>/{fullchain.pem,privkey.pem,chain.pem}
- Logs Apache por vhost: /srv/infra/apache/logs/<server>-{access,error}.log
- Inventário de serviços (CSV): /srv/infra/services/services.csv
- Units systemd de serviços: /etc/systemd/system/<name>.service
- Diretório padrão de apps: /srv/apps/<name>  (owner: www-data ou usuário do serviço)

---

## Placeholders e estilo

- Usar {{UPPER_SNAKE}} para variáveis (ex.: {{SERVER_NAME}}, {{DOCROOT}}, {{PORT}})
- Nunca versionar segredos; usar .env no diretório do app e referenciar com EnvironmentFile=
- Nomes de arquivos e serviços: minúsculos, sem espaços, com hífen quando necessário

---

## Apache

- Nunca editar ports.conf diretamente; configurar Listen via conf-available + a2enconf
- Para HTTPS seguir: apache/add-vhost-ssl-safe.md
- Template oficial: apache/templates/vhost-ssl.conf.tpl

---

## Serviços (apps)

- Todo serviço deve constar no CSV com: name,port,user,dir,exec,envfile
- Unit systemd derivada do template: services/templates/systemd-service.tpl
- .env opcional baseado em: services/templates/env.tpl
- Logs via journalctl ou em /srv/apps/<name>/logs

---

## Firewall

- Tecnologia padrão: nftables
- Procedimento oficial: global/03-firewall.md
- Enquanto policy accept estiver ativa, manter regras já organizadas (SSH, 80/443, serviços)
- Ao endurecer, trocar para policy drop e garantir exceções necessárias antes

---

## Princípios “anti-bomba”

1. Determinismo: ordem clara; cada passo tem verificação embutida no .md
2. Templates versionados: nunca improvisar em /etc sem refletir na Base
3. Rollback simples: manter passos de reversão documentados
4. Fonte única: se faltar algo, parar e atualizar a Base antes de executar
5. Rastreabilidade: mudanças relevantes devem ser registradas no bunker da Base

---
