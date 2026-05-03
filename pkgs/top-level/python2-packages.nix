# Extension with Python 2 packages that is overlaid on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self;
with super;
{
  bootstrapped-pip = toPythonModule (callPackage ../development/python2-modules/bootstrapped-pip { });

  pip = callPackage ../development/python2-modules/pip { };

  setuptools = callPackage ../development/python2-modules/setuptools { };

  wheel = callPackage ../development/python2-modules/wheel { };
}
