#################### Настройка MYSQL
###устанавливаем mysql он сам завелся запустился
apt install mysql-server-8.0 -y;

### Качаем mysqld и меняем на наш конфиг мастера
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Master-mysqld.cnf;
cp Master-mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf;

### рестартуем mysql
service mysql restart;

### заходим под Рутом
sudo mysql;

### задаем пароль для slave
CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020';

### Даём ему права на репликацию и ввобщше все
GRANT REPLICATION SLAVE ON *.* TO repl@'%';
