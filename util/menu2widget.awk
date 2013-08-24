#!/bin/awk -f

BEGIN {
    current=""
    updateInterval=""
    updateHeader=""
    mouseEventIndex=0
}
/^[ \t]+[^ \t#]+/ {
    # Indented line: append to the current script.
    scripts[current]=scripts[current] "\n" $0
}
/^Update [0-9a-zA-Z\.]+$/ {
    updateInterval=$2
    updateHeader=$0
}
/^(Click|MouseDown) [0-9]+$/ {
    mouseEventNames[mouseEventIndex++]=$0
}
/^[^ \t#]/ {
    # Any unindented line: new script.
    current=$0
    scripts[current]=""
}
END {
    print "\
widget_label() {\n\
    echo label \"$1\" | wmiir write \"/rbar/$widget_id\"\n\
}\n\
\n\
widget_color() {\n\
    echo colors \"$1\" | wmiir write \"/rbar/$widget_id\"\n\
}\n\
\n\
echo colors \"$wmii_normcolors\" | wmiir create \"/rbar/$widget_id\"\n\
"
    print scripts["Start"]
    if (updateInterval) {
        printf("\n\
{\n\
    while wmiir ls /rbar | grep -q \"^$widget_id\\$\"; do\n\
        sleep %s\n\
        wmiir xwrite /event \"Update $widget_id\"\n\
    done\n\
} &\n", updateInterval)
    }

    if (mouseEventIndex > 0 || updateHeader) {
        print "\n\
wmiir read /event |\n\
while read line; do\n\
    case $line in\n"

        for (i in mouseEventNames) {
            name=mouseEventNames[i]
            printf("\"RightBar%s $widget_id\")", name)
            print scripts[name]
            print ";;\n"
        }
        if (updateHeader) {
            print "\"Update $widget_id\")"
            print scripts[updateHeader]
            print ";;\n"
        }

        print "\n\
    esac\n\
done\n"
    }
}

