#!/bin/bash
if [ -f "${HOMERC}/z/z.sh" ]; then
    source "${HOMERC}/z/z.sh"
else
    HOMERC_LOG error "Warning z is not initialized"
fi
