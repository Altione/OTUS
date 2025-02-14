### установка прометея порты 9100 9090
apt install prometheus -y;

#установка графаны OSS
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_11.5.1_amd64.deb
sudo dpkg -i grafana_11.5.1_amd64.deb

#рестартуем демона, стартуем сервер (admin/admin)
sleep 3;
systemctl daemon-reload;
sleep 3;
systemctl start grafana-server;
