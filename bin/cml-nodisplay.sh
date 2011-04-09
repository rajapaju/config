#!/bin/sh
# Блокирует клавиатуру и мышь, не трогает того, что происходит на экране
# Звук тоже не отключается

##amixer sset Master mute
##(sleep 3; pgrep xlock && xset dpms force off)&
xlock -mode star -erasemode no_fade -timeelapsed -usefirst -lockdelay 3\
 -timeout 4 -font "-*-terminus-medium-r-normal-*-32-*-*-*-*-*-*-*"\
 -planfont "-*-terminus-medium-r-normal-*-32-*-*-*-*-*-*-*"\
 -background black -foreground gray -geometry 0x0 -icongeometry 256x60
##amixer sset Master unmute
