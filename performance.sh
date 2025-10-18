#!/bin/bash

# Set display to 165Hz for performance
kscreen-doctor output.eDP-1.mode.2560x1600@165

# Set ASUS aura lighting to static light gray
asusctl aura static -c cccccc

# Turn keyboard backlight to high
asusctl -k high

# Set battery to charge to 100% (one shot charge for traveling)
# asusctl -o
