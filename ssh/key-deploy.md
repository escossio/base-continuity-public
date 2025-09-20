---
layout: default
title: Key deploy
permalink: /ssh/key-deploy/
---
# Procedimento: Deploy de Chaves SSH (Termux → Servidor)

Alvo: Debian2-1 (e futuras versões blindadas).
Regra: seguir este fluxo determinístico. Não editar pedaços — substituir arquivos completos.

Referências:
- global/02-conventions.md
- global/03-firewall.md  (porta 22 deve permanecer acessível)

## 1) Gerar chave no cliente (recomendado: ed25519)

No cliente (Termux/Android ou laptop):
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -C "<seu_email_ou_tag>"

Cria:
~/.ssh/id_ed25519       (PRIVADA)
~/.ssh/id_ed25519.pub   (PÚBLICA)

## 2) Permissões no cliente

install -d -m 0700 ~/.ssh
chmod 0600 ~/.ssh/id_ed25519
chmod 0644 ~/.ssh/id_ed25519.pub

## 3) Enviar chave pública para o servidor

Método padrão:
ssh-copy-id -i ~/.ssh/id_ed25519.pub <usuario>@<host>

Alternativo (manual):
cat ~/.ssh/id_ed25519.pub   # copie a linha inteira
no servidor:
install -d -m 0700 ~/.ssh
nano ~/.ssh/authorized_keys   # cole em nova linha
chmod 0600 ~/.ssh/authorized_keys

## 4) Teste de acesso

ssh -i ~/.ssh/id_ed25519 <usuario>@<host>

Critério:
Conectar sem senha (pode pedir passphrase da chave, se definida).

## 5) Endurecimento opcional (servidor)

nano /etc/ssh/sshd_config
Ajustar:
PasswordAuthentication no
PubkeyAuthentication yes
# (Opcional) Proibir root:
PermitRootLogin no

Recarregar:
systemctl reload ssh

## 6) Rollback mínimo

Reverter alterações em /etc/ssh/sshd_config e recarregar:
systemctl reload ssh

Remover a chave (se necessário):
nano ~/.ssh/authorized_keys   # apague a linha correspondente
