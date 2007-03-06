packageName('m4_PACKAGE-m4_VERSION')
m4_ifdef([m4_ABOUTURL], description('m4_PACKAGE','m4_ABOUTURL'))m4_dnl

m4_define([m4_PKGURL],m4_BASEURL)m4_dnl
m4_define([m4_CACHE],m4_BASEURL/pm)m4_dnl
m4_ifdef([m4_PKGPATH], [], [m4_define([m4_PKGPATH],ext/m4_PACKAGE/m4_VERSION)m4_dnl ])m4_dnl
version('m4_VERSION')
m4_ifdef([m4_TAG], tag('m4_TAG'))m4_dnl

envIsSet('EUPS_PATH')
envIsSet('EUPS_FLAVOR')

setenvTemp('LSST_HOME', '$PWD')
setenvTemp('THIRDPARTY_INSTALL', '$PWD/external')
setenvTemp('THIRDPARTY_BUILD', '$THIRDPARTY_INSTALL/build')
shell('mkdir -p $THIRDPARTY_INSTALL')
shell('mkdir -p $THIRDPARTY_BUILD')

