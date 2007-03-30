cd('$LSST_HOME')
# shell('rm -rf $BUILDDIR/*; true')

# echo ("")
echo ("Pacman installation of m4_PACKAGE-m4_VERSION complete.")
# echo ("")

uninstallShell('eups_undeclare m4_PACKAGE m4_VERSION; true')
