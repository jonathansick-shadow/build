#! /bin/csh -f
#
#  Source this file directly or copy it to your own directory for 
#  modifications. 
#
if (! $?LSST_HOME) then
    # set the LSST_HOME directory
    # setenv LSST_HOME $PWD
endif

if (! $?EUPS_FLAVOR) then
    # set the EUPS_FLAVOR 
    # setenv EUPS_FLAVOR Linux
endif 

if (! $?EUPS_PKGROOT) then
    # set the EUPS_PKGROOT 
    # setenv EUPS_PKGROOT http://lsstdev.ncsa.uiuc.edu/pkgs
endif 

# Load PACMAN
source $LSST_HOME/external/pacman/latest/setup.csh

# Load EUPS
source $LSST_HOME/external/eups/latest/bin/setups.csh
echo $EUPS_PATH | sed -e 's/:/\n/g' | egrep ^${LSST_HOME}$
if ($status != 0) then
    setenv EUPS_PATH ${LSST_HOME}:$EUPS_PATH
endif

# Setup your default environemnt
# setup LSST 1.0
