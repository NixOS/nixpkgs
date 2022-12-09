# Extension with Python 2 packages that is overlayed on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self; with super; {
  attrs = callPackage ../development/python2-modules/attrs { };

  bootstrapped-pip = toPythonModule (callPackage ../development/python2-modules/bootstrapped-pip { });

  boto3 = callPackage ../development/python2-modules/boto3 {};

  botocore = callPackage ../development/python2-modules/botocore {};

  certifi = callPackage ../development/python2-modules/certifi { };

  chardet = callPackage ../development/python2-modules/chardet { };

  configparser = callPackage ../development/python2-modules/configparser { };

  contextlib2 = callPackage ../development/python2-modules/contextlib2 { };

  coverage = callPackage ../development/python2-modules/coverage { };

  enum = callPackage ../development/python2-modules/enum { };

  filelock =  callPackage ../development/python2-modules/filelock { };

  futures = callPackage ../development/python2-modules/futures { };

  google-apputils = callPackage ../development/python2-modules/google-apputils { };

  gtkme = callPackage ../development/python2-modules/gtkme { };

  hypothesis = callPackage ../development/python2-modules/hypothesis { };

  idna = callPackage ../development/python2-modules/idna { };

  importlib-metadata = callPackage ../development/python2-modules/importlib-metadata { };

  jinja2 = callPackage ../development/python2-modules/jinja2 { };

  marisa = callPackage ../development/python2-modules/marisa {
    inherit (pkgs) marisa;
  };

  markupsafe = callPackage ../development/python2-modules/markupsafe { };

  mock = callPackage ../development/python2-modules/mock { };

  more-itertools = callPackage ../development/python2-modules/more-itertools { };

  packaging = callPackage ../development/python2-modules/packaging { };

  pip = callPackage ../development/python2-modules/pip { };

  pluggy = callPackage ../development/python2-modules/pluggy { };

  protobuf = callPackage ../development/python2-modules/protobuf {
    disabled = isPyPy;
    protobuf = pkgs.protobuf3_17; # last version compatible with Python 2
  };

  pycairo = callPackage ../development/python2-modules/pycairo {
    inherit (pkgs.buildPackages) meson;
  };

  pygments = callPackage ../development/python2-modules/Pygments { };

  pygobject3 = callPackage ../development/python2-modules/pygobject {
    inherit (pkgs) meson;
  };

  pygtk = callPackage ../development/python2-modules/pygtk { };

  pyparsing = callPackage ../development/python2-modules/pyparsing { };

  pyroma = callPackage ../development/python2-modules/pyroma { };

  pysqlite = callPackage ../development/python2-modules/pysqlite { };

  pytest = pytest_4;

  pytest_4 = callPackage
    ../development/python2-modules/pytest {
      # hypothesis tests require pytest that causes dependency cycle
      hypothesis = self.hypothesis.override {
        doCheck = false;
      };
    };

  pytest-runner = callPackage ../development/python2-modules/pytest-runner { };

  pytest-xdist = callPackage ../development/python2-modules/pytest-xdist { };

  recoll = disabled super.recoll;

  rivet = disabled super.rivet;

  rpm = disabled super.rpm;

  s3transfer = callPackage ../development/python2-modules/s3transfer { };

  scandir = callPackage ../development/python2-modules/scandir { };

  sequoia = disabled super.sequoia;

  setuptools = callPackage ../development/python2-modules/setuptools { };

  setuptools-scm = callPackage ../development/python2-modules/setuptools-scm { };

  sphinxcontrib-websupport = callPackage ../development/python2-modules/sphinxcontrib-websupport { };

  sphinx = callPackage ../development/python2-modules/sphinx { };

  typing = callPackage ../development/python2-modules/typing { };

  zeek = disabled super.zeek;

  zipp = callPackage ../development/python2-modules/zipp { };

}
