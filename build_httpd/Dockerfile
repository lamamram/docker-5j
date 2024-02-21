FROM httpd:2.4

# métadonnée pour décrire l'image et filtrer l'image
LABEL author="matt"
LABEL created_at.year="2024"
LABEL created_at.date="2024-02-21"
LABEL stack="stack-java"
LABEL stack.version="1.0"

# modifier l'image avec des commandes lancées au moment du build de l'image
RUN mkdir /usr/local/apache2/conf/sites

# injection de fichiers / dossiers depuis l'host vers l'image
COPY . /usr/local/apache2/conf/

RUN mv /usr/local/apache2/conf/java_app.conf /usr/local/apache2/conf/sites/

# déclaration des ports avec lesquels ont peut faire du publish-all (-P) du docker run
EXPOSE 80
EXPOSE 443

# commande qui va être lancée par défaut au docker run de cette image
# OU substituée par une option command: de docker compose ou le paramètre final du docker run
CMD [ "httpd", "-D", "FOREGROUND" ]
