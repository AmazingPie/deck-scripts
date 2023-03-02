#!/bin/bash

# We need to run this as root.
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Not running as root."
  exit
fi

# Disable readonly on root.
sudo steamos-readonly disable

# Remove Xpad from blacklist.
sudo rm /etc/modprobe.d/blacklist.conf

# Kill any remaining xboxdrv processes.
sudo pkill xboxdrv

# Re-enable the xpad driver.
modprobe xpad

echo "Xpad successfully enabled."
