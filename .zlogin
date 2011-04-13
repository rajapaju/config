#!/bin/zsh


# [почти]нормальный вид java-приложений
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"


# Автозапуск для указанного пользователя
if [ $USER = sio  ]
then
    case "`tty`" in
        "/dev/tty1" )
            # Для первой tty
            export XDG_SESSION_COOKIE='' # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=598150 - consolekit: ck-launch-session doesn't set an active/local session anymore (when run as unprivileged user)
            setsid startx # чтобы не оставлять возможности переключиться в консоль и убить иксы
            exit
        ;;
        
        "/dev/tty2" )
            # Для второй tty
            clear
            echo -ne "Press Ctrl+C to abort dvtm launch." #сообщение-предупреждение
            for i in `seq 1 3` #время на подумать
            do
                sleep 0.5
                echo -n "."
            done
            dvtm #кого мы хотели запустить
            exit
        ;;
        
        * )
            # Для всех остальных tty
            clear
        ;;
    esac
else
    # Для других пользователей, которые пользуются конфигом
    # (у меня - root - пользуется через симлинк)
    clear
fi
