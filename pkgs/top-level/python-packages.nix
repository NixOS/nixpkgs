# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Expressions for Python libraries are supposed to be in `pkgs/development/python-modules/<name>/default.nix`.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

{ pkgs
, stdenv
, python
, overrides ? (self: super: {})
}:

with pkgs.lib;

let
  packages = ( self:

let
  inherit (python.passthru) isPy27 isPy33 isPy34 isPy35 isPy36 isPy37 isPy3k isPyPy pythonAtLeast pythonOlder;

  callPackage = pkgs.newScope self;

  namePrefix = python.libPrefix + "-";

  bootstrapped-pip = callPackage ../development/python-modules/bootstrapped-pip { };

  # Derivations built with `buildPythonPackage` can already be overriden with `override`, `overrideAttrs`, and `overrideDerivation`.
  # This function introduces `overridePythonAttrs` and it overrides the call to `buildPythonPackage`.
  makeOverridablePythonPackage = f: origArgs:
    let
      ff = f origArgs;
      overrideWith = newArgs: origArgs // (if pkgs.lib.isFunction newArgs then newArgs origArgs else newArgs);
    in
      if builtins.isAttrs ff then (ff // {
        overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
      })
      else if builtins.isFunction ff then {
        overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
        __functor = self: ff;
      }
      else ff;

  buildPythonPackage = makeOverridablePythonPackage ( makeOverridable (callPackage ../development/interpreters/python/build-python-package.nix {
    flit = self.flit;
    # We want Python libraries to be named like e.g. "python3.6-${name}"
    inherit namePrefix;
    inherit toPythonModule;
  }));

  buildPythonApplication = makeOverridablePythonPackage ( makeOverridable (callPackage ../development/interpreters/python/build-python-package.nix {
    flit = self.flit;
    namePrefix = "";
    toPythonModule = x: x; # Application does not provide modules.
  }));

  # See build-setupcfg/default.nix for documentation.
  buildSetupcfg = import ../build-support/build-setupcfg self;

  fetchPypi = makeOverridable( {format ? "setuptools", ... } @attrs:
    let
      fetchWheel = {pname, version, sha256, python ? "py2.py3", abi ? "none", platform ? "any"}:
      # Fetch a wheel. By default we fetch an universal wheel.
      # See https://www.python.org/dev/peps/pep-0427/#file-name-convention for details regarding the optional arguments.
        let
          url = "https://files.pythonhosted.org/packages/${python}/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}-${python}-${abi}-${platform}.whl";
        in pkgs.fetchurl {inherit url sha256;};
      fetchSource = {pname, version, sha256, extension ? "tar.gz"}:
      # Fetch a source tarball.
        let
          url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.${extension}";
        in pkgs.fetchurl {inherit url sha256;};
      fetcher = (if format == "wheel" then fetchWheel
        else if format == "setuptools" then fetchSource
        else throw "Unsupported kind ${kind}");
    in fetcher (builtins.removeAttrs attrs ["format"]) );

  # Check whether a derivation provides a Python module.
  hasPythonModule = drv: drv?pythonModule && drv.pythonModule == python;

  # Get list of required Python modules given a list of derivations.
  requiredPythonModules = drvs: let
    modules = filter hasPythonModule drvs;
  in unique ([python] ++ modules ++ concatLists (catAttrs "requiredPythonModules" modules));

  # Create a PYTHONPATH from a list of derivations. This function recurses into the items to find derivations
  # providing Python modules.
  makePythonPath = drvs: stdenv.lib.makeSearchPath python.sitePackages (requiredPythonModules drvs);

  removePythonPrefix = name:
    removePrefix namePrefix name;

  # Convert derivation to a Python module.
  toPythonModule = drv:
    drv.overrideAttrs( oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or {})// {
        pythonModule = python;
        pythonPath = [ ]; # Deprecated, for compatibility.
        requiredPythonModules = requiredPythonModules drv.propagatedBuildInputs;
      };
    });

  # Convert a Python library to an application.
  toPythonApplication = drv:
    drv.overrideAttrs( oldAttrs: {
      passthru = (oldAttrs.passthru or {}) // {
        # Remove Python prefix from name so we have a "normal" name.
        # While the prefix shows up in the store path, it won't be
        # used by `nix-env`.
        name = removePythonPrefix oldAttrs.name;
        pythonModule = false;
      };
    });

  disabledIf = x: drv:
    if x then throw "${removePythonPrefix (drv.pname or drv.name)} not supported for interpreter ${python.executable}" else drv;

