#!/bin/sh
battery=$(pmset -g batt | grep -Eo '\d+%' | head -1)
load=$(uptime | awk -F'load averages?: ' '{print $2}' | awk '{print $1}')
echo "load ${load} · bat ${battery}"
