#!/bin/bash

# first we set env var so script remembers
if [ -z "$IS_POLYBAR_HIDDEN" ]; then
    export IS_POLYBAR_HIDDEN=true
fi

if [ "$IS_POLYBAR_HIDDEN" ]; then
    i3-msg "workspace 1 gaps top 40"
    i3-msg "workspace 2 gaps top 40"
    i3-msg "workspace 3 gaps top 40"
    i3-msg "workspace 4 gaps top 40"
    i3-msg "workspace 5 gaps top 40"
else
    echo "not hidden"
    i3-msg "workspace 1 gaps top 10"
    i3-msg "workspace 2 gaps top 10"
    i3-msg "workspace 3 gaps top 10"
    i3-msg "workspace 4 gaps top 10"
    i3-msg "workspace 5 gaps top 10"
fi
