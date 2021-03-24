# Extension with Python 2 packages that is overlayed on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self; with super; {

  appleseed = toPythonModule (pkgs.appleseed.override { inherit (self) python; });

  arrow = callPackage ../development/python-modules/arrow/2.nix { };

  astroid = callPackage ../development/python-modules/astroid/1.6.nix { };

  browsermob-proxy = callPackage ../development/python-modules/browsermob-proxy { };

  cairocffi = callPackage ../development/python-modules/cairocffi/0_9.nix { };

  cairosvg = callPackage ../development/python-modules/cairosvg/1_x.nix { };

  chardet = callPackage ../development/python-modules/chardet/2.nix { };

  cherrypi = callPackage ../development/python-modules/cherrypy/17.nix { };

  dnspython = super.dnspython_1;

  docker-py = disabled super.docker-py;

  dulwich = callPackage ../development/python-modules/dulwich/0_19.nix { };

  faulthandler = callPackage ../development/python-modules/faulthandler { };

  feedparser = callPackage ../development/python-modules/feedparser/5.nix { };

  flit-core = disabled super.flit-core;

  fontforge = disabled super.fontforge;

  gaia = disabledIf (isPyPy || isPy3k) (toPythonModule (pkgs.gaia.override {
    pythonPackages = self;
    pythonSupport = true;
  })); # gaia isn't supported with python3 and it's not available from pypi

  geant4 = disabled super.geant4;

  geopy = callPackage ../development/python-modules/geopy/2.nix { };

  # Python 2.7 support was deprecated but is still needed by weboob and duplicity
  google-api-python-client = super.google-api-python-client.overridePythonAttrs (old: rec {
    version = "1.7.6";
    src = old.src.override {
      inherit version;
      sha256 = "14w5sdrp0bk9n0r2lmpqmrbf2zclpfq6q7giyahnskkfzdkb165z";
    };
  });

  gwyddion = toPythonModule (pkgs.gwyddion.override {
    pythonSupport = true;
    pythonPackages = self;
  });

  html2text = callPackage ../development/python-modules/html2text/2018.nix { };

  httpretty = callPackage ../development/python-modules/httpretty/0.nix { };

  hypothesis = super.hypothesis_4;

  idna = callPackage ../development/python-modules/idna/2.nix { };

  imagecodecs-lite = disabled super.imagecodecs-lite;

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata/2.nix { };

  isort = callPackage ../development/python-modules/isort/4.nix { };

  jupyter_client = callPackage ../development/python-modules/jupyter_client/5.nix { };

  jupyter_console = callPackage ../development/python-modules/jupyter_console/5.nix { };

  keyring = callPackage ../development/python-modules/keyring/2.nix { };

  kicad = disabled super.kicad;

  kiwisolver = callPackage ../development/python-modules/kiwisolver/1_1.nix { };

  libgpiod = disabled super.libgpiod;

  libnl-python = toPythonModule (pkgs.libnl.override {
    pythonSupport = true;
    inherit python;
  }).py;

  libplist = toPythonModule (pkgs.libplist.override {
    enablePython = true;
    inherit python;
  }).py;

  libvirt = callPackage ../development/python-modules/libvirt/5.9.0.nix {
    libvirt = pkgs.libvirt_5_9_0;
  };

  markdown = callPackage ../development/python-modules/markdown/3_1.nix { };

  matplotlib = callPackage ../development/python-modules/matplotlib/2.nix {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  mercurial = disabled super.mercurial;

  meson = disabled super.meson;

  monosat = disabled super.monosat;

  more-itertools = callPackage ../development/python-modules/more-itertools/2.7.nix { };

  nbformat = callPackage ../development/python-modules/nbformat/2.nix { };

  networkx = callPackage ../development/python-modules/networkx/2.2.nix { };

  notebook = callPackage ../development/python-modules/notebook/2.nix { };

  opencv = toPythonModule (pkgs.opencv.override {
    enablePython = true;
    pythonPackages = self;
  });

  openpyxl = callPackage ../development/python-modules/openpyxl/2.nix { };

  openwrt-luci-rpc = disabled super.openwrt-luci-rpc;

  opt-einsum = callPackage ../development/python-modules/opt-einsum/2.nix { };

  packaging = callPackage ../development/python-modules/packaging/2.nix { };

  pandas = callPackage ../development/python-modules/pandas/2.nix { };

  pathpy = callPackage ../development/python-modules/path.py/2.nix { };

  pip = callPackage ../development/python-modules/pip/20.nix { };

  postorius = disabled super.postorius;

  praw = callPackage ../development/python-modules/praw/6.3.nix { };

  prettytable = callPackage ../development/python-modules/prettytable/1.nix { };

  prompt_toolkit = callPackage ../development/python-modules/prompt_toolkit/1.nix { };

  pycangjie = disabled pycangjie;

  pydns = callPackage ../development/python-modules/pydns { };

  pydocstyle = callPackage ../development/python-modules/pydocstyle/2.nix { };

  pyexiv2 = toPythonModule (callPackage ../development/python-modules/pyexiv2 { });

  pygments = callPackage ../development/python-modules/Pygments/2_5.nix { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.36.nix {
    inherit (pkgs) meson;
  };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest/1.nix { };

  pylibacl = callPackage ../development/python-modules/pylibacl/0.5.nix { };

  pylint = callPackage ../development/python-modules/pylint/1.9.nix { };

  pyroma = callPackage ../development/python-modules/pyroma/2.nix { };

  pytest = pytest_4;

  pytest-mock = callPackage ../development/python-modules/pytest-mock/2.nix { };

  pytestrunner = callPackage ../development/python-modules/pytestrunner/2.nix { };

  pyxattr = super.pyxattr.overridePythonAttrs (oldAttrs: rec {
    version = "0.6.1";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "b525843f6b51036198b3b87c4773a5093d6dec57d60c18a1f269dd7059aa16e3";
    };
  });

  pyxml = callPackage ../development/python-modules/pyxml { };

  rhpl = callPackage ../development/python-modules/rhpl { };

  rivet = disabled super.rivet;

  rpm = disabled super.rpm;

  rpy2 = callPackage ../development/python-modules/rpy2/2.nix { };

  rsa = callPackage ../development/python-modules/rsa/4_0.nix { };

  scikitlearn = callPackage ../development/python-modules/scikitlearn/0.20.nix {
    inherit (pkgs) gfortran glibcLocales;
  };

  scipy = super.scipy.overridePythonAttrs (oldAttrs: rec {
    version = "1.2.2";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "a4331e0b8dab1ff75d2c67b5158a8bb9a83c799d7140094dda936d876c7cfbb1";
    };
  });

  seaborn = callPackage ../development/python-modules/seaborn/0.9.1.nix { };

  secretstorage = callPackage ../development/python-modules/secretstorage/2.nix { };

  sequoia = disabled super.sequoia;

  setuptools_scm = callPackage ../development/python-modules/setuptools_scm/2.nix { };

  soupsieve = callPackage ../development/python-modules/soupsieve/1.nix { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport/1_1.nix { };

  sphinx = callPackage ../development/python-modules/sphinx/2.nix { };

  sympy = callPackage ../development/python-modules/sympy/1_5.nix { };

  tables = callPackage ../development/python-modules/tables/3.5.nix { };

  tokenizers = disabled super.tokenizers;

  tokenize-rt = disabled super.tokenize-rt;

  toolz = callPackage ../development/python-modules/toolz/2.nix { };

  tornado = callPackage ../development/python-modules/tornado/5.nix { };

  traitlets = callPackage ../development/python-modules/traitlets/4.nix { };

  urllib3 = callPackage ../development/python-modules/urllib3/2.nix { };

  xenomapper = disabled super.xenomapper;

  zeek = disablede super.zeek;

}
