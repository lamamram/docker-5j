FROM httpd:2.4

# métadonnée pour décrire l'image et filtrer l'image
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
RUN mkdir /usr/local/apache2/conf/sites

# injection de fichiers / dossiers depuis l'host vers l'image
COPY . /usr/local/apache2/conf/

RUN mv /usr/local/apache2/conf/${APP_NAME} /usr/local/apache2/conf/sites/

# déclaration des ports avec lesquels ont peut faire du publish-all (-P) du docker run
EXPOSE 80
EXPOSE 443

# programme le lancement d'une commande au moment de la création du docker run
# la CMD du HEALTHCHECK commence au bout de <start_period> 
# avec une durée de <timeout>
# si la CMD exit en 0 => le container est en bonne santé
# sinon on en attend <interval>
# et on boucle <retries> fois
# HEALTHCHECK \
#   --interval=5s \
#   --timeout=30s \
#   --start-period=5s \
#   --retries=3 \
#   CMD [ "executable" ]

# commande qui va être lancée par défaut au docker run de cette image
# OU substituée par une option command: de docker compose ou le paramètre final du docker run
CMD [ "httpd", "-D", "FOREGROUND" ]
