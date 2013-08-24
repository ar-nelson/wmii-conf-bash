#!/bin/sh

# Common functions used throughout the wmii config:

wmii_programs_file="$(wmiir namespace)/.programs-menu"
wmii_global_keybindings="$(awk -f $wmii_confroot/util/menu2list.awk $wmii_confroot/modes/global.mode)"
wmii_global_key_cases="$(awk -f $wmii_confroot/util/menu2case.awk $wmii_confroot/modes/global.mode)"

cache_programs() {
    wmiir proglist -- $(echo $PATH | sed 'y/:/ /') | sort | uniq > $wmii_programs_file
}

programs_menu() {
    wmiir setsid "$(wimenu < $wmii_programs_file)"
}

wmii_actionlist="$(awk -f $wmii_confroot/util/menu2list.awk $wmii_confroot/menus/actions.menu | sort)"

actions_menu() {
    wmiir xwrite /event Action $(echo "$wmii_actionlist" | wimenu)
}

eval "
action() {
    action_name=\$1
    shift
    case \$action_name in
    $(awk -f $wmii_confroot/util/menu2case.awk $wmii_confroot/menus/actions.menu)
    esac
    unset action_name
}
"

mode() {
    modefile=$wmii_confroot/modes/$1.mode
    echo "Loading modefile: $modefile"
    if [ -e "$modefile" -a "$1" != global ]; then

        wmii_keys="$wmii_global_keybindings
$(awk -f $wmii_confroot/util/menu2list.awk "$modefile")"

        # Rebind wmii's key mappings.
        eval "wmiir xwrite /keys \"$wmii_keys\""
        unset wmii_keys
        # Create a new handle_key function.
        eval "
handle_key() {
    case \$1 in
    $wmii_global_key_cases
    $(awk -f $wmii_confroot/util/menu2case.awk "$modefile")
    esac
}"
        # Write the mode indicator widget to the left bar.
        if [ "$1" = default ]; then
            wmiir rm "/lbar/!mode"
        else
            echo colors "$wmii_modecolors$wmii_newline"\
                 label "$(echo $1 | tr '[:lower:]' '[:upper:]') MODE (click to exit)"\
                 | wmiir create "/lbar/!mode"
        fi
    fi
    unset modefile
}

wmii_widget_counter=0
widget() {
    widget_file="$wmii_confroot/widgets/$1.widget"
    shift
    if [ -e "$widget_file" ]; then
        widget_id="widget$wmii_widget_counter"
        wmii_widget_counter=`expr $wmii_widget_counter + 1`
        eval "`awk -f "$wmii_confroot/util/menu2widget.awk" "$widget_file"`" &
    else
        $wmii_xmessage "No such widget file: $widget_name"
    fi
    unset widget_name
}

eval "
window_menu() {
    win=\$1
    result=\$(\$wmii_menucmd $(awk -f $wmii_confroot/util/menu2args.awk $wmii_confroot/menus/window.menu))
    case \$result in
    $(awk -f $wmii_confroot/util/menu2case.awk $wmii_confroot/menus/window.menu)
    esac
    unset win
}"

