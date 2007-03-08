#! /bin/sh
# 
#  To build this tool, type
#     m4 "-DTHEBASEURL=http://lsstdev.ncsa.uiuc.edu/pkgs" \
#         -DMACRODIR=/var/www/html/pkgs/deploy/build/0.3/buildtemplates/macros
#       m4deploy.sh.m4 > m4deploy.sh
#
exec m4 -P --include=MACRODIR "-Dm4_BASEURL=THEBASEURL" $*
