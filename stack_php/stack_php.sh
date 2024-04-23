#!/bin/bash
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter "name=stack_php_*") ]] || docker rm -f $(docker ps -aq -f "name=stack_php_*")

docker network ls | grep stack_php
# $? le code de retour  de la commande dernière
if [ $? -eq 0 ]; then
    docker network rm stack_php
fi

docker network create \
       --subnet=172.18.0.0/24 \
       --gateway=172.18.0.1 \
       stack_php

docker run \
       --name stack_php_php \
       -d --restart unless-stopped \
       --net stack_php \
       bitnami/php-fpm:8.2-debian-12
docker cp index.php stack_php_php:/srv/index.php

# --link stack_php_php \
docker run \
       --name stack_php_nginx \
       -d --restart unless-stopped \
       -p 192.168.1.30:8080:80 \
       --net stack_php \
       nginx:1.25

docker cp php8.2.conf stack_php_nginx:/etc/nginx/conf.d/php8.2.conf
docker restart stack_php_nginx
