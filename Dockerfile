FROM mysql/mysql-server:5.7

COPY my.cnf /etc/my.cnf
COPY entrypoint.sh /entrypoint.sh
COPY bootstrap.sh /docker-entrypoint-initdb.d/bootstrap.sh

EXPOSE 3306/tcp 6606/tcp

