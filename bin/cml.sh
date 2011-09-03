#!/bin/sh
# Блокировка экрана с показом заставки
# Отключаются до ввода пароля: клавиатура, мышь, звук

LOCKDELAY=3
TIMESTART=`date +%s` #засекаем начало блокировки

timecalc () {
    #Принимает два значения в секундах, рассчитывает разницу между первым и вторым,
    #выводит в человекочитаемом виде прошедшее время
    
    TIMESTART=$1
    TIMESTOP=$2
    
    TIMEPASSED=$(( $2 - $1 ))
    SECONDSPASSED=$(( $TIMEPASSED % 60 )) #символ % - остаток от целочисленного деления
    MINUTESPASSED=$(( $TIMEPASSED % 3600 / 60 ))
    HOURSPASSED=$(( $TIMEPASSED % 86400 / 3600 ))
    DAYSPASSED=$(( $TIMEPASSED / 86400 ))
    
    [ 0 -eq $SECONDSPASSED ] || TIMESTRING="$SECONDSPASSED seconds"
    [ 0 -eq $MINUTESPASSED ] || TIMESTRING="$MINUTESPASSED minutes $TIMESTRING"
    [ 0 -eq $HOURSPASSED ] || TIMESTRING="$HOURSPASSED hours $TIMESTRING"
    [ 0 -eq $DAYSPASSED ] || TIMESTRING="$DAYSPASSED days $TIMESTRING"
    echo "$TIMESTRING"
}

# СОБСТВЕННО БЛОКИРОВКА

    #отключение звука
    amixer sset Master mute
    
    #отключение экрана через LOCKDELAY
    (sleep $LOCKDELAY; pgrep xlock && xset dpms force off)&
    
    #заставка
    xlock -mode atunnels -erasemode no_fade -timeelapsed -usefirst -lockdelay $LOCKDELAY\
     -timeout 4 -font "-*-terminus-medium-r-normal-*-32-*-*-*-*-*-*-*"\
     -planfont "-*-terminus-medium-r-normal-*-32-*-*-*-*-*-*-*"\
     -background gray -icongeometry 256x256 
    
    #включение звука
    amixer sset Master unmute 
    
TIMESTOP=`date +%s` #засекаем окончание блокировки

#уведомление о продолжительности блокировки
notify-send -i info -u low "`hostname` unlocked" "`hostname` was locked for `timecalc $TIMESTART $TIMESTOP`"
    
    
