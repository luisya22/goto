#!/bin/bash

goto() {
    if [ ! -f ~/.goto_mappings ]; then
        touch ~/.goto_mappings
    fi

    if [ "$1" == "add" ]; then
        echo "$2 $3" >> ~/.goto_mappings
        return
    elif [ "$1" == "remove" ]; then
        sed -i "/^$2 /d" ~/.goto_mappings
        return
    elif [ "$1" == "update" ]; then
        sed -i "/^$2 /d" ~/.goto_mappings
        echo "$2 $3" >> ~/.goto_mappings
        return
    elif [ "$1" == "list" ]; then
        awk '{print "• " $1 ": " $2}' ~/.goto_mappings
        return
    fi

    target=$(grep "^$1 " ~/.goto_mappings | awk '{print $2}')
    if [ -n "$target" ]; then
        cd "$target"
    else
        echo "No mapping found for $1"
    fi
}

_goto_completion() {
    local cur prev opts names
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    
    # Collect custom names from the mapping file.
    names=$(awk '{print $1}' ~/.goto_mappings)

    # Offer those names as autocompletion suggestions.
    COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
    return 0
}

complete -F _goto_completion goto
