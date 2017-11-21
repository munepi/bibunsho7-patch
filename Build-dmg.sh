#!/bin/bash -x

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

## copy some documents
cp -a README.txt ${BIBUNSHOTEMP}/bibunsho7/

## make dmg
hdiutil_encopts="-format UDZO -imagekey zlib-level=9"
# hdiutil_encopts="-format ULFO"  ##<= macOS 10.11+
hdiutil create -ov -srcfolder ${BIBUNSHOTEMP}/bibunsho7 \
        -fs HFS+ ${hdiutil_encopts} \
        -volname "Bibunsho7-patch" ${BIBUNSHOPKG}.dmg
shasum ${BIBUNSHOPKG}.dmg >${BIBUNSHOPKG}.dmg.sha1sum
echo $(basename $0): built ${BIBUNSHOPKG}.dmg

exit
