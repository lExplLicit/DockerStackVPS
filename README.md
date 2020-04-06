# DockerStackVPS
DockerStack with Nextcloud, Bitwarden and Nginx as a Proxy.

## Installation (with_nginx_proxy)

```
git clone https://github.com/lExplLicit/DockerStackVPS.git

cd DockerStackVPS/with_nginx_proxy

chmod +x backup.sh down.sh up.sh

cp nginx-proxy/.env.sample nginx-proxy/.env && nano nginx-proxy/.env

cp bitwarden/.env.sample bitwarden/.env && nano bitwarden/.env

cp nextcloud/.env.sample nextcloud/.env && nano nextcloud/.env

./up.sh

//For Nextcloud 18.0.3
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:add-missing-indices
docker exec -u www-data SERVICE_NEXTCLOUD php occ db:convert-filecache-bigint
```


## Backup container (with_nginx_proxy)

```
./backup.sh <container_dir>
```

## Restore container (with_nginx_proxy)

```
cd <container_dir>
./backups/<backup_name>/restore.sh
```
