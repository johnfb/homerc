# .bashrc
HOMERC="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.."; pwd)"
source "${HOMERC}/pre_setup.sh"
_homerc_rc_setup
source "${HOMERC}/post_setup.sh"
