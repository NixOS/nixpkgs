# Extension with Python 2 packages that is overlayed on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self; with super; {

  boto3 = callPackage ../development/python-modules/boto3/1_17.nix {};

  botocore = callPackage ../development/python-modules/botocore/1_20.nix {};

  certifi = callPackage ../development/python-modules/certifi/python2.nix { };

  chardet = callPackage ../development/python-modules/chardet/2.nix { };

  cheetah = callPackage ../development/python-modules/cheetah { };

  click = callPackage ../development/python-modules/click/7.nix { };

  configparser = callPackage ../development/python-modules/configparser/4.nix { };

  construct = callPackage ../development/python-modules/construct/2.10.54.nix { };

  contextlib2 = callPackage ../development/python-modules/contextlib2/0.nix { };

  cryptography = callPackage ../development/python-modules/cryptography/3.3.nix { };

  cryptography_vectors = callPackage ../development/python-modules/cryptography/vectors-3.3.nix { };

  decorator = callPackage ../development/python-modules/decorator/4.nix { };

  enum = callPackage ../development/python-modules/enum { };

  filelock =  callPackage ../development/python-modules/filelock/3.2.nix { };

  flask = callPackage ../development/python-modules/flask/1.nix { };

  freezegun = callPackage ../development/python-modules/freezegun/0.3.nix { };

  futures = callPackage ../development/python-modules/futures { };

  google-apputils = callPackage ../development/python-modules/google-apputils { };

  httpretty = callPackage ../development/python-modules/httpretty/0.nix { };

  hypothesis = callPackage ../development/python-modules/hypothesis/2.nix { };

  idna = callPackage ../development/python-modules/idna/2.nix { };

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata/2.nix { };

  ipaddr = callPackage ../development/python-modules/ipaddr { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous/1.nix { };

  jinja2 = callPackage ../development/python-modules/jinja2/2.nix { };

  libcloud = callPackage ../development/python-modules/libcloud/2.nix { };

  lpod = callPackage ../development/python-modules/lpod { };

  marisa = callPackage ../development/python-modules/marisa {
    inherit (pkgs) marisa;
  };

  markdown = callPackage ../development/python-modules/markdown/3_1.nix { };

  markupsafe = callPackage ../development/python-modules/markupsafe/1.nix { };

  mock = callPackage ../development/python-modules/mock/2.nix { };

  more-itertools = callPackage ../development/python-modules/more-itertools/2.7.nix { };

  mutagen = callPackage ../development/python-modules/mutagen/1.43.nix { };

  numpy = callPackage ../development/python-modules/numpy/1.16.nix { };

  packaging = callPackage ../development/python-modules/packaging/2.nix { };

  pillow = callPackage ../development/python-modules/pillow/6.nix {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11;
  };

  pip = callPackage ../development/python-modules/pip/20.nix { };

  pluggy = callPackage ../development/python-modules/pluggy/0.nix { };

  prettytable = callPackage ../development/python-modules/prettytable/1.nix { };

  protobuf = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    protobuf = pkgs.protobuf3_17; # last version compatible with Python 2
  };

  pycairo = callPackage ../development/python-modules/pycairo/1.18.nix {
    inherit (pkgs.buildPackages) meson;
  };

  pygments = callPackage ../development/python-modules/Pygments/2_5.nix { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.36.nix {
    inherit (pkgs) meson;
  };

  pygtk = callPackage ../development/python-modules/pygtk { };

  pyGtkGlade = self.pygtk.override {
    inherit (pkgs.gnome2) libglade;
  };

  pyjwt = callPackage ../development/python-modules/pyjwt/1.nix { };

  pyroma = callPackage ../development/python-modules/pyroma/2.nix { };

  pysqlite = callPackage ../development/python-modules/pysqlite { };

  pytest = pytest_4;

  pytest-runner = callPackage ../development/python-modules/pytest-runner/2.nix { };

  pytest-xdist = callPackage ../development/python-modules/pytest-xdist/1.nix { };

  qpid-python = callPackage ../development/python-modules/qpid-python { };

  recoll = disabled super.recoll;

  rivet = disabled super.rivet;

  rpm = disabled super.rpm;

  s3transfer = callPackage ../development/python-modules/s3transfer/0_4.nix { };

  scandir = callPackage ../development/python-modules/scandir { };

  sequoia = disabled super.sequoia;

  setuptools = callPackage ../development/python-modules/setuptools/44.0.nix { };

  setuptools-scm = callPackage ../development/python-modules/setuptools-scm/2.nix { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport/1_1.nix { };

  sphinx = callPackage ../development/python-modules/sphinx/2.nix { };

  TurboCheetah = callPackage ../development/python-modules/TurboCheetah { };

  typing = callPackage ../development/python-modules/typing { };

  urllib3 = callPackage ../development/python-modules/urllib3/2.nix { };

  werkzeug = callPackage ../development/python-modules/werkzeug/1.nix { };

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
  };

  wxPython = self.wxPython30;

  vcrpy = callPackage ../development/python-modules/vcrpy/3.nix { };

  yenc = callPackage ../development/python-modules/yenc { };

  yt = callPackage ../development/python-modules/yt { };

  zeek = disabled super.zeek;

  zipp = callPackage ../development/python-modules/zipp/1.nix { };

}
