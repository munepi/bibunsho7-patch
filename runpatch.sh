#!/bin/bash

set -e

## realpath [file]
realpath() {
    local f=$@
    local base=
    local dir=

    if [ -d "$f" ]; then
        base=""
        dir="$f"
    else
        base="/$(basename "$f")"
        dir=$(dirname "$f")
    fi;
    dir=$(cd "$dir" && pwd)
    echo "$dir$base"
    return 0
}

export PATH=/usr/bin:/bin:/usr/sbin:/sbin
RESDIR=$(dirname $(realpath $0))

${RESDIR}/Patch.sh 2>&1 | tee /tmp/bibunsho7-patch.log

#osascript -e "set logText to do shell script \"cat /tmp/bibunsho7-patch.log\"" -e "display dialog logText"
osascript -e "set logText to do shell script \"tail -n 1 /tmp/bibunsho7-patch.log\"" -e "display dialog logText"

exit
