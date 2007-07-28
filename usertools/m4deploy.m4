#! /bin/sh
# 
#  To build this tool, type
#     m4 "-DTHEBASEURL=http://lsstdev.ncsa.uiuc.edu/pkgs" \
#         -DMACRODIR=/var/www/html/pkgs/deploy/build/0.3/buildtemplates/macros
#       m4deploy.sh.m4 > m4deploy.sh
#
changequote(`[', `]')dnl
macrodir=MACRODIR
baseurl=THEBASEURL

usage() {
    echo "Usage: $0 [-m macrodir] [-b baseurl] infile"
}    

help() {
    usage
    echo "Description:"
    echo "   Process an m4 file with some predefined macros."
    echo "Options:"
    echo "  -b baseurl   the server's base URL pointing to the packages"
    echo "                 directory"
    echo "  -m macrodir  the full path to the LSST m4 macro directory"
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
            macrodir=$1 
            if [[ ! -d "$macrodir" ]]; then
                echo "$0: $macrodir: directory not found"
                exit 1
            fi
            ;;

        -*) echo "Unrecognized argument: $1"; usage; exit 1 ;;

        *)  break
    esac
    [shift]
done

exec m4 -P --include=$macrodir "-Dm4_BASEURL=$baseurl" $*
