#
#   LSSTInit:  ready a location for installing LSST packages
#
packageName('LSSTinit')

register('LSST', 'm4_BASEURL/pm', 'LSST DM System', 'http://www.lsstcorp.org', 'LSST Build Manager', 'rplante@ncsa.uiuc.edu')

downloadUntar('m4_BASEURL/deploy/build/0.3/LSSTinit/LSSTinit.tar.gz')

insertLine('    setenv LSST_HOME $PWD', 'loadLSST.csh', '# setenv LSST_HOME')
insertLine('    export LSST_HOME=$PWD', 'loadLSST.sh', '# export LSST_HOME')

insertLine('    setenv EUPS_PKGROOT m4_BASEURL', 'loadLSST.csh', '# setenv EUPS_PKGROOT')
insertLine('    export EUPS_PKGROOT=m4_BASEURL', 'loadLSST.sh', '# export EUPS_PKGROOT')


