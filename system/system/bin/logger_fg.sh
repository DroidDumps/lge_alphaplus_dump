#!/system/bin/sh

source check_data_mount.sh
log_to_data_partition=`is_ext4_f2fs_data_partition`

ro_build_ab_update=`getprop ro.build.ab_update`
if [ "$ro_build_ab_update" = "true" ]; then
tmp_log_path="mnt/product/els"
else
tmp_log_path="cache"
fi

let count=0

local utime
local ktime
local pause_time=10

fg_log_prop=`getprop persist.vendor.lge.service.fg.enable`

if [ -n "$1" ]; then
	pause_time=$1
fi

dump_peripheral () {
	local base=$1
	local size=$2
	local dump_path=$3
	echo $base > $dump_path/address
	echo $size > $dump_path/count
	cat $dump_path/data
}

fg_dumper() {
	echo DATE: $(date)
	echo "Starting dumps!"
	echo "Dump path = $dump_path, pause time = $pause_time"

    while true
    do
		utime=($(cat /proc/uptime))
		ktime=${utime[0]}
		echo "FG SRAM Dump Started at ${ktime}"
		dump_peripheral 0 960 "/sys/kernel/debug/fg/sram"
		uptime=($(cat /proc/uptime))
		ktime=${utime[0]}
		echo "FG SRAM Dump done at ${ktime}"
		let count=$count+1
		sleep $pause_time
    done
}

if [ "$fg_log_prop" == "1" ] || [ "$fg_log_prop" == "2" ] || [ "$fg_log_prop" == "3" ] || [ "$fg_log_prop" == "4" ] || [ "$fg_log_prop" == "5" ]; then
if [ -n "$2" ]
then
	if [[ $log_to_data_partition == 1 ]]; then
		move_log "/data/logger/fg.log" "/${tmp_log_path}/encryption_log/fg.log"

		touch $2
		chmod -h 644 $2
		fg_dumper >> "$2"
	else
		touch /${tmp_log_path}/encryption_log/fg.log
		chmod -h 644 /${tmp_log_path}/encryption_log/fg.log
		fg_dumper >> /${tmp_log_path}/encryption_log/fg.log
	fi
else
	fg_dumper
fi
fi
