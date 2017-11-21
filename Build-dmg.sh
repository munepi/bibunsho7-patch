#!/bin/bash -x

set -e

BIBUNSHOTEMP=${BIBUNSHOTEMP:-/tmp/bibunsho7.temp.d}
BIBUNSHOAPP=${BIBUNSHOTEMP}/bibunsho7/Patch.app
BIBUNSHOPKG=Bibunsho7-patch-$(date +%Y%m%d)

## cleanup
rm -rf ${BIBUNSHOTEMP}
mkdir -p ${BIBUNSHOTEMP}/bibunsho7

## make Patch.app
osacompile -o ${BIBUNSHOAPP} <<__APPLESCRIPT__
try
    do shell script quoted form of (POSIX path of (path to resource "runpatch.sh")) with administrator privileges
end try
__APPLESCRIPT__

cp -a runpatch.sh ${BIBUNSHOAPP}/Contents/Resources/
cp -a Patch.sh ${BIBUNSHOAPP}/Contents/Resources/
cp -a jfontmaps ${BIBUNSHOAPP}/Contents/Resources/

## replace icns file to ad-hoc our icon :D
cp -a artwork/bibunsho7.icns ${BIBUNSHOAPP}/Contents/Resources/applet.icns

## make dmg
hdiutil_encopts="-format UDZO -imagekey zlib-level=9"
# hdiutil_encopts="-format ULFO"  ##<= macOS 10.11+
hdiutil create -ov -srcfolder ${BIBUNSHOTEMP}/bibunsho7 \
        -fs HFS+ ${hdiutil_encopts} \
        -volname "Bibunsho7-patch" ${BIBUNSHOPKG}.dmg
shasum ${BIBUNSHOPKG}.dmg >${BIBUNSHOPKG}.dmg.sha1sum
echo $(basename $0): built ${BIBUNSHOPKG}.dmg

exit
