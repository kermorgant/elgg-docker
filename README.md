* GLPI Docker image

GLPI is a free software (GPL v2) and stands for "Gestion Libre de Parc Informatique".

For more information, see glpi-project.org.

** Image description

This image embeds :

  + glpi's source code
  + apache

For it to work, you'll need a mysql/mariadb server.

** How to use it
*** setup your environment variables
   Create a file named glpi.priv.env with the following variables (adjust them
   according to your own environment).

   INIT_DB=true
   DB_ROOT_PASSWORD=#####
   DB_HOST=mariadb
   DB_USER=glpi
   DB_PASSWORD=######
   DB_NAME=glpi
   DB_PORT=3306

*** with docker run

    Here, you'll have to make sure that the DB_HOST value resolves well on the
    host machine.
    #+BEGIN_SRC sh
    $ docker build .
    $ docker run -d --env-file ./glpi.priv.env -p "8080:80" glpidocker_glpi
    #+END_SRC
*** with docker-compose

**** create the required volume
     $ docker volume create --name=glpidata

**** Start it
     Use the "dev" environment to try in locally :
     $ docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d glpi
