# DOCKER COMPOSE

## Enjeu

* docker compose est un plugin qui permet 
  - de piloter l'installation de microservices 
  - à partir d'un fichier de configuration nommé **docker-compose.yml**
  - au format **YAML**

## Rappel sur YAML

* YAML est un format de données basé sur les paires clés / valeur, comme JSON
  - ex. `key: value` en YAML correspond à `{"key": "value"} en JSON`
  - '{}' et '""' ne sont pas utilisés
  - l'imbrication est assurée par l'indentation

  `{"obj": {"param 1": 1,"param 2": "bonjour","param 3": 3.14}}`
  
  ```json
  {
    "obj": {
        "param 1": 1,
        "param 2": "bonjour",
        "param 3": 3.14
    }
  }
  ```

  - correspond à

```yaml
obj:
  param 1: 1
  param 2: bonjour
  param 3: 3.14
```

- les listes sont gérées par indentation plus préfixage par "- " ex:

`{"obj": {"param 1": ["bonjour", 44, {"key": "value", "key2": "value2"}]}`

- soit

```json
  {
    "obj": {
        "param 1": [
            "bonjour", 44, {"key": "value", "key2": "value2"}
        ]
    }
  }
  ```

  - correspond à 

```yaml
obj:
  param 1:
    - bonjour
    - 44
    - key: value
      key2: value2
```

## syntaxe docker compose

* voir les fichiers docker-compose.yml

## lancement via docker compose

* dans le dossier contenant le fichier docker-compose.yml
* `docker compose up -d` pour lancer la stack en mode détaché
  - `docker compose down` pour supprimer la stack
  - par défaut création / suppression des réseaux

* lancer uniquement les services avec un profile donné:
  - `docker compose --profile [profile_name] up -d`
  - `docker compose --profile [profile_name] down`
  - attention, le docker compose up simple ne sélectionne plus aucun conteneur !!!

* en cas de volumes nommés, le down ne les supprime pas (logique)
  - pour tout supprimer: `docker compose down -v`

## scruter les logs du microservice facilement

* `docker compose [--profile <profile>] logs [service_particulier]`

## rappel sur la cli de compose

*  docker compose **ps** **start** **stop** **restart** **rm** **run** **exec**

## templating dans docker compose

1. remplacer le port 9000 dans la conf ngnix par ${PHP_PORT}
2. utiliser envsusbst pour remplacer cette variable par sa valeur
   dans le fichier
   - envsubst < [template] > [fichier interpolé]
   - remplacer le template par le fchier interpolé
3. modifier le docker-compose.yml pour
  - injecter la variable d'environnement dans le conteneur de façon masquée

4. aller plus loin
  - modifier le port écouté sut le conteneur php => /opt/bitnami/php/etc/php-fpm.d/www.conf
  - ajouter un Dockerfile qui expose le port pointé par la variable d'environnement PHP_PORT


## build d'image dans docker compose

1. fabriquer le docker-compose.yml de la stack java
  - créer un dossier stack_java

2. builder le dockerfile dans le fichier de conf avec arguments