#!/bin/bash

[[ -z $(docker ps -aq) ]] \
|| docker rm -f $(docker ps -aq -f "name=app_*")

# docker volume rm db_data

docker network rm stack_php

docker network create stack_php --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1

# volume nommé se trouve par défaut dans /var/lib/docker/volumes/db_data/_data/
# --env MARIADB_USER=test \
# --env MARIADB_PASSWORD=roottoor \
# --env MARIADB_DATABASE=test \
# --env MARIADB_ROOT_PASSWORD=roottoor \
# approche naïve du chargement des données
# docker run -it --rm --net stack_php -v /vagrant/mariad-init.sql:/mariadb-init.sql mariadb:10.11.6 bash -c 'mariadb -h app_mariadb -u test -proottoor test < /mariadb-init.sql'
docker run \
--name app_mariadb \
-d --restart unless-stopped \
--net stack_php \
--env-file /vagrant/.env \
-v db_data:/var/lib/mysql \
-v /vagrant/mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql \
mariadb:10.11.6


# --mount type=bind,src=/vagrant/index.php,dst=/srv/index.php,readonly\
# volume-opt driver=local,volume-opt type=nfs,volume-opt device=182.168.x.y=/storage
docker run \
--name app_php \
-d --restart unless-stopped \
--net stack_php \
-v /vagrant/index.php:/srv/index.php:ro \
bitnami/php-fpm:8.2-debian-11

# docker cp /vagrant/index.php app_php:/srv/index.php

docker run \
--name app_nginx \
-d --restart unless-stopped \
-p 8080:80 \
--net stack_php \
-v /vagrant/php8.2.conf:/etc/nginx/conf.d/php8.2.conf \
nginx:1.25.4

# docker cp /vagrant/php8.2.conf app_nginx:/etc/nginx/conf.d/php8.2.conf
# docker restart app_nginx
