#!/bin/sh
# Requires root privileges

#rmmod usb_storage
#rmmod uhci_hcd
#rmmod ehci_hcd
#s2ram --force --acpi_sleep 1
#sleep 2
#modprobe uhci_hcd
#modprobe ehci_hcd
#modprobe usb_storage

#new laptop
echo mem > /sys/power/state
hdparm -B 254 /dev/sda; hdparm -B 254 /dev/sdb
