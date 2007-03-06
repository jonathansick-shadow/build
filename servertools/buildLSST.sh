#!/bin/sh
export LSST_ROOT=$PWD/LSST
mkdir $LSST_ROOT; cd $LSST_ROOT
curl -o newinstall.sh http://dev.lsstcorp.org/pkgs/newinstall.sh
sh ./newinstall.sh
cd `uname -s`
. loadLSST.sh
eups distrib --install --current LSSTPipe
