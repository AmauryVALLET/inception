#!/bin/bash

sleep 10
cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "wp-config.php n'existe pas, début de l'installation de WordPress"

    sleep 10
    ./wp-cli.phar core download --allow-root
    echo "Téléchargement de WordPress terminé"

    ./wp-cli.phar config create --allow-root \
                --dbname=$SQL_DATABASE \
                --dbuser=$SQL_USER \
                --dbpass=$SQL_PASSWORD \
                --dbhost=mariadb:3306
    echo "Création du fichier de configuration wp-config.php terminée"

    ./wp-cli.phar core install --allow-root \
                --url=localhost \
                --title="$SITE_TITLE" \
                --admin_user=$ADMIN_USER \
                --admin_password=$ADMIN_PASSWORD \
                --admin_email=$ADMIN_EMAIL
    echo "Installation de WordPress terminée avec l'utilisateur admin"

    ./wp-cli.phar user create $USER1_LOGIN $USER1_MAIL --allow-root \
                --role=author \
                --user_pass=$USER1_PASS
    echo "Création de l'utilisateur auteur terminée"

    # Vérification du nombre d'utilisateurs
    NUM_USERS=$(mysql -u $SQL_USER -p$SQL_PASSWORD -hmariadb -e "USE $SQL_DATABASE; SELECT COUNT(*) FROM wp_users;" -s -N)
    echo "Nombre d'utilisateurs dans la base de données : $NUM_USERS"
    if [ "$NUM_USERS" -ne 2 ]; then
        echo "ERROR: Le nombre d'utilisateurs dans la base de données est incorrect. Il devrait y avoir deux utilisateurs."
        exit 1
    fi

    # Vérification du nom d'utilisateur de l'administrateur
    ADMIN_USERS=$(mysql -u $SQL_USER -p$SQL_PASSWORD -hmariadb -e "USE $SQL_DATABASE; SELECT user_login FROM wp_users WHERE user_login LIKE '%admin%' OR user_login LIKE '%administrator%' AND ID IN (SELECT user_id FROM wp_usermeta WHERE meta_key = 'wp_capabilities' AND meta_value LIKE '%administrator%');" -s -N)
    if [ -n "$ADMIN_USERS" ]; then
        echo "ERROR: Administrateur avec un nom d'utilisateur interdit trouvé : $ADMIN_USERS"
        exit 1
    fi

    chown -R www-data:www-data /var/www/html/wp-content
    chown -R www-data:www-data /var/www/html

    echo "WordPress est maintenant configuré"
else
    echo "wp-config.php existe déjà, WordPress est déjà configuré"
    usermod -u 33 www-data && groupmod -g 33 www-data
    chown -R www-data:www-data /var/www/html/
fi

exec /usr/sbin/php-fpm7.4 -F
