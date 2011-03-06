#!/bin/zsh


# [почти]нормальный вид java-приложений
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"


# Автозапуск для указанного пользователя
if [ $USER = sio  ]
then
    case "`tty`" in
        "/dev/tty1" )
            # Для первой tty
            setsid startx
            exit
        ;;
        
        "/dev/tty2" )
            # Для второй tty
            clear
            echo -ne "Press Ctrl+C to abort dvtm launch"
            for i in `seq 0 3`
            do
                sleep 0.5
                echo -n "."
                i=$(($i + 1))
            done
            dvtm -m \<; exit
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
