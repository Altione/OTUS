# **🔹 WEB сервер с балансировкой**

## **4 виртуальные машины с Ubuntu 24.10**

| IP            | Назначение | Установленные пакеты      |
| ------------- | ---------- | ------------------------- |
| 172.16.10.109 | Front      | NGINX                     |
| 172.16.10.110 | Back1      | Apache2 + MySQL (Master)  |
| 172.16.10.111 | Back2      | Apache2 + MySQL (Replica) |
| 172.16.10.112 | Monitor    | ELK + Grafana             |

---
Вся настройка производится от ROOT - sudo su

## **🚀 1 - Установка Front-сервера 172.16.10.109**

**Шаги:**

Скачиваем скрипт, даем права и запускаем:
   ```bash
   wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-Front.sh
   chmod +x Script-Front.sh
   ./Script-Front.sh
   ```

Должна появиться дефолтная веб страница ➡️ [http://172.16.10.109](http://172.16.10.109) И установится прометей


**Установка FileBeat на Front 172.16.10.109**
Положить filebeat.deb в текущую папку. 
```bash
scp -r altione@172.16.10.103:/home/altione/ELK/filebeat_8.9.1_amd64-224190-bc3f59.deb /home/altione/
```
Запустить установку
```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/Script-Filebeat-Front.sh
chmod +x Script-Filebeat-Front.sh
./Script-Filebeat-Front.sh
```

## **🖥️ 2 - Установка Master (Back1) 172.16.10.110**

### **Настройка Web-сервера (Apache2)**

Устанавливаем Apache2:
   ```bash
   wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-Back1-Master.sh
   chmod +x Script-Back1-Master.sh
   ./Script-Back1-Master.sh
   ```
Должен появиться **Apache** ➡️ [http://172.16.10.110](http://172.16.10.110)

### **Настройка MySQL Master**

```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-Back1-MasterBD.sh
chmod +x Script-Back1-MasterBD.sh
./Script-Back1-MasterBD.sh
```

### **Установка CMS (WordPress)**

```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-CMS.sh
chmod +x Script-CMS.sh
./Script-CMS.sh
```

📌 **WordPress будет доступен по адресу:**\
➡️ [http://172.16.10.110/wp-admin/install.php](http://172.16.10.110/wp-admin/install.php)\
*(но пока не устанавливаем)*

## **🖥️ 3 - Установка Slave (Back2) 172.16.10.111**

### **Настройка Web-сервера (Apache2)**

Устанавливаем Apache2:
   ```bash
   wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-Back2-Slave.sh
   chmod +x Script-Back2-Slave.sh
   ./Script-Back2-Slave.sh
   ```
Должен появиться **Apache** ➡️ [http://172.16.10.111](http://172.16.10.111)

### **Настройка MySQL Replica**

```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-Back2-SlaveBD.sh
chmod +x Script-Back2-SlaveBD.sh
./Script-Back2-SlaveBD.sh
```

📌 **Проверяем статус реплики:**

```bash
mysql -u root -e "show replica status\G"
```

### **Установка CMS** (аналогично мастеру, но без БД)

```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-CMS.sh
chmod +x Script-CMS.sh
./Script-CMS.sh
```

## **📌 4 - Финальная настройка базы (Back1)**

### **Устанавливаем базу данных**

➡️ [http://172.16.10.110/wp-admin/install.php](http://172.16.10.110/wp-admin/install.php)\
*(логин/пароль admin/password используется в конфиге)*

## **📌 5 - Проверка репликации на Back2 и бэкап БД**

### **Проверяем базы на Slave**

```bash
mysql -u root -e "show databases;"
```

### **Дамп MySQL с реплики** (файлы сохранятся в `/home/altione/DB/`)

```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-BackUP-BD-table.sh
chmod +x Script-BackUP-BD-table.sh
./Script-BackUP-BD-table.sh
```

Копируем БД на резервный сервер
```bash
scp -r /home/altione/DB altione@172.16.10.103:/home/altione/DB
```


## **📊 6 - Установка Server ELK + Grafana 172.16.10.112**

Нужно положить пакеты ELK+Grafana в /home
```bash
scp -r altione@172.16.10.103:/home/altione/ELK/*.deb /home/altione/
```

Устанавливаем Grafana. Положить файл графаны в /home откуда запускается скрипт
```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Grafana/Script-Grafana-Prometheus.sh
chmod +x Script-Grafana-Prometheus.sh
./Script-Grafana-Prometheus.sh
```

Устанавливаем ELK

Запустить установку
```bash
wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/ELK/Script-ELK.sh
chmod +x Script-ELK.sh
./Script-ELK.sh
```

Для надежности можно перезагрузиться

---
---
---

## **🛠️ Восстановление после сбоя**

### **1️⃣ Восстановление Master (Back1)**
Проворачиваем пункт 1,2,3 и 6. Восстанавливаем БД из бэкапа:

📌 **Загружаем сохраненную базу на Master с сервера резервирования**
```bash
scp -r altione@172.16.10.103:/home/altione/DB /home/altione/DB
```
Затем **восстанавливаем базу** (база WP создается скриптами выше, но надо ее залить из бэкапа):
```bash
for file in /home/altione/DB/DB/WP/*; do
    mysql -u root WP < "$file"
done
```

✅ **Проверяем работу сайта.**

После восстановления Grafana, делаем манипуляции в Web и добавляем в 
/etc/prometheus/prometheus.yml фртонт 
- targets: ['localhost:9100', '172.16.10.109:9090']

