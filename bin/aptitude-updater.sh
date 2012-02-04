#!/bin/bash
#set -e -u

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
SEPARATOR="^Package"

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
    
    #echo Debug: CHUNK[$i] is from line $FIRST_LINE to line $LAST_LINE
done

#show user chunks one by one and ask for his decision
ACTION="$1" #todo: exceptions
DEFAULT_ANSWER=n
#QUESTION="Would you like to $ACTION ${PACKAGE[$i]}? [$DEFAULT_ANSWER]"


for i in `seq 1 $MAX_ITERATOR`
do
    echo "${CHUNK[$i]}"
    while [ -z ${ANSWER[$i]} ]
    do
        QUESTION="Would you like to $ACTION ${PACKAGE[$i]}? [$DEFAULT_ANSWER]"
        echo -n $QUESTION
        read USER_INPUT
        [ -z $USER_INPUT ] && ANSWER[$i]=$DEFAULT_ANSWER && break
        case $USER_INPUT in
            y|Y|н|Н)
                ANSWER[$i]=y
            ;;                
            n|N|т|Т)
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
