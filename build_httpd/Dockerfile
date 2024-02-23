# multistaging build
FROM curlimages/curl AS provider

# REMARQUE: on peut compiler un projet dans une image et copier avec COPY --from xxx.exe .
# dance cas on peut envelopper ce exécutable par une image FROM scratch (LHS hierarchie) => ./xxx.exe 

FROM httpd:2.4

# métadonnée pour décrire l'image et filtrer l'image
# docker image ls --filter "label=stack=stack-java"
# docker ps --filter "label=author=matt"
LABEL author="matt"
LABEL created_at.year="2024"
LABEL created_at.date="2024-02-21"
LABEL stack="stack-java"
LABEL stack.version="1.0"

# variable d'environnement qui peut être utilisée avec le conteneur => docker run
# ENV APP_NAME=java_app.conf

# variable de build => valeur injectable par docker build -t ... --build-arg <value>
ARG APP_NAME=java_app.conf

# modifier l'image avec des commandes lancées au moment du build de l'image
# ajouter curl pour le healthcheck et nettoyer un cache apt
# RUN mkdir /usr/local/apache2/conf/sites && \
#     apt-get update -qq && \
#     apt-get install -y curl && \
#     apt-get clean autoclean && \
#     apt-get autoremove --yes && \
#     rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir /usr/local/apache2/conf/sites

# injection de fichiers / dossiers depuis l'host vers l'image
COPY . /usr/local/apache2/conf/
# copier un utilitaire sur l'image qui nous intéresse
COPY --chown=root:root --from=provider /usr/bin/curl /usr/bin/curl

RUN mv /usr/local/apache2/conf/${APP_NAME} /usr/local/apache2/conf/sites/

# déclaration des ports avec lesquels ont peut faire du publish-all (-P) du docker run
EXPOSE 80
EXPOSE 443


HEALTHCHECK \
  --interval=3s \
  --timeout=30s \
  --start-period=3s \
  CMD curl http://localhost:80

# commande qui va être lancée par défaut au docker run de cette image
# OU substituée par une option command: de docker compose ou le paramètre final du docker run
CMD [ "httpd", "-D", "FOREGROUND" ]
