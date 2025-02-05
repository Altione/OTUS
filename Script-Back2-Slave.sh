### Установка Apache2. Он сам установился и стартанул
apt install apache2 -y;

### Добавить к дефолтной странице 222
sed -i 's/Apache2 Default Page/&222/' /var/www/html/index.html;
