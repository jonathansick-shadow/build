#! /bin/sh
#
if [ -z "$LSST_HOME" ]; then
    echo "Please set LSST_HOME so that I can find EUPS"
    exit 1
fi
. $LSST_HOME/external/eups/latest/bin/setups.sh

URLBASE=http://dev.lsstcorp.org/pkgs
currname=current.list
CURRENT=/tmp/LSSTcurrent.list
manifest=/tmp/pkg.manifest

# cat > setpkgcurrent.sh <<EOF
# #! /bin/sh
# # 
# # set each package described on standard input to be current, but only if 
# # that package is installed
# #
# 
# EOF

setcurrentin () {
    declare -i i=$1
    while [ $i -gt 0 ]; do
        read -u $2 pkg flav vers extra
        versinstalld=`eups list $pkg $vers 2>&1`
        if [ "${pkg:0:4}" != "EUPS" -a "${pkg:0:1}" != "#" -a -n "$versinstalld" ]; then
            echo eups declare --current $pkg $vers
            eups declare --current $pkg $vers
        fi
        let --i
    done
}

curl -o $CURRENT $URLBASE/$currname
if [ $? -ne 0 -o ! -f "$CURRENT" ]; then
    echo "failed to download $currname to $CURRENT"
    exit 1
fi

if [ $# -gt 0 ]; then

    for pkg in $*; do
        vers=`grep $pkg $CURRENT | awk '{print $3}'`
        if [ -n "$vers" ]; then
          curl -o $manifest $URLBASE/manifests/${pkg}-${vers}.manifest
          if [ $? -ne 0 ]; then
              echo "Failed to download ${pkg}-${vers}.manifest; skipping..."
          else 
              setcurrentin `cat $manifest | wc -l` 10 10<>$manifest
          fi
        fi
    done
else
    setcurrentin `cat $CURRENT | wc -l` 10 10<>$CURRENT
fi



