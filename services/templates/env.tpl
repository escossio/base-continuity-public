# TEMPLATE OFICIAL — arquivo .env para serviços (Debian2-1)
# Formato: CHAVE=valor (uma por linha). Não usar aspas.
# Não versionar segredos reais neste template.

# Identidade do serviço
APP_NAME={{NAME}}
APP_ENV=production

# Rede / bind (se aplicável)
HOST=0.0.0.0
PORT={{PORT}}

# Caminhos padrão
WORKDIR={{WORKDIR}}
LOG_DIR={{WORKDIR}}/logs

# Banco de dados (exemplo; remova se não usar)
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME={{NAME}}
DB_USER={{NAME}}
DB_PASS=__definir_no_deploy__

# Variáveis extras do aplicativo
# KEY1=value1
# KEY2=value2
