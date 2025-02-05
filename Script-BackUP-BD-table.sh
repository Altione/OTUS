#!/bin/bash

USER="root"
PASSWORD="Testpass1$"
OUTPUT_DIR="/home/altione/DB/DB"

# Получаем БД
databases=$(mysql -u"$USER" -p"$PASSWORD" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

# Цикл по каждой БД
for db in $databases; do
    echo "Выгружаем базу данных: $db"

    # Создаем папку для текущей БД
    mkdir -p "$OUTPUT_DIR/$db"

    # Получаем список всех таблиц в БД
    tables=$(mysql -u"$USER" -p"$PASSWORD" -e "SHOW TABLES IN $db;" | tr -d "| " | grep -v Tables_in)

    # Цикл по каждой таблице
    for table in $tables; do
        echo "Выгружаем таблицу: $table из базы $db"

        # Делаем выгрузку таблицы в файл внутри папки базы данных
        mysqldump -u"$USER" -p"$PASSWORD" "$db" "$table" > "$OUTPUT_DIR/$db/$table"
    done
done

echo "Бэкап сделан!"