in {

  inherit (python.passthru) isPy27 isPy33 isPy34 isPy35 isPy36 isPy37 isPy3k isPyPy pythonAtLeast pythonOlder;
  inherit python bootstrapped-pip buildPythonPackage buildPythonApplication;
  inherit fetchPypi callPackage;
  inherit hasPythonModule requiredPythonModules makePythonPath disabledIf;
  inherit toPythonModule toPythonApplication;
  inherit buildSetupcfg;

  # helpers

  wrapPython = callPackage ../development/interpreters/python/wrap-python.nix {inherit python; inherit (pkgs) makeSetupHook makeWrapper; };

  # specials

  recursivePthLoader = callPackage ../development/python-modules/recursive-pth-loader { };

  setuptools = toPythonModule (callPackage ../development/python-modules/setuptools { });

  vowpalwabbit = callPackage ../development/python-modules/vowpalwabbit {
    boost = pkgs.boost160;
  };

  acoustics = callPackage ../development/python-modules/acoustics { };

  py3to2 = callPackage ../development/python-modules/3to2 { };

  absl-py = callPackage ../development/python-modules/absl-py { };

  aenum = callPackage ../development/python-modules/aenum { };

  affinity = callPackage ../development/python-modules/affinity { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  alerta = callPackage ../development/python-modules/alerta { };

  alerta-server = callPackage ../development/python-modules/alerta-server { };

  androguard = callPackage ../development/python-modules/androguard { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  aioimaplib = callPackage ../development/python-modules/aioimaplib { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  argon2_cffi = callPackage ../development/python-modules/argon2_cffi { };

  asana = callPackage ../development/python-modules/asana { };

  asciimatics = callPackage ../development/python-modules/asciimatics { };

  ase = callPackage ../development/python-modules/ase { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  aspy-yaml = callPackage ../development/python-modules/aspy.yaml { };

  astral = callPackage ../development/python-modules/astral { };

  astropy = callPackage ../development/python-modules/astropy { };

  astroquery = callPackage ../development/python-modules/astroquery { };

  atom = callPackage ../development/python-modules/atom { };

  augeas = callPackage ../development/python-modules/augeas {
    inherit (pkgs) augeas;
  };

  authres = callPackage ../development/python-modules/authres { };

  autograd = callPackage ../development/python-modules/autograd { };

  autologging = callPackage ../development/python-modules/autologging { };

  automat = callPackage ../development/python-modules/automat { };

  awkward = callPackage ../development/python-modules/awkward { };

  aws-sam-translator = callPackage ../development/python-modules/aws-sam-translator { };

  aws-xray-sdk = callPackage ../development/python-modules/aws-xray-sdk { };

  aws-adfs = callPackage ../development/python-modules/aws-adfs { };

  atomman = callPackage ../development/python-modules/atomman { };

  # packages defined elsewhere

  amazon_kclpy = callPackage ../development/python-modules/amazon_kclpy { };

  ansiconv = callPackage ../development/python-modules/ansiconv { };

  azure = callPackage ../development/python-modules/azure { };

  azure-nspkg = callPackage ../development/python-modules/azure-nspkg { };

  azure-common = callPackage ../development/python-modules/azure-common { };

  azure-mgmt-common = callPackage ../development/python-modules/azure-mgmt-common { };

  azure-mgmt-compute = callPackage ../development/python-modules/azure-mgmt-compute { };

  azure-mgmt-network = callPackage ../development/python-modules/azure-mgmt-network { };

  azure-mgmt-nspkg = callPackage ../development/python-modules/azure-mgmt-nspkg { };

  azure-mgmt-resource = callPackage ../development/python-modules/azure-mgmt-resource { };

  azure-mgmt-storage = callPackage ../development/python-modules/azure-mgmt-storage { };

  azure-storage = callPackage ../development/python-modules/azure-storage { };

  azure-storage-nspkg = callPackage ../development/python-modules/azure-storage-nspkg { };

  azure-storage-common = callPackage ../development/python-modules/azure-storage-common { };

  azure-storage-blob = callPackage ../development/python-modules/azure-storage-blob { };

  azure-storage-file = callPackage ../development/python-modules/azure-storage-file { };

  azure-storage-queue = callPackage ../development/python-modules/azure-storage-queue { };

  azure-servicemanagement-legacy = callPackage ../development/python-modules/azure-servicemanagement-legacy { };

  backports_csv = callPackage ../development/python-modules/backports_csv {};

  backports-shutil-which = callPackage ../development/python-modules/backports-shutil-which {};

  bap = callPackage ../development/python-modules/bap {
    bap = pkgs.ocamlPackages.bap;
  };

  bash_kernel = callPackage ../development/python-modules/bash_kernel { };

  bayespy = callPackage ../development/python-modules/bayespy { };

  bitarray = callPackage ../development/python-modules/bitarray { };

  bitcoinlib = callPackage ../development/python-modules/bitcoinlib { };

  bitcoin-price-api = callPackage ../development/python-modules/bitcoin-price-api { };

  blivet = callPackage ../development/python-modules/blivet { };

  boltons = callPackage ../development/python-modules/boltons { };

  braintree = callPackage ../development/python-modules/braintree { };

  django-sesame = callPackage ../development/python-modules/django-sesame { };

  breathe = callPackage ../development/python-modules/breathe { };

  brotli = callPackage ../development/python-modules/brotli { };

  broadlink = callPackage ../development/python-modules/broadlink { };

  browser-cookie3 = callPackage ../development/python-modules/browser-cookie3 { };

  browsermob-proxy = disabledIf isPy3k (callPackage ../development/python-modules/browsermob-proxy {});

  bt_proximity = callPackage ../development/python-modules/bt-proximity { };

  bugseverywhere = callPackage ../applications/version-management/bugseverywhere {};

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cachy = callPackage ../development/python-modules/cachy { };

  cdecimal = callPackage ../development/python-modules/cdecimal { };

  cfn-flip = callPackage ../development/python-modules/cfn-flip { };
 
  chalice = callPackage ../development/python-modules/chalice { };

  cleo = callPackage ../development/python-modules/cleo { };

  clikit = callPackage ../development/python-modules/clikit { };

  clustershell = callPackage ../development/python-modules/clustershell { };

  cozy = callPackage ../development/python-modules/cozy { };

  dendropy = callPackage ../development/python-modules/dendropy { };

  dependency-injector = callPackage ../development/python-modules/dependency-injector { };

  btchip = callPackage ../development/python-modules/btchip { };

  datamodeldict = callPackage ../development/python-modules/datamodeldict { };

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  deap = callPackage ../development/python-modules/deap { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  dictionaries = callPackage ../development/python-modules/dictionaries { };

  diff_cover = callPackage ../development/python-modules/diff_cover { };

  docrep = callPackage ../development/python-modules/docrep { };

  dominate = callPackage ../development/python-modules/dominate { };

  emcee = callPackage ../development/python-modules/emcee { };

  email_validator = callPackage ../development/python-modules/email-validator { };

  ewmh = callPackage ../development/python-modules/ewmh { };

  exchangelib = callPackage ../development/python-modules/exchangelib { };

  dbus-python = callPackage ../development/python-modules/dbus {
    inherit (pkgs) dbus pkgconfig;
  };

  dftfit = callPackage ../development/python-modules/dftfit { };

  discid = callPackage ../development/python-modules/discid { };

  discordpy = callPackage ../development/python-modules/discordpy { };

  parver = callPackage ../development/python-modules/parver { };
  arpeggio = callPackage ../development/python-modules/arpeggio { };
  invoke = callPackage ../development/python-modules/invoke { };

  distorm3 = callPackage ../development/python-modules/distorm3 { };

  distributed = callPackage ../development/python-modules/distributed { };

  docutils = callPackage ../development/python-modules/docutils { };

  dogtail = callPackage ../development/python-modules/dogtail { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  eradicate = callPackage ../development/python-modules/eradicate {  };

  face = callPackage ../development/python-modules/face { };

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 {  };

  favicon = callPackage ../development/python-modules/favicon {  };

  fido2 = callPackage ../development/python-modules/fido2 {  };

  filterpy = callPackage ../development/python-modules/filterpy { };

  fints = callPackage ../development/python-modules/fints { };

  fire = callPackage ../development/python-modules/fire { };

  fdint = callPackage ../development/python-modules/fdint { };

  fuse = callPackage ../development/python-modules/fuse-python {
    inherit (pkgs) fuse pkgconfig;
  };

  fuzzywuzzy = callPackage ../development/python-modules/fuzzywuzzy { };

  genanki = callPackage ../development/python-modules/genanki { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  gin-config = callPackage ../development/python-modules/gin-config { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  glom = callPackage ../development/python-modules/glom { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  grandalf = callPackage ../development/python-modules/grandalf { };

  gprof2dot = callPackage ../development/python-modules/gprof2dot { };

  gsd = callPackage ../development/python-modules/gsd { };

  gssapi = callPackage ../development/python-modules/gssapi { };

  guestfs = callPackage ../development/python-modules/guestfs { };

  h5py = callPackage ../development/python-modules/h5py {
    hdf5 = pkgs.hdf5;
  };

  h5py-mpi = self.h5py.override {
    hdf5 = pkgs.hdf5-mpi;
  };

  ha-ffmpeg = callPackage ../development/python-modules/ha-ffmpeg { };

  habanero = callPackage ../development/python-modules/habanero { };

  helper = callPackage ../development/python-modules/helper { };

  histbook = callPackage ../development/python-modules/histbook { };

  hdmedians = callPackage ../development/python-modules/hdmedians { };

  hoomd-blue = toPythonModule (callPackage ../development/python-modules/hoomd-blue {
    inherit python;
  });

  hopcroftkarp = callPackage ../development/python-modules/hopcroftkarp { };

  httpsig = callPackage ../development/python-modules/httpsig { };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  imutils = callPackage ../development/python-modules/imutils { };

  intelhex = callPackage ../development/python-modules/intelhex { };

  jira = callPackage ../development/python-modules/jira { };

  jwcrypto = callPackage ../development/python-modules/jwcrypto { };

  lammps-cython = callPackage ../development/python-modules/lammps-cython {
    mpi = pkgs.openmpi;
  };

  libmr = callPackage ../development/python-modules/libmr { };

  limitlessled = callPackage ../development/python-modules/limitlessled { };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  logster = callPackage ../development/python-modules/logster { };

  logzero = callPackage ../development/python-modules/logzero { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  manhole = callPackage ../development/python-modules/manhole { };

  markerlib = callPackage ../development/python-modules/markerlib { };

  matchpy = callPackage ../development/python-modules/matchpy { };

  monty = callPackage ../development/python-modules/monty { };

  mininet-python = (toPythonModule (pkgs.mininet.override{ inherit python; })).py;

  mpi4py = callPackage ../development/python-modules/mpi4py {
    mpi = pkgs.openmpi;
  };

  multiset = callPackage ../development/python-modules/multiset { };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python { inherit (pkgs) nanomsg; };

  nbval = callPackage ../development/python-modules/nbval { };

  nest-asyncio = callPackage ../development/python-modules/nest-asyncio { };

  neuron = pkgs.neuron.override {
    inherit python;
  };

  neuron-mpi = pkgs.neuron-mpi.override {
    inherit python;
  };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # This is used for NixOps to make sure we won't break it with the next major
  # version of nixpart.
  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4 { };

  nltk = callPackage ../development/python-modules/nltk { };

  ntlm-auth = callPackage ../development/python-modules/ntlm-auth { };

  nvchecker = callPackage ../development/python-modules/nvchecker { };

  numericalunits = callPackage ../development/python-modules/numericalunits { };

  oauthenticator = callPackage ../development/python-modules/oauthenticator { };

  ordered-set = callPackage ../development/python-modules/ordered-set { };

  osmnx = callPackage ../development/python-modules/osmnx { };

  outcome = callPackage ../development/python-modules/outcome {};

  ovito = toPythonModule (pkgs.libsForQt5.callPackage ../development/python-modules/ovito {
      pythonPackages = self;
    });

  palettable = callPackage ../development/python-modules/palettable { };

  pastel = callPackage ../development/python-modules/pastel { };

  pathlib = callPackage ../development/python-modules/pathlib { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfminer = callPackage ../development/python-modules/pdfminer_six { };

  pdfx = callPackage ../development/python-modules/pdfx { };

  perf = callPackage ../development/python-modules/perf { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  pims = callPackage ../development/python-modules/pims { };

  plantuml = callPackage ../tools/misc/plantuml { };

  poetry = callPackage ../development/python-modules/poetry { };

  pprintpp = callPackage ../development/python-modules/pprintpp { };

  progress = callPackage ../development/python-modules/progress { };

  pymysql = callPackage ../development/python-modules/pymysql { };

  Pmw = callPackage ../development/python-modules/Pmw { };

  py_stringmatching = callPackage ../development/python-modules/py_stringmatching { };

  pyaes = callPackage ../development/python-modules/pyaes { };

  pyairvisual = callPackage ../development/python-modules/pyairvisual { };

  pyamf = callPackage ../development/python-modules/pyamf { };

  pyarrow = callPackage ../development/python-modules/pyarrow {
    inherit (pkgs) arrow-cpp cmake pkgconfig;
  };

  pyannotate = callPackage ../development/python-modules/pyannotate { };

  pyatspi = callPackage ../development/python-modules/pyatspi {
    inherit (pkgs) pkgconfig;
  };

  pyaxmlparser = callPackage ../development/python-modules/pyaxmlparser { };

  pybind11 = callPackage ../development/python-modules/pybind11 { };

  pycairo = callPackage ../development/python-modules/pycairo {
    inherit (pkgs) pkgconfig;
  };

  pycangjie = disabledIf (!isPy3k) (callPackage ../development/python-modules/pycangjie {
    inherit (pkgs) pkgconfig;
  });

  pycrc = callPackage ../development/python-modules/pycrc { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  PyChromecast = callPackage ../development/python-modules/pychromecast { };

  py-cpuinfo = callPackage ../development/python-modules/py-cpuinfo { };

  pydbus = callPackage ../development/python-modules/pydbus { };

  pydocstyle = callPackage ../development/python-modules/pydocstyle { };

  pyexiv2 = disabledIf isPy3k (toPythonModule (callPackage ../development/python-modules/pyexiv2 {}));

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { };

  pyfakefs = callPackage ../development/python-modules/pyfakefs {};

  pyfttt = callPackage ../development/python-modules/pyfttt { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygame_sdl2 = callPackage ../development/python-modules/pygame_sdl2 { };

  pygdbmi = callPackage ../development/python-modules/pygdbmi { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygobject2 = callPackage ../development/python-modules/pygobject {
    inherit (pkgs) pkgconfig;
  };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix {
    inherit (pkgs) pkgconfig;
  };

  pygtail = callPackage ../development/python-modules/pygtail { };

  pygtk = callPackage ../development/python-modules/pygtk {
    inherit (pkgs) pkgconfig;
    libglade = null;
  };

  pygtksourceview = callPackage ../development/python-modules/pygtksourceview {
    inherit (pkgs) pkgconfig;
  };

  pyGtkGlade = self.pygtk.override {
    libglade = pkgs.gnome2.libglade;
  };

  pyjwkest = callPackage ../development/python-modules/pyjwkest { };

  pykde4 = callPackage ../development/python-modules/pykde4 {
    inherit (self) pyqt4;
    callPackage = pkgs.callPackage;
  };

  pykdtree = callPackage ../development/python-modules/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykerberos = callPackage ../development/python-modules/pykerberos { };

  pykeepass = callPackage ../development/python-modules/pykeepass { };

  pylev = callPackage ../development/python-modules/pylev { };

  pymatgen = callPackage ../development/python-modules/pymatgen { };

  pymatgen-lammps = callPackage ../development/python-modules/pymatgen-lammps { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pyparser = callPackage ../development/python-modules/pyparser { };

  pyres = callPackage ../development/python-modules/pyres { };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix {
    pythonPackages = self;
    inherit (pkgs) pkgconfig;
  };

  pyqt5 = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt/5.x.nix {
    pythonPackages = self;
  };

  /*
    `pyqt5_with_qtwebkit` should not be used by python libraries in
    pkgs/development/python-modules/*. Putting this attribute in
    `propagatedBuildInputs` may cause collisions.
  */
  pyqt5_with_qtwebkit = self.pyqt5.override { withWebKit = true; };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscard = callPackage ../development/python-modules/pyscard { inherit (pkgs.darwin.apple_sdk.frameworks) PCSC; };

  pyside = callPackage ../development/python-modules/pyside { };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix {
    inherit (pkgs) libxml2 libxslt; # Do not need the Python bindings.
  };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pyslurm = callPackage ../development/python-modules/pyslurm {
    slurm = pkgs.slurm;
  };

  pyssim = callPackage ../development/python-modules/pyssim { };

  pystache = callPackage ../development/python-modules/pystache { };

  pytesseract = callPackage ../development/python-modules/pytesseract { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-engineio = callPackage ../development/python-modules/python-engineio { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-lz4 = callPackage ../development/python-modules/python-lz4 { };
  lz4 = self.python-lz4; # alias 2018-12-05

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

  python-mnist = callPackage ../development/python-modules/python-mnist { };

  python-igraph = callPackage ../development/python-modules/python-igraph {
    pkgconfig = pkgs.pkgconfig;
    igraph = pkgs.igraph;
  };

  python3-openid = callPackage ../development/python-modules/python3-openid { };

  python-packer = callPackage ../development/python-modules/python-packer { };

  python-periphery = callPackage ../development/python-modules/python-periphery { };

  python-prctl = callPackage ../development/python-modules/python-prctl { };

  python-rapidjson = callPackage ../development/python-modules/python-rapidjson { };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-socketio = callPackage ../development/python-modules/python-socketio { };

  python-utils = callPackage ../development/python-modules/python-utils { };

  pytimeparse =  callPackage ../development/python-modules/pytimeparse { };

  PyWebDAV = callPackage ../development/python-modules/pywebdav { };

  pyxml = disabledIf isPy3k (callPackage ../development/python-modules/pyxml{ });

  pyvcd = callPackage ../development/python-modules/pyvcd { };

  pyvoro = callPackage ../development/python-modules/pyvoro { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  remotecv = callPackage ../development/python-modules/remotecv { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  rhpl = disabledIf isPy3k (callPackage ../development/python-modules/rhpl {});

  rlp = callPackage ../development/python-modules/rlp { };

  rx = callPackage ../development/python-modules/rx { };

  sabyenc = callPackage ../development/python-modules/sabyenc { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  selectors2 = callPackage ../development/python-modules/selectors2 { };

  sepaxml = callPackage ../development/python-modules/sepaxml { };

  serversyncstorage = callPackage ../development/python-modules/serversyncstorage {};

  shellingham = callPackage ../development/python-modules/shellingham {};

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  singledispatch = callPackage ../development/python-modules/singledispatch { };

  sip = callPackage ../development/python-modules/sip { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  slackclient = callPackage ../development/python-modules/slackclient { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  slither-analyzer = callPackage ../development/python-modules/slither-analyzer { };

  sly = callPackage ../development/python-modules/sly { };

  snapcast = callPackage ../development/python-modules/snapcast { };

  spglib = callPackage ../development/python-modules/spglib { };

  sslib = callPackage ../development/python-modules/sslib { };

  statistics = callPackage ../development/python-modules/statistics { };

  sumo = callPackage ../development/python-modules/sumo { };

  supervise_api = callPackage ../development/python-modules/supervise_api { };

  tables = callPackage ../development/python-modules/tables {
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  };

  tableaudocumentapi = callPackage ../development/python-modules/tableaudocumentapi { };

  trueskill = callPackage ../development/python-modules/trueskill { };

  trustme = callPackage ../development/python-modules/trustme {};

  trio = callPackage ../development/python-modules/trio {};

  sniffio = callPackage ../development/python-modules/sniffio { };

  tenacity = callPackage ../development/python-modules/tenacity { };

  tokenserver = callPackage ../development/python-modules/tokenserver {};

  toml = callPackage ../development/python-modules/toml { };

  tomlkit = callPackage ../development/python-modules/tomlkit { };

  unifi = callPackage ../development/python-modules/unifi { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  webapp2 = callPackage ../development/python-modules/webapp2 { };

  pyunbound = callPackage ../tools/networking/unbound/python.nix { };

  WazeRouteCalculator = callPackage ../development/python-modules/WazeRouteCalculator { };

  yarg = callPackage ../development/python-modules/yarg { };

  # packages defined here

  aafigure = callPackage ../development/python-modules/aafigure { };

  altair = callPackage ../development/python-modules/altair { };

  vega = callPackage ../development/python-modules/vega { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  adal = callPackage ../development/python-modules/adal { };

  affine = callPackage ../development/python-modules/affine { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aioh2 = callPackage ../development/python-modules/aioh2 { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp/cors.nix { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aiohttp-socks = callPackage ../development/python-modules/aiohttp-socks { };

  aioprocessing = callPackage ../development/python-modules/aioprocessing { };

  aiorpcx = callPackage ../development/python-modules/aiorpcx { };

  ajpy = callPackage ../development/python-modules/ajpy { };

  alabaster = callPackage ../development/python-modules/alabaster {};

  alembic = callPackage ../development/python-modules/alembic {};

  allpairspy = callPackage ../development/python-modules/allpairspy { };

  ansicolors = callPackage ../development/python-modules/ansicolors {};

  aniso8601 = callPackage ../development/python-modules/aniso8601 {};

  asgiref = callPackage ../development/python-modules/asgiref { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg {};

  python-uinput = callPackage ../development/python-modules/python-uinput {};

  python-sybase = callPackage ../development/python-modules/sybase {};

  alot = callPackage ../development/python-modules/alot {};

  anyjson = callPackage ../development/python-modules/anyjson {};

  amqp = callPackage ../development/python-modules/amqp {};

  amqplib = callPackage ../development/python-modules/amqplib {};

  antlr4-python3-runtime = callPackage ../development/python-modules/antlr4-python3-runtime {};

  apipkg = callPackage ../development/python-modules/apipkg {};

  appdirs = callPackage ../development/python-modules/appdirs { };

  appleseed = disabledIf isPy3k
    (toPythonModule (pkgs.appleseed.override {
      inherit (self) python;
    }));

  application = callPackage ../development/python-modules/application { };

  appnope = callPackage ../development/python-modules/appnope { };

  approvaltests = callPackage ../development/python-modules/approvaltests { };

  apsw = callPackage ../development/python-modules/apsw {};

  astor = callPackage ../development/python-modules/astor {};

  asyncio = callPackage ../development/python-modules/asyncio {};

  asyncssh = callPackage ../development/python-modules/asyncssh { };

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  APScheduler = callPackage ../development/python-modules/APScheduler { };

  args = callPackage ../development/python-modules/args { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  area53 = callPackage ../development/python-modules/area53 { };

  arxiv2bib = callPackage ../development/python-modules/arxiv2bib { };

  chai = callPackage ../development/python-modules/chai { };

  chainmap = callPackage ../development/python-modules/chainmap { };

  arelle = callPackage ../development/python-modules/arelle {
    gui = true;
  };

  arelle-headless = callPackage ../development/python-modules/arelle {
    gui = false;
  };

  deluge-client = callPackage ../development/python-modules/deluge-client { };

  arrow = callPackage ../development/python-modules/arrow { };

  asynctest = callPackage ../development/python-modules/asynctest { };

  async-timeout = callPackage ../development/python-modules/async_timeout { };

  async_generator = callPackage ../development/python-modules/async_generator { };

  asn1ate = callPackage ../development/python-modules/asn1ate { };

  atomiclong = callPackage ../development/python-modules/atomiclong { };

  atomicwrites = callPackage ../development/python-modules/atomicwrites { };

  astroid = if isPy3k then callPackage ../development/python-modules/astroid { }
            else callPackage ../development/python-modules/astroid/1.6.nix { };

  attrdict = callPackage ../development/python-modules/attrdict { };

  attrs = callPackage ../development/python-modules/attrs { };

  atsim_potentials = callPackage ../development/python-modules/atsim_potentials { };

  audio-metadata = callPackage ../development/python-modules/audio-metadata { };

  audioread = callPackage ../development/python-modules/audioread { };

  audiotools = callPackage ../development/python-modules/audiotools { };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  av = callPackage ../development/python-modules/av {
    inherit (pkgs) pkgconfig;
  };

  avro = callPackage ../development/python-modules/avro {};

  avro3k = callPackage ../development/python-modules/avro3k {};

  python-slugify = callPackage ../development/python-modules/python-slugify { };

  awesome-slugify = callPackage ../development/python-modules/awesome-slugify {};

  noise = callPackage ../development/python-modules/noise {};

  backcall = callPackage ../development/python-modules/backcall { };

  backports_abc = callPackage ../development/python-modules/backports_abc { };

  backports_functools_lru_cache = callPackage ../development/python-modules/backports_functools_lru_cache { };

  backports_os = callPackage ../development/python-modules/backports_os { };

  backports_shutil_get_terminal_size = callPackage ../development/python-modules/backports_shutil_get_terminal_size { };

  backports_ssl_match_hostname = if !(pythonOlder "3.5") then null else
    callPackage ../development/python-modules/backports_ssl_match_hostname { };

  backports_lzma = callPackage ../development/python-modules/backports_lzma { };

  backports_tempfile = callPackage ../development/python-modules/backports_tempfile { };

  backports_unittest-mock = callPackage ../development/python-modules/backports_unittest-mock {};

  babelfish = callPackage ../development/python-modules/babelfish {};

  basiciw = callPackage ../development/python-modules/basiciw {
    inherit (pkgs) gcc wirelesstools;
  };

  base58 = callPackage ../development/python-modules/base58 {};

  batinfo = callPackage ../development/python-modules/batinfo {};

  bcdoc = callPackage ../development/python-modules/bcdoc {};

  beancount = callPackage ../development/python-modules/beancount { };

  beautifulsoup4 = callPackage ../development/python-modules/beautifulsoup4 { };

  beaker = callPackage ../development/python-modules/beaker { };

  betamax = callPackage ../development/python-modules/betamax {};

  betamax-matchers = callPackage ../development/python-modules/betamax-matchers { };

  betamax-serializers = callPackage ../development/python-modules/betamax-serializers { };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  bidict = callPackage ../development/python-modules/bidict { };

  binwalk = callPackage ../development/python-modules/binwalk { };

  binwalk-full = appendToName "full" (self.binwalk.override {
    pyqtgraph = self.pyqtgraph;
  });

  bitmath = callPackage ../development/python-modules/bitmath { };

  bitstruct = callPackage ../development/python-modules/bitstruct { };

  caldavclientlibrary-asynk = callPackage ../development/python-modules/caldavclientlibrary-asynk { };

  biopython = callPackage ../development/python-modules/biopython { };

  bedup = callPackage ../development/python-modules/bedup { };

  blessed = callPackage ../development/python-modules/blessed {};

  block-io = callPackage ../development/python-modules/block-io {};

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (pkgs.boost.override {
    inherit (self) python numpy;
    enablePython = true;
  });

  boltztrap2 = callPackage ../development/python-modules/boltztrap2 { };

  bumps = callPackage ../development/python-modules/bumps {};

  cached-property = callPackage ../development/python-modules/cached-property { };

  caffe = pkgs.caffe.override {
    python = self.python;
    boost = self.boost;
    numpy = self.numpy;
  };

  capstone = callPackage ../development/python-modules/capstone { };

  cement = callPackage ../development/python-modules/cement {};

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils {};

  chainer = callPackage ../development/python-modules/chainer {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  channels = callPackage ../development/python-modules/channels {};

  cheroot = callPackage ../development/python-modules/cheroot {};

  cli-helpers = callPackage ../development/python-modules/cli-helpers {};

  cmarkgfm = callPackage ../development/python-modules/cmarkgfm { };

  circus = callPackage ../development/python-modules/circus {};

  colorclass = callPackage ../development/python-modules/colorclass {};

  colorlog = callPackage ../development/python-modules/colorlog { };

  colour = callPackage ../development/python-modules/colour {};

  configshell = callPackage ../development/python-modules/configshell { };

  constantly = callPackage ../development/python-modules/constantly { };

  cornice = callPackage ../development/python-modules/cornice { };

  cram = callPackage ../development/python-modules/cram { };

  csscompressor = callPackage ../development/python-modules/csscompressor {};

  csvkit =  callPackage ../development/python-modules/csvkit { };

  cufflinks = callPackage ../development/python-modules/cufflinks { };

  cupy = callPackage ../development/python-modules/cupy {
    cudatoolkit = pkgs.cudatoolkit_8;
    cudnn = pkgs.cudnn6_cudatoolkit_8;
    nccl = pkgs.nccl;
  };

  cx_Freeze = callPackage ../development/python-modules/cx_freeze {};

  cx_oracle = callPackage ../development/python-modules/cx_oracle {};

  cvxopt = callPackage ../development/python-modules/cvxopt { };

  cycler = callPackage ../development/python-modules/cycler { };

  cysignals = callPackage ../development/python-modules/cysignals { };

  cypari2 = callPackage ../development/python-modules/cypari2 { };

  dlib = callPackage ../development/python-modules/dlib {
    inherit (pkgs) dlib;
  };

  datadog = callPackage ../development/python-modules/datadog {};

  dataclasses = callPackage ../development/python-modules/dataclasses { };

  debian = callPackage ../development/python-modules/debian {};

  defusedxml = callPackage ../development/python-modules/defusedxml {};

  dugong = callPackage ../development/python-modules/dugong {};

  iowait = callPackage ../development/python-modules/iowait {};

  responses = callPackage ../development/python-modules/responses {};

  rarfile = callPackage ../development/python-modules/rarfile { inherit (pkgs) libarchive; };

  proboscis = callPackage ../development/python-modules/proboscis {};

  py4j = callPackage ../development/python-modules/py4j { };

  pyechonest = callPackage ../development/python-modules/pyechonest { };

  pyepsg = callPackage ../development/python-modules/pyepsg { };

  pyezminc = callPackage ../development/python-modules/pyezminc { };

  billiard = callPackage ../development/python-modules/billiard { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  bitbucket_api = callPackage ../development/python-modules/bitbucket-api { };

  bitbucket-cli = callPackage ../development/python-modules/bitbucket-cli { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  blaze = callPackage ../development/python-modules/blaze { };

  html5-parser = callPackage ../development/python-modules/html5-parser {
    inherit (pkgs) pkgconfig;
  };

  httpserver = callPackage ../development/python-modules/httpserver {};

  bleach = callPackage ../development/python-modules/bleach { };

  blinker = callPackage ../development/python-modules/blinker { };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

  blockdiagcontrib-cisco = callPackage ../development/python-modules/blockdiagcontrib-cisco { };

  bpython = callPackage ../development/python-modules/bpython {};

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  bkcharts = callPackage ../development/python-modules/bkcharts { };

  bokeh = callPackage ../development/python-modules/bokeh { };

  boto = callPackage ../development/python-modules/boto { };

  boto3 = callPackage ../development/python-modules/boto3 { };

  botocore = callPackage ../development/python-modules/botocore { };

  bottle = callPackage ../development/python-modules/bottle { };

  box2d = callPackage ../development/python-modules/box2d { pkgs-box2d = pkgs.box2d; };

  branca = callPackage ../development/python-modules/branca { };

  bugwarrior = callPackage ../development/python-modules/bugwarrior { };

  bugz = callPackage ../development/python-modules/bugz { };

  bugzilla = callPackage ../development/python-modules/bugzilla { };

  buildbot = callPackage ../development/python-modules/buildbot { };
  buildbot-plugins = pkgs.recurseIntoAttrs (callPackage ../development/python-modules/buildbot/plugins.nix { });
  buildbot-ui = self.buildbot.withPlugins (with self.buildbot-plugins; [ www ]);
  buildbot-full = self.buildbot.withPlugins (with self.buildbot-plugins; [ www console-view waterfall-view grid-view wsgi-dashboards ]);
  buildbot-worker = callPackage ../development/python-modules/buildbot/worker.nix { };
  buildbot-pkg = callPackage ../development/python-modules/buildbot/pkg.nix { };

  check-manifest = callPackage ../development/python-modules/check-manifest { };

  devpi-common = callPackage ../development/python-modules/devpi-common { };
  # A patched version of buildout, useful for buildout based development on Nix
  zc_buildout_nix = callPackage ../development/python-modules/buildout-nix { };

  zc_buildout = self.zc_buildout221;

  zc_buildout221 = callPackage ../development/python-modules/buildout { };

  bunch = callPackage ../development/python-modules/bunch { };

  can = callPackage ../development/python-modules/can {};

  canopen = callPackage ../development/python-modules/canopen {};

  canmatrix = callPackage ../development/python-modules/canmatrix {};

  cairocffi = callPackage ../development/python-modules/cairocffi {};

  cairosvg1 = callPackage ../development/python-modules/cairosvg/1_x.nix {};

  cairosvg = callPackage ../development/python-modules/cairosvg {};

  carrot = callPackage ../development/python-modules/carrot {};

  cartopy = callPackage ../development/python-modules/cartopy {};

  case = callPackage ../development/python-modules/case {};

  cbor = callPackage ../development/python-modules/cbor {};

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  cccolutils = callPackage ../development/python-modules/cccolutils {};

  cchardet = callPackage ../development/python-modules/cchardet { };

  CDDB = callPackage ../development/python-modules/cddb { };

  cntk = callPackage ../development/python-modules/cntk { };

  celery = callPackage ../development/python-modules/celery { };

  cerberus = callPackage ../development/python-modules/cerberus { };

  certifi = callPackage ../development/python-modules/certifi { };

  characteristic = callPackage ../development/python-modules/characteristic { };

  cheetah = callPackage ../development/python-modules/cheetah { };

  cherrypy = callPackage ../development/python-modules/cherrypy {};

  cfgv = callPackage ../development/python-modules/cfgv { };

  cftime = callPackage ../development/python-modules/cftime {};

  cjson = callPackage ../development/python-modules/cjson { };

  cld2-cffi = callPackage ../development/python-modules/cld2-cffi {};

  clf = callPackage ../development/python-modules/clf {};

  click = callPackage ../development/python-modules/click {};

  click-completion = callPackage ../development/python-modules/click-completion {};

  click-default-group = callPackage ../development/python-modules/click-default-group { };

  click-didyoumean = callPackage ../development/python-modules/click-didyoumean {};

  click-log = callPackage ../development/python-modules/click-log {};

  click-plugins = callPackage ../development/python-modules/click-plugins {};

  click-repl = callPackage ../development/python-modules/click-repl { };

  click-threading = callPackage ../development/python-modules/click-threading {};

  cligj = callPackage ../development/python-modules/cligj { };

  closure-linter = callPackage ../development/python-modules/closure-linter { };

  cloudpickle = callPackage ../development/python-modules/cloudpickle { };

  cmdline = callPackage ../development/python-modules/cmdline { };

  codecov = callPackage ../development/python-modules/codecov {};

  cogapp = callPackage ../development/python-modules/cogapp {};

  colorama = callPackage ../development/python-modules/colorama { };

  colorlover = callPackage ../development/python-modules/colorlover { };

  CommonMark = callPackage ../development/python-modules/commonmark { };

  coilmq = callPackage ../development/python-modules/coilmq { };

  colander = callPackage ../development/python-modules/colander { };

  # Backported version of the ConfigParser library of Python 3.3
  configparser = callPackage ../development/python-modules/configparser { };

  ColanderAlchemy = callPackage ../development/python-modules/colanderalchemy { };

  conda = callPackage ../development/python-modules/conda { };

  configobj = callPackage ../development/python-modules/configobj { };

  confluent-kafka = callPackage ../development/python-modules/confluent-kafka {};

  kafka-python = callPackage ../development/python-modules/kafka-python {};

  construct = callPackage ../development/python-modules/construct {};

  consul = callPackage ../development/python-modules/consul { };

  contexter = callPackage ../development/python-modules/contexter { };

  contextvars = callPackage ../development/python-modules/contextvars {};

  contextlib2 = callPackage ../development/python-modules/contextlib2 { };

  cookiecutter = callPackage ../development/python-modules/cookiecutter { };

  cookies = callPackage ../development/python-modules/cookies { };

  coveralls = callPackage ../development/python-modules/coveralls { };

  coverage = callPackage ../development/python-modules/coverage { };

  covCore = callPackage ../development/python-modules/cov-core { };

  crcmod = callPackage ../development/python-modules/crcmod { };

  credstash = callPackage ../development/python-modules/credstash { };

  cython = callPackage ../development/python-modules/Cython { };

  cytoolz = callPackage ../development/python-modules/cytoolz { };

  cryptacular = callPackage ../development/python-modules/cryptacular { };

  cryptography = callPackage ../development/python-modules/cryptography { };

  cryptography_vectors = callPackage ../development/python-modules/cryptography_vectors { };

  curtsies = callPackage ../development/python-modules/curtsies { };

  envs = callPackage ../development/python-modules/envs { };

  eth-hash = callPackage ../development/python-modules/eth-hash { };

  eth-typing = callPackage ../development/python-modules/eth-typing { };

  eth-utils = callPackage ../development/python-modules/eth-utils { };

  jsonrpc-async = callPackage ../development/python-modules/jsonrpc-async { };

  jsonrpc-base = callPackage ../development/python-modules/jsonrpc-base { };

  jsonrpc-websocket = callPackage ../development/python-modules/jsonrpc-websocket { };

  onkyo-eiscp = callPackage ../development/python-modules/onkyo-eiscp { };

  pyunifi = callPackage ../development/python-modules/pyunifi { };

  tablib = callPackage ../development/python-modules/tablib { };

  wakeonlan = callPackage ../development/python-modules/wakeonlan { };

  openant = callPackage ../development/python-modules/openant { };

  opencv = toPythonModule (pkgs.opencv.override {
    enablePython = true;
    pythonPackages = self;
  });

  opencv3 = toPythonModule (pkgs.opencv3.override {
    enablePython = true;
    pythonPackages = self;
  });

  opencv4 = toPythonModule (pkgs.opencv4.override {
    enablePython = true;
    pythonPackages = self;
  });

  openidc-client = callPackage ../development/python-modules/openidc-client {};

  idna = callPackage ../development/python-modules/idna { };

  mahotas = callPackage ../development/python-modules/mahotas { };

  MDP = callPackage ../development/python-modules/mdp {};

  minidb = callPackage ../development/python-modules/minidb { };

  miniupnpc = callPackage ../development/python-modules/miniupnpc {};

  mixpanel = callPackage ../development/python-modules/mixpanel { };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mxnet = callPackage ../development/python-modules/mxnet { };

  parsy = callPackage ../development/python-modules/parsy { };

  portpicker = callPackage ../development/python-modules/portpicker { };

  pkginfo = callPackage ../development/python-modules/pkginfo { };

  pretend = callPackage ../development/python-modules/pretend { };

  detox = callPackage ../development/python-modules/detox { };

  pbkdf2 = callPackage ../development/python-modules/pbkdf2 { };

  bcrypt = callPackage ../development/python-modules/bcrypt { };

  cffi = callPackage ../development/python-modules/cffi { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycontracts = callPackage ../development/python-modules/pycontracts { };

  pycparser = callPackage ../development/python-modules/pycparser { };

  pydub = callPackage ../development/python-modules/pydub {};

  pyjade = callPackage ../development/python-modules/pyjade {};

  pyjet = callPackage ../development/python-modules/pyjet {};

  PyLD = callPackage ../development/python-modules/PyLD { };

  python-jose = callPackage ../development/python-modules/python-jose {};

  python-json-logger = callPackage ../development/python-modules/python-json-logger { };

  python-ly = callPackage ../development/python-modules/python-ly {};

  pyhepmc = callPackage ../development/python-modules/pyhepmc { };

  pytest = self.pytest_39;

  pytest_39 = callPackage ../development/python-modules/pytest {
    # hypothesis tests require pytest that causes dependency cycle
    hypothesis = self.hypothesis.override { doCheck = false; };
  };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytest-annotate = callPackage ../development/python-modules/pytest-annotate { };

  pytest-ansible = callPackage ../development/python-modules/pytest-ansible { };

  pytest-aiohttp = callPackage ../development/python-modules/pytest-aiohttp { };

  pytest-benchmark = callPackage ../development/python-modules/pytest-benchmark { };

  pytestcache = callPackage ../development/python-modules/pytestcache { };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-faulthandler = callPackage ../development/python-modules/pytest-faulthandler { };

  pytest-fixture-config = callPackage ../development/python-modules/pytest-fixture-config { };

  pytest-forked = callPackage ../development/python-modules/pytest-forked { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-flake8 = callPackage ../development/python-modules/pytest-flake8 { };

  pytestflakes = callPackage ../development/python-modules/pytest-flakes { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-mock = callPackage ../development/python-modules/pytest-mock { };

  pytest-timeout = callPackage ../development/python-modules/pytest-timeout { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytestpep8 = callPackage ../development/python-modules/pytest-pep8 { };

  pytest-pep257 = callPackage ../development/python-modules/pytest-pep257 { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytestrunner = callPackage ../development/python-modules/pytestrunner { };

  pytestquickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  pytestcov = callPackage ../development/python-modules/pytest-cov { };

  pytest-expect = callPackage ../development/python-modules/pytest-expect { };

  pytest-virtualenv = callPackage ../development/python-modules/pytest-virtualenv { };

  pytest_xdist = callPackage ../development/python-modules/pytest-xdist { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-subtesthack = callPackage ../development/python-modules/pytest-subtesthack { };

  pytest-sugar = callPackage ../development/python-modules/pytest-sugar { };

  tinycss = callPackage ../development/python-modules/tinycss { };

  tinycss2 = callPackage ../development/python-modules/tinycss2 { };

  cssselect = callPackage ../development/python-modules/cssselect { };

  cssselect2 = callPackage ../development/python-modules/cssselect2 { };

  cssutils = callPackage ../development/python-modules/cssutils { };

  css-parser = callPackage ../development/python-modules/css-parser { };

  darcsver = callPackage ../development/python-modules/darcsver { };

  dask = callPackage ../development/python-modules/dask { };

  dask-glm = callPackage ../development/python-modules/dask-glm { };

  dask-image = callPackage ../development/python-modules/dask-image { };

  dask-jobqueue = callPackage ../development/python-modules/dask-jobqueue { };

  dask-ml = callPackage ../development/python-modules/dask-ml { };

  dask-xgboost = callPackage ../development/python-modules/dask-xgboost { };

  datrie = callPackage ../development/python-modules/datrie { };

  heapdict = callPackage ../development/python-modules/heapdict { };

  zict = callPackage ../development/python-modules/zict { };

  digital-ocean = callPackage ../development/python-modules/digitalocean { };

  leather = callPackage ../development/python-modules/leather { };

  libais = callPackage ../development/python-modules/libais { };

  libfdt = disabledIf isPy3k (toPythonModule (pkgs.dtc.override {
    python2 = python;
  }));

  libtmux = callPackage ../development/python-modules/libtmux { };

  libusb1 = callPackage ../development/python-modules/libusb1 { inherit (pkgs) libusb1; };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  locket = callPackage ../development/python-modules/locket { };

  tblib = callPackage ../development/python-modules/tblib { };

  s3fs = callPackage ../development/python-modules/s3fs { };

  datashape = callPackage ../development/python-modules/datashape { };

  requests-cache = callPackage ../development/python-modules/requests-cache { };

  requests-file = callPackage ../development/python-modules/requests-file { };

  requests-kerberos = callPackage ../development/python-modules/requests-kerberos { };

  requests-unixsocket = callPackage ../development/python-modules/requests-unixsocket {};

  requests-aws4auth = callPackage ../development/python-modules/requests-aws4auth { };

  howdoi = callPackage ../development/python-modules/howdoi {};

  neurotools = callPackage ../development/python-modules/neurotools {};

  jdatetime = callPackage ../development/python-modules/jdatetime {};

  daphne = callPackage ../development/python-modules/daphne { };

  dateparser = callPackage ../development/python-modules/dateparser { };

  # Actual name of package
  python-dateutil = callPackage ../development/python-modules/dateutil { };
  # Alias that we should deprecate
  dateutil = self.python-dateutil;

  decorator = callPackage ../development/python-modules/decorator { };

  deform = callPackage ../development/python-modules/deform { };

  demjson = callPackage ../development/python-modules/demjson { };

  deprecation = callPackage ../development/python-modules/deprecation { };

  derpconf = callPackage ../development/python-modules/derpconf { };

  deskcon = callPackage ../development/python-modules/deskcon { };

  dill = callPackage ../development/python-modules/dill { };

  discogs_client = callPackage ../development/python-modules/discogs_client { };

  dmenu-python = callPackage ../development/python-modules/dmenu { };

  dnspython = callPackage ../development/python-modules/dnspython { };
  dns = self.dnspython; # Alias for compatibility, 2017-12-10

  docker = callPackage ../development/python-modules/docker {};

  docker-py = disabledIf isPy27 (callPackage ../development/python-modules/docker-py {});

  dockerpty = callPackage ../development/python-modules/dockerpty {};

  docker_pycreds = callPackage ../development/python-modules/docker-pycreds {};

  docopt = callPackage ../development/python-modules/docopt { };

  doctest-ignore-unicode = callPackage ../development/python-modules/doctest-ignore-unicode { };

  dogpile_cache = callPackage ../development/python-modules/dogpile.cache { };

  dogpile_core = callPackage ../development/python-modules/dogpile.core { };

  dopy = callPackage ../development/python-modules/dopy { };

  dpath = callPackage ../development/python-modules/dpath { };

  dpkt = callPackage ../development/python-modules/dpkt {};

  urllib3 = callPackage ../development/python-modules/urllib3 {};

  dropbox = callPackage ../development/python-modules/dropbox {};

  ds4drv = callPackage ../development/python-modules/ds4drv {
    inherit (pkgs) fetchFromGitHub bluez;
  };

  dyn = callPackage ../development/python-modules/dyn { };

  easydict = callPackage ../development/python-modules/easydict { };

  easygui = callPackage ../development/python-modules/easygui { };

  EasyProcess = callPackage ../development/python-modules/easyprocess { };

  easy-thumbnails = callPackage ../development/python-modules/easy-thumbnails { };

  eccodes = toPythonModule (pkgs.eccodes.override {
    enablePython = true;
    pythonPackages = self;
  });

  EditorConfig = callPackage ../development/python-modules/editorconfig { };

  edward = callPackage ../development/python-modules/edward { };

  elasticsearch = callPackage ../development/python-modules/elasticsearch { };

  elasticsearch-dsl = callPackage ../development/python-modules/elasticsearch-dsl { };
  # alias
  elasticsearchdsl = self.elasticsearch-dsl;

  elasticsearch-curator = callPackage ../development/python-modules/elasticsearch-curator { };

  entrypoints = callPackage ../development/python-modules/entrypoints { };

  enzyme = callPackage ../development/python-modules/enzyme {};

  escapism = callPackage ../development/python-modules/escapism { };

  etcd = callPackage ../development/python-modules/etcd { };

  evdev = callPackage ../development/python-modules/evdev {};

  eve = callPackage ../development/python-modules/eve {};

  eventlib = callPackage ../development/python-modules/eventlib { };

  events = callPackage ../development/python-modules/events { };

  eyeD3 = callPackage ../development/python-modules/eyed3 { };

  execnet = callPackage ../development/python-modules/execnet { };

  ezdxf = callPackage ../development/python-modules/ezdxf {};

  facebook-sdk = callPackage ../development/python-modules/facebook-sdk { };

  face_recognition = callPackage ../development/python-modules/face_recognition { };

  face_recognition_models = callPackage ../development/python-modules/face_recognition_models { };

  faker = callPackage ../development/python-modules/faker { };

  fake_factory = callPackage ../development/python-modules/fake_factory { };

  factory_boy = callPackage ../development/python-modules/factory_boy { };

  Fabric = callPackage ../development/python-modules/Fabric { };

  faulthandler = if ! isPy3k
    then callPackage ../development/python-modules/faulthandler {}
    else throw "faulthandler is built into ${python.executable}";

  fb-re2 = callPackage ../development/python-modules/fb-re2 { };

  filetype = callPackage ../development/python-modules/filetype { };

  flexmock = callPackage ../development/python-modules/flexmock { };

  flit = callPackage ../development/python-modules/flit { };

  flowlogs_reader = callPackage ../development/python-modules/flowlogs_reader { };

  fluent-logger = callPackage ../development/python-modules/fluent-logger {};

  python-forecastio = callPackage ../development/python-modules/python-forecastio { };

  fpdf = callPackage ../development/python-modules/fpdf { };

  fpylll = callPackage ../development/python-modules/fpylll { };

  fritzconnection = callPackage ../development/python-modules/fritzconnection { };

  frozendict = callPackage ../development/python-modules/frozendict { };

  ftputil = callPackage ../development/python-modules/ftputil { };

  fudge = callPackage ../development/python-modules/fudge { };

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  functools32 = callPackage ../development/python-modules/functools32 { };

  future-fstrings = callPackage ../development/python-modules/future-fstrings { };

  gateone = callPackage ../development/python-modules/gateone { };

  # TODO: Remove after 19.03 is branched off:
  gcutil = throw ''
    pythonPackages.gcutil is deprecated and can be replaced with "gcloud
    compute" from the package google-cloud-sdk.
  '';

  GeoIP = callPackage ../development/python-modules/GeoIP { };

  gmpy = callPackage ../development/python-modules/gmpy { };

  gmpy2 = callPackage ../development/python-modules/gmpy2 { };

  gmusicapi = callPackage ../development/python-modules/gmusicapi { };

  gnureadline = callPackage ../development/python-modules/gnureadline { };

  gnutls = callPackage ../development/python-modules/gnutls { };

  gpy = callPackage ../development/python-modules/gpy { };

  gitdb = callPackage ../development/python-modules/gitdb { };

  gitdb2 = callPackage ../development/python-modules/gitdb2 { };

  GitPython = callPackage ../development/python-modules/GitPython { };

  git-annex-adapter = callPackage ../development/python-modules/git-annex-adapter {
    inherit (pkgs.gitAndTools) git-annex;
  };

  python-gitlab = callPackage ../development/python-modules/python-gitlab { };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk { };
  google-cloud-sdk-gce = callPackage ../tools/admin/google-cloud-sdk { with-gce=true; };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-music = callPackage ../development/python-modules/google-music { };

  google-music-proto = callPackage ../development/python-modules/google-music-proto { };

  google-music-utils = callPackage ../development/python-modules/google-music-utils { };

  gpapi = callPackage ../development/python-modules/gpapi { };
  gplaycli = callPackage ../development/python-modules/gplaycli { };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  grip = callPackage ../development/python-modules/grip { };

  gst-python = callPackage ../development/python-modules/gst-python {
    inherit (pkgs) pkgconfig;
    gst-plugins-base = pkgs.gst_all_1.gst-plugins-base;
  };

  gtimelog = callPackage ../development/python-modules/gtimelog { };

  gurobipy = if stdenv.hostPlatform.system == "x86_64-darwin"
  then callPackage ../development/python-modules/gurobipy/darwin.nix {
    inherit (pkgs.darwin) cctools insert_dylib;
  }
  else if stdenv.hostPlatform.system == "x86_64-linux"
  then callPackage ../development/python-modules/gurobipy/linux.nix {}
  else throw "gurobipy not yet supported on ${stdenv.hostPlatform.system}";

  hbmqtt = callPackage ../development/python-modules/hbmqtt { };

  hiro = callPackage ../development/python-modules/hiro {};

  hglib = callPackage ../development/python-modules/hglib {};

  humanize = callPackage ../development/python-modules/humanize { };

  hupper = callPackage ../development/python-modules/hupper {};

  hsaudiotag = callPackage ../development/python-modules/hsaudiotag { };

  hsaudiotag3k = callPackage ../development/python-modules/hsaudiotag3k { };

  htmlmin = callPackage ../development/python-modules/htmlmin {};

  httpauth = callPackage ../development/python-modules/httpauth { };

  idna-ssl = callPackage ../development/python-modules/idna-ssl { };

  identify = callPackage ../development/python-modules/identify { };

  ijson = callPackage ../development/python-modules/ijson {};

  imagesize = callPackage ../development/python-modules/imagesize { };

  image-match = callPackage ../development/python-modules/image-match { };

  imbalanced-learn = callPackage ../development/python-modules/imbalanced-learn { };

  immutables = callPackage ../development/python-modules/immutables {};

  imread = callPackage ../development/python-modules/imread { };

  imaplib2 = callPackage ../development/python-modules/imaplib2 { };

  ipfsapi = callPackage ../development/python-modules/ipfsapi { };

  isbnlib = callPackage ../development/python-modules/isbnlib { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous { };

  iniparse = callPackage ../development/python-modules/iniparse { };

  i3-py = callPackage ../development/python-modules/i3-py { };

  JayDeBeApi = callPackage ../development/python-modules/JayDeBeApi {};

  jdcal = callPackage ../development/python-modules/jdcal { };

  jieba = callPackage ../development/python-modules/jieba { };

  internetarchive = callPackage ../development/python-modules/internetarchive {};

  JPype1 = callPackage ../development/python-modules/JPype1 {};

  josepy = callPackage ../development/python-modules/josepy {};

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier {};

  jug = callPackage ../development/python-modules/jug {};

  jsmin = callPackage ../development/python-modules/jsmin { };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpickle = callPackage ../development/python-modules/jsonpickle { };

  jsonpointer = callPackage ../development/python-modules/jsonpointer { };

  jsonrpclib = callPackage ../development/python-modules/jsonrpclib { };

  jsonrpclib-pelix = callPackage ../development/python-modules/jsonrpclib-pelix {};

  jsonwatch = callPackage ../development/python-modules/jsonwatch { };

  latexcodec = callPackage ../development/python-modules/latexcodec {};

  libsexy = callPackage ../development/python-modules/libsexy {
    inherit (pkgs) libsexy pkgconfig;
  };

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libthumbor = callPackage ../development/python-modules/libthumbor { };

  lightblue = callPackage ../development/python-modules/lightblue { };

  lightning = callPackage ../development/python-modules/lightning { };

  jupyter = callPackage ../development/python-modules/jupyter { };

  jupyter_console = if pythonOlder "3.5" then
       callPackage ../development/python-modules/jupyter_console/5.nix { }
     else
       callPackage ../development/python-modules/jupyter_console { };

  jupyterlab_launcher = callPackage ../development/python-modules/jupyterlab_launcher { };

  jupyterlab_server = callPackage ../development/python-modules/jupyterlab_server { };

  jupyterlab = callPackage ../development/python-modules/jupyterlab {};

  jupytext = callPackage ../development/python-modules/jupytext { };

  PyLTI = callPackage ../development/python-modules/pylti { };

  lmdb = callPackage ../development/python-modules/lmdb { };

  logilab_astng = callPackage ../development/python-modules/logilab_astng { };

  lpod = callPackage ../development/python-modules/lpod { };

  ludios_wpull = callPackage ../development/python-modules/ludios_wpull { };

  luftdaten = callPackage ../development/python-modules/luftdaten { };

  m2r = callPackage ../development/python-modules/m2r { };

  mailchimp = callPackage ../development/python-modules/mailchimp { };

  python-mapnik = callPackage ../development/python-modules/python-mapnik { };

  misaka = callPackage ../development/python-modules/misaka {};

  mt-940 = callPackage ../development/python-modules/mt-940 { };

  mwlib = callPackage ../development/python-modules/mwlib { };

  mwlib-ext = callPackage ../development/python-modules/mwlib-ext { };

  mwlib-rl = callPackage ../development/python-modules/mwlib-rl { };

  natsort = callPackage ../development/python-modules/natsort { };

  ncclient = callPackage ../development/python-modules/ncclient {};

  logfury = callPackage ../development/python-modules/logfury { };

  ndg-httpsclient = callPackage ../development/python-modules/ndg-httpsclient { };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  netdisco = callPackage ../development/python-modules/netdisco { };

  Nikola = callPackage ../development/python-modules/Nikola { };

  nxt-python = callPackage ../development/python-modules/nxt-python { };

  odfpy = callPackage ../development/python-modules/odfpy { };

  oset = callPackage ../development/python-modules/oset { };

  pamela = callPackage ../development/python-modules/pamela { };

  paperspace = callPackage ../development/python-modules/paperspace { };

  paperwork-backend = callPackage ../applications/office/paperwork/backend.nix { };

  papis-python-rofi = callPackage ../development/python-modules/papis-python-rofi { };

  pathspec = callPackage ../development/python-modules/pathspec { };

  pathtools = callPackage ../development/python-modules/pathtools { };

  paver = callPackage ../development/python-modules/paver { };

  passlib = callPackage ../development/python-modules/passlib { };

  path-and-address = callPackage ../development/python-modules/path-and-address { };

  peppercorn = callPackage ../development/python-modules/peppercorn { };

  pex = callPackage ../development/python-modules/pex { };

  phe = callPackage ../development/python-modules/phe { };

  phpserialize = callPackage ../development/python-modules/phpserialize { };

  plaid-python = callPackage ../development/python-modules/plaid-python { };

  plaster = callPackage ../development/python-modules/plaster {};

  plaster-pastedeploy = callPackage ../development/python-modules/plaster-pastedeploy {};

  plotly = callPackage ../development/python-modules/plotly { };

  plyfile = callPackage ../development/python-modules/plyfile { };

  podcastparser = callPackage ../development/python-modules/podcastparser { };

  podcats = callPackage ../development/python-modules/podcats { };

  pomegranate = callPackage ../development/python-modules/pomegranate { };

  poppler-qt5 = callPackage ../development/python-modules/poppler-qt5 {
    inherit (pkgs.qt5) qtbase;
    inherit (pkgs.libsForQt5) poppler;
    inherit (pkgs) pkgconfig;
  };

  poyo = callPackage ../development/python-modules/poyo { };

  priority = callPackage ../development/python-modules/priority { };

  prov = callPackage ../development/python-modules/prov { };

  pudb = callPackage ../development/python-modules/pudb { };

  pybtex = callPackage ../development/python-modules/pybtex {};

  pybtex-docutils = callPackage ../development/python-modules/pybtex-docutils {};

  pycallgraph = callPackage ../development/python-modules/pycallgraph { };

  pycassa = callPackage ../development/python-modules/pycassa { };

  lirc = disabledIf isPy27 (toPythonModule (pkgs.lirc.override {
    python3 = python;
  }));

  pyblake2 = callPackage ../development/python-modules/pyblake2 { };

  pybluez = callPackage ../development/python-modules/pybluez { };

  pycares = callPackage ../development/python-modules/pycares { };

  pycuda = callPackage ../development/python-modules/pycuda rec {
    cudatoolkit = pkgs.cudatoolkit_7_5;
    inherit (pkgs.stdenv) mkDerivation;
  };

  pydotplus = callPackage ../development/python-modules/pydotplus { };

  pyfxa = callPackage ../development/python-modules/pyfxa { };

  pyhomematic = callPackage ../development/python-modules/pyhomematic { };

  pylama = callPackage ../development/python-modules/pylama { };

  pymediainfo = callPackage ../development/python-modules/pymediainfo { };

  pyphen = callPackage ../development/python-modules/pyphen {};

  pypoppler = callPackage ../development/python-modules/pypoppler { };

  pypillowfight = callPackage ../development/python-modules/pypillowfight { };

  pyprind = callPackage ../development/python-modules/pyprind { };

  python-axolotl = callPackage ../development/python-modules/python-axolotl { };

  python-axolotl-curve25519 = callPackage ../development/python-modules/python-axolotl-curve25519 { };

  pythonix = toPythonModule (callPackage ../development/python-modules/pythonix { });

  pyramid = callPackage ../development/python-modules/pyramid { };

  pyramid_beaker = callPackage ../development/python-modules/pyramid_beaker { };

  pyramid_chameleon = callPackage ../development/python-modules/pyramid_chameleon { };

  pyramid_jinja2 = callPackage ../development/python-modules/pyramid_jinja2 { };

  pyramid_mako = callPackage ../development/python-modules/pyramid_mako { };

  peewee =  callPackage ../development/python-modules/peewee { };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyspf = callPackage ../development/python-modules/pyspf { };

  pysrim = callPackage ../development/python-modules/pysrim { };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pytools = callPackage ../development/python-modules/pytools { };

  python-ctags3 = callPackage ../development/python-modules/python-ctags3 { };

  junos-eznc = callPackage ../development/python-modules/junos-eznc {};

  raven = callPackage ../development/python-modules/raven { };

  rawkit = callPackage ../development/python-modules/rawkit { };

  joblib = callPackage ../development/python-modules/joblib { };

  sarge = callPackage ../development/python-modules/sarge { };

  subliminal = callPackage ../development/python-modules/subliminal {};

  hyperlink = callPackage ../development/python-modules/hyperlink {};

  zope_copy = callPackage ../development/python-modules/zope_copy {};

  s2clientprotocol = callPackage ../development/python-modules/s2clientprotocol { };

  py3status = callPackage ../development/python-modules/py3status {};

  pyrtlsdr = callPackage ../development/python-modules/pyrtlsdr { };

  scandir = callPackage ../development/python-modules/scandir { };

  schema = callPackage ../development/python-modules/schema {};

  simple-websocket-server = callPackage ../development/python-modules/simple-websocket-server {};

  stem = callPackage ../development/python-modules/stem { };

  svg-path = callPackage ../development/python-modules/svg-path { };

  r2pipe = callPackage ../development/python-modules/r2pipe { };

  regex = callPackage ../development/python-modules/regex { };

  ratelimiter = callPackage ../development/python-modules/ratelimiter { };

  pywatchman = callPackage ../development/python-modules/pywatchman { };

  pywavelets = callPackage ../development/python-modules/pywavelets { };

  vcrpy = callPackage ../development/python-modules/vcrpy { };

  descartes = callPackage ../development/python-modules/descartes { };

  chardet = callPackage ../development/python-modules/chardet { };

  pyramid_exclog = callPackage ../development/python-modules/pyramid_exclog { };

  pyramid_multiauth = callPackage ../development/python-modules/pyramid_multiauth { };

  pyramid_hawkauth = callPackage ../development/python-modules/pyramid_hawkauth { };

  pytun = callPackage ../development/python-modules/pytun { };

  rethinkdb = callPackage ../development/python-modules/rethinkdb { };

  roman = callPackage ../development/python-modules/roman { };

  librosa = callPackage ../development/python-modules/librosa { };

  samplerate = callPackage ../development/python-modules/samplerate { };

  ssdeep = callPackage ../development/python-modules/ssdeep { };

  statsd = callPackage ../development/python-modules/statsd { };

  multi_key_dict = callPackage ../development/python-modules/multi_key_dict { };

  random2 = callPackage ../development/python-modules/random2 { };

  schedule = callPackage ../development/python-modules/schedule { };

  repoze_lru = callPackage ../development/python-modules/repoze_lru { };

  repoze_sphinx_autointerface =  callPackage ../development/python-modules/repoze_sphinx_autointerface { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  sievelib = callPackage ../development/python-modules/sievelib { };

  watchdog = callPackage ../development/python-modules/watchdog { };

  zope_deprecation = callPackage ../development/python-modules/zope_deprecation { };

  validictory = callPackage ../development/python-modules/validictory { };

  venusian = callPackage ../development/python-modules/venusian { };

  chameleon = callPackage ../development/python-modules/chameleon { };

  ddt = callPackage ../development/python-modules/ddt { };

  distutils_extra = callPackage ../development/python-modules/distutils_extra { };

  pyxdg = callPackage ../development/python-modules/pyxdg { };

  crayons = callPackage ../development/python-modules/crayons{ };

  django = self.django_1_11;

  django_1_11 = callPackage ../development/python-modules/django/1_11.nix {
    gdal = self.gdal;
  };

  django_2_1 = callPackage ../development/python-modules/django/2_1.nix {
    gdal = self.gdal;
  };

  django_1_8 = callPackage ../development/python-modules/django/1_8.nix { };

  django-allauth = callPackage ../development/python-modules/django-allauth { };

  django_appconf = callPackage ../development/python-modules/django_appconf { };

  django_colorful = callPackage ../development/python-modules/django_colorful { };

  django-cache-url = callPackage ../development/python-modules/django-cache-url { };

  django-configurations = callPackage ../development/python-modules/django-configurations { };

  django_compressor = callPackage ../development/python-modules/django_compressor { };

  django_compat = callPackage ../development/python-modules/django-compat { };

  django_contrib_comments = callPackage ../development/python-modules/django_contrib_comments { };

  django-cors-headers = callPackage ../development/python-modules/django-cors-headers { };

  django-discover-runner = callPackage ../development/python-modules/django-discover-runner { };

  django_environ = callPackage ../development/python-modules/django_environ { };

  django_evolution = callPackage ../development/python-modules/django_evolution { };

  django_extensions = callPackage ../development/python-modules/django-extensions { };

  django-gravatar2 = callPackage ../development/python-modules/django-gravatar2 { };

  django_guardian = callPackage ../development/python-modules/django_guardian { };

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django_polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-rest-auth = callPackage ../development/python-modules/django-rest-auth { };

  django-sampledatahelper = callPackage ../development/python-modules/django-sampledatahelper { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django_tagging = callPackage ../development/python-modules/django_tagging { };

  django_tagging_0_4_3 = if
       self.django.version != "1.8.19"
  then throw "django_tagging_0_4_3 should be build with django_1_8"
  else (callPackage ../development/python-modules/django_tagging {}).overrideAttrs (attrs: rec {
    pname = "django-tagging";
    version = "0.4.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0617azpmp6jpg3d88v2ir97qrc9aqcs2s9gyvv9bgf2cp55khxhs";
    };
    propagatedBuildInputs = with self; [ django ];
  });

  django_classytags = callPackage ../development/python-modules/django_classytags { };

  # This package may need an older version of Django.
  # Override the package set and set e.g. `django = super.django_1_9`.
  # See the Nixpkgs manual for examples on how to override the package set.
  django_hijack = callPackage ../development/python-modules/django-hijack { };

  django_hijack_admin = callPackage ../development/python-modules/django-hijack-admin { };

  django_nose = callPackage ../development/python-modules/django_nose { };

  django_modelcluster = callPackage ../development/python-modules/django_modelcluster { };

  djangorestframework = callPackage ../development/python-modules/djangorestframework { };

  djangorestframework-jwt = callPackage ../development/python-modules/djangorestframework-jwt { };

  django-raster = callPackage ../development/python-modules/django-raster { };

  django_redis = callPackage ../development/python-modules/django_redis { };

  django_reversion = callPackage ../development/python-modules/django_reversion { };

  django_silk = callPackage ../development/python-modules/django_silk { };

  django_taggit = callPackage ../development/python-modules/django_taggit { };

  django_treebeard = callPackage ../development/python-modules/django_treebeard { };

  django_pipeline = callPackage ../development/python-modules/django-pipeline { };

  dj-database-url = callPackage ../development/python-modules/dj-database-url { };

  dj-email-url = callPackage ../development/python-modules/dj-email-url { };

  dj-search-url = callPackage ../development/python-modules/dj-search-url { };

  djmail = callPackage ../development/python-modules/djmail { };

  pillowfight = callPackage ../development/python-modules/pillowfight { };

  kaptan = callPackage ../development/python-modules/kaptan { };

  keepalive = callPackage ../development/python-modules/keepalive { };

  keyrings-alt = callPackage ../development/python-modules/keyrings-alt {};

  SPARQLWrapper = callPackage ../development/python-modules/sparqlwrapper { };

  dulwich = callPackage ../development/python-modules/dulwich {
    inherit (pkgs) git glibcLocales;
  };

  hg-git = callPackage ../development/python-modules/hg-git { };

  dtopt = callPackage ../development/python-modules/dtopt { };

  easywatch = callPackage ../development/python-modules/easywatch { };

  ecdsa = callPackage ../development/python-modules/ecdsa { };

  effect = callPackage ../development/python-modules/effect {};

  elpy = callPackage ../development/python-modules/elpy { };

  enum = callPackage ../development/python-modules/enum { };

  enum-compat = callPackage ../development/python-modules/enum-compat { };

  enum34 = callPackage ../development/python-modules/enum34 { };

  epc = callPackage ../development/python-modules/epc { };

  et_xmlfile = callPackage ../development/python-modules/et_xmlfile { };

  eventlet = callPackage ../development/python-modules/eventlet { };

  exifread = callPackage ../development/python-modules/exifread { };

  fastimport = callPackage ../development/python-modules/fastimport { };

  fastpair = callPackage ../development/python-modules/fastpair { };

  fastrlock = callPackage ../development/python-modules/fastrlock {};

  feedgen = callPackage ../development/python-modules/feedgen { };

  feedgenerator = callPackage ../development/python-modules/feedgenerator {
    inherit (pkgs) glibcLocales;
  };

  feedparser = callPackage ../development/python-modules/feedparser { };

  pyfribidi = callPackage ../development/python-modules/pyfribidi { };

  pyftpdlib = callPackage ../development/python-modules/pyftpdlib { };

  filebrowser_safe = callPackage ../development/python-modules/filebrowser_safe { };

  pycodestyle = callPackage ../development/python-modules/pycodestyle { };

  filebytes = callPackage ../development/python-modules/filebytes { };

  filelock = callPackage ../development/python-modules/filelock {};

  fiona = callPackage ../development/python-modules/fiona { gdal = pkgs.gdal; };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flake8-import-order = callPackage ../development/python-modules/flake8-import-order { };

  flaky = callPackage ../development/python-modules/flaky { };

  flask = callPackage ../development/python-modules/flask { };

  flask-api = callPackage ../development/python-modules/flask-api { };

  flask_assets = callPackage ../development/python-modules/flask-assets { };

  flask-autoindex = callPackage ../development/python-modules/flask-autoindex { };

  flask-babel = callPackage ../development/python-modules/flask-babel { };

  flask-bootstrap = callPackage ../development/python-modules/flask-bootstrap { };

  flask-caching = callPackage ../development/python-modules/flask-caching { };

  flask-common = callPackage ../development/python-modules/flask-common { };

  flask-compress = callPackage ../development/python-modules/flask-compress { };

  flask-cors = callPackage ../development/python-modules/flask-cors { };

  flask_elastic = callPackage ../development/python-modules/flask-elastic { };

  flask-jwt-extended = callPackage ../development/python-modules/flask-jwt-extended { };

  flask-limiter = callPackage ../development/python-modules/flask-limiter { };

  flask_login = callPackage ../development/python-modules/flask-login { };

  flask_ldap_login = callPackage ../development/python-modules/flask-ldap-login { };

  flask_mail = callPackage ../development/python-modules/flask-mail { };

  flask_marshmallow = callPackage ../development/python-modules/flask-marshmallow { };

  flask_migrate = callPackage ../development/python-modules/flask-migrate { };

  flask_oauthlib = callPackage ../development/python-modules/flask-oauthlib { };

  flask-paginate = callPackage ../development/python-modules/flask-paginate { };

  flask_principal = callPackage ../development/python-modules/flask-principal { };

  flask-pymongo = callPackage ../development/python-modules/Flask-PyMongo { };

  flask-restful = callPackage ../development/python-modules/flask-restful { };

  flask-restplus = callPackage ../development/python-modules/flask-restplus { };

  flask_script = callPackage ../development/python-modules/flask-script { };

  flask-silk = callPackage ../development/python-modules/flask-silk { };

  flask-socketio = callPackage ../development/python-modules/flask-socketio { };

  flask_sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask_testing = callPackage ../development/python-modules/flask-testing { };

  flask_wtf = callPackage ../development/python-modules/flask-wtf { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  graph-tool = callPackage ../development/python-modules/graph-tool/2.x.x.nix {
    inherit (pkgs) pkgconfig;
  };

  grappelli_safe = callPackage ../development/python-modules/grappelli_safe { };

  pytorch = callPackage ../development/python-modules/pytorch {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  pyro-ppl = callPackage ../development/python-modules/pyro-ppl {};

  opt-einsum = callPackage ../development/python-modules/opt-einsum {};

  pytorchWithCuda = self.pytorch.override {
    cudaSupport = true;
  };

  pytorchWithoutCuda = self.pytorch.override {
    cudaSupport = false;
  };

  python2-pythondialog = callPackage ../development/python-modules/python2-pythondialog { };

  pyRFC3339 = callPackage ../development/python-modules/pyrfc3339 { };

  ConfigArgParse = callPackage ../development/python-modules/configargparse { };

  jsonschema = callPackage ../development/python-modules/jsonschema { };

  vcversioner = callPackage ../development/python-modules/vcversioner { };

  falcon = callPackage ../development/python-modules/falcon { };

  hug = callPackage ../development/python-modules/hug { };

  flup = callPackage ../development/python-modules/flup { };

  fn = callPackage ../development/python-modules/fn { };

  folium = callPackage ../development/python-modules/folium { };

  fontforge = toPythonModule (pkgs.fontforge.override {
    withPython = true;
    inherit python;
  });

  fonttools = callPackage ../development/python-modules/fonttools { };

  foolscap = callPackage ../development/python-modules/foolscap { };

  forbiddenfruit = callPackage ../development/python-modules/forbiddenfruit { };

  fusepy = callPackage ../development/python-modules/fusepy { };

  future = callPackage ../development/python-modules/future { };

  futures = callPackage ../development/python-modules/futures { };

  gcovr = callPackage ../development/python-modules/gcovr { };

  gdal = toPythonModule (pkgs.gdal.override {
    pythonPackages = self;
  });

  gdrivefs = callPackage ../development/python-modules/gdrivefs { };

  genshi = callPackage ../development/python-modules/genshi { };

  gentools = callPackage ../development/python-modules/gentools { };

  gevent = callPackage ../development/python-modules/gevent { };

  geventhttpclient = callPackage ../development/python-modules/geventhttpclient { };

  gevent-socketio = callPackage ../development/python-modules/gevent-socketio { };

  geopandas = callPackage ../development/python-modules/geopandas { };

  geojson = callPackage ../development/python-modules/geojson { };

  gevent-websocket = callPackage ../development/python-modules/gevent-websocket { };

  genzshcomp = callPackage ../development/python-modules/genzshcomp { };

  gflags = callPackage ../development/python-modules/gflags { };

  ghdiff = callPackage ../development/python-modules/ghdiff { };

  gipc = callPackage ../development/python-modules/gipc { };

  git-sweep = callPackage ../development/python-modules/git-sweep { };

  glances = callPackage ../development/python-modules/glances { };

  github3_py = callPackage ../development/python-modules/github3_py { };

  github-webhook = callPackage ../development/python-modules/github-webhook { };

  goobook = callPackage ../development/python-modules/goobook { };

  googleapis_common_protos = callPackage ../development/python-modules/googleapis_common_protos { };

  google-auth-httplib2 = callPackage ../development/python-modules/google-auth-httplib2 { };

  google_api_core = callPackage ../development/python-modules/google_api_core { };

  google_api_python_client = callPackage ../development/python-modules/google-api-python-client { };

  google_apputils = callPackage ../development/python-modules/google_apputils { };

  google_auth = callPackage ../development/python-modules/google_auth { };

  google_cloud_asset = callPackage ../development/python-modules/google_cloud_asset { };

  google_cloud_automl = callPackage ../development/python-modules/google_cloud_automl { };

  google_cloud_core = callPackage ../development/python-modules/google_cloud_core { };

  google_cloud_bigquery = callPackage ../development/python-modules/google_cloud_bigquery { };

  google_cloud_bigquery_datatransfer = callPackage ../development/python-modules/google_cloud_bigquery_datatransfer { };

  google_cloud_bigtable = callPackage ../development/python-modules/google_cloud_bigtable { };

  google_cloud_container = callPackage ../development/python-modules/google_cloud_container { };

  google_cloud_dataproc = callPackage ../development/python-modules/google_cloud_dataproc { };

  google_cloud_datastore = callPackage ../development/python-modules/google_cloud_datastore { };

  google_cloud_dlp = callPackage ../development/python-modules/google_cloud_dlp { };

  google_cloud_dns = callPackage ../development/python-modules/google_cloud_dns { };

  google_cloud_error_reporting = callPackage ../development/python-modules/google_cloud_error_reporting { };

  google_cloud_firestore = callPackage ../development/python-modules/google_cloud_firestore { };

  google_cloud_iot = callPackage ../development/python-modules/google_cloud_iot { };

  google_cloud_kms = callPackage ../development/python-modules/google_cloud_kms { };

  google_cloud_language = callPackage ../development/python-modules/google_cloud_language { };

  google_cloud_logging = callPackage ../development/python-modules/google_cloud_logging { };

  google_cloud_monitoring = callPackage ../development/python-modules/google_cloud_monitoring { };

  google_cloud_pubsub = callPackage ../development/python-modules/google_cloud_pubsub { };

  google_cloud_redis = callPackage ../development/python-modules/google_cloud_redis { };

  google_cloud_resource_manager = callPackage ../development/python-modules/google_cloud_resource_manager { };

  google_cloud_runtimeconfig = callPackage ../development/python-modules/google_cloud_runtimeconfig { };

  google_cloud_securitycenter = callPackage ../development/python-modules/google_cloud_securitycenter { };

  google_cloud_spanner = callPackage ../development/python-modules/google_cloud_spanner { };

  google_cloud_storage = callPackage ../development/python-modules/google_cloud_storage { };

  google_cloud_speech = callPackage ../development/python-modules/google_cloud_speech { };

  google_cloud_tasks = callPackage ../development/python-modules/google_cloud_tasks { };

  google_cloud_testutils = callPackage ../development/python-modules/google_cloud_testutils { };

  google_cloud_texttospeech = callPackage ../development/python-modules/google_cloud_texttospeech { };

  google_cloud_trace = callPackage ../development/python-modules/google_cloud_trace { };

  google_cloud_translate = callPackage ../development/python-modules/google_cloud_translate { };

  google_cloud_videointelligence = callPackage ../development/python-modules/google_cloud_videointelligence { };

  google_cloud_vision = callPackage ../development/python-modules/google_cloud_vision { };

  google_cloud_websecurityscanner = callPackage ../development/python-modules/google_cloud_websecurityscanner { };

  google-i18n-address = callPackage ../development/python-modules/google-i18n-address { };

  google_resumable_media = callPackage ../development/python-modules/google_resumable_media { };

  gpgme = toPythonModule (pkgs.gpgme.override {
    pythonSupport = true;
    inherit python;
  });

  gphoto2 = callPackage ../development/python-modules/gphoto2 {
    inherit (pkgs) pkgconfig;
  };

  grammalecte = callPackage ../development/python-modules/grammalecte { };

  greenlet = callPackage ../development/python-modules/greenlet { };

  grib-api = disabledIf (!isPy27) (toPythonModule
    (pkgs.grib-api.override {
      enablePython = true;
      pythonPackages = self;
    }));

  grpcio = callPackage ../development/python-modules/grpcio { };

  grpcio-tools = callPackage ../development/python-modules/grpcio-tools { };

  grpcio-gcp = callPackage ../development/python-modules/grpcio-gcp { };

  grpc_google_iam_v1 = callPackage ../development/python-modules/grpc_google_iam_v1 { };

  gspread = callPackage ../development/python-modules/gspread { };

  gym = callPackage ../development/python-modules/gym { };

  gyp = callPackage ../development/python-modules/gyp { };

  guessit = callPackage ../development/python-modules/guessit { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  gunicorn = callPackage ../development/python-modules/gunicorn { };

  hawkauthlib = callPackage ../development/python-modules/hawkauthlib { };

  hdbscan = callPackage ../development/python-modules/hdbscan { };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hcs_utils = callPackage ../development/python-modules/hcs_utils { };

  hetzner = callPackage ../development/python-modules/hetzner { };

  homeassistant-pyozw = callPackage ../development/python-modules/homeassistant-pyozw { };

  htmllaundry = callPackage ../development/python-modules/htmllaundry { };

  html5lib = callPackage ../development/python-modules/html5lib { };

  httmock = callPackage ../development/python-modules/httmock { };

  http_signature = callPackage ../development/python-modules/http_signature { };

  httpbin = callPackage ../development/python-modules/httpbin { };

  httplib2 = callPackage ../development/python-modules/httplib2 { };

  hvac = callPackage ../development/python-modules/hvac { };

  hypothesis = callPackage ../development/python-modules/hypothesis { };

  colored = callPackage ../development/python-modules/colored { };

  xdis = callPackage ../development/python-modules/xdis { };

  uncompyle6 = callPackage ../development/python-modules/uncompyle6 { };

  lsi = callPackage ../development/python-modules/lsi { };

  hkdf = callPackage ../development/python-modules/hkdf { };

  httpretty = callPackage ../development/python-modules/httpretty { };

  icalendar = callPackage ../development/python-modules/icalendar { };

  ifaddr = callPackage ../development/python-modules/ifaddr { };

  imageio = callPackage ../development/python-modules/imageio { };

  imgaug = callPackage ../development/python-modules/imgaug { };

  inflection = callPackage ../development/python-modules/inflection { };

  influxdb = callPackage ../development/python-modules/influxdb { };

  infoqscraper = callPackage ../development/python-modules/infoqscraper { };

  inifile = callPackage ../development/python-modules/inifile { };

  interruptingcow = callPackage ../development/python-modules/interruptingcow {};

  iocapture = callPackage ../development/python-modules/iocapture { };

  iptools = callPackage ../development/python-modules/iptools { };

  ipy = callPackage ../development/python-modules/IPy { };

  ipykernel = if pythonOlder "3.4" then
      callPackage ../development/python-modules/ipykernel/4.nix { }
    else
      callPackage ../development/python-modules/ipykernel { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  ipython = if pythonOlder "3.5" then
      callPackage ../development/python-modules/ipython/5.nix { }
    else
      callPackage ../development/python-modules/ipython { };

  ipython_genutils = callPackage ../development/python-modules/ipython_genutils { };

  ipywidgets = callPackage ../development/python-modules/ipywidgets { };

  ipaddr = callPackage ../development/python-modules/ipaddr { };

  ipaddress = callPackage ../development/python-modules/ipaddress { };

  ipdb = callPackage ../development/python-modules/ipdb { };

  ipdbplugin = callPackage ../development/python-modules/ipdbplugin { };

  pythonIRClib = callPackage ../development/python-modules/pythonirclib { };

  iso-639 = callPackage ../development/python-modules/iso-639 {};

  iso3166 = callPackage ../development/python-modules/iso3166 {};

  iso8601 = callPackage ../development/python-modules/iso8601 { };

  isort = callPackage ../development/python-modules/isort {};

  jabberbot = callPackage ../development/python-modules/jabberbot {};

  jedi = callPackage ../development/python-modules/jedi { };

  jellyfish = callPackage ../development/python-modules/jellyfish { };

  jeepney = callPackage ../development/python-modules/jeepney { };

  j2cli = callPackage ../development/python-modules/j2cli { };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2_time = callPackage ../development/python-modules/jinja2_time { };

  jinja2_pluralize = callPackage ../development/python-modules/jinja2_pluralize { };

  jmespath = callPackage ../development/python-modules/jmespath { };

  journalwatch = callPackage ../tools/system/journalwatch {
    inherit (self) systemd pytest;
  };

  jq = callPackage ../development/python-modules/jq {
    inherit (pkgs) jq;
  };

  jsondate = callPackage ../development/python-modules/jsondate { };

  jsondiff = callPackage ../development/python-modules/jsondiff { };

  jsonnet = buildPythonPackage {
    inherit (pkgs.jsonnet) name src;
  };

  jupyter_client = callPackage ../development/python-modules/jupyter_client { };

  jupyter_core = callPackage ../development/python-modules/jupyter_core { };

  jupyter-repo2docker = callPackage ../development/python-modules/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyterhub = callPackage ../development/python-modules/jupyterhub { };

  jupyterhub-ldapauthenticator = callPackage ../development/python-modules/jupyterhub-ldapauthenticator { };

  keyring = callPackage ../development/python-modules/keyring { };

  keyutils = callPackage ../development/python-modules/keyutils { inherit (pkgs) keyutils; };

  kiwisolver = callPackage ../development/python-modules/kiwisolver { };

  klaus = callPackage ../development/python-modules/klaus {};

  klein = callPackage ../development/python-modules/klein { };

  koji = callPackage ../development/python-modules/koji { };

  kombu = callPackage ../development/python-modules/kombu { };

  konfig = callPackage ../development/python-modules/konfig { };

  kitchen = callPackage ../development/python-modules/kitchen { };

  kubernetes = callPackage ../development/python-modules/kubernetes { };

  pylast = callPackage ../development/python-modules/pylast { };

  pylru = callPackage ../development/python-modules/pylru { };

  libnl-python = disabledIf isPy3k
    (toPythonModule (pkgs.libnl.override{pythonSupport=true; inherit python; })).py;

  lark-parser = callPackage ../development/python-modules/lark-parser { };

  jsonpath_rw = callPackage ../development/python-modules/jsonpath_rw { };

  kerberos = callPackage ../development/python-modules/kerberos {
    inherit (pkgs) kerberos;
  };

  lazy-object-proxy = callPackage ../development/python-modules/lazy-object-proxy { };

  ldaptor = callPackage ../development/python-modules/ldaptor { };

  le = callPackage ../development/python-modules/le { };

  lektor = callPackage ../development/python-modules/lektor { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  python_openzwave = callPackage ../development/python-modules/python_openzwave {
    inherit (pkgs) pkgconfig;
  };

  python-Levenshtein = callPackage ../development/python-modules/python-levenshtein { };

  fs = callPackage ../development/python-modules/fs { };

  fs-s3fs = callPackage ../development/python-modules/fs-s3fs { };

  libarcus = callPackage ../development/python-modules/libarcus { };

  libcloud = callPackage ../development/python-modules/libcloud { };

  libgpuarray = callPackage ../development/python-modules/libgpuarray {
    clblas = pkgs.clblas.override { boost = self.boost; };
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
  };

  libkeepass = callPackage ../development/python-modules/libkeepass { };

  librepo = toPythonModule (pkgs.librepo.override {
    inherit python;
  });

  libnacl = callPackage ../development/python-modules/libnacl {
    inherit (pkgs) libsodium;
  };

  libsavitar = callPackage ../development/python-modules/libsavitar { };

  libplist = disabledIf isPy3k
    (toPythonModule (pkgs.libplist.override{python2Packages=self; })).py;

  libxml2 = toPythonModule (pkgs.libxml2.override{pythonSupport=true; python2=python;}).py;

  libxslt = disabledIf isPy3k
    (toPythonModule (pkgs.libxslt.override{pythonSupport=true; python2=python; inherit (self) libxml2;})).py;

  limits = callPackage ../development/python-modules/limits { };

  limnoria = callPackage ../development/python-modules/limnoria { };

  line_profiler = callPackage ../development/python-modules/line_profiler { };

  linode = callPackage ../development/python-modules/linode { };

  linode-api = callPackage ../development/python-modules/linode-api { };

  livereload = callPackage ../development/python-modules/livereload { };

  llfuse = callPackage ../development/python-modules/llfuse {
    inherit (pkgs) fuse pkgconfig; # use "real" fuse and pkgconfig, not the python modules
  };

  locustio = callPackage ../development/python-modules/locustio { };

  llvmlite = callPackage ../development/python-modules/llvmlite { llvm = pkgs.llvm_6; };

  lockfile = callPackage ../development/python-modules/lockfile { };

  logilab_common = callPackage ../development/python-modules/logilab/common.nix {};

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix {};

  lxml = callPackage ../development/python-modules/lxml {inherit (pkgs) libxml2 libxslt;};

  lxc = callPackage ../development/python-modules/lxc { };

  py_scrypt = callPackage ../development/python-modules/py_scrypt { };

  python_magic = callPackage ../development/python-modules/python-magic { };

  magic = callPackage ../development/python-modules/magic { };

  m2crypto = callPackage ../development/python-modules/m2crypto { };

  Mako = callPackage ../development/python-modules/Mako { };

  manifestparser = callPackage ../development/python-modules/marionette-harness/manifestparser.nix {};
  marionette_driver = callPackage ../development/python-modules/marionette-harness/marionette_driver.nix {};
  mozcrash = callPackage ../development/python-modules/marionette-harness/mozcrash.nix {};
  mozdevice = callPackage ../development/python-modules/marionette-harness/mozdevice.nix {};
  mozfile = callPackage ../development/python-modules/marionette-harness/mozfile.nix {};
  mozhttpd = callPackage ../development/python-modules/marionette-harness/mozhttpd.nix {};
  mozinfo = callPackage ../development/python-modules/marionette-harness/mozinfo.nix {};
  mozlog = callPackage ../development/python-modules/marionette-harness/mozlog.nix {};
  moznetwork = callPackage ../development/python-modules/marionette-harness/moznetwork.nix {};
  mozprocess = callPackage ../development/python-modules/marionette-harness/mozprocess.nix {};
  mozprofile = callPackage ../development/python-modules/marionette-harness/mozprofile.nix {};
  mozrunner = callPackage ../development/python-modules/marionette-harness/mozrunner.nix {};
  moztest = callPackage ../development/python-modules/marionette-harness/moztest.nix {};
  mozversion = callPackage ../development/python-modules/marionette-harness/mozversion.nix {};
  marionette-harness = callPackage ../development/python-modules/marionette-harness {};

  marisa = callPackage ../development/python-modules/marisa {
    marisa = pkgs.marisa;
  };

  marisa-trie = callPackage ../development/python-modules/marisa-trie { };

  markupsafe = callPackage ../development/python-modules/markupsafe { };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  manuel = callPackage ../development/python-modules/manuel { };

  mapsplotlib = callPackage ../development/python-modules/mapsplotlib { };

  markdown = callPackage ../development/python-modules/markdown { };

  markdownsuperscript = callPackage ../development/python-modules/markdownsuperscript {};

  markdown-macros = callPackage ../development/python-modules/markdown-macros { };

  mathics = callPackage ../development/python-modules/mathics { };

  matplotlib = let
    path = if isPy3k then ../development/python-modules/matplotlib/default.nix else
      ../development/python-modules/matplotlib/2.nix;
  in callPackage path {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
    inherit (pkgs) pkgconfig;
  };

  matrix-client = callPackage ../development/python-modules/matrix-client { };

  mautrix-appservice = callPackage ../development/python-modules/mautrix-appservice { };

  maya = callPackage ../development/python-modules/maya { };

  mccabe = callPackage ../development/python-modules/mccabe { };

  mechanize = callPackage ../development/python-modules/mechanize { };

  MechanicalSoup = callPackage ../development/python-modules/MechanicalSoup { };

  meld3 = callPackage ../development/python-modules/meld3 { };

  meliae = callPackage ../development/python-modules/meliae {};

  meinheld = callPackage ../development/python-modules/meinheld { };

  memcached = callPackage ../development/python-modules/memcached { };

  memory_profiler = callPackage ../development/python-modules/memory_profiler { };

  metaphone = callPackage ../development/python-modules/metaphone { };

  mezzanine = callPackage ../development/python-modules/mezzanine { };

  micawber = callPackage ../development/python-modules/micawber { };

  milksnake = callPackage ../development/python-modules/milksnake { };

  minimock = callPackage ../development/python-modules/minimock { };

  moviepy = callPackage ../development/python-modules/moviepy { };

  mozterm = callPackage ../development/python-modules/mozterm { };

  mplleaflet = callPackage ../development/python-modules/mplleaflet { };

  multidict = callPackage ../development/python-modules/multidict { };

  munch = callPackage ../development/python-modules/munch { };

  nototools = callPackage ../data/fonts/noto-fonts/tools.nix { };

  rainbowstream = callPackage ../development/python-modules/rainbowstream { };

  pendulum = callPackage ../development/python-modules/pendulum { };

  pocket = callPackage ../development/python-modules/pocket { };

  mistune = callPackage ../development/python-modules/mistune { };

  brotlipy = callPackage ../development/python-modules/brotlipy { };

  sortedcollections = callPackage ../development/python-modules/sortedcollections { };

  hyperframe = callPackage ../development/python-modules/hyperframe { };

  h2 = callPackage ../development/python-modules/h2 { };

  editorconfig = callPackage ../development/python-modules/editorconfig { };

  mock = callPackage ../development/python-modules/mock { };

  mock-open = callPackage ../development/python-modules/mock-open { };

  mockito = callPackage ../development/python-modules/mockito { };

  moderngl = callPackage ../development/python-modules/moderngl { };

  modestmaps = callPackage ../development/python-modules/modestmaps { };

  # Needed here because moinmoin is loaded as a Python library.
  moinmoin = callPackage ../development/python-modules/moinmoin { };

  moretools = callPackage ../development/python-modules/moretools { };

  moto = callPackage ../development/python-modules/moto {};

  mox = callPackage ../development/python-modules/mox { };

  mozsvc = callPackage ../development/python-modules/mozsvc { };

  mpmath = callPackage ../development/python-modules/mpmath { };

  mpd = callPackage ../development/python-modules/mpd { };

  mpd2 = callPackage ../development/python-modules/mpd2 { };

  mpv = callPackage ../development/python-modules/mpv { };

  mrbob = callPackage ../development/python-modules/mrbob {};

  msgpack = callPackage ../development/python-modules/msgpack {};

  msgpack-numpy = callPackage ../development/python-modules/msgpack-numpy {};

  msgpack-python = self.msgpack.overridePythonAttrs {
    pname = "msgpack-python";
    postPatch = ''
      substituteInPlace setup.py --replace "TRANSITIONAL = False" "TRANSITIONAL = True"
    '';
  };

  msrplib = callPackage ../development/python-modules/msrplib { };

  multipledispatch = callPackage ../development/python-modules/multipledispatch { };

  multiprocess = callPackage ../development/python-modules/multiprocess { };

  munkres = callPackage ../development/python-modules/munkres { };

  musicbrainzngs = callPackage ../development/python-modules/musicbrainzngs { };

  mutag = callPackage ../development/python-modules/mutag { };

  mutagen = callPackage ../development/python-modules/mutagen { };

  muttils = callPackage ../development/python-modules/muttils { };

  mygpoclient = callPackage ../development/python-modules/mygpoclient { };

  mysqlclient = callPackage ../development/python-modules/mysqlclient { };

  mypy = callPackage ../development/python-modules/mypy { };

  mypy_extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  neuronpy = callPackage ../development/python-modules/neuronpy { };

  pint = callPackage ../development/python-modules/pint { };

  pygal = callPackage ../development/python-modules/pygal { };

  pytaglib = callPackage ../development/python-modules/pytaglib { };

  pyte = callPackage ../development/python-modules/pyte { };

  graphviz = callPackage ../development/python-modules/graphviz {
    inherit (pkgs) graphviz;
  };

  pygraphviz = callPackage ../development/python-modules/pygraphviz {
    inherit (pkgs) graphviz pkgconfig; # not the python package
  };

  pymc3 = callPackage ../development/python-modules/pymc3 { };

  pympler = callPackage ../development/python-modules/pympler { };

  pymysqlsa = callPackage ../development/python-modules/pymysqlsa { };

  monosat = disabledIf (!isPy3k) (pkgs.monosat.python { inherit buildPythonPackage; inherit (self) cython; });

  monotonic = callPackage ../development/python-modules/monotonic { };

  MySQL_python = callPackage ../development/python-modules/mysql_python { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  namebench = callPackage ../development/python-modules/namebench { };

  namedlist = callPackage ../development/python-modules/namedlist { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

  slixmpp = callPackage ../development/python-modules/slixmpp {
    inherit (pkgs) gnupg;
  };

  netaddr = callPackage ../development/python-modules/netaddr { };

  netifaces = callPackage ../development/python-modules/netifaces { };

  hpack = callPackage ../development/python-modules/hpack { };

  nevow = callPackage ../development/python-modules/nevow { };

  nibabel = callPackage ../development/python-modules/nibabel {};

  nilearn = callPackage ../development/python-modules/nilearn {};

  nimfa = callPackage ../development/python-modules/nimfa {};

  nipy = callPackage ../development/python-modules/nipy { };

  nipype = callPackage ../development/python-modules/nipype {
    inherit (pkgs) which;
  };

  nixpkgs = callPackage ../development/python-modules/nixpkgs { };

  nodeenv = callPackage ../development/python-modules/nodeenv { };

  nose = callPackage ../development/python-modules/nose { };

  nose-cov = callPackage ../development/python-modules/nose-cov { };

  nose-exclude = callPackage ../development/python-modules/nose-exclude { };

  nose-focus = callPackage ../development/python-modules/nose-focus { };

  nose-randomly = callPackage ../development/python-modules/nose-randomly { };

  nose2 = callPackage ../development/python-modules/nose2 { };

  nose-cover3 = callPackage ../development/python-modules/nose-cover3 { };

  nosexcover = callPackage ../development/python-modules/nosexcover { };

  nosejs = callPackage ../development/python-modules/nosejs { };

  nose-cprof = callPackage ../development/python-modules/nose-cprof { };

  nose-of-yeti = callPackage ../development/python-modules/nose-of-yeti { };

  nose-pattern-exclude = callPackage ../development/python-modules/nose-pattern-exclude { };

  nose_warnings_filters = callPackage ../development/python-modules/nose_warnings_filters { };

  notebook = callPackage ../development/python-modules/notebook { };

  notify = callPackage ../development/python-modules/notify { };

  notify2 = callPackage ../development/python-modules/notify2 {};

  notmuch = callPackage ../development/python-modules/notmuch { };

  emoji = callPackage ../development/python-modules/emoji { };

  ntplib = callPackage ../development/python-modules/ntplib { };

  numba = callPackage ../development/python-modules/numba { };

  numexpr = callPackage ../development/python-modules/numexpr { };

  Nuitka = callPackage ../development/python-modules/nuitka { };

  numpy = callPackage ../development/python-modules/numpy {
    blas = pkgs.openblasCompat;
  };

  numpydoc = callPackage ../development/python-modules/numpydoc { };

  numpy-stl = callPackage ../development/python-modules/numpy-stl { };

  numtraits = callPackage ../development/python-modules/numtraits { };

  nwdiag = callPackage ../development/python-modules/nwdiag { };

  dynd = callPackage ../development/python-modules/dynd { };

  langcodes = callPackage ../development/python-modules/langcodes { };

  livestreamer = callPackage ../development/python-modules/livestreamer { };

  livestreamer-curses = callPackage ../development/python-modules/livestreamer-curses { };

  oauth = callPackage ../development/python-modules/oauth { };

  oauth2 = callPackage ../development/python-modules/oauth2 { };

  oauth2client = callPackage ../development/python-modules/oauth2client { };

  oauthlib = callPackage ../development/python-modules/oauthlib { };

  obfsproxy = callPackage ../development/python-modules/obfsproxy { };

  objgraph = callPackage ../development/python-modules/objgraph {
    graphvizPkg = pkgs.graphviz;
  };

  odo = callPackage ../development/python-modules/odo { };

  offtrac = callPackage ../development/python-modules/offtrac { };

  openpyxl = callPackage ../development/python-modules/openpyxl { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  ordereddict = callPackage ../development/python-modules/ordereddict { };

  od = callPackage ../development/python-modules/od { };

  orderedset = callPackage ../development/python-modules/orderedset { };

  python-otr = callPackage ../development/python-modules/python-otr { };

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  ply = callPackage ../development/python-modules/ply { };

  plyplus = callPackage ../development/python-modules/plyplus { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  osc = callPackage ../development/python-modules/osc { };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  cachetools = callPackage ../development/python-modules/cachetools {};

  cmd2_8 = callPackage ../development/python-modules/cmd2/old.nix {};
  cmd2_9 = callPackage ../development/python-modules/cmd2 {};
  cmd2 = if isPy27 then self.cmd2_8 else self.cmd2_9;

  warlock = callPackage ../development/python-modules/warlock { };

  pecan = callPackage ../development/python-modules/pecan { };

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  Kajiki = callPackage ../development/python-modules/kajiki { };

  WSME = callPackage ../development/python-modules/WSME { };

  zake = callPackage ../development/python-modules/zake { };

  kazoo = callPackage ../development/python-modules/kazoo { };

  FormEncode = callPackage ../development/python-modules/FormEncode { };

  pycountry = callPackage ../development/python-modules/pycountry { };

  nine = callPackage ../development/python-modules/nine { };

  logutils = callPackage ../development/python-modules/logutils { };

  ldappool = callPackage ../development/python-modules/ldappool { };

  retrying = callPackage ../development/python-modules/retrying { };

  fasteners = callPackage ../development/python-modules/fasteners { };

  aioeventlet = callPackage ../development/python-modules/aioeventlet { };

  olefile = callPackage ../development/python-modules/olefile { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  mox3 = callPackage ../development/python-modules/mox3 { };

  doc8 = callPackage ../development/python-modules/doc8 { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  pagerduty = callPackage ../development/python-modules/pagerduty { };

  pandas = callPackage ../development/python-modules/pandas { };

  xlrd = callPackage ../development/python-modules/xlrd { };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt { };

  pamqp = callPackage ../development/python-modules/pamqp { };

  parsedatetime = callPackage ../development/python-modules/parsedatetime { };

  paramiko = callPackage ../development/python-modules/paramiko { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  paramz = callPackage ../development/python-modules/paramz { };

  parsel = callPackage ../development/python-modules/parsel { };

  parso = callPackage ../development/python-modules/parso { };

  partd = callPackage ../development/python-modules/partd { };

  patch = callPackage ../development/python-modules/patch { };

  pathos = callPackage ../development/python-modules/pathos { };

  patsy = callPackage ../development/python-modules/patsy { };

  paste = callPackage ../development/python-modules/paste { };

  PasteDeploy = callPackage ../development/python-modules/pastedeploy { };

  pasteScript = callPackage ../development/python-modules/pastescript { };

  patator = callPackage ../development/python-modules/patator { };

  pathlib2 = callPackage ../development/python-modules/pathlib2 { };

  pathpy = callPackage ../development/python-modules/path.py { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbr = callPackage ../development/python-modules/pbr { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  pelican = callPackage ../development/python-modules/pelican {
    inherit (pkgs) glibcLocales git;
  };

  pep8 = callPackage ../development/python-modules/pep8 { };

  pep257 = callPackage ../development/python-modules/pep257 { };

  percol = callPackage ../development/python-modules/percol { };

  pexif = callPackage ../development/python-modules/pexif { };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pdfkit = callPackage ../development/python-modules/pdfkit { };

  periodictable = callPackage ../development/python-modules/periodictable { };

  pg8000 = callPackage ../development/python-modules/pg8000 { };

  pgsanity = callPackage ../development/python-modules/pgsanity { };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  pickleshare = callPackage ../development/python-modules/pickleshare { };

  piep = callPackage ../development/python-modules/piep { };

  piexif = callPackage ../development/python-modules/piexif { };

  pip = callPackage ../development/python-modules/pip { };

  pip-tools = callPackage ../development/python-modules/pip-tools {
    git = pkgs.gitMinimal;
    glibcLocales = pkgs.glibcLocales;
  };

  pika = callPackage ../development/python-modules/pika { };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  kmsxx = (callPackage ../development/libraries/kmsxx {
    inherit (pkgs.kmsxx) stdenv;
    inherit (pkgs) pkgconfig;
  }).overrideAttrs (oldAttrs: {
    name = "${python.libPrefix}-${pkgs.kmsxx.name}";
  });

  precis-i18n = callPackage ../development/python-modules/precis-i18n { };

  pvlib = callPackage ../development/python-modules/pvlib { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibmc = callPackage ../development/python-modules/pylibmc {};

  pymetar = callPackage ../development/python-modules/pymetar { };

  pysftp = callPackage ../development/python-modules/pysftp { };

  pysoundfile = callPackage ../development/python-modules/pysoundfile { };

  python3pika = callPackage ../development/python-modules/python3pika { };

  python-jenkins = callPackage ../development/python-modules/python-jenkins { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pillow = callPackage ../development/python-modules/pillow {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11;
  };

  pkgconfig = callPackage ../development/python-modules/pkgconfig {
    inherit (pkgs) pkgconfig;
  };

  plumbum = callPackage ../development/python-modules/plumbum { };

  polib = callPackage ../development/python-modules/polib {};

  posix_ipc = callPackage ../development/python-modules/posix_ipc { };

  portend = callPackage ../development/python-modules/portend { };

  powerline = callPackage ../development/python-modules/powerline { };

  pox = callPackage ../development/python-modules/pox { };

  ppft = callPackage ../development/python-modules/ppft { };

  praw = callPackage ../development/python-modules/praw { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  premailer = callPackage ../development/python-modules/premailer { };

  prettytable = callPackage ../development/python-modules/prettytable { };

  prompt_toolkit = let
    filename = if isPy3k then ../development/python-modules/prompt_toolkit else ../development/python-modules/prompt_toolkit/1.nix;
  in callPackage filename { };

  protobuf = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    doCheck = !isPy3k;
    protobuf = pkgs.protobuf;
  };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psutil = callPackage ../development/python-modules/psutil { };

  psycopg2 = callPackage ../development/python-modules/psycopg2 {};

  ptpython = callPackage ../development/python-modules/ptpython {
    prompt_toolkit = self.prompt_toolkit;
  };

  publicsuffix = callPackage ../development/python-modules/publicsuffix {};

  py = callPackage ../development/python-modules/py { };

  pyacoustid = callPackage ../development/python-modules/pyacoustid { };

  pyalgotrade = callPackage ../development/python-modules/pyalgotrade { };

  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyaudio = callPackage ../development/python-modules/pyaudio { };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = callPackage ../development/python-modules/pysaml2 {
    inherit (pkgs) xmlsec;
  };

  python-pushover = callPackage ../development/python-modules/pushover {};

  pystemd = callPackage ../development/python-modules/pystemd { systemd = pkgs.systemd; };

  mongodict = callPackage ../development/python-modules/mongodict { };

  repoze_who = callPackage ../development/python-modules/repoze_who { };

  vobject = callPackage ../development/python-modules/vobject { };

  pycarddav = callPackage ../development/python-modules/pycarddav { };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  Babel = callPackage ../development/python-modules/Babel { };

  pybfd = callPackage ../development/python-modules/pybfd { };

  pyblock = callPackage ../development/python-modules/pyblock { };

  pybcrypt = callPackage ../development/python-modules/pybcrypt { };

  pyblosxom = callPackage ../development/python-modules/pyblosxom { };

  pycapnp = callPackage ../development/python-modules/pycapnp { };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycdio = callPackage ../development/python-modules/pycdio { };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycryptopp = callPackage ../development/python-modules/pycryptopp { };

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycurl2 = callPackage ../development/python-modules/pycurl2 { };

  pydispatcher = callPackage ../development/python-modules/pydispatcher { };

  pydot = callPackage ../development/python-modules/pydot {
    inherit (pkgs) graphviz;
  };

  pydot_ng = callPackage ../development/python-modules/pydot_ng { };

  pyelftools = callPackage ../development/python-modules/pyelftools { };

  pyenchant = callPackage ../development/python-modules/pyenchant { };

  pyev = callPackage ../development/python-modules/pyev { };

  pyexcelerator = callPackage ../development/python-modules/pyexcelerator { };

  pyext = callPackage ../development/python-modules/pyext { };

  pyfantom = callPackage ../development/python-modules/pyfantom { };

  pyfftw = callPackage ../development/python-modules/pyfftw { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pygeoip = callPackage ../development/python-modules/pygeoip {};

  PyGithub = callPackage ../development/python-modules/pyGithub {};

  pyglet = callPackage ../development/python-modules/pyglet {};

  pygments = callPackage ../development/python-modules/Pygments { };

  pygpgme = callPackage ../development/python-modules/pygpgme { };

  pyment = callPackage ../development/python-modules/pyment { };

  pylint = if isPy3k then callPackage ../development/python-modules/pylint { }
           else callPackage ../development/python-modules/pylint/1.9.nix { };

  pyopencl = callPackage ../development/python-modules/pyopencl { };

  pyotp = callPackage ../development/python-modules/pyotp { };

  pyproj = callPackage ../development/python-modules/pyproj {
    # pyproj does *work* if you want to use a system supplied proj, but with the current version(s) the tests fail by
    # a few decimal places, so caveat emptor.
    proj = null;
  };

  pyqrcode = callPackage ../development/python-modules/pyqrcode { };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pysha3 = callPackage ../development/python-modules/pysha3 { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pysmbc = callPackage ../development/python-modules/pysmbc {
    inherit (pkgs) pkgconfig;
  };

  pyspread = callPackage ../development/python-modules/pyspread { };

  pyupdate = callPackage ../development/python-modules/pyupdate {};

  pyx = callPackage ../development/python-modules/pyx { };

  mmpython = callPackage ../development/python-modules/mmpython { };

  kaa-base = callPackage ../development/python-modules/kaa-base { };

  kaa-metadata = callPackage ../development/python-modules/kaa-metadata { };

  PyICU = callPackage ../development/python-modules/pyicu { };

  pyinputevent = callPackage ../development/python-modules/pyinputevent { };

  pyinotify = callPackage ../development/python-modules/pyinotify { };

  pyinsane2 = callPackage ../development/python-modules/pyinsane2 { };

  pyjwt = callPackage ../development/python-modules/pyjwt { };

  pykickstart = callPackage ../development/python-modules/pykickstart { };

  pyobjc = if stdenv.isDarwin
    then callPackage ../development/python-modules/pyobjc {}
    else throw "pyobjc can only be built on Mac OS";

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyocr = callPackage ../development/python-modules/pyocr { };

  pyparsing = callPackage ../development/python-modules/pyparsing { };

  pyparted = callPackage ../development/python-modules/pyparted { };

  pyptlib = callPackage ../development/python-modules/pyptlib { };

  pyqtgraph = callPackage ../development/python-modules/pyqtgraph { };

  PyStemmer = callPackage ../development/python-modules/pystemmer {};

  # Missing expression?
  # Pyro = callPackage ../development/python-modules/pyro { };

  pyrsistent = callPackage ../development/python-modules/pyrsistent { };

  PyRSS2Gen = callPackage ../development/python-modules/pyrss2gen { };

  pysmi = callPackage ../development/python-modules/pysmi { };

  pysnmp = callPackage ../development/python-modules/pysnmp { };

  pysocks = callPackage ../development/python-modules/pysocks { };

  python_fedora = callPackage ../development/python-modules/python_fedora {};

  python-simple-hipchat = callPackage ../development/python-modules/python-simple-hipchat {};
  python_simple_hipchat = self.python-simple-hipchat;

  python_keyczar = callPackage ../development/python-modules/python_keyczar { };

  python-language-server = callPackage ../development/python-modules/python-language-server {};

  python-jsonrpc-server = callPackage ../development/python-modules/python-jsonrpc-server {};

  pyls-black = callPackage ../development/python-modules/pyls-black {};

  pyls-isort = callPackage ../development/python-modules/pyls-isort {};

  pyls-mypy = callPackage ../development/python-modules/pyls-mypy {};

  pyu2f = callPackage ../development/python-modules/pyu2f { };

  pyudev = callPackage ../development/python-modules/pyudev {
    inherit (pkgs) systemd;
  };

  pynmea2 = callPackage ../development/python-modules/pynmea2 {};

  pynzb = callPackage ../development/python-modules/pynzb { };

  process-tests = callPackage ../development/python-modules/process-tests { };

  progressbar = callPackage ../development/python-modules/progressbar {};

  progressbar2 = callPackage ../development/python-modules/progressbar2 { };

  progressbar231 = callPackage ../development/python-modules/progressbar231 { };

  progressbar33 = callPackage ../development/python-modules/progressbar33 { };

  ldap = callPackage ../development/python-modules/ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  ldap3 = callPackage ../development/python-modules/ldap3 {};

  ptest = callPackage ../development/python-modules/ptest { };

  ptyprocess = callPackage ../development/python-modules/ptyprocess { };

  pylibacl = callPackage ../development/python-modules/pylibacl { };

  pylibgen = callPackage ../development/python-modules/pylibgen { };

  pyliblo = callPackage ../development/python-modules/pyliblo { };

  pypcap = callPackage ../development/python-modules/pypcap {};

  pyplatec = callPackage ../development/python-modules/pyplatec { };

  purepng = callPackage ../development/python-modules/purepng { };

  pymaging = callPackage ../development/python-modules/pymaging { };

  pymaging_png = callPackage ../development/python-modules/pymaging_png { };

  pyPdf = callPackage ../development/python-modules/pypdf { };

  pypdf2 = callPackage ../development/python-modules/pypdf2 { };

  pyopengl = callPackage ../development/python-modules/pyopengl { };

  pyopenssl = callPackage ../development/python-modules/pyopenssl { };

  pyquery = callPackage ../development/python-modules/pyquery { };

  pyreport = callPackage ../development/python-modules/pyreport { };

  pyreadability = callPackage ../development/python-modules/pyreadability { };

  pyscss = callPackage ../development/python-modules/pyscss { };

  pyserial = callPackage ../development/python-modules/pyserial {};

  pymongo = callPackage ../development/python-modules/pymongo {};

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pysqlite = callPackage ../development/python-modules/pysqlite { };

  pysvn = callPackage ../development/python-modules/pysvn { };

  python-ptrace = callPackage ../development/python-modules/python-ptrace { };

  python-wifi = callPackage ../development/python-modules/python-wifi { };

  python-etcd = callPackage ../development/python-modules/python-etcd { };

  pythonnet = callPackage ../development/python-modules/pythonnet {
    # `mono >= 4.6` required to prevent crashes encountered with earlier versions.
    mono = pkgs.mono4;
    inherit (pkgs) pkgconfig;
  };

  pytz = callPackage ../development/python-modules/pytz { };

  pytzdata = callPackage ../development/python-modules/pytzdata { };

  pyutil = callPackage ../development/python-modules/pyutil { };

  pywal = callPackage ../development/python-modules/pywal { };

  pywebkitgtk = callPackage ../development/python-modules/pywebkitgtk { };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pyxattr = callPackage ../development/python-modules/pyxattr { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  rabbitpy = callPackage ../development/python-modules/rabbitpy { };

  rasterio = callPackage ../development/python-modules/rasterio { };

  radicale_infcloud = callPackage ../development/python-modules/radicale_infcloud {};

  recaptcha_client = callPackage ../development/python-modules/recaptcha_client { };

  rbtools = callPackage ../development/python-modules/rbtools { };

  rencode = callPackage ../development/python-modules/rencode { };

  reportlab = callPackage ../development/python-modules/reportlab { };

  requests = callPackage ../development/python-modules/requests { };

  requests_download = callPackage ../development/python-modules/requests_download { };

  requestsexceptions = callPackage ../development/python-modules/requestsexceptions {};

  requests_ntlm = callPackage ../development/python-modules/requests_ntlm { };

  requests_oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };
  requests_toolbelt = self.requests-toolbelt; # Old attr, 2017-09-26

  retry_decorator = callPackage ../development/python-modules/retry_decorator { };

  quandl = callPackage ../development/python-modules/quandl { };
  # alias for an older package which did not support Python 3
  Quandl = callPackage ../development/python-modules/quandl { };

  qscintilla-qt4 = callPackage ../development/python-modules/qscintilla { };

  qscintilla-qt5 = callPackage ../development/python-modules/qscintilla-qt5 {
    qscintillaCpp = pkgs.libsForQt5.qscintilla;
    lndir = pkgs.xorg.lndir;
  };

  qscintilla = self.qscintilla-qt4;

  qserve = callPackage ../development/python-modules/qserve { };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  quantities = callPackage ../development/python-modules/quantities { };

  qutip = callPackage ../development/python-modules/qutip { };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  redis = callPackage ../development/python-modules/redis { };

  rednose = callPackage ../development/python-modules/rednose { };

  reikna = callPackage ../development/python-modules/reikna { };

  repocheck = callPackage ../development/python-modules/repocheck { };

  restview = callPackage ../development/python-modules/restview { };

  readme = callPackage ../development/python-modules/readme { };

  readme_renderer = callPackage ../development/python-modules/readme_renderer { };

  rivet = disabledIf isPy3k (toPythonModule (pkgs.rivet.override {
    python2 = python;
  }));

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  geoalchemy2 = callPackage ../development/python-modules/geoalchemy2 { };

  geopy = callPackage ../development/python-modules/geopy { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  isodate = callPackage ../development/python-modules/isodate { };

  owslib = callPackage ../development/python-modules/owslib { };

  resampy = callPackage ../development/python-modules/resampy { };

  restructuredtext_lint = callPackage ../development/python-modules/restructuredtext_lint { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-requests = callPackage ../development/python-modules/robotframework-requests { };

  robotframework-ride = callPackage ../development/python-modules/robotframework-ride { };

  robotframework-seleniumlibrary = callPackage ../development/python-modules/robotframework-seleniumlibrary { };

  robotframework-selenium2library = callPackage ../development/python-modules/robotframework-selenium2library { };

  robotframework-tools = callPackage ../development/python-modules/robotframework-tools { };

  robotstatuschecker = callPackage ../development/python-modules/robotstatuschecker { };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  serpent = callPackage ../development/python-modules/serpent { };

  selectors34 = callPackage ../development/python-modules/selectors34 { };

  Pyro4 = callPackage ../development/python-modules/pyro4 { };

  root_numpy = callPackage ../development/python-modules/root_numpy { };

  rootpy = callPackage ../development/python-modules/rootpy { };

  rope = callPackage ../development/python-modules/rope { };

  ropper = callPackage ../development/python-modules/ropper { };

  rpkg = callPackage ../development/python-modules/rpkg {};

  rply = callPackage ../development/python-modules/rply {};

  rpm = toPythonModule (pkgs.rpm.override{inherit python;});

  rpmfluff = callPackage ../development/python-modules/rpmfluff {};

  rpy2 = callPackage ../development/python-modules/rpy2 {};

  rtslib = callPackage ../development/python-modules/rtslib {};

  Rtree = callPackage ../development/python-modules/Rtree { inherit (pkgs) libspatialindex; };

  typing = callPackage ../development/python-modules/typing { };

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  safe = callPackage ../development/python-modules/safe { };

  sampledata = callPackage ../development/python-modules/sampledata { };

  sasmodels = callPackage ../development/python-modules/sasmodels { };

  scapy = callPackage ../development/python-modules/scapy { };

  scipy = callPackage ../development/python-modules/scipy { };

  scikitimage = callPackage ../development/python-modules/scikit-image { };

  scikitlearn = callPackage ../development/python-modules/scikitlearn {
    inherit (pkgs) gfortran glibcLocales;
  };

  scikit-bio = callPackage ../development/python-modules/scikit-bio { };

  scp = callPackage ../development/python-modules/scp {};

  seaborn = callPackage ../development/python-modules/seaborn { };

  selenium = callPackage ../development/python-modules/selenium { };

  serpy = callPackage ../development/python-modules/serpy { };

  setuptools_scm = callPackage ../development/python-modules/setuptools_scm { };

  shippai = callPackage ../development/python-modules/shippai {};

  simanneal = callPackage ../development/python-modules/simanneal { };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  shodan = callPackage ../development/python-modules/shodan { };

  should-dsl = callPackage ../development/python-modules/should-dsl { };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simplekml = callPackage ../development/python-modules/simplekml { };

  slimit = callPackage ../development/python-modules/slimit { };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  snscrape = callPackage ../development/python-modules/snscrape { };

  snug = callPackage ../development/python-modules/snug { };

  snuggs = callPackage ../development/python-modules/snuggs { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  supervisor = callPackage ../development/python-modules/supervisor {};

  subprocess32 = callPackage ../development/python-modules/subprocess32 { };

  spark_parser = callPackage ../development/python-modules/spark_parser { };

  sphinx = callPackage ../development/python-modules/sphinx { };

  sphinx-argparse = callPackage ../development/python-modules/sphinx-argparse { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  guzzle_sphinx_theme = callPackage ../development/python-modules/guzzle_sphinx_theme { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex {};

  sphinx-navtree = callPackage ../development/python-modules/sphinx-navtree {};

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  splinter = callPackage ../development/python-modules/splinter { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy_migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  staticjinja = callPackage ../development/python-modules/staticjinja { };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  structlog = callPackage ../development/python-modules/structlog { };

  sybil = callPackage ../development/python-modules/sybil { };

  # legacy alias
  syncthing-gtk = pkgs.syncthing-gtk;

  systemd = callPackage ../development/python-modules/systemd {
    inherit (pkgs) pkgconfig systemd;
  };

  tabulate = callPackage ../development/python-modules/tabulate { };

  tempita = callPackage ../development/python-modules/tempita { };

  terminado = callPackage ../development/python-modules/terminado { };

  testresources = callPackage ../development/python-modules/testresources { };

  testtools = callPackage ../development/python-modules/testtools { };

  traitlets = callPackage ../development/python-modules/traitlets { };

  transitions = callPackage ../development/python-modules/transitions { };

  extras = callPackage ../development/python-modules/extras { };

  texttable = callPackage ../development/python-modules/texttable { };

  tiros = callPackage ../development/python-modules/tiros { };

  tifffile = callPackage ../development/python-modules/tifffile { };

  tmdb3 = callPackage ../development/python-modules/tmdb3 { };

  toolz = callPackage ../development/python-modules/toolz { };

  tox = callPackage ../development/python-modules/tox { };

  tqdm = callPackage ../development/python-modules/tqdm { };

  smmap = callPackage ../development/python-modules/smmap { };

  smmap2 = callPackage ../development/python-modules/smmap2 { };

  transaction = callPackage ../development/python-modules/transaction { };

  TurboCheetah = callPackage ../development/python-modules/TurboCheetah { };

  tweepy = callPackage ../development/python-modules/tweepy { };

  twill = callPackage ../development/python-modules/twill { };

  twine = callPackage ../development/python-modules/twine { };

  twisted = callPackage ../development/python-modules/twisted { };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  ua-parser = callPackage ../development/python-modules/ua-parser { };

  uarray = callPackage ../development/python-modules/uarray { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  umemcache = callPackage ../development/python-modules/umemcache {};

  uritools = callPackage ../development/python-modules/uritools { };

  update_checker = callPackage ../development/python-modules/update_checker {};

  update-copyright = callPackage ../development/python-modules/update-copyright {};

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uproot = callPackage ../development/python-modules/uproot {};

  uproot-methods = callPackage ../development/python-modules/uproot-methods { };

  urlgrabber = callPackage ../development/python-modules/urlgrabber {};

  urwid = callPackage ../development/python-modules/urwid {};

  user-agents = callPackage ../development/python-modules/user-agents { };

  vega_datasets = callPackage ../development/python-modules/vega_datasets { };

  virtkey = callPackage ../development/python-modules/virtkey {
    inherit (pkgs) pkgconfig;
  };

  virtual-display = callPackage ../development/python-modules/virtual-display { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  webassets = callPackage ../development/python-modules/webassets { };

  webcolors = callPackage ../development/python-modules/webcolors { };

  webencodings = callPackage ../development/python-modules/webencodings { };

  websockets = callPackage ../development/python-modules/websockets { };

  Wand = callPackage ../development/python-modules/Wand { };

  wcwidth = callPackage ../development/python-modules/wcwidth { };

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  wheel = callPackage ../development/python-modules/wheel { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  wordfreq = callPackage ../development/python-modules/wordfreq { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  magic-wormhole-mailbox-server = callPackage ../development/python-modules/magic-wormhole-mailbox-server { };

  magic-wormhole-transit-relay = callPackage ../development/python-modules/magic-wormhole-transit-relay { };

  wxPython = self.wxPython30;

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
    inherit (pkgs) pkgconfig;
  };

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xarray = callPackage ../development/python-modules/xarray { };

  xlwt = callPackage ../development/python-modules/xlwt { };

  youtube-dl = callPackage ../tools/misc/youtube-dl {};

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
    phantomjsSupport = false;
  };

  zconfig = callPackage ../development/python-modules/zconfig { };

  zc_lockfile = callPackage ../development/python-modules/zc_lockfile { };

  zipstream = callPackage ../development/python-modules/zipstream { };

  zodb = callPackage ../development/python-modules/zodb {};

  zodbpickle = callPackage ../development/python-modules/zodbpickle {};

  BTrees = callPackage ../development/python-modules/btrees {};

  persistent = callPackage ../development/python-modules/persistent {};

  xdot = callPackage ../development/python-modules/xdot { };

  zetup = callPackage ../development/python-modules/zetup { };

  routes = callPackage ../development/python-modules/routes { };

  rpyc = callPackage ../development/python-modules/rpyc { };

  rsa = callPackage ../development/python-modules/rsa { };

  squaremap = callPackage ../development/python-modules/squaremap { };

  ruamel_base = callPackage ../development/python-modules/ruamel_base { };

  ruamel_ordereddict = callPackage ../development/python-modules/ruamel_ordereddict { };

  ruamel_yaml = callPackage ../development/python-modules/ruamel_yaml { };

  runsnakerun = callPackage ../development/python-modules/runsnakerun { };

  pysendfile = callPackage ../development/python-modules/pysendfile { };

  qpid-python = callPackage ../development/python-modules/qpid-python { };

  xattr = callPackage ../development/python-modules/xattr { };

  scripttest = callPackage ../development/python-modules/scripttest { };

  setuptoolsDarcs = callPackage ../development/python-modules/setuptoolsdarcs { };

  setuptoolsTrial = callPackage ../development/python-modules/setuptoolstrial { };

  simplebayes = callPackage ../development/python-modules/simplebayes { };

  shortuuid = callPackage ../development/python-modules/shortuuid { };

  shouldbe = callPackage ../development/python-modules/shouldbe { };

  simpleparse = callPackage ../development/python-modules/simpleparse { };

  slob = callPackage ../development/python-modules/slob { };

  slowaes = callPackage ../development/python-modules/slowaes { };

  sqlite3dbm = callPackage ../development/python-modules/sqlite3dbm { };

  sqlobject = callPackage ../development/python-modules/sqlobject { };

  sqlmap = callPackage ../development/python-modules/sqlmap { };

  pgpdump = callPackage ../development/python-modules/pgpdump { };

  spambayes = callPackage ../development/python-modules/spambayes { };

  shapely = callPackage ../development/python-modules/shapely { };

  sharedmem = callPackage ../development/python-modules/sharedmem { };

  soco = callPackage ../development/python-modules/soco { };

  sopel = callPackage ../development/python-modules/sopel { };

  sounddevice = callPackage ../development/python-modules/sounddevice { };

  stevedore = callPackage ../development/python-modules/stevedore {};

  text-unidecode = callPackage ../development/python-modules/text-unidecode { };

  Theano = callPackage ../development/python-modules/Theano rec {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    inherit (pkgs.linuxPackages) nvidia_x11;
  };

  TheanoWithoutCuda = self.Theano.override {
    cudaSupport = false;
    cudnnSupport = false;
  };

  TheanoWithCuda = self.Theano.override {
    cudaSupport = true;
    cudnnSupport = true;
  };

  thespian = callPackage ../development/python-modules/thespian { };

  tidylib = callPackage ../development/python-modules/pytidylib { };

  tilestache = callPackage ../development/python-modules/tilestache { };

  timelib = callPackage ../development/python-modules/timelib { };

  timeout-decorator = callPackage ../development/python-modules/timeout-decorator { };

  pid = callPackage ../development/python-modules/pid { };

  pip2nix = callPackage ../development/python-modules/pip2nix { };

  pychef = callPackage ../development/python-modules/pychef { };

  pydns =
    let
      py3 = callPackage ../development/python-modules/py3dns { };

      py2 = callPackage ../development/python-modules/pydns { };
    in if isPy3k then py3 else py2;

  python-daemon = callPackage ../development/python-modules/python-daemon { };

  python-vagrant = callPackage ../development/python-modules/python-vagrant { };

  sympy = callPackage ../development/python-modules/sympy { };

  pilkit = callPackage ../development/python-modules/pilkit { };

  clint = callPackage ../development/python-modules/clint { };

  argh = callPackage ../development/python-modules/argh { };

  nose_progressive = callPackage ../development/python-modules/nose_progressive { };

  blessings = callPackage ../development/python-modules/blessings { };

  secretstorage = if isPy3k
    then callPackage ../development/python-modules/secretstorage { }
    else callPackage ../development/python-modules/secretstorage/2.nix { };

  semantic = callPackage ../development/python-modules/semantic { };

  sandboxlib = callPackage ../development/python-modules/sandboxlib { };

  scales = callPackage ../development/python-modules/scales { };

  secp256k1 = callPackage ../development/python-modules/secp256k1 {
    inherit (pkgs) secp256k1 pkgconfig;
  };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  sexpdata = callPackage ../development/python-modules/sexpdata { };

  sh = callPackage ../development/python-modules/sh { };

  sipsimple = callPackage ../development/python-modules/sipsimple { };

  six = callPackage ../development/python-modules/six { };

  smartdc = callPackage ../development/python-modules/smartdc { };

  socksipy-branch = callPackage ../development/python-modules/socksipy-branch { };

  sockjs-tornado = callPackage ../development/python-modules/sockjs-tornado { };

  sorl_thumbnail = callPackage ../development/python-modules/sorl_thumbnail { };

  sphinx_rtd_theme = callPackage ../development/python-modules/sphinx_rtd_theme { };

  sphinxcontrib-blockdiag = callPackage ../development/python-modules/sphinxcontrib-blockdiag { };

  sphinxcontrib-openapi = callPackage ../development/python-modules/sphinxcontrib-openapi { };

  sphinxcontrib_httpdomain = callPackage ../development/python-modules/sphinxcontrib_httpdomain { };

  sphinxcontrib_newsfeed = callPackage ../development/python-modules/sphinxcontrib_newsfeed { };

  sphinxcontrib_plantuml = callPackage ../development/python-modules/sphinxcontrib_plantuml { };

  sphinxcontrib-spelling = callPackage ../development/python-modules/sphinxcontrib-spelling { };

  sphinx_pypi_upload = callPackage ../development/python-modules/sphinx_pypi_upload { };

  Pweave = callPackage ../development/python-modules/pweave { };

  SQLAlchemy-ImageAttach = callPackage ../development/python-modules/sqlalchemy-imageattach { };

  sqlparse = callPackage ../development/python-modules/sqlparse { };

  python_statsd = callPackage ../development/python-modules/python_statsd { };

  stompclient = callPackage ../development/python-modules/stompclient { };

  subdownloader = callPackage ../development/python-modules/subdownloader { };

  subunit = callPackage ../development/python-modules/subunit { };

  sure = callPackage ../development/python-modules/sure { };

  svgwrite = callPackage ../development/python-modules/svgwrite { };

  freezegun = callPackage ../development/python-modules/freezegun { };

  taskw = callPackage ../development/python-modules/taskw { };

  telethon = callPackage ../development/python-modules/telethon { };

  telethon-session-sqlalchemy = callPackage ../development/python-modules/telethon-session-sqlalchemy { };

  terminaltables = callPackage ../development/python-modules/terminaltables { };

  testpath = callPackage ../development/python-modules/testpath { };

  testrepository = callPackage ../development/python-modules/testrepository { };

  testscenarios = callPackage ../development/python-modules/testscenarios { };

  python_mimeparse = callPackage ../development/python-modules/python_mimeparse { };

  # Tkinter/tkinter is part of the Python standard library.
  # The Python interpreters in Nixpkgs come without tkinter by default.
  # To make the module available, we make it available as any other
  # Python package.
  tkinter = let
    py = python.override{x11Support=true;};
  in callPackage ../development/python-modules/tkinter { py = py; };

  tlslite-ng = callPackage ../development/python-modules/tlslite-ng { };

  qrcode = callPackage ../development/python-modules/qrcode { };

  traits = callPackage ../development/python-modules/traits { };

  transmissionrpc = callPackage ../development/python-modules/transmissionrpc { };

  eggdeps = callPackage ../development/python-modules/eggdeps { };

  twiggy = callPackage ../development/python-modules/twiggy { };

  twitter = callPackage ../development/python-modules/twitter { };

  twitter-common-collections = callPackage ../development/python-modules/twitter-common-collections { };

  twitter-common-confluence = callPackage ../development/python-modules/twitter-common-confluence { };

  twitter-common-dirutil = callPackage ../development/python-modules/twitter-common-dirutil { };

  twitter-common-lang = callPackage ../development/python-modules/twitter-common-lang { };

  twitter-common-log = callPackage ../development/python-modules/twitter-common-log { };

  twitter-common-options = callPackage ../development/python-modules/twitter-common-options { };

  umalqurra = callPackage ../development/python-modules/umalqurra { };

  unicodecsv = callPackage ../development/python-modules/unicodecsv { };

  unidiff = callPackage ../development/python-modules/unidiff { };

  unittest2 = callPackage ../development/python-modules/unittest2 { };

  unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

  traceback2 = callPackage ../development/python-modules/traceback2 { };

  linecache2 = callPackage ../development/python-modules/linecache2 { };

  upass = callPackage ../development/python-modules/upass { };

  uptime = callPackage ../development/python-modules/uptime { };

  urwidtrees = callPackage ../development/python-modules/urwidtrees { };

  pyuv = callPackage ../development/python-modules/pyuv { };

  virtualenv-clone = callPackage ../development/python-modules/virtualenv-clone { };

  virtualenvwrapper = callPackage ../development/python-modules/virtualenvwrapper { };

  vmprof = callPackage ../development/python-modules/vmprof { };

  vultr = callPackage ../development/python-modules/vultr { };

  waitress = callPackage ../development/python-modules/waitress { };

  waitress-django = callPackage ../development/python-modules/waitress-django { };

  web = callPackage ../development/python-modules/web { };

  webob = callPackage ../development/python-modules/webob { };

  websockify = callPackage ../development/python-modules/websockify { };

  webtest = callPackage ../development/python-modules/webtest { };

  wsgiproxy2 = callPackage ../development/python-modules/wsgiproxy2 { };

  xcaplib = callPackage ../development/python-modules/xcaplib { };

  xlib = callPackage ../development/python-modules/xlib { };

  zbase32 = callPackage ../development/python-modules/zbase32 { };

  zdaemon = callPackage ../development/python-modules/zdaemon { };

  zfec = callPackage ../development/python-modules/zfec { };

  zope_broken = callPackage ../development/python-modules/zope_broken { };

  zope_component = callPackage ../development/python-modules/zope_component { };

  zope_configuration = callPackage ../development/python-modules/zope_configuration { };

  zope_contenttype = callPackage ../development/python-modules/zope_contenttype { };

  zope-deferredimport = callPackage ../development/python-modules/zope-deferredimport { };

  zope_dottedname = callPackage ../development/python-modules/zope_dottedname { };

  zope_event = callPackage ../development/python-modules/zope_event { };

  zope_exceptions = callPackage ../development/python-modules/zope_exceptions { };

  zope_filerepresentation = callPackage ../development/python-modules/zope_filerepresentation { };

  zope-hookable = callPackage ../development/python-modules/zope-hookable { };

  zope_i18n = callPackage ../development/python-modules/zope_i18n { };

  zope_i18nmessageid = callPackage ../development/python-modules/zope_i18nmessageid { };

  zope_lifecycleevent = callPackage ../development/python-modules/zope_lifecycleevent { };

  zope_location = callPackage ../development/python-modules/zope_location { };

  zope_proxy = callPackage ../development/python-modules/zope_proxy { };

  zope_schema = callPackage ../development/python-modules/zope_schema { };

  zope_size = callPackage ../development/python-modules/zope_size { };

  zope_testing = callPackage ../development/python-modules/zope_testing { };

  zope_testrunner = callPackage ../development/python-modules/zope_testrunner { };

  zope_interface = callPackage ../development/python-modules/zope_interface { };

  hgsvn = callPackage ../development/python-modules/hgsvn { };

  cliapp = callPackage ../development/python-modules/cliapp { };

  cmdtest = callPackage ../development/python-modules/cmdtest { };

  tornado = callPackage ../development/python-modules/tornado { };
  tornado_4 = callPackage ../development/python-modules/tornado { version = "4.5.3"; };

  tokenlib = callPackage ../development/python-modules/tokenlib { };

  tunigo = callPackage ../development/python-modules/tunigo { };

  tarman = callPackage ../development/python-modules/tarman { };

  libarchive = self.python-libarchive; # The latter is the name upstream uses

  python-libarchive = callPackage ../development/python-modules/python-libarchive { };

  libarchive-c = callPackage ../development/python-modules/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libasyncns = callPackage ../development/python-modules/libasyncns {
    inherit (pkgs) libasyncns pkgconfig;
  };

  pybrowserid = callPackage ../development/python-modules/pybrowserid { };

  pyzmq = callPackage ../development/python-modules/pyzmq { };

  testfixtures = callPackage ../development/python-modules/testfixtures {};

  tissue = callPackage ../development/python-modules/tissue { };

  titlecase = callPackage ../development/python-modules/titlecase { };

  tracing = callPackage ../development/python-modules/tracing { };

  translationstring = callPackage ../development/python-modules/translationstring { };

  ttystatus = callPackage ../development/python-modules/ttystatus { };

  larch = callPackage ../development/python-modules/larch { };

  websocket_client = callPackage ../development/python-modules/websockets_client { };

  webhelpers = callPackage ../development/python-modules/webhelpers { };

  whichcraft = callPackage ../development/python-modules/whichcraft { };

  whisper = callPackage ../development/python-modules/whisper { };

  worldengine = callPackage ../development/python-modules/worldengine { };

  carbon = callPackage ../development/python-modules/carbon { };

  ujson = callPackage ../development/python-modules/ujson { };

  unidecode = callPackage ../development/python-modules/unidecode {};

  pyusb = callPackage ../development/python-modules/pyusb { libusb1 = pkgs.libusb1; };

  BlinkStick = callPackage ../development/python-modules/blinkstick { };

  usbtmc = callPackage ../development/python-modules/usbtmc {};

  txgithub = callPackage ../development/python-modules/txgithub { };

  txrequests = callPackage ../development/python-modules/txrequests { };

  txamqp = callPackage ../development/python-modules/txamqp { };

  versiontools = callPackage ../development/python-modules/versiontools { };

  veryprettytable = callPackage ../development/python-modules/veryprettytable { };

  graphite-web = callPackage ../development/python-modules/graphite-web { };

  graphite_api = callPackage ../development/python-modules/graphite-api { };

  graphite_beacon = callPackage ../development/python-modules/graphite_beacon { };

  influxgraph = callPackage ../development/python-modules/influxgraph { };

  graphitepager = callPackage ../development/python-modules/graphitepager { };

  pyspotify = callPackage ../development/python-modules/pyspotify { };

  pykka = callPackage ../development/python-modules/pykka { };

  ws4py = callPackage ../development/python-modules/ws4py {};

  gdata = callPackage ../development/python-modules/gdata { };

  IMAPClient = callPackage ../development/python-modules/imapclient { };

  Logbook = callPackage ../development/python-modules/Logbook { };

  libversion = callPackage ../development/python-modules/libversion {
    inherit (pkgs) libversion pkgconfig;
  };

  libvirt = callPackage ../development/python-modules/libvirt {
    inherit (pkgs) libvirt pkgconfig;
  };

  rpdb = callPackage ../development/python-modules/rpdb { };

  grequests = callPackage ../development/python-modules/grequests { };

  first = callPackage ../development/python-modules/first {};

  flaskbabel = callPackage ../development/python-modules/flaskbabel { };

  speaklater = callPackage ../development/python-modules/speaklater { };

  speedtest-cli = callPackage ../development/python-modules/speedtest-cli { };

  pushbullet = callPackage ../development/python-modules/pushbullet { };

  power = callPackage ../development/python-modules/power { };

  pythonefl = callPackage ../development/python-modules/python-efl {
    inherit (pkgs) pkgconfig;
  };

  tlsh = callPackage ../development/python-modules/tlsh { };

  toposort = callPackage ../development/python-modules/toposort { };

  snapperGUI = callPackage ../development/python-modules/snappergui { };

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  funcy = callPackage ../development/python-modules/funcy { };

  vxi11 = callPackage ../development/python-modules/vxi11 { };

  svg2tikz = callPackage ../development/python-modules/svg2tikz { };

  WSGIProxy = callPackage ../development/python-modules/wsgiproxy { };

  blist = callPackage ../development/python-modules/blist { };

  canonicaljson = callPackage ../development/python-modules/canonicaljson { };

  daemonize = callPackage ../development/python-modules/daemonize { };

  pydenticon = callPackage ../development/python-modules/pydenticon { };

  pynac = callPackage ../development/python-modules/pynac { };

  pybindgen = callPackage ../development/python-modules/pybindgen {};

  pygccxml = callPackage ../development/python-modules/pygccxml {};

  pymacaroons = callPackage ../development/python-modules/pymacaroons { };

  pynacl = callPackage ../development/python-modules/pynacl { };

  service-identity = callPackage ../development/python-modules/service_identity { };

  signedjson = callPackage ../development/python-modules/signedjson { };

  unpaddedbase64 = callPackage ../development/python-modules/unpaddedbase64 { };

  thumbor = callPackage ../development/python-modules/thumbor { };

  thumborPexif = callPackage ../development/python-modules/thumborpexif { };

  pync = callPackage ../development/python-modules/pync { };

  weboob = callPackage ../development/python-modules/weboob { };

  datadiff = callPackage ../development/python-modules/datadiff { };

  termcolor = callPackage ../development/python-modules/termcolor { };

  html2text = callPackage ../development/python-modules/html2text { };

  pychart = callPackage ../development/python-modules/pychart {};

  parsimonious = callPackage ../development/python-modules/parsimonious { };

  networkx = callPackage ../development/python-modules/networkx { };

  ofxclient = callPackage ../development/python-modules/ofxclient {};

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = callPackage ../development/python-modules/ofxparse { };

  ofxtools = callPackage ../development/python-modules/ofxtools { };

  basemap = callPackage ../development/python-modules/basemap { };

  dicttoxml = callPackage ../development/python-modules/dicttoxml { };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  evernote = callPackage ../development/python-modules/evernote { };

  setproctitle = callPackage ../development/python-modules/setproctitle { };

  thrift = callPackage ../development/python-modules/thrift { };

  geeknote = callPackage ../development/python-modules/geeknote { };

  trollius = callPackage ../development/python-modules/trollius {};

  pynvim = callPackage ../development/python-modules/pynvim {};

  typogrify = callPackage ../development/python-modules/typogrify { };

  smartypants = callPackage ../development/python-modules/smartypants { };

  pypeg2 = callPackage ../development/python-modules/pypeg2 { };

  torchvision = callPackage ../development/python-modules/torchvision { };

  jenkinsapi = callPackage ../development/python-modules/jenkinsapi { };

  jenkins-job-builder = callPackage ../development/python-modules/jenkins-job-builder { };

  dot2tex = callPackage ../development/python-modules/dot2tex { };

  poezio = callPackage ../applications/networking/instant-messengers/poezio {
    inherit (pkgs) pkgconfig;
  };

  potr = callPackage ../development/python-modules/potr {};

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  pluggy = callPackage ../development/python-modules/pluggy {};

  xcffib = callPackage ../development/python-modules/xcffib {};

  pafy = callPackage ../development/python-modules/pafy { };

  suds = callPackage ../development/python-modules/suds { };

  suds-jurko = callPackage ../development/python-modules/suds-jurko { };

  mailcap-fix = callPackage ../development/python-modules/mailcap-fix { };

  maildir-deduplicate = callPackage ../development/python-modules/maildir-deduplicate { };

  mps-youtube = callPackage ../development/python-modules/mps-youtube { };

  d2to1 = callPackage ../development/python-modules/d2to1 { };

  ovh = callPackage ../development/python-modules/ovh { };

  willow = callPackage ../development/python-modules/willow { };

  importmagic = callPackage ../development/python-modules/importmagic { };

  xgboost = callPackage ../development/python-modules/xgboost {
    xgboost = pkgs.xgboost;
  };

  xkcdpass = callPackage ../development/python-modules/xkcdpass { };

  xlsx2csv = callPackage ../development/python-modules/xlsx2csv { };

  xmpppy = callPackage ../development/python-modules/xmpppy {};

  xstatic = callPackage ../development/python-modules/xstatic {};

  xstatic-bootbox = callPackage ../development/python-modules/xstatic-bootbox {};

  xstatic-bootstrap = callPackage ../development/python-modules/xstatic-bootstrap {};

  xstatic-jquery = callPackage ../development/python-modules/xstatic-jquery {};

  xstatic-jquery-file-upload = callPackage ../development/python-modules/xstatic-jquery-file-upload {};

  xstatic-jquery-ui = callPackage ../development/python-modules/xstatic-jquery-ui {};

  xstatic-pygments = callPackage ../development/python-modules/xstatic-pygments {};

  xvfbwrapper = callPackage ../development/python-modules/xvfbwrapper {
    inherit (pkgs.xorg) xorgserver;
  };

  hidapi = callPackage ../development/python-modules/hidapi {
    inherit (pkgs) udev libusb1;
  };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  libagent = callPackage ../development/python-modules/libagent { };

  ledgerblue = callPackage ../development/python-modules/ledgerblue { };

  ecpy = callPackage ../development/python-modules/ecpy { };

  semver = callPackage ../development/python-modules/semver { };

  ed25519 = callPackage ../development/python-modules/ed25519 { };

  trezor = callPackage ../development/python-modules/trezor { };

  trezor_agent = callPackage ../development/python-modules/trezor_agent { };

  x11_hash = callPackage ../development/python-modules/x11_hash { };

  termstyle = callPackage ../development/python-modules/termstyle { };

  green = callPackage ../development/python-modules/green { };

  topydo = throw "python3Packages.topydo was moved to topydo"; # 2017-09-22

  w3lib = callPackage ../development/python-modules/w3lib { };

  queuelib = callPackage ../development/python-modules/queuelib { };

  scrapy = callPackage ../development/python-modules/scrapy { };

  pandocfilters = callPackage ../development/python-modules/pandocfilters { };

  htmltreediff = callPackage ../development/python-modules/htmltreediff { };

  repeated_test = callPackage ../development/python-modules/repeated_test { };

  Keras = callPackage ../development/python-modules/keras { };

  keras-applications = callPackage ../development/python-modules/keras-applications { };

  keras-preprocessing = callPackage ../development/python-modules/keras-preprocessing { };

  Lasagne = callPackage ../development/python-modules/lasagne { };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sigtools = callPackage ../development/python-modules/sigtools { };

  clize = callPackage ../development/python-modules/clize { };

  zerobin = callPackage ../development/python-modules/zerobin { };

  tensorflow-tensorboard = callPackage ../development/python-modules/tensorflow-tensorboard { };

  tensorflow = disabledIf isPy37 (
    if stdenv.isDarwin
    then callPackage ../development/python-modules/tensorflow/bin.nix { }
    else callPackage ../development/python-modules/tensorflow/bin.nix rec {
      cudaSupport = pkgs.config.cudaSupport or false;
      inherit (pkgs.linuxPackages) nvidia_x11;
      cudatoolkit = pkgs.cudatoolkit_9_0;
      cudnn = pkgs.cudnn_cudatoolkit_9_0;
    });

  tensorflowWithoutCuda = self.tensorflow.override {
    cudaSupport = false;
  };

  tensorflowWithCuda = self.tensorflow.override {
    cudaSupport = true;
  };

  tflearn = callPackage ../development/python-modules/tflearn { };

  simpleai = callPackage ../development/python-modules/simpleai { };

  word2vec = callPackage ../development/python-modules/word2vec { };

  tvdb_api = callPackage ../development/python-modules/tvdb_api { };

  sdnotify = callPackage ../development/python-modules/sdnotify { };

  tvnamer = callPackage ../development/python-modules/tvnamer { };

  threadpool = callPackage ../development/python-modules/threadpool { };

  rocket-errbot = callPackage ../development/python-modules/rocket-errbot {  };

  Yapsy = callPackage ../development/python-modules/yapsy { };

  ansi = callPackage ../development/python-modules/ansi { };

  pygments-markdown-lexer = callPackage ../development/python-modules/pygments-markdown-lexer { };

  telegram = callPackage ../development/python-modules/telegram { };

  python-telegram-bot = callPackage ../development/python-modules/python-telegram-bot { };

  irc = callPackage ../development/python-modules/irc { };

  jaraco_logging = callPackage ../development/python-modules/jaraco_logging { };

  jaraco_text = callPackage ../development/python-modules/jaraco_text { };

  jaraco_collections = callPackage ../development/python-modules/jaraco_collections { };

  jaraco_itertools = callPackage ../development/python-modules/jaraco_itertools { };

  inflect = callPackage ../development/python-modules/inflect { };

  more-itertools = callPackage ../development/python-modules/more-itertools { };

  jaraco_functools = callPackage ../development/python-modules/jaraco_functools { };

  jaraco_classes = callPackage ../development/python-modules/jaraco_classes { };

  jaraco_stream = callPackage ../development/python-modules/jaraco_stream { };

  tempora= callPackage ../development/python-modules/tempora { };

  hypchat = callPackage ../development/python-modules/hypchat { };

  pivy = callPackage ../development/python-modules/pivy { };

  smugpy = callPackage ../development/python-modules/smugpy { };

  smugline = callPackage ../development/python-modules/smugline { };

  txaio = callPackage ../development/python-modules/txaio { };

  ramlfications = callPackage ../development/python-modules/ramlfications { };

  yapf = callPackage ../development/python-modules/yapf { };

  black = callPackage ../development/python-modules/black { };

  bjoern = callPackage ../development/python-modules/bjoern { };

  autobahn = callPackage ../development/python-modules/autobahn { };

  jsonref = callPackage ../development/python-modules/jsonref { };

  whoosh = callPackage ../development/python-modules/whoosh { };

  packet-python = callPackage ../development/python-modules/packet-python { };

  pwntools = callPackage ../development/python-modules/pwntools { };

  ROPGadget = callPackage ../development/python-modules/ROPGadget { };

  # We need "normal" libxml2 and not the python package by the same name.
  pywbem = callPackage ../development/python-modules/pywbem { libxml2 = pkgs.libxml2; };

  unicorn = callPackage ../development/python-modules/unicorn { };

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  packaging = callPackage ../development/python-modules/packaging { };

  preggy = callPackage ../development/python-modules/preggy { };

  pytoml = callPackage ../development/python-modules/pytoml { };

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yanc = callPackage ../development/python-modules/yanc { };

  yarl = callPackage ../development/python-modules/yarl { };

  suseapi = callPackage ../development/python-modules/suseapi { };

  typed-ast = callPackage ../development/python-modules/typed-ast { };

  stripe = callPackage ../development/python-modules/stripe { };

  twilio = callPackage ../development/python-modules/twilio { };

  uranium = callPackage ../development/python-modules/uranium { };

  uuid = callPackage ../development/python-modules/uuid { };

  versioneer = callPackage ../development/python-modules/versioneer { };

  vine = callPackage ../development/python-modules/vine { };

  visitor = callPackage ../development/python-modules/visitor { };

  whitenoise = callPackage ../development/python-modules/whitenoise { };

  XlsxWriter = callPackage ../development/python-modules/XlsxWriter { };

  yowsup = callPackage ../development/python-modules/yowsup { };

  yubico-client = callPackage ../development/python-modules/yubico-client { };

  wptserve = callPackage ../development/python-modules/wptserve { };

  yenc = callPackage ../development/python-modules/yenc { };

  zeep = callPackage ../development/python-modules/zeep { };

  zeitgeist = disabledIf isPy3k
    (toPythonModule (pkgs.zeitgeist.override{python2Packages=self;})).py;

  zeroconf = callPackage ../development/python-modules/zeroconf { };

  zipfile36 = callPackage ../development/python-modules/zipfile36 { };

  todoist = callPackage ../development/python-modules/todoist { };

  zstd = callPackage ../development/python-modules/zstd {
    inherit (pkgs) zstd pkgconfig;
  };

  zxcvbn-python = callPackage ../development/python-modules/zxcvbn-python { };

  incremental = callPackage ../development/python-modules/incremental { };

  treq = callPackage ../development/python-modules/treq { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  nitpick = callPackage ../applications/version-management/nitpick { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  distro = callPackage ../development/python-modules/distro { };

  bz2file =  callPackage ../development/python-modules/bz2file { };

  smart_open =  callPackage ../development/python-modules/smart_open { };

  gensim = callPackage  ../development/python-modules/gensim { };

  cymem = callPackage ../development/python-modules/cymem { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  plac = callPackage ../development/python-modules/plac { };

  preshed = callPackage ../development/python-modules/preshed { };

  backports_weakref = callPackage ../development/python-modules/backports_weakref { };

  thinc = callPackage ../development/python-modules/thinc { };

  yahooweather = callPackage ../development/python-modules/yahooweather { };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy_models = callPackage ../development/python-modules/spacy/models.nix { };

  pyspark = callPackage ../development/python-modules/pyspark { };

  pysensors = callPackage ../development/python-modules/pysensors { };

  sseclient = callPackage ../development/python-modules/sseclient { };

  warrant = callPackage ../development/python-modules/warrant { };

  textacy = callPackage ../development/python-modules/textacy { };

  tldextract = callPackage ../development/python-modules/tldextract { };

  pyemd  = callPackage ../development/python-modules/pyemd { };

  pulp  = callPackage ../development/python-modules/pulp { };

  behave = callPackage ../development/python-modules/behave { };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest { };

  parse = callPackage ../development/python-modules/parse { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  ephem = callPackage ../development/python-modules/ephem { };

  voluptuous = callPackage ../development/python-modules/voluptuous { };

  voluptuous-serialize = callPackage ../development/python-modules/voluptuous-serialize { };

  pysigset = callPackage ../development/python-modules/pysigset { };

  us = callPackage ../development/python-modules/us { };

  wsproto = callPackage ../development/python-modules/wsproto { };

  h11 = callPackage ../development/python-modules/h11 { };

  python-docx = callPackage ../development/python-modules/python-docx { };

  aiohue = callPackage ../development/python-modules/aiohue { };

  PyMVGLive = callPackage ../development/python-modules/pymvglive { };

  coinmarketcap = callPackage ../development/python-modules/coinmarketcap { };

  pyowm = callPackage ../development/python-modules/pyowm { };

  prometheus_client = callPackage ../development/python-modules/prometheus_client { };

  pysdl2 = callPackage ../development/python-modules/pysdl2 { };

  pyogg = callPackage ../development/python-modules/pyogg { };

  rubymarshal = callPackage ../development/python-modules/rubymarshal { };

  radio_beam = callPackage ../development/python-modules/radio_beam { };

  spectral-cube = callPackage ../development/python-modules/spectral-cube { };

  astunparse = callPackage ../development/python-modules/astunparse { };

  gast = callPackage ../development/python-modules/gast { };

  IBMQuantumExperience = callPackage ../development/python-modules/ibmquantumexperience { };

  qiskit = callPackage ../development/python-modules/qiskit { };

  qasm2image = callPackage ../development/python-modules/qasm2image { };

  simpy = callPackage ../development/python-modules/simpy { };

  x256 = callPackage ../development/python-modules/x256 { };

  yattag = callPackage ../development/python-modules/yattag { };

  z3 = (toPythonModule (pkgs.z3.override {
    inherit python;
  })).python;

  zm-py = callPackage ../development/python-modules/zm-py { };

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  foundationdb51 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb51; };
  foundationdb52 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb52; };
  foundationdb60 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb60; };

  libtorrentRasterbar = (toPythonModule (pkgs.libtorrentRasterbar.override {
    inherit python;
  })).python;

  libiio = (toPythonModule (pkgs.libiio.override {
    inherit python;
  })).python;

  scour = callPackage ../development/python-modules/scour { };

  pymssql = callPackage ../development/python-modules/pymssql { };

  nanoleaf = callPackage ../development/python-modules/nanoleaf { };

  nanotime = callPackage ../development/python-modules/nanotime { };

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata {};

  importlib-resources = callPackage ../development/python-modules/importlib-resources {};

  srptools = callPackage ../development/python-modules/srptools { };

  curve25519-donna = callPackage ../development/python-modules/curve25519-donna { };

  pyatv = callPackage ../development/python-modules/pyatv { };

  pybotvac = callPackage ../development/python-modules/pybotvac { };

  pytado = callPackage ../development/python-modules/pytado { };

  casttube = callPackage ../development/python-modules/casttube { };

});

in fix' (extends overrides packages)
