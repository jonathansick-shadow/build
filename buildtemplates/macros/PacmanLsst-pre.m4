packageName('m4_PACKAGE-m4_VERSION')
m4_ifdef([m4_ABOUTURL], description('m4_PACKAGE','m4_ABOUTURL'))m4_dnl

m4_define([m4_PKGURL],m4_BASEURL)m4_dnl
m4_define([m4_CACHE],m4_BASEURL/pm)m4_dnl
m4_ifdef([m4_PKGPATH], [], [m4_define([m4_PKGPATH],m4_PACKAGE/m4_VERSION)m4_dnl ])m4_dnl
version('m4_VERSION')
m4_ifdef([m4_TAG], tag('m4_TAG'))m4_dnl

envIsSet('EUPS_PATH')
envIsSet('EUPS_FLAVOR')

setenvTemp('LSST_HOME', '$PWD')
setenvTemp('LSST_BUILD', '$LSST_HOME/external/build')
shell('mkdir -p $LSST_BUILD')

