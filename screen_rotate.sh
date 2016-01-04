#!/bin/sh

# Find the line in "xrandr -q --verbose" output that contains current screen orientation, grep - select current orientation and assign value to var rotation;
rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"
stylus="$xsetwacom --list devices | grep -o -e ".\+stylus""

eraser="$xsetwacom --list devices | grep -o -e ".\+eraser""
# Using current screen orientation proceed to rotate screen and input tools.
case "$rotation" in
    normal)
    # rotate to the left
    xrandr -o left
    xsetwacom set $stylus rotate ccw
    xsetwacom set $eraser rotate ccw
    ;;
    left)
    # rotate to normal
    xrandr -o inverted
    xsetwacom set $stylus rotate half 
    xsetwacom set $eraser rotate half
    ;;
    inverted)
 xrandr -o right
    xsetwacom set $stylus rotate cw
    xsetwacom set  $eraser rotate cw
;;
right)
 xrandr -o normal
    xsetwacom set $stylus rotate none
    xsetwacom set  $eraser rotate none



esac
#I'm NOT first author of this script, but I fix some bug's, like wrong touchscreen rotation (stylus and eraser);
#feel free tou use this script as you want.
