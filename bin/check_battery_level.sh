#! /bin/bash
# Original from https://faq.i3wm.org/question/1730/warning-popup-when-battery-very-low/

SAFE_PERCENT=99  # Still safe at this level.
DANGER_PERCENT=98  # Warn when battery at this level.
CRITICAL_PERCENT=5  # Hibernate when battery at this level.

NAGBAR_PID=0
PID_FILE="/tmp/check_battery_level.pid"
CMD_HIBERNATE="/usr/sbin/pm-hibernate"

export DISPLAY=:0.0

function launchNagBar
{
    i3-nagbar -m "Battery low: ${1}%!" -b 'Hibernate!' "$CMD_HIBERNATE" >/dev/null 2>&1 &
    NAGBAR_PID=$!; echo $NAGBAR_PID > $PID_FILE
}

function fyiHibernate 
{
    i3-nagbar -m "BATTERY IS TOO LOWi (${1}%) - HIBERNATING NOW!" -b 'Hibernate!' "$CMD_HIBERNATE" >/dev/null 2>&1 &
    NAGBAR_PID=$!; echo $NAGBAR_PID > $PID_FILE
    sleep 5 
    killNagBar
    $CMD_HIBERNATE 

}

function killNagBar
{
    kill `cat $PID_FILE` 2>/dev/null
    rm -f $PID_FILE
}


killNagBar

if [[ -n $(acpitool -b | grep -i discharging) ]]; then
    rem_bat=$(acpitool -b | grep -Eo "[0-9]+\.[0-9]+%" | cut -d\. -f 1)

    if [[ $rem_bat -gt $SAFE_PERCENT ]]; then
        SLEEP_TIME=10
    else
        SLEEP_TIME=5
        killNagBar
        if [[ $rem_bat -le $DANGER_PERCENT ]]; then
            SLEEP_TIME=2
            launchNagBar $rem_bat
        fi
        if [[ $rem_bat -le $CRITICAL_PERCENT ]]; then
            fyiHibernate 
        fi
    fi
else
    SLEEP_TIME=10
fi

