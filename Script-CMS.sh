###устанавливаем php для CMS
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y;

### скачать wordpress, распаковать
wget https://ru.wordpress.org/wordpress-6.7.1-ru_RU.tar.gz;
tar -xzvf wordpress-6.7.1-ru_RU.tar.gz;

### копируем все в папку apache
cp -r wordpress/* /var/www/html/;

### создаем базу для wp
mysql -u root -e "CREATE DATABASE WP;";

### раздаем права создаем пользователя
mysql -u root -e "CREATE USER 'wp'@'%' IDENTIFIED BY 'password';";
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'wp'@'%';";

### качаем wp-config
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/wp-config.php

### копируем его в папку wordpress
cp wp-config.php /var/www/html/;

### удаляем файл apache index (чтобы резолвился нормальный wordpress)
sudo rm /var/www/html/index.html;
