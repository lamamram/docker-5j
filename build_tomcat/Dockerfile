## nous allons utiliser une image centos 9: quay.io/centos/centos:stream9
FROM quay.io/centos/centos:stream9

## documenter l'image
LABEL author="matt"
LABEL created_at.year="2024"
LABEL created_at.date="2024-02-21"
LABEL stack="stack-java"
LABEL stack.version="1.0"

## paramètres de build
ARG TOMCAT_VERSION_MAJOR
ARG TOMCAT_VERSION_FULL

## ajouter un dossier /opt/tomcat
RUN mkdir /opt/tomcat

## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz dans ce dossier
## best practices du ADD: en local pour transférer on préférera curl / wget qui sont plus rapides et chaînables
# ADD https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz /opt/tomcat

## décomprésser dans ce dossier sans dossier intermédiaire 
## installer java 
## nettoyer les paquets yum
## ajouter un utilisateur tomcat avec le dossier /opt/tomcat comme home  
## optimisation des RUN pour ne créer qu'une seule couche => un seul état => + légéer en disque
RUN curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz \
    | tar -xvz -C /opt/tomcat --strip-components=1 && \
    rm -f /opt/tomcat/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz && \
    yum update -q && \
    yum install java -y -q && \
    yum clean all && \
    useradd -m -d /opt/tomcat -U tomcat

## changer le home de l'image vers /opt/tomcat/tomcat/webapps
## WORKDIR subsitue le home d'un utilisateur même avant l'utilisation de la directive USER 
WORKDIR /opt/tomcat/webapps

## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 
ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .
## spécifier le propriétaire et groupe à tomcat
RUN chown -R tomcat:tomcat /opt/tomcat
## changer l'utilisateur à tomcat
USER tomcat
## persister le dossier home pour accéder ou sauvegarder les apps
## INTERET => création d'un dossier dans l'instance docker, utilisation par ex. avec --volumes-from
VOLUME [ "/opt/tomcat/webapps" ]
## pour communiquer avec httpd avec le port 8080
EXPOSE 8080

## exécuter de manière statique (sans substitution) le binaire en foreground catalina.sh vs startup.sh ???
# ENTRYPOINT [ "/opt/tomcat/bin/catalina.sh" ]
## ajouter la sous commande pour lancer en one shot run ou start ???
# CMD [ "run" ]
## CMD seule => la totalité de la commande est substituable
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]

# programme le lancement d'une commande au moment de la création du docker run
# la CMD du HEALTHCHECK commence au bout de <start_period> 
# avec une durée de <timeout>
# si la CMD exit en 0 => le container est en bonne santé
# sinon on en attend <interval>
# et on boucle <retries> fois
# WARNING le CMD ne fonctionne en mode tokens ["key", "word"]
HEALTHCHECK \
  --interval=5s \
  --timeout=30s \
  --start-period=5s \
  --retries=3 \
  CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log