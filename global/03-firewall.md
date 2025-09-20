# Procedimento: Firewall (GLOBAL, nftables)

Padrão oficial do Debian2-1.
Estratégia atual: policy accept com regras já organizadas por serviço.
Quando for endurecer, trocar 1 linha para policy drop e todo o conjunto passa a valer.

## 1) Arquivo de regras do sistema

Abrir o arquivo persistente do nftables:

nano /etc/nftables.conf

Conteúdo recomendado (modo permissivo e organizado):

#!/usr/sbin/nft -f
flush ruleset
table inet filter {
  chain input {
    type filter hook input priority 0;

    # Política ATUAL: aceitar tudo (modo permissivo organizado)
    # Para endurecer no futuro, troque para: policy drop;
    policy accept;

    # ===== BLOCO 1: Acesso administrativo =====
    tcp dport 22 accept

    # ===== BLOCO 2: Web (Apache) =====
    tcp dport { 80, 443 } accept
    # Portas HTTP dedicadas de vhosts (se usadas pelo add-vhost-ssl-safe)
    # Ex.: tcp dport 8081 accept

    # ===== BLOCO 3: Serviços de Aplicação =====
    # Portas registradas em /srv/infra/services/services.csv
    # Exemplo hello@8080:
    tcp dport 8080 accept
    # Outro serviço:
    # tcp dport 9000 accept

    # ===== BLOCO 4: ICMP =====
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept
  }
}

## 2) Aplicação e persistência

Aplicar as regras e garantir que carreguem no boot:

nft -f /etc/nftables.conf
systemctl enable nftables
systemctl restart nftables
systemctl status nftables --no-pager

## 3) Validações obrigatórias

Listar regras ativas:

nft list ruleset

Checar portas em LISTEN:

ss -ltn

Critério de aprovação:
- Se 22, 80, 443 e as portas de serviços aparecem, o firewall está válido.
- Se alguma porta esperada não aparece, revisar /etc/nftables.conf e o CSV.

## 4) Convenção para novas portas

Sempre que criar um novo serviço ou vhost:
1. Registrar no CSV:  nano /srv/infra/services/services.csv
2. Adicionar a porta correspondente no bloco adequado de /etc/nftables.conf.
3. Reaplicar:  nft -f /etc/nftables.conf
4. Validar:    ss -ltn | grep -E ":<porta>\b" || echo "porta <porta> não está em LISTEN"

## 5) Endurecimento (quando tudo estiver alinhado)

Trocar a linha:
policy accept;
por:
policy drop;

Reaplicar e validar:
nft -f /etc/nftables.conf
nft list ruleset

Checklist pós-drop:
- SSH (22) acessível
- HTTP/HTTPS (80/443) acessíveis
- Portas de serviços em LISTEN

## 6) Rollback emergencial

Se perder acesso remoto por engano:
echo 'flush ruleset' | nft -f -

## 7) Referências cruzadas

- Apache (HTTPS blindado): apache/add-vhost-ssl-safe.md
- Services (registro/CSV/systemd): services/register-service.md


