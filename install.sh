#!/bin/bash
HOMERC_DIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"
"${HOMERC_DIR}/conf/.local/bin/linkfarm" "${HOMERC_DIR}/conf" "${HOME}"
