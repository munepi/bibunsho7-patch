#!/bin/bash -x

set -e

##
## INITIALIZATION
## ==============================

## set temporary root
BIBUNSHOTEMP=${BIBUNSHOTEMP:-/tmp/bibunsho7.temp.d}
BIBUNSHOROOT=${BIBUNSHOTEMP}/texlive/2016

## set given tlnet repository for TeX Live 2016 installation
TLNET=${TLNET:-http://texlive.texjp.org/2016/tlnet}
## set usual main tlnet repository
MAIN_TLNET=http://texlive.texjp.org/2016/tlnet

## initialize some environment variables
export LANG=C LANGUAGE=C LC_ALL=C
export PATH=$(pwd)/bin:${BIBUNSHOROOT}/bin/x86_64-darwin:/usr/bin:/bin:/usr/sbin:/sbin

trap cleanup EXIT
cleanup() {
    set +e
    rm -rf install-tl-20170413
    # rm -rf ${BIBUNSHOTEMP}
}

##
## INSTALLATION
## ==============================

## clean our temporary directory
#rm -rf ${BIBUNSHOTEMP}
[ -d ${BIBUNSHOROOT}/texmf-dist ] && exit 1

[ ! -f install-tl-unx.tar.gz ] && \
    curl -L -O https://texlive.texjp.org/2016/tlnet/install-tl-unx.tar.gz ||:
[ ! -f hiraprop.tar.xz ] && \
    curl -L -O https://texlive.texjp.org/2016/tltexjp/archive/hiraprop.tar.xz ||:

## deploy the installation profile
mkdir -p ${BIBUNSHOROOT}/tlpkg
sed -e "s,@@BIBUNSHOROOT@@,${BIBUNSHOROOT}," \
    -e "s,@@BIBUNSHOTEMP@@,${BIBUNSHOTEMP}," \
    -e "s,@@WITH_WINDOWS@@,${WITH_WINDOWS}," \
    -e "s,@@WITH_LINUX@@,${WITH_LINUX}," \
    test-tl16frozen.profile.in >${BIBUNSHOROOT}/tlpkg/texlive.profile

## run TeX Live 2016 frozen installer with the texlive.profile
tar -xf install-tl-unx.tar.gz
pushd install-tl-20170413
./install-tl --profile ${BIBUNSHOROOT}/tlpkg/texlive.profile --repository ${TLNET}
popd

## add some extra packages
## 1. hiraprop
#tlmgr --repository http://texlive.texjp.org/2016/tltexjp install hiraprop
#gtar -C $(kpsewhich -var-value=TEXMFDIST)/ -xf hiraprop.tar.xz
__xzdec=install-tl-20170413//tlpkg/installer/xz/xzdec.x86_64-darwin
${__xzdec} hiraprop.tar.xz | tar x - -C $(kpsewhich -var-value=TEXMFDIST)/

echo export PATH=${BIBUNSHOROOT}/bin/x86_64-darwin:\${PATH}

exit
