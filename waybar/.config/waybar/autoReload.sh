#! /usr/bin/env bash


# Kill and restart waybar whenever its config files change
CONFIG_FILES="$HOME/.config/waybar/*"

trap "pkill waybar" EXIT

echo 'start'
while true; do
    logger -i "$0: Starting waybar in the background..."
    echo "$0: Starting waybar in the background..."
    waybar &
    echo "$0: Started waybar PID=$!. Waiting for modifications to ${CONFIG_FILES}..."
    inotifywait -e modify ${CONFIG_FILES} 2>&1 | logger -i
    echo "$0: inotifywait returned $?. Killing all waybar processes..."
    pkill waybar 2>&1 | logger -i
    logger -i "$0: pkill waybar returned $?, wait a sec..."
done

