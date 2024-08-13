# I hate command not found handlers!!!
if type command_not_found_handle &> /dev/null; then
    HOMERC_LOG debug "Unsetting command_not_found_handle"
    unset -f command_not_found_handle
fi
