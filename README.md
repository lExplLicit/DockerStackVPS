# DockerStackVPS
DockerStack with Nextcloud, Bitwarden and Nginx as a Proxy.

## Installation (with_nginx_proxy)

```bash
git clone https://github.com/lExplLicit/DockerStackVPS.git

cd DockerStackVPS/with_nginx_proxy

chmod +x backup.sh down.sh up.sh

cp nginx-proxy/.env.sample nginx-proxy/.env && nano nginx-proxy/.env

cp bitwarden/.env.sample bitwarden/.env && nano bitwarden/.env

cp nextcloud/.env.sample nextcloud/.env && nano nextcloud/.env

./up.sh

# For Nextcloud 18.0.3:

# Add 's' to 'http' in 'overwrite.cli.url' and add this line: 'overwriteprotocol' => 'https'
nano nextcloud/volumes/SERVICE_NEXTCLOUD/config/config.php

# Run following occ comands
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:add-missing-indices
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:convert-filecache-bigint

# Install Turn Server for Talk
Open Firewall ports: 3478,3479 TCP and 3478,3479 UDP

sudo apt install coturn
sudo sed -i '/TURNSERVER_ENABLED/c\TURNSERVER_ENABLED=1' /etc/default/coturn

# Add configuration to /etc/turnserver.conf:
  listening-ip=0.0.0.0
  listening-port=3478
  fingerprint
  use-auth-secret
  static-auth-secret=<yourChosen/GeneratedSecret>
  realm=your.domain.tld
  total-quota=100
  bps-capacity=0
  stale-nonce
  no-multicast-peers

systemctl restart coturn

# Nextcloud Settings
TURN server: your.domain.tld:3478
TURN secret: <yourChosen/GeneratedSecret>
UDP and TCP
```


## Backup container (with_nginx_proxy)

```bash
./backup.sh <container_dir>
```

## Restore container (with_nginx_proxy)

```bash
cd <container_dir>
./backups/<backup_name>/restore.sh
```
