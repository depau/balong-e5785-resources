#!/bin/sh

backup() {
	if [ -f "$1.orig" ]; then
		echo "Backup for $1 already exists, skipping."
		return
	fi
	if [ ! -f "$1" ]; then
		echo "File $1 does not exist, skipping backup."
		return
	fi
	echo "Backing up $1 to $1.orig"
	cp "$1" "$1.orig"
}

backup /app/config/wifi/config.xml
backup /app/config/wifi/countryChannel.xml
backup /app/config/oled/animation/ani_power_off.xml
backup /app/config/oled/animation/welcome.xml
backup /app/bin/cli
backup /app/bin/device
backup /app/bin/oled
backup /app/bin/cms
backup /app/bin/sms
backup /system/etc/autorun.sh