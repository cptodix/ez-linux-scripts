#!/bin/bash
if warp-cli status | grep -q "Connected"; then
    warp-cli disconnect && notify-send "WARP" "Disconnected"
else
    warp-cli connect && notify-send "WARP" "Connected to WARP+"
fi
