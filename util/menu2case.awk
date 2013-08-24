#!/bin/awk -f
# Parses a "menu format file" into the body of a case statement.
BEGIN {
    item=0
}
/^[ \t]+[^ \t#]+/ {
    # Indented line: append to the current script.
    scripts[item]=scripts[item] "\n" $0
}
/^[^ \t#]/ {
    # Unindented line: new script.
    scripts[++item]=""
    scriptnames[item]=$0
}
END {
    for (i in scripts) {
        printf("\"%s\")", scriptnames[i])
        print scripts[i]
        printf(";;\n")
    }
}

