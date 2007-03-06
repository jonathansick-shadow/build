#! /bin/sh
#
#  Source this file directly or copy it to your own directory for 
#  modifications. 
#
if [ -z $LSST_HOME ]; then
    # set the LSST_HOME directory
    # export LSST_HOME=$PWD
fi

if [ -z $EUPS_FLAVOR ]; then
    # set the EUPS_FLAVOR 
    # export EUPS_FLAVOR=Linux
fi 

if [ -z $EUPS_PKGROOT ]; then
    # set the EUPS_PKGROOT 
    # export EUPS_PKGROOT=http://lsstdev.ncsa.uiuc.edu/pkgs
fi 

# Load PACMAN
. $LSST_HOME/external/pacman/latest/setup.sh

# Load EUPS
. $LSST_HOME/external/eups/latest/bin/setups.sh
echo $EUPS_PATH | sed -e 's/:/\n/g' | egrep ^${LSST_HOME}$
if [ $? != 0 ]; then
    export EUPS_PATH=${LSST_HOME}:$EUPS_PATH
endif


# Setup your default environemnt
# setup LSST 1.0
