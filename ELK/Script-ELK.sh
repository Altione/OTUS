### закинул deb пакеты в home
### для работы нужен jdk
apt install default-jdk -y;

### устанавливаем пакеты пачкой из папки ELK
###cd ELK
dpkg -i *.deb;

### устанавливаем лимиты для оперативки
echo -e "-Xms1g\n-Xmx1g" | sudo cat > /etc/elasticsearch/jvm.options.d/jvm.options;

### скачиваем конфиги
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/elasticsearch.yml;
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/filebeat.yml;
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/kibana.yml;
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/logstash.yml;
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/logstash-nginx-es.conf;


### копируем в нужные папки
cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml;
cp filebeat.yml /etc/filebeat/filebeat.yml;
cp kibana.yml /etc/kibana/kibana.yml;
cp logstash.yml /etc/logstash/logstash.yml;
cp logstash-nginx-es.conf /etc/logstash/conf.d/logstash-nginx-es.conf;

### рестартуем все возможное
systemctl daemon-reload;
systemctl enable --now elasticsearch.service;
systemctl daemon-reload;
systemctl enable --now kibana.service;
systemctl enable --now logstash.service;
systemctl restart logstash.service;
systemctl restart filebeat;
systemctl enable filebeat;
