# DockerStackVPS
DockerStack with Nextcloud, Bitwarden, VNC-Downloadserver, Heimdall and Nginx as a Proxy.

You will need:

* A domain pointing to your server
* docker
* docker-compose
* git, zip, unzip, nano, rsync

## Installation

```bash
git clone https://github.com/lExplLicit/DockerStackVPS.git
cd DockerStackVPS/
chmod +x backup.sh down.sh up.sh

# Settings for Letsencrypt
cp nginx-proxy/.env.sample nginx-proxy/.env && nano nginx-proxy/.env

# Settings for Bitwarden
cp bitwarden/.env.sample bitwarden/.env && nano bitwarden/.env

# Setting for Nextcloud
cp nextcloud/.env.sample nextcloud/.env && nano nextcloud/.env

# Setting for Heimdall
cp heimdall/.env.sample heimdall/.env && nano nextcloud/.env

# Setting for Downloadserver
cp downloadsrv/.env.sample downloadsrv/.env && nano downloadsrv/.env
./up.sh
```

## Configuration for Nextcloud:
```bash
# Add 's' to 'http' in 'overwrite.cli.url' and add this line: 'overwriteprotocol' => 'https'
nano nextcloud/volumes/SERVICE_NEXTCLOUD/config/config.php

# Run following occ comands
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:add-missing-indices
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:convert-filecache-bigint
```

### Install Turn Server for Nextcloud Talk
Open Firewall ports: 3478 TCP and 3478 UDP first
```bash
sudo apt install coturn
sudo sed -i '/TURNSERVER_ENABLED/c\TURNSERVER_ENABLED=1' /etc/default/coturn

# Generate Secret
openssl rand -hex 32

# Add this configuration to /etc/turnserver.conf:
  
  listening-ip=0.0.0.0
  listening-port=3478
  fingerprint
  use-auth-secret
  static-auth-secret=<GeneratedSecret>
  realm=<your.domain.tld>
  total-quota=100
  bps-capacity=0
  stale-nonce
  no-multicast-peers

systemctl restart coturn

# Apply Nextcloud Settings
TURN server: <your.domain.tld>:3478
TURN secret: <GeneratedSecret>
UDP and TCP
```

## Backup container

```bash
./backup.sh <container_dir>
```

## Restore container

```bash
cd <container_dir>
./backups/<backup_name>/restore.sh
```
