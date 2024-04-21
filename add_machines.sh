#!/bin/bash

for i in 1 2; do
docker-machine create \
    --driver generic \
    --generic-ip-address "$1$i" \
    --generic-ssh-user vagrant \
    --generic-ssh-key /home/vagrant/.ssh/insecure_private_key \
    "worker$i" || echo "continue !!"
done