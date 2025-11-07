#!/bin/bash
BASE_DIR="$( cd "$(dirname ${BASH_SOURCE[0]})/.." && pwd )"
for dst in ${BASE_DIR}/python3.{6..14}/site-packages; do
    mkdir -p $dst
    linkfarm $BASE_DIR/python-site $dst -x '.*update-sites.*'
done
