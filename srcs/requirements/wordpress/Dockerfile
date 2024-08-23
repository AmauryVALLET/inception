FROM debian:bullseye

RUN     mkdir -p /var/www/html \
        && mkdir -p /run/php

RUN     apt update -y && apt upgrade -y
RUN     apt-get -y install wget

RUN     apt-get install -y php7.4\
        php-fpm\
        php-mysql\
        php-common\
        php-cgi\
        php-cli\
        mariadb-client

RUN     wget https://fr.wordpress.org/wordpress-6.2.2-fr_FR.tar.gz -P /var/www
RUN     cd /var/www && tar -xzf wordpress-6.2.2-fr_FR.tar.gz && rm wordpress-6.2.2-fr_FR.tar.gz

RUN 	cp -r /var/www/wordpress/. /var/www/html
# install of wp-cli and make it executable (cmd line inter pour sh)
RUN	cd /var/www/html && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar

COPY	conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY 	tools/wp_conf.sh /usr/local/bin/wp_conf.sh
RUN     chmod +x /usr/local/bin/wp_conf.sh

# Ajout pour vérifier la présence du script et son exécution
RUN     ls -l /usr/local/bin/wp_conf.sh
RUN     cat /usr/local/bin/wp_conf.sh

EXPOSE	9000

ENTRYPOINT [ "sh", "/usr/local/bin/wp_conf.sh" ]
