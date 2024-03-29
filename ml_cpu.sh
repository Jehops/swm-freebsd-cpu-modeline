#!/bin/sh

## You will need to customize the sysctl command(s) below to use the variables
## that show CPU frequency and temperature.  Also, I have conditioned the sysctl
## commands on *my* two hosts, so you will need to remove the if-statement if
## you only have one host or change the hostname values to your hosts.  If you
## have multiple CPUs and you want to show something like a one minute load
## average and CPU temperatures separated by commas, you could use something
## like
##
# echo $(uptime | awk -F "load averages: " '{ print $2 }' | cut -d, -f1; \
# 	   /sbin/sysctl -n \
# 			dev.cpu.0.temperature \
# 			dev.cpu.1.temperature dev.cpu.2.temperature \
# 			dev.cpu.3.temperature \
# 	       | tr '\n' ',' | sed 's/,$//')
##
## The lisp code that calls this script, swm-freebsd-cpu-modeline.lisp, expects
## an integer number for %f (frequency) and a string for %t (temperature).  If
## the temperature has decimal points followed by digits and C, these parts will
## be stripped. For example, if the temperature formatter reads in 55.5C it
## will return 55, if it reads in 38.9C,41.2C, it will return 38,41.  If you
## customize the sysctl call below, just ensure it echos an integer and a string
## separated by space.  If you want to make further customizations, just ensure
## that this script and swm-freebsd-cpu-modeline.lisp are coordinated.
##

# Set the variable stump_pid using one of these two lines.  Which line you use
# depends on whether you run the large StumpWM executable that bundles SBCL, or
# if you simply start SBCL and load StumpWM.  If you are using the FreeBSD
# StumpWM package, use the second line.

stump_pid=$(pgrep -a -n stumpwm)
#stump_pid="$(pgrep -anf -U "$(id -u)" "sbcl .*(stumpwm:stumpwm)")"

hostname=$(hostname -s)

# customize the interval to your liking
interval=3

# while stumpwm is still running
while kill -0 "$stump_pid" > /dev/null 2>&1; do
    # you need to customize the hostnames (if you have multiple hosts, otherwise
    # remove the if-statement) and the sysctl command(s) below
    if [ "$hostname" = "phe" ] || [ "$hostname" = "bravo" ]; then
	/sbin/sysctl -n dev.cpu.0.freq hw.acpi.thermal.tz0.temperature | \
	    tr '\n' ' ' | sed 's/.[0-9]C//g'
        printf "\n"
    elif [ "${hostname}" = "gly" ]; then
	printf "%2.2f " $(uptime | awk -F "load averages: " '{ print $2 }' \
                              | cut -d, -f1 | tr '\n' ' ')
	/sbin/sysctl -n dev.cpu.0.temperature dev.cpu.1.temperature \
                     dev.cpu.2.temperature dev.cpu.3.temperature \
	    | sed 's/.[0-9]C//' | paste -s -d ',' -
    fi
    sleep "$interval"
done
