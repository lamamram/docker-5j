#!/bin/bash
docker ps -a | grep stack_php_nginx
# $? le code de retour  de la commande dernière
if [ $? -eq 0 ]; then
    docker rm -f stack_php_nginx
fi

docker run \
       --name stack_php_nginx \
       -d --restart unless-stopped \
       -p 192.168.1.30:8080:80 \
       nginx:1.25