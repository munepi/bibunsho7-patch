#!/bin/bash

# This program is licensed under the terms of the MIT License.
#
# Copyright 2017 Munehiro Yamamoto <munepixyz@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in 
# the Software without restriction, including without limitation the rights to 
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
# of the Software, and to permit persons to whom the Software is furnished to do 
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.

set -x
set -e

##
## INITIALIZATION
## ==============================

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

## 
TLRESDIR=$(dirname $(realpath $0))

## set Mac OS X version
OSXVERSION=${OSXVERSION:-$(sw_vers -productVersion)}
OSXVERSION=$(echo ${OSXVERSION} | sed s,\\\(10\\\.[0-9]*\\\)\\\.[0-9]*,\\\1,) # replace: 10.X.Y -> 10.X

## initialize some environment variables
export LANG=C LANGUAGE=C LC_ALL=C
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

TLPATH=${TLPATH:-}
if [ -z "${TLPATH}" ]; then
    if [ -x /Applications/TeXLive/Library/texlive/2016/bin/x86_64-darwin/kpsewhich ]; then
        TLPATH=/Applications/TeXLive/Library/texlive/2016/bin/x86_64-darwin
    elif [ -x /usr/local/texlive/2016/bin/x86_64-darwin/kpsewhich ]; then
        TLPATH=/usr/local/texlive/2016/bin/x86_64-darwin
    fi
fi
export PATH=${TLPATH}:${PATH}

## check some binaries and system-wide TEXMF trees
which kpsewhich || exit 1
which mktexlsr || exit 1
which updmap-sys || exit 1

if [ ! -d $(kpsewhich -var-value=TEXMFLOCAL) ]; then
    echo E: no such directory: TEXMFLOCAL: $(kpsewhich -var-value=TEXMFLOCAL)
    exit 1
fi
if [ ! -d $(kpsewhich -var-value=TEXMFSYSCONFIG) ]; then
    echo E: no such directory: TEXMFSYSCONFIG: $(kpsewhich -var-value=TEXMFSYSCONFIG)
    exit 1
fi
if [ ! -d $(kpsewhich -var-value=TEXMFSYSVAR) ]; then
    echo E: no such directory: TEXMFSYSVAR: $(kpsewhich -var-value=TEXMFSYSVAR)
    exit 1
fi


##
## INSTALLATION
## ==============================

## ptex-fontmaps
## NOTE: TL16 already has
##  - ptex-fontmaps/hiragino{,-pron} (for legacy Mac OS X)
##  - ptex-fontmaps/hiragino-elcapitan{,-pron}
HRGNMAPDIR=$(kpsewhich -var-value=TEXMFLOCAL)/fonts/map/dvipdfmx/ptex-fontmaps
mkdir -p ${HRGNMAPDIR}/
cp -a ${TLRESDIR}/jfontmaps/maps/hiragino* ${HRGNMAPDIR}/

## modified/imported a part of lnsysfnt.sh
HRGNLEGACYDIR=$(kpsewhich -var-value=TEXMFLOCAL)/fonts/opentype/cjk-gs-integrate # screen/hiragino-legacy
HRGNDIR=$(kpsewhich -var-value=TEXMFLOCAL)/fonts/truetype/cjk-gs-integrate # screen/hiragino

