#!/bin/bash

# Set display to 60Hz for power saving
kscreen-doctor output.eDP-1.mode.2560x1600@60

# Set display to 60Hz for power saving (dgpu)
kscreen-doctor output.eDP-2.mode.2560x1600@60

# Set ASUS aura lighting to static light gray
asusctl aura static -c cccccc

# Turn off keyboard backlight
asusctl -k off
