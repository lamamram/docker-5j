# multistaging build
# j'utilise le contenu d'une aimage auxilliaire
# par exemple: compilation dans une image de travail qui pond un binaire executable
FROM shakefu/curl-static AS curl

# from the kernel
# 1. pour les images de distribution
# 2. pour installer un simple binaire exécutable exécuté par le noya (./app)
# FROM scratch

FROM httpd:2.4

LABEL author="matt"
LABEL created_at="2024-04-24"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="httpd"

# variables d'environnement: utilisables au moment du docker run --env ...
ENV HOME /usr/local/apache2
ENV TRUC toto

# utilisation de l'image "curl" je transfers un contenu de l'image auxiliaire vers l'image principale
# plus propre que apt-get update && install && autoremoce && autoclean && rm -rf ....
COPY --from=curl /usr/local/bin/curl /usr/local/bin/curl

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir -p /usr/local/apache2/conf/sites

COPY ./java_app.conf /usr/local/apache2/conf/sites

EXPOSE 80
EXPOSE 443

# commande par défaut du docker run sur cette image
# ne peut pas être substituée par la commande du docker run
# ENTRYPOINT ["httpd"]
# commande par défaut du docker run sur cette image
# peut être substituée totalement par la commande du docker run 
CMD ["httpd", "-D",  "FOREGROUND"]


HEALTHCHECK \
           --start-period=5s \
           --timeout=5s \
           --interval=3s \
           CMD curl http://127.0.0.1