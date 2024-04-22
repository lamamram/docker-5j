# images docker

* nomenclature des images
* `docker pull IMAGE_NAME:([TAG_NAME]|[@sha26:HASH])`

# docker run: REMARQUES

* le processus lancé es t indenpendant du PID du process du terminal (shell) qui a mancé le docker run => çà l'effet du namespace PID
* la redirection de sortie du docke run bloque le shell si le processus est un démon
