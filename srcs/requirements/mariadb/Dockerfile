FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install mariadb-server -y

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/startsql.sh /usr/local/bin/startsql.sh
RUN chmod 777 /usr/local/bin/startsql.sh

EXPOSE 3306

CMD [ "/usr/local/bin/startsql.sh" ]