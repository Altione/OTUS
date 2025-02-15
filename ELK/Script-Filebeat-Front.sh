###установка filebeat на Front
dpkg -i *.deb

### скачать  конфигурацию для filebeat Front
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/filebeat-Front.yml

### заменить скачанной 
cp filebeat-Front.yml /etc/filebeat/filebeat.yml

