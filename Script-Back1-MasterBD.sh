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

### НАВЕРНОЕ НЕ НАДО задаем пароль для root, вот так заходить: mysql -p"Testpass1$"
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY 'Testpass1$';

### задаем пароль для slave
mysql -u root -e "CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020';"

### Даём ему права на репликацию и ввобщше все
mysql -u root -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%';"
