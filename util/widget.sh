#!/bin/sh

widget_id=$1
shift

widget_label() {
    wmiir xwrite "/rbar/$widget_id" "label $@"
}

widget_color() {
    wmiir xwrite "/rbar/$widget_id" "color $@"
}

widget_color "$wmii_normcolors"

{
    while wmiir ls /rbar | grep -q "^$widget_id\$"; do
        sleep 1s
        wmiir xwrite /event "Update $widget_id"
    done
} &

wmiir read /event |
# Read the events, line by line.
while read line; do
    case $line in
        "RightBarClick 1 $widget_id")
            ;;
        "Update $widget_id")
            ;;
    esac
done

