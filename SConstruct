# -*- python -*-
#
# Setup our environment
#
import glob
import os
import lsst.SConsUtils as scons

opts = scons.LsstOptions()
opts.AddOptions(('pkgsurl', 'the base url for the software server',
                 'http://dev.lsstcorp.org/pkgs'))

env = scons.makeEnv("build",
                    r"$HeadURL$",
                    eups_product_path='%P/%f/deploy/%p/%v',
                    options=opts)
#
# Libraries that I need to link things.  This should be handled better
#
env.libs = dict([])

env.Command('bin', '', [Mkdir('bin')])
env.Clean('bin', 'bin')
env.Clean('server',["pmdeploy", "mkserver"])

#
# Build/install things
#
# for d in Split("servertools usertools deploy"):
for d in Split("usertools"):
    SConscript("%s/SConscript" % d)

if 'server' in COMMAND_LINE_TARGETS:
    SConscript("servertools/SConscript")

env['IgnoreFiles'] = r"(~$|\.pyc$|^\.svn$|\.o$)"

Alias("install", env.Install(env['prefix'], "buildtemplates"))
Alias("install", env.Install(env['prefix'], "bin"))
Alias("install", env.Install(env['prefix'], "doc"))
Alias("install", env.InstallEups(env['prefix'] + "/ups", glob.glob("ups/*.table")))

Alias("server", "install")
Alias("server", env.Install(env['prefix'], "usertools"))
Alias("server", env.Install(env['prefix'], "servertools"))
Alias("server", env.Install(env['prefix'], "deploy"))
Alias("server", env.Install(env['prefix'], "SConstruct"))
Alias("server", env.Install(env['prefix'], "ups"))

scons.CleanTree(r"*~ core *.so *.os *.o")

env.Declare()
env.Help("""
deploy/build:  LSST Build Tools

This provides tools for building LSST products and installing them into
the software distribution server.  
""")

