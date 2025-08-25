# Clean up and finalize any environment setup
# undefine anything defined in pre_setup.sh that should not stick around
unset -f _homerc_redirect_stdout
unset -f _homerc_restore_stdout
unset -f _homerc_find_includes
unset -f _homerc_gather_includes
unset -f _homerc_base_setup
unset -f _homerc_rc_setup
unset -f _homerc_profile_setup
unset -f _homerc_bash_version_at_least
HOMERC_LOG_LEVEL=${HOMERC_LOG_LEVEL_MAP["info"]}
