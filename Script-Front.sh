### Установка Nginx. Он сам установился и стартанул
apt install nginx -y;

### Скачать nginx site-enable default и переместить
wget https://raw.githubusercontent.com/Altione/OTUS-Front/refs/heads/main/nginx-sites-available
cp nginx-sites-available /etc/nginx/sites-available/default;

### рестарт nginx
systemctl restart nginx;
