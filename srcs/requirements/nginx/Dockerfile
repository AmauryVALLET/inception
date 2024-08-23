FROM debian:bullseye

RUN apt update && \
    apt install nginx -y && \
    apt install openssl -y

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR//ST=IDF/L=Paris/O=42/OU=42/CN=avallet.42.fr/UID=avallet"

RUN mkdir -p /var/run/nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html
RUN chmod 755 /var/www/html

# change proprio et groupe du dir pour donner a  www-data (user de nginx)
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

# pour l avoir en avant plan
CMD [ "nginx", "-g", "daemon off;" ]