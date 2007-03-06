#! /bin/tcsh -f
#
#  To build this tool, type
#    m4 -DEXECDIR=$PWD -DBASEDIR=/lsst/softstack pmdeploy.csh.m4 > pmdeploy.csh
#
changequote(`[', `]')
set M4DEPLOY="sh EXECDIR/m4deploy.sh"
set PKG=BASEDIR/pkgs
set PM=$PKG/pm
set pmm4s = `find . -name \*.pacman.m4 -print`
set newinst = `find -name newinstall.sh.m4 -print |grep deploy/newinstall.sh.m4`
if ($newinst != '') then
    echo $M4DEPLOY:t $newinst \>\! $PKG/$newinst:t:r
    $M4DEPLOY $newinst >! $PKG/$newinst:t:r
endif 

foreach f ($pmm4s) 
   echo $M4DEPLOY:t $f \>\! $PM/$f:t:r
   $M4DEPLOY $f >! $PM/$f:t:r
end
