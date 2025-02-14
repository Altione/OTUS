# **🔹 WEB сервер с балансировкой**

## **4 виртуальные машины с Ubuntu 24.10**

| IP            | Назначение | Установленные пакеты      |
| ------------- | ---------- | ------------------------- |
| 172.16.10.109 | Front      | NGINX                     |
| 172.16.10.110 | Back1      | Apache2 + MySQL (Master)  |
| 172.16.10.111 | Back2      | Apache2 + MySQL (Replica) |
| 172.16.10.112 | Monitor    | ELK + Grafana             |

---

## **🚀 1 - Установка Front-сервера 172.16.10.109**

**Шаги:**

Заходим под `root`:
   ```bash
   sudo su
   ```
Скачиваем скрипт, даем права и запускаем:
   ```bash
   wget https://raw.githubusercontent.com/Altione/OTUS/refs/heads/main/Script-Front.sh
   chmod +x Script-Front.sh
   ./Script-Front.sh
   ```

Должен появиться **NGINX** ➡️ [http://172.16.10.109](http://172.16.10.109)

---

## **🖥️ 2 - Установка Master (Back1) 172.16.10.110**

### **Настройка Web-сервера (Apache2)**

Заходим под `root`:
   ```bash
   sudo su
   ```
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

---

## **🖥️ 3 - Установка Slave (Back2) 172.16.10.111**

### **Настройка Web-сервера (Apache2)**

Заходим под `root`:
   ```bash
   sudo su
   ```
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

---

## **📌 4 - Финальная настройка базы (Back1)**

### **Устанавливаем базу данных**

➡️ [http://172.16.10.110/wp-admin/install.php](http://172.16.10.110/wp-admin/install.php)\
*(логин/пароль admin/password используется в конфиге)*

---

## **📌 5 - Проверка репликации на Back2**

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

---

## **📊 6 - Установка ELK + Grafana 172.16.10.112**

*(Подробности в отдельной инструкции.)*

---

## **🛠️ Восстановление после сбоя**

### **1️⃣ Восстановление Master (Back1)**

📌 **Откатываем по снапшоту**, затем **восстанавливаем базу**:

```bash
for file in /home/altione/DB/WP/*; do
    mysql -u root WP < "$file"
done
```

✅ **Проверяем работу сайта.**

### **2️⃣ Восстановление Slave (Back2)**

📌 **Повторяем шаги установки Back2 (3-й пункт).**

---

📌 **Готово!** Теперь вся система должна работать корректно. 🚀



