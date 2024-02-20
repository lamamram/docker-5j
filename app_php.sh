#!/bin/bash
[[ -z $(docker ps -aq) ]] \
|| docker rm -f $(docker ps -aq -f "name=app_*")

docker network rm stack_php

docker network create stack_php --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1


docker run \
--name app_php \
-d --restart unless-stopped \
--net stack_php \
bitnami/php-fpm:8.2-debian-11

docker cp /vagrant/index.php app_php:/srv/index.php

docker run \
--name app_nginx \
-d --restart unless-stopped \
-p 8080:80 \
--net stack_php \
nginx:1.25.4

docker cp /vagrant/php8.2.conf app_nginx:/etc/nginx/conf.d/php8.2.conf
docker restart app_nginx
