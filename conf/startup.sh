#!/bin/sh

# This is my personal startup script.
# Change it before using this wmii config.

xcompmgr -n -f &
urxvtd -q -o -f
nice -20 mpd &
lxpanel &

{
    sleep 1
    nitrogen --restore &
    urxvtc &
} &

{
    sleep 4
    dropbox start &
    SpiderOak &
    pidgin &
    sylpheed &
    sonata &
    shutter --min_at_startup &
} &

