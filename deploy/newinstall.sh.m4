#! /bin/sh
#
# Usage: sh newinstall.sh [rootdir]
#
m4_dnl
m4_dnl Use the m4deploy to install this script
m4_dnl
m4_changequote(^, ^)m4_dnl
m4_dnl set -x
#  Set up some initial environment variables
#
LSST_HOME=$PWD
if [ -n "$1" ]; then
   LSST_HOME=$1
fi
cd $LSST_HOME

# Create the initial set of directories 
#
mkdir -p pacman; cd pacman

# Download and install pacman
#
curl -o pacman-latest.tar.gz m4_BASEURL/ext/pacman/latest/pacman-latest.tar.gz
tar xzf pacman-latest.tar.gz
if [ $? != 0 ]; then
   echo "Failed to unpack Pacman"
   exit 1
fi

pacmandir=`ls -d pacman-* | grep -v tar.gz | sort -r | head -1`
pacmanver=`echo $pacmandir | sed 's/pacman\-//'`
mv $pacmandir $pacmanver
ln -s $pacmanver latest

cd $pacmanver
csh -c "source setup.csh"
source setup.sh
cd $LSST_HOME
source pacman/$pacmanver/setup.sh

# Initialize the distribution via a pacman script.  For one, define the 
# LSST cache symbol
#
echo y | pacman -install m4_BASEURL/pm:LSSTinit
if [ $? != 0 ]; then
   echo "Failed to install initialization scripts"
   exit 1
fi

# Download and install EUPS
#
echo y | pacman -install LSST:eups-latest
if [ $? != 0 ]; then
   echo "Failed to install EUPS"
   exit 1
fi

# Remove the annoying "Do not edit" messages from loadLSST.*
#
sed -e 's/#.*Do not edit.*$//' loadLSST.csh > loadLSST.tmp
mv loadLSST.tmp loadLSST.csh
sed -e 's/#.*Do not edit.*$//' loadLSST.sh > loadLSST.tmp
mv loadLSST.tmp loadLSST.sh

# mark the eups we just installed as the "latest"
#
cd eups
latest=`ls | sort -r | head -1`
if [ ! -e latest ]; then
   ln -s $latest latest
fi
cd $LSST_HOME

source eups/latest/bin/setups.sh
flavor=`eups flavor`
mkdir -p $flavor

echo Initialization complete
echo 
echo "Now type "
echo 
echo "  cd $LSST_HOME"
echo "  source loadLSST.sh"
echo 
echo "or"
echo 
echo "  cd $LSST_HOME"
echo "  source loadLSST.csh" 
echo 
echo "to load version management with EUPS"
echo 


