#!/bin/sh
#TO BACKUP:

# Папка хранения бэкапа (должна быть передана как первый параметр)
OUTPUT="$1/`date +%Y-%m-%d`"
mkdir "$OUTPUT"

cd /home/sio
# В это эхо вписывать нужные папки. По симлинкам не ходит. Адреса относительно хомяка
echo '\
bin
documents
misc/backup
misc/D-Link DIR-320
misc/ringtones_my
misc/Зачетка
pictures/handmade
pictures/photos
data/study
data/oldpix
' | while read FNAME; do cp -a -v --parents "$FNAME" "$OUTPUT"/; done

# Делаем листинг всех файлов - знать, что мы не скопировали
tree -N / > "$OUTPUT"/root.tree

# Защищаем от редактирования
chmod -R a-w "$OUTPUT"
