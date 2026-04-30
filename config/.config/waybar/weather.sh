#!/usr/bin/env bash

CACHE_FILE="/tmp/waybar_weather_location"
CACHE_TTL=3600

# --- Get coordinates (cached) ---
if [[ -f "$CACHE_FILE" ]] && (($(date +%s) - $(stat -c %Y "$CACHE_FILE") < CACHE_TTL)); then
    IFS=',' read -r LAT LON <"$CACHE_FILE"
else
    GEO=$(curl -s "ip-api.com/json")
    LAT=$(echo "$GEO" | jq -r '.lat')
    LON=$(echo "$GEO" | jq -r '.lon')

    if [[ -z "$LAT" || "$LAT" == "null" ]]; then
        echo "N/A"
        exit 0
    fi

    echo "${LAT},${LON}" >"$CACHE_FILE"
fi

# --- Fetch weather from Open-Meteo ---
RESPONSE=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current_weather=true&temperature_unit=celsius&models=best_match")

TEMP=$(echo "$RESPONSE" | jq -r '.current_weather.temperature')
CODE=$(echo "$RESPONSE" | jq -r '.current_weather.weathercode')

if [[ -z "$TEMP" || "$TEMP" == "null" ]]; then
    echo "N/A"
    exit 0
fi

# --- Map WMO weather code to emoji ---
case "$CODE" in
0) ICON="☀️" ;;
1 | 2) ICON="🌤️" ;;
3) ICON="☁️" ;;
45 | 48) ICON="🌫️" ;;
51 | 53 | 55) ICON="🌦️" ;;
61 | 63 | 65) ICON="🌧️" ;;
71 | 73 | 75 | 77) ICON="❄️" ;;
80 | 81 | 82) ICON="🌧️" ;;
85 | 86) ICON="🌨️" ;;
95 | 96 | 99) ICON="⛈️" ;;
*) ICON="🌡️" ;;
esac

echo "${ICON} ${TEMP}°C"
