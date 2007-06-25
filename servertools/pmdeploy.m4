#! /bin/sh 
#
#  To build this tool, type
#    m4 -DBASEDIR=/lsst/softstack pmdeploy.m4 > pmdeploy
#
changequote(`[', `]')
m4deploy=m4deploy
pkgs=BASEDIR/pkgs
pm=$PKG/pm
informative=1

usage() {
    echo "Usage: $0 [[-h]] [[-p pkgsdir]]"
}    

help() {
    usage
    echo "Description:"
    echo "   Find all files called pacman.m4 below the current directory and"
    echo "   install them into the output pkgs/pm directory."
    echo "Options:"
    echo "  -p pkgsdir   the packages directory; pacman scripts installed into"
    echo "               pkgsdir/pm"
    echo "  -q           quiet; don't print informative messages"
    echo "  -h help      print this help"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h) help; exit 0 ;;

        -u) usage; exit 0 ;;

        -q) informative="" ;;

        -p) [shift] 
            pkgs=$1 ;;

        *) echo "Unrecognized argument: $1"; usage; exit 1 ;;
    esac
    [shift]
done

files=`find . -name pacman.m4 -print`

if [[ -z "$files" ]]; then
    if [[ -n "$informative" ]]; then
        echo "No pacman files found under current directory."
    fi
    exit 1
fi

for file in $files; do
    pkgname=`grep '\[[m4_PACKAGE\]]' $file | sed -e 's/^.*\[[m4_PACKAGE\]],\s*\][//' -e 's/\]].*//'`
    version=`grep '\[[m4_VERSION\]]' $file | sed -e 's/^.*\[[m4_VERSION\],\s*\][//' -e 's/\]].*//'`
    if [[ -n "$informative" ]]; then
        echo m4deploy $file \> $pkgs/pm/$pkgname-$version.pacman
    fi
#    m4deploy $file > $pkgs/$pkgname-$version.pacman
done

