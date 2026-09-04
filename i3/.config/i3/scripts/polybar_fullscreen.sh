#!/bin/bash

while true; do
    fullscreen=$(i3-msg -t get_tree | jq '
        [.. | objects | .fullscreen_mode?]
        | any(. == 1)
    ')

    if [ "$fullscreen" = "true" ]; then
        polybar-msg cmd hide
    else
        polybar-msg cmd show
    fi

    sleep 0.5
done
