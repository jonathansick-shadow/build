# -*- python -*-
#
# Setup our environment
#
import glob
import lsst.SConsUtils as scons

env = scons.makeEnv("deploy/build",
                    r"$HeadURL$",
                    )
#
# Libraries that I need to link things.  This should be handled better
#
env.libs = dict([])

env.Command('bin', '', [Mkdir('bin')])
env.Clean('bin', 'bin')

#
# Build/install things
#
# for d in Split("servertools usertools deploy"):
for d in Split("usertools"):
    SConscript("%s/SConscript" % d)

env['IgnoreFiles'] = r"(~$|\.pyc$|^\.svn$|\.o$)"

Alias("install", env.Install(env['prefix'], "buildtemplates"))
Alias("install", env.Install(env['prefix'], "bin"))
Alias("install", env.Install(env['prefix'], "doc"))
Alias("install", env.InstallEups(env['prefix'] + "/ups", glob.glob("ups/*.table")))

scons.CleanTree(r"*~ core *.so *.os *.o")

env.Declare()
env.Help("""
LSST FrameWork packages
""")

