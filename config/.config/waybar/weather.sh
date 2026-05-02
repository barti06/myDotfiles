#!/usr/bin/env bash

CACHE_FILE="/tmp/waybar_weather_wttr"
CACHE_TTL=1800

# check the weather cache
if [[ -f "$CACHE_FILE" && -s "$CACHE_FILE" ]] && (($(date +%s) - $(stat -c %Y "$CACHE_FILE") < CACHE_TTL)); then
    cat "$CACHE_FILE"
else
    # fetch from wttr.in
    # %c = condition (emoji)
    # %t = temperature
    # %m = moon phase (optional)
    RAW_WEATHER=$(curl -s --max-time 5 "https://wttr.in/?format=%c+%t")

    if [[ -z "$RAW_WEATHER" || "$RAW_WEATHER" == *"Unknown"* || "$RAW_WEATHER" == *"error"* ]]; then
        # use some old cached weather, if there's none print N/A
        [[ -s "$CACHE_FILE" ]] && cat "$CACHE_FILE" || echo "N/A"
    else
        # output cleanup (remove the + sign)
        WEATHER=$(echo "${RAW_WEATHER//+/}" | xargs)
        echo "$WEATHER" >"$CACHE_FILE"
        echo "$WEATHER"
    fi
fi
