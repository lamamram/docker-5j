#!/bin/bash

# dump à froid (avec le microservice off)
# docker run \
#        --rm \
#        --net none \
#        -v db_data:/data \
#        -v ./dump:/dump \
#        debian:12 \
#        tar -czvf /dump/dump_cold.tar.gz /data \

# dump à chaud (avec le microservice on)
# l'option --volumes-from ajoute tous les volumes 
# => (bind, et nommés avec leur emplacement dans le conteneur)
docker run \
       --rm \
       --volumes-from stack_php_mariadb \
       -v ./dump:/dump \
       --net stack_php \
       debian:12 \
       tar -czvf /dump/dump.gz /var/lib/mysql