mkdir -p ${HRGNDIR}
pushd ${HRGNDIR}
rm -f HiraginoSerif*.ttc HiraginoSans*.ttc
case ${OSXVERSION} in
    10.[0-9]|10.[0-9].*|10.10|10.10.*)
        ## bundled Hiragino OpenType fonts (OS X 10.10 Yosemite or lower versions)
        mkdir -p ${HRGNLEGACYDIR}
        pushd ${HRGNLEGACYDIR}
        rm -f HiraMin*.otf HiraKaku*.otf HiraMaru*.otf

        ln -s "/Library/Fonts/ヒラギノ明朝 Pro W3.otf" HiraMinPro-W3.otf
        ln -s "/Library/Fonts/ヒラギノ明朝 Pro W6.otf" HiraMinPro-W6.otf
        ln -s "/Library/Fonts/ヒラギノ丸ゴ Pro W4.otf" HiraMaruPro-W4.otf
        ln -s "/Library/Fonts/ヒラギノ角ゴ Pro W3.otf" HiraKakuPro-W3.otf
        ln -s "/Library/Fonts/ヒラギノ角ゴ Pro W6.otf" HiraKakuPro-W6.otf
        ln -s "/Library/Fonts/ヒラギノ角ゴ Std W8.otf" HiraKakuStd-W8.otf

        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN W3.otf" HiraMinProN-W3.otf
        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN W6.otf" HiraMinProN-W6.otf
        ln -s "/Library/Fonts/ヒラギノ丸ゴ ProN W4.otf"        HiraMaruProN-W4.otf
        ln -s "/System/Library/Fonts/ヒラギノ角ゴ ProN W3.otf" HiraKakuProN-W3.otf
        ln -s "/System/Library/Fonts/ヒラギノ角ゴ ProN W6.otf" HiraKakuProN-W6.otf
        ln -s "/Library/Fonts/ヒラギノ角ゴ StdN W8.otf"        HiraKakuStdN-W8.otf
        popd
        ;;
    10.11|10.11.*|10.12|10.12.*)
        ## bundled Hiragino OpenType fonts/collections (OS X 10.11 El Capitan/macOS 10.12 Sierra)
        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN W3.ttc"  HiraginoSerif-W3.ttc
        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN W6.ttc"  HiraginoSerif-W6.ttc
        ln -s "/Library/Fonts/ヒラギノ丸ゴ ProN W4.ttc"         HiraginoSansR-W4.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc" HiraginoSans-W3.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc" HiraginoSans-W6.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" HiraginoSans-W8.ttc

        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W1.ttc" HiraginoSans-W1.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W2.ttc" HiraginoSans-W2.ttc

        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc" HiraginoSans-W0.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W4.ttc" HiraginoSans-W4.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W5.ttc" HiraginoSans-W5.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W7.ttc" HiraginoSans-W7.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W9.ttc" HiraginoSans-W9.ttc
        ;;
    10.13|10.13.*)
        ## bundled Hiragino OpenType fonts/collections (OS X 10.13 High Sierra)
        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN.ttc"     HiraginoSerif.ttc
        ln -s "/System/Library/Fonts/ヒラギノ丸ゴ ProN W4.ttc"  HiraginoSansR-W4.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc" HiraginoSans-W0.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W1.ttc" HiraginoSans-W1.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W2.ttc" HiraginoSans-W2.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc" HiraginoSans-W3.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W4.ttc" HiraginoSans-W4.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W5.ttc" HiraginoSans-W5.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc" HiraginoSans-W6.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W7.ttc" HiraginoSans-W7.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" HiraginoSans-W8.ttc
        ln -s "/System/Library/Fonts/ヒラギノ角ゴシック W9.ttc" HiraginoSans-W9.ttc
        ;;
    *)
        echo 
        exit 
        ;;
esac
popd

## set hiragino-<Mac OS X flavor>-pron
kanjiEmbed=
case ${OSXVERSION} in
    10.[0-9]|10.[0-9].*|10.10|10.10.*)
        kanjiEmbed=hiragino-pron;;
    10.11|10.11.*|10.12|10.12.*)
        kanjiEmbed=hiragino-elcapitan-pron;;
    10.13|10.13.*)
        kanjiEmbed=hiragino-highsierra-pron;;
    *)
        echo E: not supported: ${OSXVERSION}
        exit 1
        ;;
esac
## We run not kanji-config-updmap-sys ${kanjiEmbed} but updmap-sys directly.
mkdir -p $(kpsewhich -var-value=TEXMFSYSCONFIG)/web2c/
echo "kanjiEmbed ${kanjiEmbed}" >$(kpsewhich -var-value=TEXMFSYSCONFIG)/web2c/updmap.cfg

## Finally, 
mktexlsr
updmap-sys

## TODO: remove mpost, upmpost from texmf.cnf in TLROOT

echo Finished
exit
## end of file
