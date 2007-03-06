#
#   LSSTFastDemo-0.1:  a fast demonstration uber script
#
#
m4_define(`m4_PACKAGE', `LSSTFastDemo')m4_dnl
m4_define(`m4_VERSION', `0.1')m4_dnl
# 
# set up the initial pacman definitions and environment variables.
#
packageName('m4_PACKAGE')

m4_define(`m4_PKGURL',m4_BASEURL/pkgs)m4_dnl
m4_define(`m4_CACHE',m4_BASEURL/pm)m4_dnl

version('m4_VERSION')
envIsSet('EUPS_PATH')
envIsSet('EUPS_FLAVOR')

setenvTemp('LSST_HOME', '$PWD')
setenvTemp('THIRDPARTY_INSTALL', '$PWD/external')
setenvTemp('THIRDPARTY_BUILD', '$THIRDPARTY_INSTALL/build')
shell('mkdir -p $THIRDPARTY_INSTALL $THIRDPARTY_BUILD')

echo ("Installing all packages required for  m4_PACKAGE-m4_VERSION...")

#
# denote dependencies
#
package("m4_CACHE:Termcap-1.3.1-1")
package("m4_CACHE:Termcap-1.3.1-2")
# package("m4_CACHE:cfitsio-3006.1")

#
# Now download & install the EUPS table file and load package into EUPS
#

echo ("")
echo ("m4_PACKAGE-m4_VERSION installed.")
echo ("")

