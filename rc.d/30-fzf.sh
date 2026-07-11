#!/bin/bash
if type -p fzf > /dev/null; then
    for f in /usr/share/fzf/key-bindings.bash /usr/share/fzf/completion.bash; do
        if [ -f "$f" ]; then
            source "$f"
        else
            HOMERC_LOG debug "fzf integration file not found: $f"
        fi
    done
else
    HOMERC_LOG debug "fzf not installed, skipping integration"
fi
