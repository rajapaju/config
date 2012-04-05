#!/bin/sh


# USER-WIDE SETTINGS
xrandr --output LVDS1 --set "scaling mode" Full
xbacklight -set 70
fbsetbg -l
numlockx on
setxkbmap -option "compose:menu,grp:caps_toggle"&
(sleep 3; xmodmap ~/.xmodmaprc)&
# END SETTINGS


# TOUCHPAD DONE RIGHT
synclient TapButton1=1 TapButton2=3 TapButton3=2 FastTaps=0 PalmDetect=1 TouchpadOff=1 LockedDrags=1 LockedDragTimeout=660&
# END TOUCHPAD


# ENVIROMENT VARIABLES
export GNOME_DESKTOP_SESSION_ID=1234567890&
export OOO_FORCE_DESKTOP="gnome"
# END VARIABLES


# LAUNCH WINDOW MANAGER AND EXIT THIS SCRIPT
# "EXEC" REQUIRED
startfluxbox || while true; do fluxbox && break || continue;  done
# END WM LAUNCH
