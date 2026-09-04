#!/usr/bin/bash

# get sinks
sinks=($(pactl list short sinks | awk '{print $2}'))
current=$(pactl get-default-sink)

for i in "${!sinks[@]}"; do
  if [[ "${sinks[$i]}" == "$current" ]]; then
    next_index=$(( (i + 1) % ${#sinks[@]} ))
    next_sink="${sinks[$next_index]}"

    # set new default sink
    pactl set-default-sink "$next_sink"

    # move all current audio streams to new sink
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
      pactl move-sink-input "$input" "$next_sink"
    done

    # get human-readable name
    desc=$(pactl list sinks | awk -v sink="$next_sink" '
      $0 ~ "Name: "sink {found=1}
      found && /Description:/ {sub("Description: ", ""); print; exit}
    ')

    # fallback if description not found
    [[ -z "$desc" ]] && desc="$next_sink"

    # send notification (replace previous one)
    notify-send -r 9991 -i audio-headphones "Audio Output Switched" "$desc"

    break
  fi
done
