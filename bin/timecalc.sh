#!/bin/sh

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

timecalc $1 $2
