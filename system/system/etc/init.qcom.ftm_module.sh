#!/system/bin/sh

log "WlanFTM : trying to reload the driver"
rmmod wlan
insmod /system/lib/modules/wlan.ko con_mode=5

log "WlanFTM : waiting to check driver loading"
usleep 0.5

while ! ifconfig -a wlan0
do
    log "WlanFTM : not loaded yet"
    usleep 0.1
done

log "WlanFTM : driver loaded"
