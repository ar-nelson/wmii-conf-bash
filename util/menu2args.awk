#!/bin/awk -f
# Parses a "menu format file" into a list of menu items separated by spaces.
/^[^ \t#]/ {
    printf(" '%s'", $0)
}

