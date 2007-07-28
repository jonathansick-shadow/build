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
m4opts=
baseurl=
macrodir=

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
    echo "  -b baseurl   the server's base URL pointing to the packages"
    echo "                 directory (passed to m4deploy)"
    echo "  -m macrodir  the full path to the LSST m4 macro directory (passed "
    echo "                 to m4deploy)"
    echo "  -q           quiet; don't print informative messages"
    echo "  -h help      print this help"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h) help; exit 0 ;;

        -u) usage; exit 0 ;;

        -q) informative="" ;;

        -b) [shift]
            baseurl=$1 ;;

        -m) [shift]
            macrodir=$1 ;;

        -p) [shift] 
            pkgs=$1 ;;

        *) echo "Unrecognized argument: $1"; usage; exit 1 ;;
    esac
    [shift]
done

if [[ -n "$baseurl" ]]; then
    m4opts="$m4opts -b $baseurl"
fi
if [[ -n "$macrodir" ]]; then
    m4opts="$m4opts -m $macrodir"
fi
if [[ ! -d "$pkgs" ]]; then
    echo "$0: $pkgs: Packages directory does not exist"
    exit 1
fi
mkdir -p "$pkgs/pm"

files=`find . -name \*pacman.m4 -print`

if [[ -z "$files" ]]; then
    if [[ -n "$informative" ]]; then
        echo "No pacman files found under current directory."
    fi
    exit 1
fi

for file in $files; do
    if ( echo $file | grep -q '/pacman.m4$' ); then
        pkgname=`grep 'm4_define(.m4_PACKAGE.' $file | sed -e 's/^.*m4_PACKAGE.,\s*.//' -e 's/[[^a-zA-Z0-9]].*//'`
        version=`grep 'm4_define(.m4_VERSION.' $file | sed -e 's/^.*m4_VERSION.,\s*.//' -e 's/\].*//' -e "s/'.*//"`
        if [[ -z "$pkgname" ]]; then
            echo "Unable to determine package name for $file"
            exit 1
        fi
        out="$pkgs/pm/$pkgname"
        if [[ -n "$version" ]]; then
            out=$out"-$version"
        fi
        out="$out.pacman"
    else
        out=`echo $file | sed -e 's/^.*\///' -e 's/\.m4$//'`
        out="$pkgs/pm/$out"
    fi
    if [[ -n "$informative" ]]; then
        echo m4deploy$m4opts $file \> $out
    fi
    m4deploy $m4opts $file > $out
done

