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

if [ `${RESDIR}/Patch.sh` ]; then
    osascript -e "display dialog \"パッチ完了\""
else
    osascript -e "display dialog \"$(${RESDIR}/Patch.sh 2>&1)\""
fi

exit
