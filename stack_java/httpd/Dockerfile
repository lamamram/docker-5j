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
