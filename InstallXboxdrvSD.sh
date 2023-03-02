#!/bin/bash

# We need to run this as root.
if [ "$EUID" -ne 0 ]
  then echo "ERROR: Not running as root."
  exit
fi

# Disable readonly on root.
sudo steamos-readonly disable

# Remove xpad driver.
modprobe -r xpad
echo "blacklist xpad" | sudo tee -a /etc/modprobe.d/blacklist.conf > /dev/null

# Allow userspace progs to create and handle input devices.
modprobe uinput
modprobe joydev
sudo usermod -a -G input deck

echo "Setup complete, starting xboxdrv..."

# Needed to ensure dbus is setup correctly for debugging.
DBUS_CMD="dbus-launch --exit-with-session"

# Run xboxdrv in daemon mode.
$DBUS_CMD /home/deck/git/xboxdrv/xboxdrv/xboxdrv \
	--daemon \
	--silent \
	--detach \
	--next-controller \
	--next-controller \
	--next-controller \
		--guitar


