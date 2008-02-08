#! /bin/csh -f
#
#  Source this file directly or copy it to your own directory for 
#  modifications. 
#
if (! $?LSST_HOME) then
    # set the LSST_HOME directory
    # setenv LSST_HOME $PWD
endif

if (! $?EUPS_PKGROOT) then
    # set the EUPS_PKGROOT 
    # setenv EUPS_PKGROOT http://lsstdev.ncsa.uiuc.edu/pkgs
endif 

# Load PACMAN
source $LSST_HOME/pacman/latest/setup.csh

# Load EUPS
source $LSST_HOME/eups/latest/bin/setups.csh

# make sure LSST_HOME is part of the EUPS path
set target = `ls -id1 $LSST_HOME | awk '{print $1}'`
ls -id1 `echo $EUPS_PATH | sed -e 's/:/ /g'` | egrep -q "^${target} "
if ($status != 0) then
    setenv EUPS_PATH ${LSST_HOME}:$EUPS_PATH
endif

# make sure LSST_DEVEL is part of the EUPS path
if ($?LSST_DEVEL) then
    if (-e "$LSST_DEVEL/ups_db") then
        set target = `ls -id1 $LSST_DEVEL | awk '{print $1}'`
        ls -id1 `echo $EUPS_PATH | sed -e 's/:/ /g'` | egrep -q "^${target} "
        if ($status != 0) then
            setenv EUPS_PATH "${LSST_DEVEL}:$EUPS_PATH"
        endif
    else 
        echo "LSST_DEVEL=${LSST_DEVEL}: "
        echo "    Not setup for EUPS (not ups_db directory); ignoring..."
    endif
endif

# set the LSST_PKGS var
if (! $?LSST_PKGS) then
    if ($?EUPS_FLAVOR) then
        set flv = "$EUPS_FLAVOR"
    else
        set flv = `eups flavor`
    endif
    setenv LSST_PKGS $LSST_HOME/`eups flavor`
    unset flv
endif

# Setup your default environemnt
# setup build
