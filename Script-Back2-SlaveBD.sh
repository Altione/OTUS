####################Настройка MYSQL
###устанавливаем mysql он сам завелся запустился
apt install mysql-server-8.0 -y;

### Качаем mysqld и меняем на наш конфиг мастера
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Slave-mysqld.cnf;
cp Slave-mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf;

### рестартуем mysql
service mysql restart;

### на всякий случай останавливаем текущую репликацию
mysql -u root -e "STOP REPLICA;"

### Устанавливаем мастер для реплики
mysql -u root -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='172.16.10.110', SOURCE_USER='repl', SOURCE_PASSWORD='oTUSlave#2020', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;"

### Стартуем реплику
mysql -u root -e "START REPLICA;"
