# ssh-agent
#export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
if ! ssh-add -l | grep -q '.ssh/id_rsa'; then
    echo 'WARNING: .ssh/id_rsa not found in ssh_agent'
fi
