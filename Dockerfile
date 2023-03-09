FROM php:7.4-apache-bullseye
MAINTAINER Antonio Marchán Posada "wildworld14@gmail.com"
RUN apt update && apt upgrade -y && docker-php-ext-install mysqli pdo pdo_mysql && apt install mariadb-client -y && apt clean && rm -rf /var/lib/apt/lists/*
ADD src /var/www/html/
ADD script.sh /opt/
RUN chmod +x /opt/script.sh
ENV DB_HOST=mariadb_app
ENV DB_NAME=app
ENV DB_USER=app
ENV DB_PASSWORD=app
ENTRYPOINT ["/opt/script.sh"]
EXPOSE 80
