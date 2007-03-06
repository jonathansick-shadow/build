#! /bin/sh
#
#  Source this file directly or copy it to your own directory for 
#  modifications. 
#
if [ -z "$LSST_HOME" ]; then
    # set the LSST_HOME directory
    # export LSST_HOME=$PWD
fi

if [ -z "$EUPS_PKGROOT" ]; then
    # set the EUPS_PKGROOT 
    # export EUPS_PKGROOT=http://dev.lsstcorp.org/pkgs
fi 

# Load PACMAN
. $LSST_HOME/pacman/latest/setup.sh

# Load EUPS
. $LSST_HOME/eups/latest/bin/setups.sh

# make sure LSST_HOME is part of the EUPS path
target=`ls -id1 $LSST_HOME | awk '{print $1}'`
ls -id1 `echo $EUPS_PATH | sed -e 's/:/ /g'` | egrep -q "^${target} "
if [ $? != 0 ]; then
    export EUPS_PATH="${LSST_HOME}:$EUPS_PATH"
fi

# make sure LSST_DEVEL is part of the EUPS path
if [ -n "$LSST_DEVEL" ]; then
    if [ -e "$LSST_DEVEL/ups_db" ]; then
        target=`ls -id1 $LSST_DEVEL | awk '{print $1}'`
        ls -id1 `echo $EUPS_PATH | sed -e 's/:/ /g'` | egrep -q "^${target} "
        if [ $? != 0 ]; then
            export EUPS_PATH="${LSST_DEVEL}:$EUPS_PATH"
        fi  
    else 
        echo "LSST_DEVEL=${LSST_DEVEL}: "
        echo "    Not setup for EUPS (no ups_db directory); ignoring..."
    fi
fi

# Setup your default environemnt
# setup LSST 1.0
