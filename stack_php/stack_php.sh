#!/bin/bash

########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter "name=stack_php_*") ]] || docker rm -f $(docker ps -aq -f "name=stack_php_*")

docker network ls | grep stack_php
# $? le code de retour  de la commande dernière
if [ $? -eq 0 ]; then
    docker network rm stack_php
fi

docker volume ls | grep nfs-vol
if [ $? -eq 0 ]; then
    docker volume rm nfs-vol
fi

########################### VOLUMES #####################################

docker volume create \
       --driver local \
       --opt type=nfs \
       --opt o=addr=192.168.1.30,ro \
       --opt device=:/mnt/nfs-dir \
       nfs-vol

############################ RESEAU ######################################

docker network create \
       --subnet=172.18.0.0/24 \
       --gateway=172.18.0.1 \
       stack_php

############################ CONTAINERS ###################################

docker run \
       --name stack-php-mariadb \
       -d --restart unless-stopped \
       --net stack_php \
       --env-file .env \
       -v ./mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql:ro \
       -v db_data:/var/lib/mysql \
       mariadb:11.0.4-jammy
       ## les variables d'env sont éditées puisqu'elles existent déjà dans le contenur

# -e MARIADB_USER=test \
# -e MARIADB_PASSWORD=roottoor \
# -e MARIADB_DATABASE=test \
# -e MARIADB_ROOT_PASSWORD=roottoor \
# manière artisanale
# -v ./mariadb-init.sql:/mariadb-init.sql:ro \
# docker exec stack_php_mariadb bash -c 'mariadb -h localhost -u test -proottoor test < /mariadb-init.sql' 


docker run \
       --name stack-php-php \
       -d --restart unless-stopped \
       --net stack_php \
       --env-file .env \
       -v nfs-vol:/srv \
       bitnami/php-fpm:8.2-debian-12

# -v ./index.php:/srv/index.php:ro \
# les variables d'env de mariadb sont chargées et crées dans le conteneur
# docker cp index.php stack_php_php:/srv/index.php
# --link stack_php_php \ inutile pour un réseau custom
docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 192.168.1.30:8080:80 \
       -v ./php8.2.conf:/etc/nginx/conf.d/php8.2.conf:ro \
       --net stack_php \
       nginx:1.25

# docker cp php8.2.conf stack_php_nginx:/etc/nginx/conf.d/php8.2.conf
# docker restart stack_php_nginx

