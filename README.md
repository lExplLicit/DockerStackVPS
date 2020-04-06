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
```