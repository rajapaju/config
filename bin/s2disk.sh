#!/bin/sh
# Requires root privileges

#rmmod usb_storage #was used to reconnect to Yota via usb wimax dongle
#rmmod uhci_hcd
#rmmod ehci_hcd
#s2disk
#sleep 2
#modprobe uhci_hcd
#modprobe ehci_hcd
#modprobe usb_storage
##swapoff -a; swapon -a

#new laptop
echo disk > /sys/power/state
sudo hdparm -B 254 /dev/sda; sudo hdparm -B 254 /dev/sdb
