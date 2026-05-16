#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    # Option list
    echo -en "󰌾 Lock\n"
    echo -en "󰍃 Logout\n"
    echo -en "󰜉 Reboot\n"
    echo -en "󰐥 Shutdown\n"
else
    # Perform the selected option
    case "$1" in
    *Lock)
        hyprlock >/dev/null 2>&1 &
        ;;
    *Logout)
        niri msg action quit --skip-confirmation
        ;;
    *Reboot)
        reboot >/dev/null 2>&1
        ;;
    *Shutdown)
        systemctl poweroff >/dev/null 2>&1
        ;;
    esac
fi
