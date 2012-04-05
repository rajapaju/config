#!/bin/sh
/usr/sbin/smartctl -a /dev/sda > /home/sio/misc/backup/smart/wd500/smartctl-`date +%Y%m%d`
/usr/sbin/smartctl -a /dev/sdb > /home/sio/misc/backup/smart/wd1000/smartctl-`date +%Y%m%d`
