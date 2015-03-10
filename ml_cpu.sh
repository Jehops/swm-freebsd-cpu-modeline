#!/bin/sh

cpu_cmd="/sbin/sysctl -n dev.cpu.0.freq hw.acpi.thermal.tz0.temperature | tr '\n' ' '"
interval=3
stump_pid=`pgrep -a -n stumpwm`

# while stumpwm is still running
while kill -0 $stump_pid > /dev/null 2>&1; do
    cpu_info=`eval ${cpu_cmd}`
    echo ${cpu_info}
    sleep ${interval}
done