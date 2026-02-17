# Extension with Python 2 packages that is overlaid on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self;
with super;
{
  attrs = disabled super.attrs;

  bootstrapped-pip = toPythonModule (callPackage ../development/python2-modules/bootstrapped-pip { });

  cffi = disabed super.cffi;

  configparser = disabled super.configparser;

  contextlib2 = disabled super.contextlib2;

  coverage = disabled super.coverage;

  filelock = disabled super.filelock;

  hypothesis = disabled super.hypothesis;

  importlib-metadata = disabled super.importlib-metadata;

  jinja2 = disabled super.jinja2;

  markupsafe = disabled super.markupsafe;

  mock = disabled super.mock;

  more-itertools = disabled super.more-itertools;

  ninja = disabled super.ninja;

  packaging = disabled super.packaging;

  pip = callPackage ../development/python2-modules/pip { };

  pluggy = disabled super.pluggy;

  pycairo = disabled super.pycairo;

  pyparsing = disabled super.pyparsing;

  pytest = disabled super.pytest;

  pytest_4 = disabled super.pytest;

  pytest-xdist = disabled super.pytest-xdist;

  recoll = disabled super.recoll;

  rivet = disabled super.rivet;

  rpm = disabled super.rpm;

  setuptools = callPackage ../development/python2-modules/setuptools { };

  six = disabled super.six;

  wcwidth = disabled super.wcwitch;

  wheel = callPackage ../development/python2-modules/wheel { };

  zeek = disabled super.zeek;

  zipp = disabled super.zipp;
}
