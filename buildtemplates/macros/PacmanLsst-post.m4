cd('$LSST_HOME/m4_PACKAGE/m4_VERSION')
shell('mkdir -p ups')
download('m4_PKGURL/m4_PKGPATH/m4_PACKAGE.table')
shell('mv m4_PACKAGE.table ups')
# shell('eups_declare m4_PACKAGE m4_VERSION -r $PWD')

cd('$LSST_HOME')
# shell('rm -rf $BUILDDIR/*; true')

# echo ("")
echo ("Pacman installation of m4_PACKAGE-m4_VERSION complete.")
# echo ("")

uninstallShell('eups_undeclare m4_PACKAGE m4_VERSION; true')
