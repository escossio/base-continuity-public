# TEMPLATE OFICIAL — systemd service (Debian2-1)
# Preencha os placeholders conforme a Base:
# {{NAME}} {{USER}} {{GROUP}} {{WORKDIR}} {{ENVFILE}} {{EXEC}}

[Unit]
Description={{NAME}} service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User={{USER}}
Group={{GROUP}}
WorkingDirectory={{WORKDIR}}

# Variáveis de ambiente (opcional). Se não houver .env, remova a linha.
EnvironmentFile={{ENVFILE}}

# Processo principal do serviço
ExecStart={{EXEC}}

# Política de reinício
Restart=always
RestartSec=3

# Endurecimento básico
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true
ReadWritePaths={{WORKDIR}}
LockPersonality=true
CapabilityBoundingSet=
AmbientCapabilities=

# Logs via journalctl
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
