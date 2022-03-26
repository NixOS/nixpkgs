# Extension with Python 2 packages that is overlayed on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self; with super; {

  bootstrapped-pip = callPackage ../development/python2-modules/bootstrapped-pip { };

  boto3 = callPackage ../development/python2-modules/boto3 {};

  botocore = callPackage ../development/python2-modules/botocore {};

  certifi = callPackage ../development/python2-modules/certifi { };

  chardet = callPackage ../development/python2-modules/chardet { };

  cheetah = callPackage ../development/python2-modules/cheetah { };

  click = callPackage ../development/python2-modules/click { };

  configparser = callPackage ../development/python2-modules/configparser { };

  construct = callPackage ../development/python2-modules/construct { };

  contextlib2 = callPackage ../development/python2-modules/contextlib2 { };

  coverage = callPackage ../development/python2-modules/coverage { };

  cryptography = callPackage ../development/python2-modules/cryptography { };

  cryptography_vectors = callPackage ../development/python2-modules/cryptography-vectors { };

  decorator = callPackage ../development/python2-modules/decorator { };

  enum = callPackage ../development/python2-modules/enum { };

  filelock =  callPackage ../development/python2-modules/filelock { };

  flask = callPackage ../development/python2-modules/flask { };

  freezegun = callPackage ../development/python2-modules/freezegun { };

  futures = callPackage ../development/python2-modules/futures { };

  google-apputils = callPackage ../development/python2-modules/google-apputils { };

  gtkme = callPackage ../development/python2-modules/gtkme { };

  httpretty = callPackage ../development/python2-modules/httpretty { };

  hypothesis = callPackage ../development/python2-modules/hypothesis { };

  idna = callPackage ../development/python2-modules/idna { };

  importlib-metadata = callPackage ../development/python2-modules/importlib-metadata { };

  ipaddr = callPackage ../development/python2-modules/ipaddr { };

  itsdangerous = callPackage ../development/python2-modules/itsdangerous { };

  jinja2 = callPackage ../development/python2-modules/jinja2 { };

  libcloud = callPackage ../development/python2-modules/libcloud { };

  lpod = callPackage ../development/python2-modules/lpod { };

  marisa = callPackage ../development/python2-modules/marisa {
    inherit (pkgs) marisa;
  };

  markdown = callPackage ../development/python2-modules/markdown { };

  markupsafe = callPackage ../development/python2-modules/markupsafe { };

  mock = callPackage ../development/python2-modules/mock { };

  more-itertools = callPackage ../development/python2-modules/more-itertools { };

  mutagen = callPackage ../development/python2-modules/mutagen { };

  numpy = callPackage ../development/python2-modules/numpy { };

  packaging = callPackage ../development/python2-modules/packaging { };

  pillow = callPackage ../development/python2-modules/pillow {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11;
  };

  pip = callPackage ../development/python2-modules/pip { };

  pluggy = callPackage ../development/python2-modules/pluggy { };

  prettytable = callPackage ../development/python2-modules/prettytable { };

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

  pyjwt = callPackage ../development/python2-modules/pyjwt { };

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

  pyyaml = callPackage ../development/python2-modules/pyyaml { };

  qpid-python = callPackage ../development/python2-modules/qpid-python { };

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

  TurboCheetah = callPackage ../development/python2-modules/TurboCheetah { };

  typing = callPackage ../development/python2-modules/typing { };

  urllib3 = callPackage ../development/python2-modules/urllib3 { };

  werkzeug = callPackage ../development/python2-modules/werkzeug { };

  wsproto = callPackage ../development/python2-modules/wsproto { };

  wxPython30 = callPackage ../development/python2-modules/wxPython {
    wxGTK = pkgs.wxGTK30;
  };

  wxPython = self.wxPython30;

  vcrpy = callPackage ../development/python2-modules/vcrpy { };

  zeek = disabled super.zeek;

  zipp = callPackage ../development/python2-modules/zipp { };

}
