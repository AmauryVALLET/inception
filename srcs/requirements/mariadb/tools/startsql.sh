#!/bin/sh

if [ -d "/var/lib/mysql/${SQL_DATABASE}" ]; then 
    echo "==> DB ${SQL_DATABASE} has already been created"
else
    service mariadb start
    sleep 1

    # Correct SQL to create database and user
    mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';"
    # assure que les nv privileges sont passes immediatement
    mysql -e "FLUSH PRIVILEGES;"

    sleep 1
    mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
fi
sleep 1
# Launch MariaDB as the primary process
exec mysqld
