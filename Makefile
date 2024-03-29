#!/usr/bin/make

VERSION=git$(shell git rev-list HEAD -n 1 | cut -c 1-7)

BIBUNSHOTEMP=$(shell pwd)/Work
BIBUNSHOROOT=${BIBUNSHOTEMP}/bibunsho7
BIBUNSHOAPP=${BIBUNSHOROOT}/Patch.app
BIBUNSHOPKG=Bibunsho7-patch-${VERSION}-$(shell date +%Y%m%d)

hdiutil_encopts=-format UDZO -imagekey zlib-level=9
# hdiutil_encopts=-format ULFO

all: clean
	make app

app: clean ${BIBUNSHOAPP}

${BIBUNSHOAPP}:
	mkdir -p ${BIBUNSHOROOT}
	osacompile -o ${BIBUNSHOAPP} patchapp.applescript

	cp -a Patch.sh ${BIBUNSHOAPP}/Contents/Resources/
	cp -a ptex-fontmaps ${BIBUNSHOAPP}/Contents/Resources/
	cp -a cjk-gs-support ${BIBUNSHOAPP}/Contents/Resources/

	## replace icns file to ad-hoc our icon :D
	cp -a artwork/bibunsho7.icns ${BIBUNSHOAPP}/Contents/Resources/applet.icns

	## copy some documents as plain text files
	cp -a README.md ${BIBUNSHOROOT}/README.txt

dmg: ${BIBUNSHOAPP}
	hdiutil create -ov -srcfolder ${BIBUNSHOROOT} \
            -fs HFS+ ${hdiutil_encopts} \
            -volname "Bibunsho7-patch" ${BIBUNSHOPKG}.dmg

clean:
	rm -f *~
	rm -rf ${BIBUNSHOTEMP}

## end of file
