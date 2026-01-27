#!/bin/bash
# SSH Websocket Installer - Local Version
# Uses files from cloned repository

BASEDIR="${AUTOSCRIPT_DIR:-/root/autoscript}"

clear
cd

#Install Script Websocket-SSH golang
cp "$BASEDIR/sshws/ws-stunnel.go" /usr/local/bin/ws-stunnel.go
/usr/local/go/bin/go build -o /usr/local/bin/ws-stunnel /usr/local/bin/ws-stunnel.go
chmod +x /usr/local/bin/ws-stunnel
cp "$BASEDIR/sshws/ws-stunnel.service" /etc/systemd/system/ws-stunnel.service
chmod +x /etc/systemd/system/ws-stunnel.service

#restart service
systemctl daemon-reload

#Enable & Start & Restart ws-stunnel service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service

echo "SSH Websocket installation complete!"
