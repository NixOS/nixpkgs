# Extension with Python 2 packages that is overlayed on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self; with super; {

  affinity = callPackage ../development/python-modules/affinity { };

  antlr4-python2-runtime = callPackage ../development/python-modules/antlr4-python2-runtime {
    inherit (pkgs) antlr4;
  };

  appleseed = toPythonModule (pkgs.appleseed.override { inherit (self) python; });

  application = callPackage ../development/python-modules/application { };

  arrow = callPackage ../development/python-modules/arrow/2.nix { };

  ase = callPackage ../development/python-modules/ase/3.17.nix { };

  astroid = callPackage ../development/python-modules/astroid/1.6.nix { };

  backports_lzma = callPackage ../development/python-modules/backports_lzma { };

  backports_os = callPackage ../development/python-modules/backports_os { };

  bcrypt = callPackage ../development/python-modules/bcrypt/3_1.nix { };

  bitbucket_api = callPackage ../development/python-modules/bitbucket-api { };

  bitbucket-cli = callPackage ../development/python-modules/bitbucket-cli { };

  blivet = callPackage ../development/python-modules/blivet { };

  box2d = callPackage ../development/python-modules/box2d { };

  boto3 = callPackage ../development/python-modules/boto3/1_17.nix {};

  botocore = callPackage ../development/python-modules/botocore/1_20.nix {};

  browsermob-proxy = callPackage ../development/python-modules/browsermob-proxy { };

  cairocffi = callPackage ../development/python-modules/cairocffi/0_9.nix { };

  cairosvg = callPackage ../development/python-modules/cairosvg/1_x.nix { };

  CDDB = callPackage ../development/python-modules/cddb { };

  cdecimal = callPackage ../development/python-modules/cdecimal { };

  certifi = callPackage ../development/python-modules/certifi/python2.nix { };

  chardet = callPackage ../development/python-modules/chardet/2.nix { };

  cheetah = callPackage ../development/python-modules/cheetah { };

  cherrypi = callPackage ../development/python-modules/cherrypy/17.nix { };

  cjson = callPackage ../development/python-modules/cjson { };

  cliapp = callPackage ../development/python-modules/cliapp { };

  click = callPackage ../development/python-modules/click/7.nix { };

  closure-linter = callPackage ../development/python-modules/closure-linter { };

  cmdtest = callPackage ../development/python-modules/cmdtest { };

  coilmq = callPackage ../development/python-modules/coilmq { };

  configparser = callPackage ../development/python-modules/configparser/4.nix { };

  construct = callPackage ../development/python-modules/construct/2.10.54.nix { };

  contextlib2 = callPackage ../development/python-modules/contextlib2/0.nix { };

  convertdate = callPackage ../development/python-modules/convertdate/2.2.x.nix { };

  cryptography = callPackage ../development/python-modules/cryptography/3.3.nix { };

  cryptography_vectors = callPackage ../development/python-modules/cryptography/vectors-3.3.nix { };

  darcsver = callPackage ../development/python-modules/darcsver { };

  dateparser = callPackage ../development/python-modules/dateparser/0.x.nix { };

  decorator = callPackage ../development/python-modules/decorator/4.nix { };

  deskcon = callPackage ../development/python-modules/deskcon { };

  django_evolution = callPackage ../development/python-modules/django_evolution { };

  dnspython = callPackage ../development/python-modules/dnspython/1.nix { };

  docker-py = disabled super.docker-py;

  dtopt = callPackage ../development/python-modules/dtopt { };

  dulwich = callPackage ../development/python-modules/dulwich/0_19.nix { };

  enum = callPackage ../development/python-modules/enum { };

  eventlib = callPackage ../development/python-modules/eventlib { };

  faulthandler = callPackage ../development/python-modules/faulthandler { };

  fdint = callPackage ../development/python-modules/fdint { };

  feedparser = callPackage ../development/python-modules/feedparser/5.nix { };

  flask = callPackage ../development/python-modules/flask/1.nix { };

  flask_ldap_login = callPackage ../development/python-modules/flask-ldap-login { };

  flit = disabled super.flit;

  flit-core = disabled super.flit-core;

  flup = callPackage ../development/python-modules/flup { };

  fontforge = disabled super.fontforge;

  freezegun = callPackage ../development/python-modules/freezegun/0.3.nix { };

  fudge = callPackage ../development/python-modules/fudge { };

  futures = callPackage ../development/python-modules/futures { };

  gdcm = disabled super.gdcm;

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

  gateone = callPackage ../development/python-modules/gateone { };

  gdrivefs = callPackage ../development/python-modules/gdrivefs { };

  gsd = callPackage ../development/python-modules/gsd/1.7.nix { };

  gnutls = callPackage ../development/python-modules/gnutls { };

  google-apputils = callPackage ../development/python-modules/google-apputils { };

  grib-api = disabledIf (!isPy27) (toPythonModule (pkgs.grib-api.override {
    enablePython = true;
    pythonPackages = self;
  }));

  gunicorn = callPackage ../development/python-modules/gunicorn/19.nix { };

  gwyddion = toPythonModule (pkgs.gwyddion.override {
    pythonSupport = true;
    pythonPackages = self;
  });

  hg-git = callPackage ../development/python-modules/hg-git/0.8.nix { };

  hgsvn = callPackage ../development/python-modules/hgsvn { };

  hsaudiotag = callPackage ../development/python-modules/hsaudiotag { };

  html2text = callPackage ../development/python-modules/html2text/2018.nix { };

  httpretty = callPackage ../development/python-modules/httpretty/0.nix { };

  http_signature = callPackage ../development/python-modules/http_signature { };

  hypothesis = callPackage ../development/python-modules/hypothesis/2.nix { };

  idna = callPackage ../development/python-modules/idna/2.nix { };

  imagecodecs-lite = disabled super.imagecodecs-lite;

  imbalanced-learn = callPackage ../development/python-modules/imbalanced-learn/0.4.nix { };

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata/2.nix { };

  importlib-resources = callPackage ../development/python-modules/importlib-resources/2.nix { };

  ipaddr = callPackage ../development/python-modules/ipaddr { };

  ipykernel = callPackage ../development/python-modules/ipykernel/4.nix { };

  ipython = callPackage ../development/python-modules/ipython/5.nix { };

  isort = callPackage ../development/python-modules/isort/4.nix { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous/1.nix { };

  jaraco_functools = callPackage ../development/python-modules/jaraco_functools/2.nix { };

  jaraco_stream = callPackage ../development/python-modules/jaraco_stream/2.nix { };

  jinja2 = callPackage ../development/python-modules/jinja2/2.nix { };

  jsonrpclib = callPackage ../development/python-modules/jsonrpclib { };

  jupyter-client = callPackage ../development/python-modules/jupyter-client/5.nix { };

  jupyter_console = callPackage ../development/python-modules/jupyter_console/5.nix { };

  keyring = callPackage ../development/python-modules/keyring/2.nix { };

  koji = callPackage ../development/python-modules/koji { };

  konfig = callPackage ../development/python-modules/konfig { };

  kicad = disabled super.kicad;

  kiwisolver = callPackage ../development/python-modules/kiwisolver/1_1.nix { };

  larch = callPackage ../development/python-modules/larch { };

  Lasagne = callPackage ../development/python-modules/lasagne { };

  le = callPackage ../development/python-modules/le { };

  libcloud = callPackage ../development/python-modules/libcloud/2.nix { };

  libgpiod = disabled super.libgpiod;

  libnl-python = toPythonModule (pkgs.libnl.override {
    pythonSupport = true;
    inherit python;
  }).py;

  libplist = toPythonModule (pkgs.libplist.override {
    enablePython = true;
    inherit python;
  }).py;

  libtorrent-rasterbar = (toPythonModule (pkgs.libtorrent-rasterbar-1_2_x.override { inherit python; })).python;

  libvirt = callPackage ../development/python-modules/libvirt/5.9.0.nix {
    libvirt = pkgs.libvirt_5_9_0;
  };

  lightblue = callPackage ../development/python-modules/lightblue { };

  lirc = disabled super.lirc;

  lpod = callPackage ../development/python-modules/lpod { };

  lsi = callPackage ../development/python-modules/lsi { };

  lxc = callPackage ../development/python-modules/lxc { };

  mapsplotlib = callPackage ../development/python-modules/mapsplotlib { };

  marionette-harness = callPackage ../development/python-modules/marionette-harness { };

  marisa = callPackage ../development/python-modules/marisa {
    inherit (pkgs) marisa;
  };

  marionette_driver = callPackage ../development/python-modules/marionette-harness/marionette_driver.nix { };

  markdown = callPackage ../development/python-modules/markdown/3_1.nix { };

  markupsafe = callPackage ../development/python-modules/markupsafe/1.nix { };

  matplotlib = callPackage ../development/python-modules/matplotlib/2.nix {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  meliae = callPackage ../development/python-modules/meliae { };

  mercurial = disabled super.mercurial;

  meson = disabled super.meson;

  metaphone = callPackage ../development/python-modules/metaphone { };

  mlt = disabled super.mlt;

  mock = callPackage ../development/python-modules/mock/2.nix { };

  # Needed here because moinmoin is loaded as a Python library.
  moinmoin = callPackage ../development/python-modules/moinmoin { };

  monosat = disabled super.monosat;

  more-itertools = callPackage ../development/python-modules/more-itertools/2.7.nix { };

  mozcrash = callPackage ../development/python-modules/marionette-harness/mozcrash.nix { };

  mozdevice = callPackage ../development/python-modules/marionette-harness/mozdevice.nix { };

  mozfile = callPackage ../development/python-modules/marionette-harness/mozfile.nix { };

  mozhttpd = callPackage ../development/python-modules/marionette-harness/mozhttpd.nix { };

  mozinfo = callPackage ../development/python-modules/marionette-harness/mozinfo.nix { };

  mozlog = callPackage ../development/python-modules/marionette-harness/mozlog.nix { };

  moznetwork = callPackage ../development/python-modules/marionette-harness/moznetwork.nix { };

  mozprocess = callPackage ../development/python-modules/marionette-harness/mozprocess.nix { };

  mozprofile = callPackage ../development/python-modules/marionette-harness/mozprofile.nix { };

  mozterm = callPackage ../development/python-modules/mozterm { };

  mozrunner = callPackage ../development/python-modules/marionette-harness/mozrunner.nix { };

  mozsvc = callPackage ../development/python-modules/mozsvc { };

  moztest = callPackage ../development/python-modules/marionette-harness/moztest.nix { };

  mozversion = callPackage ../development/python-modules/marionette-harness/mozversion.nix { };

  mpd = callPackage ../development/python-modules/mpd { };

  mrbob = callPackage ../development/python-modules/mrbob { };

  msrplib = callPackage ../development/python-modules/msrplib { };

  mwlib = callPackage ../development/python-modules/mwlib { };

  mwlib-ext = callPackage ../development/python-modules/mwlib-ext { };

  mwlib-rl = callPackage ../development/python-modules/mwlib-rl { };

  mutagen = callPackage ../development/python-modules/mutagen/1.43.nix { };

  muttils = callPackage ../development/python-modules/muttils { };

  namebench = callPackage ../development/python-modules/namebench { };

  nbformat = callPackage ../development/python-modules/nbformat/2.nix { };

  networkx = callPackage ../development/python-modules/networkx/2.2.nix { };

  nevow = callPackage ../development/python-modules/nevow { };

  # This is used for NixOps to make sure we won't break it with the next major version of nixpart.
  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4 { };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  nose-focus = callPackage ../development/python-modules/nose-focus { };

  nose-of-yeti = callPackage ../development/python-modules/nose-of-yeti { };

  notebook = callPackage ../development/python-modules/notebook/2.nix { };

  notify = callPackage ../development/python-modules/notify { };

  numpy = callPackage ../development/python-modules/numpy/1.16.nix { };

  nxt-python = callPackage ../development/python-modules/nxt-python { };

  oauthlib = callPackage ../development/python-modules/oauthlib/3.1.nix { };

  opencv = toPythonModule (pkgs.opencv.override {
    enablePython = true;
    pythonPackages = self;
  });

  openpyxl = callPackage ../development/python-modules/openpyxl/2.nix { };

  openwrt-luci-rpc = disabled super.openwrt-luci-rpc;

  opt-einsum = callPackage ../development/python-modules/opt-einsum/2.nix { };

  packaging = callPackage ../development/python-modules/packaging/2.nix { };

  pagerduty = callPackage ../development/python-modules/pagerduty { };

  pandas = callPackage ../development/python-modules/pandas/2.nix { };

  pathpy = callPackage ../development/python-modules/path.py/2.nix { };

  pg8000 = callPackage ../development/python-modules/pg8000/1_12.nix { };

  pillow = callPackage ../development/python-modules/pillow/6.nix {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11;
  };

  pip = callPackage ../development/python-modules/pip/20.nix { };

  pluggy = callPackage ../development/python-modules/pluggy/0.nix { };

  postorius = disabled super.postorius;

  praw = callPackage ../development/python-modules/praw/6.3.nix { };

  prettytable = callPackage ../development/python-modules/prettytable/1.nix { };

  ldaptor = callPackage ../development/python-modules/ldaptor/19.nix { };

  progressbar231 = callPackage ../development/python-modules/progressbar231 { };

  prompt-toolkit = callPackage ../development/python-modules/prompt-toolkit/1.nix { };

  pyamf = callPackage ../development/python-modules/pyamf { };

  pyblosxom = callPackage ../development/python-modules/pyblosxom { };

  pycairo = callPackage ../development/python-modules/pycairo/1.18.nix {
    inherit (pkgs) meson;
  };

  pycangjie = disabled pycangjie;

  pycarddav = callPackage ../development/python-modules/pycarddav { };

  pycassa = callPackage ../development/python-modules/pycassa { };

  pycryptopp = callPackage ../development/python-modules/pycryptopp { };

  pycurl2 = callPackage ../development/python-modules/pycurl2 { };

  pydns = callPackage ../development/python-modules/pydns { };

  pydocstyle = callPackage ../development/python-modules/pydocstyle/2.nix { };

  pyechonest = callPackage ../development/python-modules/pyechonest { };

  pyexcelerator = callPackage ../development/python-modules/pyexcelerator { };

  pyexiv2 = toPythonModule (callPackage ../development/python-modules/pyexiv2 { });

  pygments = callPackage ../development/python-modules/Pygments/2_5.nix { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.36.nix {
    inherit (pkgs) meson;
  };

  pygtk = callPackage ../development/python-modules/pygtk { };

  pygtksourceview = callPackage ../development/python-modules/pygtksourceview { };

  pyGtkGlade = self.pygtk.override {
    inherit (pkgs.gnome2) libglade;
  };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest/1.nix { };

  pyjwt = callPackage ../development/python-modules/pyjwt/1.nix { };

  pykickstart = callPackage ../development/python-modules/pykickstart { };

  pylibacl = callPackage ../development/python-modules/pylibacl/0.5.nix { };

  pylint = callPackage ../development/python-modules/pylint/1.9.nix { };

  pyobjc = if stdenv.isDarwin then
    callPackage ../development/python-modules/pyobjc { }
  else
    throw "pyobjc can only be built on Mac OS";

  pyPdf = callPackage ../development/python-modules/pypdf { };

  pypoppler = callPackage ../development/python-modules/pypoppler { };

  pyreport = callPackage ../development/python-modules/pyreport { };

  pyroma = callPackage ../development/python-modules/pyroma/2.nix { };

  pysqlite = callPackage ../development/python-modules/pysqlite { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pytest = pytest_4;

  pytest-mock = callPackage ../development/python-modules/pytest-mock/2.nix { };

  pytest-runner = callPackage ../development/python-modules/pytest-runner/2.nix { };

  pytest-xdist = callPackage ../development/python-modules/pytest-xdist/1.nix { };

  python-otr = callPackage ../development/python-modules/python-otr { };

  python_statsd = callPackage ../development/python-modules/python_statsd { };

  python-sybase = callPackage ../development/python-modules/sybase { };

  python2-pythondialog = callPackage ../development/python-modules/python2-pythondialog { };

  pythonIRClib = callPackage ../development/python-modules/pythonirclib { };

  pythonmagick = callPackage ../development/python-modules/pythonmagick { };

  pyutil = callPackage ../development/python-modules/pyutil { };

  pyxattr = super.pyxattr.overridePythonAttrs (oldAttrs: rec {
    version = "0.6.1";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "b525843f6b51036198b3b87c4773a5093d6dec57d60c18a1f269dd7059aa16e3";
    };
  });

  PyWebDAV = callPackage ../development/python-modules/pywebdav { };

  pyxml = callPackage ../development/python-modules/pyxml { };

  qpid-python = callPackage ../development/python-modules/qpid-python { };

  qserve = callPackage ../development/python-modules/qserve { };

  remotecv = callPackage ../development/python-modules/remotecv { };

  rhpl = callPackage ../development/python-modules/rhpl { };

  rivet = disabled super.rivet;

  robotframework-ride = callPackage ../development/python-modules/robotframework-ride { };

  ruamel-ordereddict = self.ruamel_ordereddict;
  ruamel_ordereddict = callPackage ../development/python-modules/ruamel_ordereddict { };

  ruamel_yaml = self.ruamel-yaml;
  ruamel-yaml = callPackage ../development/python-modules/ruamel_yaml/0.16.nix { };

  runsnakerun = callPackage ../development/python-modules/runsnakerun { };

  rpm = disabled super.rpm;

  rpkg = callPackage ../development/python-modules/rpkg { };

  rpy2 = callPackage ../development/python-modules/rpy2/2.nix { };

  rsa = callPackage ../development/python-modules/rsa/4_0.nix { };

  s3transfer = callPackage ../development/python-modules/s3transfer/0_4.nix { };

  sandboxlib = callPackage ../development/python-modules/sandboxlib { };

  scandir = callPackage ../development/python-modules/scandir { };

  scikit-learn = callPackage ../development/python-modules/scikit-learn/0.20.nix {
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

  semantic = callPackage ../development/python-modules/semantic { };

  serversyncstorage = callPackage ../development/python-modules/serversyncstorage { };

  sequoia = disabled super.sequoia;

  setuptools = callPackage ../development/python-modules/setuptools/44.0.nix { };

  setuptools-scm = callPackage ../development/python-modules/setuptools-scm/2.nix { };

  setuptoolsDarcs = callPackage ../development/python-modules/setuptoolsdarcs { };

  simpleai = callPackage ../development/python-modules/simpleai { };

  simpleparse = callPackage ../development/python-modules/simpleparse { };

  singledispatch = callPackage ../development/python-modules/singledispatch { };

  sipsimple = callPackage ../development/python-modules/sipsimple { };

  slowaes = callPackage ../development/python-modules/slowaes { };

  smartdc = callPackage ../development/python-modules/smartdc { };

  snug = callPackage ../development/python-modules/snug { };

  soupsieve = callPackage ../development/python-modules/soupsieve/1.nix { };

  spambayes = callPackage ../development/python-modules/spambayes { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport/1_1.nix { };

  sphinx = callPackage ../development/python-modules/sphinx/2.nix { };

  sqlite3dbm = callPackage ../development/python-modules/sqlite3dbm { };

  squaremap = callPackage ../development/python-modules/squaremap { };

  stompclient = callPackage ../development/python-modules/stompclient { };

  subliminal = callPackage ../development/python-modules/subliminal { };

  subprocess32 = callPackage ../development/python-modules/subprocess32 { };

  suds = callPackage ../development/python-modules/suds { };

  sympy = callPackage ../development/python-modules/sympy/1_5.nix { };

  tables = callPackage ../development/python-modules/tables/3.5.nix {
    hdf5 = pkgs.hdf5_1_10;
  };

  tarman = callPackage ../development/python-modules/tarman { };

  thumbor = callPackage ../development/python-modules/thumbor { };

  tmdb3 = callPackage ../development/python-modules/tmdb3 { };

  tokenizers = disabled super.tokenizers;

  tokenize-rt = disabled super.tokenize-rt;

  tokenserver = callPackage ../development/python-modules/tokenserver { };

  toolz = callPackage ../development/python-modules/toolz/2.nix { };

  tornado = callPackage ../development/python-modules/tornado/5.nix { };

  traitlets = callPackage ../development/python-modules/traitlets/4.nix { };

  ttystatus = callPackage ../development/python-modules/ttystatus { };

  TurboCheetah = callPackage ../development/python-modules/TurboCheetah { };

  typing = callPackage ../development/python-modules/typing { };

  ujson = callPackage ../development/python-modules/ujson/2.nix { };

  umemcache = callPackage ../development/python-modules/umemcache { };

  urllib3 = callPackage ../development/python-modules/urllib3/2.nix { };

  wptserve = callPackage ../development/python-modules/wptserve { };

  werkzeug = callPackage ../development/python-modules/werkzeug/1.nix { };

  WSGIProxy = callPackage ../development/python-modules/wsgiproxy { };

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
  };

  wxPython = self.wxPython30;

  vcrpy = callPackage ../development/python-modules/vcrpy/3.nix { };

  xcaplib = callPackage ../development/python-modules/xcaplib { };

  xenomapper = disabled super.xenomapper;

  yenc = callPackage ../development/python-modules/yenc { };

  yt = callPackage ../development/python-modules/yt { };

  zeek = disabled super.zeek;

  zbase32 = callPackage ../development/python-modules/zbase32 { };

  zfec = callPackage ../development/python-modules/zfec { };

  zipp = callPackage ../development/python-modules/zipp/1.nix { };

}
