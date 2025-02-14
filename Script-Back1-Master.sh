### Установка Apache2. Он сам установился и рестартанул
apt install apache2 -y;

### Добавить к дефолтной странице 1111
sed -i 's/Apache2 Default Page/&111/' /var/www/html/index.html;
