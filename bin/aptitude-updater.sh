#!/bin/bash

# aptitude-updater.sh
# A handy script to simplify dealing with multi-repo installation
#
#    Copyright 2012 SIO (sio.wtf@gmail.com)
#    
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 3 of the License, or
#    (at your option) any later version.
#    
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#    MA 02110-1301, USA or visit <http://www.gnu.org/licenses/>.
#
# Now playing: Destroy The Runner/Saints

#set -e -u

usage() {
    echo -e "Usage: aptitude versions '\$pattern'|$0 {install|hold|remove|...}\nRefer to \`$0 --help' for more information"
    exit
}
help_msg() {
    echo -e "Usage: aptitude versions '\$pattern'|$0 {install|hold|remove|...}\n\nPossible parameters include: install, hold, remove, purge, markauto, reinstall, unhold, unmarkauto. Those parameters are passed to aptitude, so please refer to its documentation for further questions.\n\nExample: aptitude versions \"?upgradable\"|$0 install"
    exit
}

# validate command-line parameters
case "$*" in
    install|hold|remove|purge|markauto|reinstall|unhold|unmarkauto|full-upgrade|safe-upgrade)
    ;;
    -h|--help)
        help_msg
    ;;
    *)
        usage
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
# ugly code below
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
[[ -z $PIPE_INPUT || -z ${PACKAGE[1]} ]] && echo "Bad input was given. Exiting..." && usage

#show user chunks one by one and ask for his decisions
ACTION="$1" 
DEFAULT_ANSWER=y #param

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

# show positive answers and launch aptitude
PACKAGES_TOGO=""
for i in `seq 1 $MAX_ITERATOR`
do
    [ "${ANSWER[$i]}" = "y" ] && PACKAGES_TOGO="$PACKAGES_TOGO ${PACKAGE[$i]}"
done
if [ -z "$PACKAGES_TOGO" ]
then
    echo -e "\nNo action will be performed"
else
    echo -e "\nWill now perform \"aptitude $ACTION$PACKAGES_TOGO\""
    echo -n "Press Enter to proceed or ^C to abort..."
    read || exit
    sudo aptitude $ACTION $PACKAGES_TOGO
fi
