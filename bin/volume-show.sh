#!/bin/bash

DESKTOP=:0 # need for notifications run 'over' display
mixer_state=`amixer get Master | awk '$2=="Left:" {print $7}'`
x=`amixer get Master | sed -rn "/[^[]+\[/{s///;s/%.+//p;q}"`
z=$[x/10];  y='◼◼◼◼◼◼◼◼◼◼'
zz=$[10-z];yy='◻◻◻◻◻◻◻◻◻◻'

notify_title="Volume"

case $x in
    0*|?|1?)  notify_icon="notification-audio-volume-off";;
    2?|3?|4?)  notify_icon="notification-audio-volume-low";;
    5?|6?|7?)  notify_icon="notification-audio-volume-medium";;
    8?|9?|100)  notify_icon="notification-audio-volume-high";;
esac

if [ $mixer_state = '[off]' ]
then
    notify_icon="notification-audio-volume-muted"
    notify_title="$notify_title muted"
fi

#notify-send -i $notify_icon -t 1500 -u low -h int:x:1015 -h int:y:200 \
#"$notify_title" "${y::z}${yy::zz} $x%"

notify-send -i $notify_icon -t 1500 -u low -h int:x:1015 -h int:y:700 \
"$notify_title" "${y::z}${yy::zz} $x%"


