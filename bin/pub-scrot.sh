#!/bin/sh

#Задаем имя скриншоту (зависит от даты)
FILENAME=~/data/Dropbox/Public/imgbin/`date +%Y-%m-%d-%H%M%S`.png

#Делаем скриншот, не забываем про уведомление
scrot $FILENAME && STATUS="ok" || STATUS="failed"

#Узнаем адрес картинки
FILEURL=`dropbox puburl $FILENAME`

#Копируем адрес в оба буфера обмена
echo $FILEURL | xclip -selection clipboard
echo $FILEURL | xclip -selection primary

#Уведомление
notify-send -i info -u low "Taking screenshot: $STATUS" "$FILENAME"
