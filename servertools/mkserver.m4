#! /bin/bash
#
#  mkserver  -  deploy an LSST software distribution server
#
#  Usage: mkserver rootpath
#
changequote(`[', `]')dnl
function usage() {
    echo "Usage: mkserver rootpath [pkgsurl]";
    echo 
    echo "Arguments:"
    echo "  rootpath    The directory to install files into.  Build package "
    echo "              tools will go into rootpath/bin and server packages in "
    echo "              rootpath/pkgs."
    echo "  pkgurl      The URL that will resolve to the rootpath/pkgs "
    echo "              directory (default: http://dev.lsstcorp.org/pkgs)"
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
if [[ ! -d "$1" -o ! -w "$1" ]]; then 
    echo "$1: not an existing directory with write permission"
    exit 3
fi

rootdir=$1
pkgs="$rootdir/pkgs"
version="THEVERSION"
baseurlopt=
if [[ -n "$2" ]]; then
    baseurl="-b $2"
fi

# Create the output directories
if [[ ! -d "$pkgs" ]]; then
    mkdir "$pkgs"
fi
if [[ ! -d "$rootdir/cgi-bin" ]]; then
    mkdir "$rootdir/cgi-bin"
fi
cp $BUILD_DIR/servertools/eupsmanifest.py $rootdir/cgi-bin

# deploy the bootstrapping packages
buildpkg="$pkgs/deploy/build/$version"
mkdir -p $buildpkg
(cd $BUILD_DIR/deploy; tar cf - *) | (cd $buildpkg; tar xf -)
cp $BUILD_DIR/ups/pacman.m4 $buildpkg/pacman.m4
echo m4deploy $baseurlopt -m $BUILD_DIR/buildtemplates/macros \
     $BUILD_DIR/deploy/newinstall.sh.m4 \> $pkgs/newinstall.sh
m4deploy $baseurlopt -m $BUILD_DIR/buildtemplates/macros \
     $BUILD_DIR/deploy/newinstall.sh.m4 > $pkgs/newinstall.sh

# Now deploy the packages
if [[ -n "$CURRENT_DIR" ]]; then
    $CURRENT_DIR/bin/loadpkgs $1
else 
    echo "CURRENT_DIR not set; run "
    echo "   setup current; loadpkgs $1"
    echo "to include all packages"
fi

# process m4 files
cd $1
if [[ $? != 0 ]]; then
    echo "Failed to change into directory $1"
    exit 3
fi
cd $pkgs && pmdeploy -p $pkgs





