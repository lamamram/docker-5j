# limitations des ressources conteneurs

## setup

* utilisation de l'image **progrium/stress**
  - `docker pull progrium/stress`
  - `docker run --rm progrium/stress --help`
* utilisation du paquet ctop
  - `sudo apt-get update && sudo apt-get install -y ctop`


## limiter l'accès mémoire

* `docker run --memory=xx(k,m,g)`
* option **--memory-swap** pour autoriser le swap pour le contneur
  - utilisation du stockage comme extension de la RAM (plus lent)
* option **--memory-reservation** pour établir une quantité de mémoire minimale

* ex: `docker run -d --rm --memory=512m progrium/stress -m 1 --vm-bytes 256m -t 20s`
  - limitation phys de la RAM à 512M et exéc. d'un process allouant 256m pendant 20s
  - en exécutant de process, on prend le risque d'atteindre la lim phys ==> crash du conteneur
  - ajouter --memory-reservation à coté de --memory: permet d'allouer au moins telle quantité de RAM, vis à vis des autres conteneurs, sans garanties.

  ```
  docker run -d --rm \
    --memory=520m \
    --memory-reservation=256m \
    progrium/stress -m 1 --vm-bytes 256m -t 20s
  ```

## limiter l'accès au cpu

* `docker run ... --cpus=x.y`
  -  0.1 < x.y < nb de cpus disponibles
  - le conteneur peut utiliser telle fraction du temps cpu par rapport au nb total
  - ex. x.y = 1 avec deux cpus et exec de deux process => 50% du temps cpu total des 2 cpus
    + `docker run --rm -d --cpus=1 progrium/stress -c 2 -t 20s`

* `docker run ... --cpuset-cpus=min-max|n,m,p...`
  - flécher l'exec du conteneur sur certains cpus (indéxés de 0 à nb_de_cpu -1 )
  - ex. `docker run --rm -d --cpuset-cpus=0 progrium/stress -c 1 -t 20s`
  - ex. `docker run --rm -d --cpuset-cpus=0,1 progrium/stress -c 2 -t 20s`

* `docker run ... --cpu-shares=1024`
  - poids relatif par rapport aux autres conteneur (1024 => équilibre)
