FROM mysql/mysql-server:5.7

COPY my.cnf /etc/my.cnf
COPY entrypoint.sh /entrypoint.sh
COPY bootstrap.sh /docker-entrypoint-initdb.d/bootstrap.sh

EXPOSE 3306/tcp 33060/tcp 6606/tcp

CMD --server_id="${SERVER_ID}" --group_replication_local_address="${LOCAL_ADDRESS}:6606" --group_replication_group_seeds="${MYSQL1_ADDRESS}:6606,${MYSQL2_ADDRESS}:6606,${MYSQL3_ADDRESS}:6606" --group_replication_ip_whitelist="${MYSQL1_ADDRESS},${MYSQL2_ADDRESS},${MYSQL3_ADDRESS}" --character-set-server=utf8 --collation-server=utf8_unicode_ci
