#!/bin/sh

# Getting data from transmission-remote
RAW_PEER_DATA=`transmission-remote -t all -pi`

# Calculate total peers number
TOTAL_PEERS_NUMBER=`echo "$RAW_PEER_DATA"|grep -vE "^ *#|^ *$|^ *;"|grep -v Address|wc -l`
echo "Total peers: $TOTAL_PEERS_NUMBER"

#~ # Peers connected via µTP
#~ UTP_PEERS_NUMBER=`echo "$RAW_PEER_DATA"|awk '{ print $2 }'| grep T|wc -l`
#~ echo "  µTP peers: $UTP_PEERS_NUMBER (`echo "$UTP_PEERS_NUMBER/$TOTAL_PEERS_NUMBER*100"|bc -l|cut -d. -f 1`%)"
