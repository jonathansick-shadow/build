#
#   package version
#
#
m4_changequote([, ])m4_dnl
#
m4_dnl
m4_dnl  For a simple external package that follows the configure-make pattern,
m4_dnl  it may only be necessary to update the values of the following macros.
m4_dnl  Only m4_PACKAGE and m4_VERSION are required.  
m4_dnl
m4_define([m4_PACKAGE], [ExamplePackage])m4_dnl
m4_define([m4_VERSION], [1.0])m4_dnl
m4_define([m4_TARBALL], [examplepackage-1.0.tar.gz])m4_dnl
m4_define([m4_ABOUTURL], [http://example.org/about.html])m4_dnl    OPTIONAL
# 
# set up the initial pacman definitions and environment variables.
#
m4_include([PacmanExt-pre.m4])m4_dnl
m4_dnl
m4_dnl  uncomment and adjust freeMegsMinimum() if you know a good value
m4_dnl  for this package.
m4_dnl
# freeMegsMinimum(11)       # requires at least 11 Megs to build and install

#
# denote dependencies
#
# package('m4_CACHE:otherpkg-2.2')


#
# begin installation assuming we are located in LSST_HOME
#
# available environment variables:
#   LSST_HOME           the root of the LSST installation (the current 
#                          directory)
#   THIRDPARTY_INSTALL  the directory where 3rd party packages are installed
#   THIRDPARTY_BUILD    the temporary directory where 3rd party packages 
#                          are built
#
# EUPS_PATH and EUPS_FLAVOR should also be set.
#

cd('$THIRDPARTY_BUILD')

#
#   download any tarballs and unzip
#
echo ("downloading and extracting m4_PACKAGE-m4_VERSION...")
downloadUntar('m4_PKGURL/m4_PKGPATH/m4_TARBALL','BUILDDIR')

#
#   cd into the untarred directory, configure, make and make install
#
cd('$BUILDDIR')
echo ("configuring m4_PACKAGE-m4_VERSION...")
shell('./configure --prefix=$THIRDPARTY_INSTALL/m4_PACKAGE/m4_VERSION')

echo ("running make")
shell('make')

# This next line may not be necessary
shell('mkdir -p $THIRDPARTY_INSTALL/m4_PACKAGE/m4_VERSION')
#
echo ("running make install")
shell('make install')
cd()

#
# Now download & install the EUPS table file and load package into EUPS
#
m4_include([PacmanExt-post.m4])m4_dnl

uninstallShell('rm -rf $PWD/external/m4_PACKAGE/m4_VERSION')
uninstallShell('rmdir $PWD/external/m4_PACKAGE; true')



