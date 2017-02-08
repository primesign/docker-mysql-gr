#!/bin/bash
set -e

if [ -z "$MYSQL_REPLICATION_USER" -o -z "$MYSQL_REPLICATION_PASSWORD" ]; then
        echo >&2 "Error: No replication user specified"
        exit 1
fi

BOOTSTRAP_ENABLED=$(echo "SELECT @@server_id;" | "${mysql[@]}" 2>/dev/null | awk 'NR==2')
if [ "$BOOTSTRAP_ENABLED" == "1" ]; then
        echo "BOOTSTRAP ENABLED"
        echo "
        CREATE USER '$MYSQL_REPLICATION_USER'@'%' IDENTIFIED BY '$MYSQL_REPLICATION_PASSWORD';
        GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPLICATION_USER'@'%';
        FLUSH PRIVILEGES;
        " | "${mysql[@]}"
        set -- "$@" --group_replication_bootstrap_group=ON --group_replication_group_seeds=''
else
        echo "BOOTSTRAP DISABLED"
        echo "RESET MASTER;" | "${mysql[@]}"
fi
echo "CHANGE MASTER TO MASTER_USER='$MYSQL_REPLICATION_USER', MASTER_PASSWORD='$MYSQL_REPLICATION_PASSWORD' FOR CHANNEL 'group_replication_recovery';" | "${mysql[@]}"

