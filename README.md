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

# Add 's' to http in 'overwrite.cli.url' and add this line: 'overwriteprotocol' => 'https'
nano nextcloud/volumes/SERVICE_NEXTCLOUD/config/config.php
# Run following occ comands
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:add-missing-indices
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:convert-filecache-bigint
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
