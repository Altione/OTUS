### Установка Nginx. Он сам установился и рестартанул
apt install nginx -y;

### Скачать nginx site-enable default и переместить
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/nginx-sites-available;
cp nginx-sites-available /etc/nginx/sites-available/default;

### рестарт nginx
systemctl restart nginx;
apt install prometheus -y;
