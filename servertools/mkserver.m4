#! /bin/bash
#
#  mkserver  -  deploy an LSST software distribution server
#
#  Usage: mkserver rootpath
#
changequote(`[', `]')dnl
function usage() {
    echo "Usage: mkserver rootpath pkgsurl";
    echo 
    echo "Arguments:"
    echo "  rootpath    The directory to install files into.  Build package "
    echo "              tools will go into rootpath/bin and server packages in "
    echo "              rootpath/pkgs."
    echo "  pkgurl      The URL that will resolve to the rootpath/pkgs directory"
}

if [[ -z "$BUILD_DIR" ]]; then
    echo "BUILD_DIR environment not set; please run setup build"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "missing arguments"
    usage
    exit 2
fi
if [[ -z "$2" ]]; then
    echo "missing package URL argument"
    usage
    exit 2
fi
if [[ ! -d "$1" -o ! -w "$1" ]]; then 
    echo "$1: not an existing directory with write permission"
    exit 3
fi

rootdir=$1
baseurl=$2
pkgs="$rootdir/pkgs"
version="THEVERSION"

# Create the output directories
if [ ! -d "$pkgs" ]]; then
    mkdir "$pkgs"
fi
if [ ! -d "$rootdir/cgi-bin" ]]; then
    mkdir "$rootdir/cgi-bin"
fi
cp $BUILD_DIR/servertools/eupsmanifest.py $rootdir/cgi-bin

# deploy the bootstrapping packages
buildpkg="$pkgs/deploy/build/$version"
mkdir -p $buildpkg
(cd $BUILD_DIR/deploy; tar cf - *) | (cd $buildpkg; tar xf -)
cp $BUILD_DIR/ups/pacman.m4 $buildpkg/pacman.m4
m4deploy -b $baseurl -m $BUILD_DIR/buildtemplates/macros newinstall.sh.m4 \
     > $pkgs/newinstall.sh

# Now deploy the packages
if [[ -n "$CURRENT_DIR" ]]; then
    $CURRENT_DIR/bin/loadpkgs $1
else 
    echo "CURRENT_DIR not set; run 'setup current; loadpkgs $1' to include"
    echo "all packages"
fi

# process m4 files
cd $1
if [[ $? != 0 ]]; then
    echo "Failed to change into directory $1"
    exit 3
fi
pmdeploy -p $1





