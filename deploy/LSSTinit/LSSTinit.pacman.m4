#
#   LSSTInit:  ready a location for installing LSST packages
#
m4_changequote([, ])m4_dnl
m4_define([m4_VERSION], [1.1])m4_dnl
#
packageName('LSSTinit')

m4_include([PacmanRegister.m4])m4_dnl

downloadUntar('m4_BASEURL/deploy/build/m4_VERSION/LSSTinit/LSSTinit.tar.gz')

insertLine('    setenv LSST_HOME $PWD', 'loadLSST.csh', '# setenv LSST_HOME')
insertLine('    export LSST_HOME=$PWD', 'loadLSST.sh', '# export LSST_HOME')

insertLine('    setenv EUPS_PKGROOT m4_BASEURL', 'loadLSST.csh', '# setenv EUPS_PKGROOT')
insertLine('    export EUPS_PKGROOT=m4_BASEURL', 'loadLSST.sh', '# export EUPS_PKGROOT')


