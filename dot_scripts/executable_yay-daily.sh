#!/bin/bash

# Define the log file location (change this if you want it elsewhere)
LOG_FILE="$HOME/.yay_daily_log"

# Get today's date in YYYY-MM-DD format
TODAY=$(date +%F)

# Check if log file exists and contains today's date
if [[ -f "$LOG_FILE" ]] && grep -q "$TODAY" "$LOG_FILE"; then
    echo "Yay has already been run today. Exiting."
    exit 0
fi

h=`date +%H`

if [ $h -lt 12 ]; then
    export GREETING="Good morning"
elif [ $h -lt 18 ]; then
    export GREETING="Good afternoon"
else
    export GREETING="Good evening"
fi
# Launch kitty with yay
kitty --class smolkitty -e bash -c 'cowsay -f tux \"$GREETING $USER! You want to run yay\?\"; yay; sl -w' &

# Log the current date
echo "$TODAY" > "$LOG_FILE"
