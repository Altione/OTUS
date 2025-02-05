#################### Настройка MYSQL
###устанавливаем mysql он сам завелся запустился
apt install mysql-server-8.0 -y;

### Качаем mysqld и меняем на наш конфиг мастера
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Slave-mysqld.cnf;
cp Slave-mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf;

### рестартуем mysql
service mysql restart;

### заходим под Рутом
sudo mysql;

### на всякий случай останавливаем текущую репликацию
STOP REPLICA;

### Устанавливаем мастер для реплики
CHANGE REPLICATION SOURCE TO SOURCE_HOST='172.16.10.110', SOURCE_USER='repl', SOURCE_PASSWORD='oTUSlave#2020', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;

### Стартуем реплику
START REPLICA;
