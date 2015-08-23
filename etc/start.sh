#!/bin/bash

if [ ! -f /var/lib/mysql/ibdata1 ]; then

    mysql_install_db

    /usr/bin/mysqld_safe &
    sleep 10s

    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'changeme' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

    killall mysqld
    sleep 10s

fi

/usr/bin/mysqld_safe &

if [ ! -f /hackpad/dbinitok ]; then
    sleep 10s
    /hackpad/bin/setup-mysql-db.sh
    touch /hackpad/dbinitok
fi

/hackpad/bin/run.sh
