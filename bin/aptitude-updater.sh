#!/bin/bash

# aptitude-updater.sh
#
#        Copyright 2012 SIO (sio.wtf@gmail.com)
#        
#        This program is free software; you can redistribute it and/or modify
#        it under the terms of the GNU General Public License as published by
#        the Free Software Foundation; either version 3 of the License, or
#        (at your option) any later version.
#        
#        This program is distributed in the hope that it will be useful,
#        but WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#        GNU General Public License for more details.
#        
#        You should have received a copy of the GNU General Public License
#        along with this program; if not, write to the Free Software
#        Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#        MA 02110-1301, USA or visit <http://www.gnu.org/licenses/>.
#
# Now playing: Destroy The Runner/Saints

#set -e -u

# validate command-line parameters
case "$*" in
    install|hold|remove|purge|markauto|reinstall|unhold|unmarkauto)
    ;;
    *)
        echo "Usage: aptitude versions '\$pattern'|$0 {install|hold|remove|purge|markauto|reinstall|unhold|unmarkauto}"
        exit
    ;;
esac

# read the input data from pipe
PIPE_INPUT=""
while read LINE
do
    PIPE_INPUT="$PIPE_INPUT"$'\n'"$LINE"
done

# switch input to tty for accepting user answers
exec </dev/tty

# parse input

# separate input into CHUNKs with predefined SEPARATOR line
# ugly code
SEPARATOR="^Package" #param

LINE_NUMBERS=`echo "$PIPE_INPUT"|grep -En $SEPARATOR|cut -d: -f1`
MAX_ITERATOR=`echo "$LINE_NUMBERS"|wc -l`
for i in `seq 1 $MAX_ITERATOR`
do
    FIRST_LINE=$((`echo "$LINE_NUMBERS"|head -n 1`-1))
    LINE_NUMBERS=`echo "$LINE_NUMBERS"|tail -n $(($MAX_ITERATOR-$i))`
    LAST_LINE=$((`echo "$LINE_NUMBERS"|head -n 1`-2))
    [ $i -eq $MAX_ITERATOR ] && LAST_LINE=`echo "$PIPE_INPUT"|wc -l`
    CHUNK[$i]=`echo "$PIPE_INPUT"|head -n $LAST_LINE|tail -n $(($LAST_LINE-$FIRST_LINE))`
    PACKAGE[$i]=`echo "${CHUNK[$i]}"|head -n 1|cut -d\  -f2|cut -d: -f1`
done

#show user chunks one by one and ask for his decision
ACTION="$1" #todo: exceptions
DEFAULT_ANSWER=n #param

for i in `seq 1 $MAX_ITERATOR`
do
    echo -e "\n${CHUNK[$i]}"
    while [ -z ${ANSWER[$i]} ]
    do
        QUESTION="Would you like to $ACTION ${PACKAGE[$i]}? (y/n) [$DEFAULT_ANSWER]:"
        echo -n $QUESTION
        read USER_INPUT
        [ -z $USER_INPUT ] && ANSWER[$i]=$DEFAULT_ANSWER && break
        case $USER_INPUT in
            y|Y|н|Н|yes|Yes|YES)
                ANSWER[$i]=y
            ;;                
            n|N|т|Т|no|No|NO)
                ANSWER[$i]=n
            ;;
        esac
    done    
done

# show positive answers
for i in `seq 1 $MAX_ITERATOR`
do
    [ "${ANSWER[$i]}" = "y" ] && echo ${PACKAGE[$i]}
done
