#!/bin/bash

XBOXDRV_BIN="/home/deck/git/xboxdrv/xboxdrv"

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

echo "INFO: Disabled Xpad."

# Allow userspace progs to create and handle input devices.
modprobe uinput
modprobe joydev
sudo usermod -a -G input deck

echo "INFO: Setup complete, starting xboxdrv..."

# Needed to ensure dbus is setup correctly for debugging. Not needed for
# standard runs.
#DBUS_CMD="dbus-launch --exit-with-session"

# Run xboxdrv in daemon mode.
${XBOXDRV_BIN}/xboxdrv \
	--dbus disabled \
	--daemon \
	--silent \
	--detach \
	--next-controller \
	--next-controller \
	--next-controller \
		--guitar

echo "INFO: Successfully started xboxdrv daemon."
