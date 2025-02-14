### для работы нужен jdk
apt install default-jdk -y;

### устанавливаем пакеты пачкой из папки ELK
###cd ELK
dpkg -i *.deb

### устанавливаем лимиты для оперативки
cat > /etc/elasticsearch/jvm.options.d/jvm.options

-Xms1g
-Xmx1g

