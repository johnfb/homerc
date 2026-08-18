
function set_terminal_title() {
    printf "\033]0;%s\007" "$*"
}
function set_pane_title() {
    printf "\033k%s\033\\" "$*"
}
