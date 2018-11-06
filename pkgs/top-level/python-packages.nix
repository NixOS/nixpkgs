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
  pythonAtLeast = versionAtLeast python.pythonVersion;
  pythonOlder = versionOlder python.pythonVersion;
  isPy27 = python.pythonVersion == "2.7";
  isPy33 = python.pythonVersion == "3.3";
  isPy34 = python.pythonVersion == "3.4";
  isPy35 = python.pythonVersion == "3.5";
  isPy36 = python.pythonVersion == "3.6";
  isPy37 = python.pythonVersion == "3.7";
  isPyPy = python.executable == "pypy";
  isPy3k = strings.substring 0 1 python.pythonVersion == "3";

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
    inherit bootstrapped-pip;
    flit = self.flit;
    # We want Python libraries to be named like e.g. "python3.6-${name}"
    inherit namePrefix;
    inherit toPythonModule;
  }));

  buildPythonApplication = makeOverridablePythonPackage ( makeOverridable (callPackage ../development/interpreters/python/build-python-package.nix {
    inherit bootstrapped-pip;
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

  inherit python bootstrapped-pip pythonAtLeast pythonOlder isPy27 isPy33 isPy34 isPy35 isPy36 isPy37 isPyPy isPy3k buildPythonPackage buildPythonApplication;
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
  # Left for backwards compatibility
  "3to2" = self.py3to2;

  absl-py = callPackage ../development/python-modules/absl-py { };

  aenum = callPackage ../development/python-modules/aenum { };

  affinity = callPackage ../development/python-modules/affinity { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  aioimaplib = callPackage ../development/python-modules/aioimaplib { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  argon2_cffi = callPackage ../development/python-modules/argon2_cffi { };

  asana = callPackage ../development/python-modules/asana { };

  ase = callPackage ../development/python-modules/ase { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  aspy-yaml = callPackage ../development/python-modules/aspy.yaml { };

  astral = callPackage ../development/python-modules/astral { };

  astropy = callPackage ../development/python-modules/astropy { };

  atom = callPackage ../development/python-modules/atom { };

  augeas = callPackage ../development/python-modules/augeas {
    inherit (pkgs) augeas;
  };

  authres = callPackage ../development/python-modules/authres { };

  autograd = callPackage ../development/python-modules/autograd { };

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

  breathe = callPackage ../development/python-modules/breathe { };

  brotli = callPackage ../development/python-modules/brotli { };

  broadlink = callPackage ../development/python-modules/broadlink { };

  browser-cookie3 = callPackage ../development/python-modules/browser-cookie3 { };

  browsermob-proxy = disabledIf isPy3k (callPackage ../development/python-modules/browsermob-proxy {});

  bugseverywhere = callPackage ../applications/version-management/bugseverywhere {};

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cdecimal = callPackage ../development/python-modules/cdecimal { };

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
    dbus = pkgs.dbus;
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

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 {  };

  fido2 = callPackage ../development/python-modules/fido2 {  };

  filterpy = callPackage ../development/python-modules/filterpy { };

  fire = callPackage ../development/python-modules/fire { };

  fdint = callPackage ../development/python-modules/fdint { };

  fuse = callPackage ../development/python-modules/fuse-python { fuse = pkgs.fuse; };

  genanki = callPackage ../development/python-modules/genanki { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  gsd = callPackage ../development/python-modules/gsd { };

  gssapi = callPackage ../development/python-modules/gssapi { };

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

  httpsig = callPackage ../development/python-modules/httpsig { };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  imutils = callPackage ../development/python-modules/imutils { };

  intelhex = callPackage ../development/python-modules/intelhex { };

  jira = callPackage ../development/python-modules/jira { };

  lammps-cython = callPackage ../development/python-modules/lammps-cython {
    mpi = pkgs.openmpi;
  };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  logster = callPackage ../development/python-modules/logster { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  markerlib = callPackage ../development/python-modules/markerlib { };

  monty = callPackage ../development/python-modules/monty { };

  mpi4py = callPackage ../development/python-modules/mpi4py {
    mpi = pkgs.openmpi;
  };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

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

  palettable = callPackage ../development/python-modules/palettable { };

  pathlib = callPackage ../development/python-modules/pathlib { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfminer = callPackage ../development/python-modules/pdfminer_six { };

  pdfx = callPackage ../development/python-modules/pdfx { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  pims = callPackage ../development/python-modules/pims { };

  plantuml = callPackage ../tools/misc/plantuml { };

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

  pyatspi = callPackage ../development/python-modules/pyatspi { };

  pyaxmlparser = callPackage ../development/python-modules/pyaxmlparser { };

  pycairo = callPackage ../development/python-modules/pycairo { };

  pycangjie = disabledIf (!isPy3k) (callPackage ../development/python-modules/pycangjie { });

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

  pygame = callPackage ../development/python-modules/pygame { };

  pygame-git = callPackage ../development/python-modules/pygame/git.nix { };

  pygame_sdl2 = callPackage ../development/python-modules/pygame_sdl2 { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygobject2 = callPackage ../development/python-modules/pygobject { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix { };

  pygtail = callPackage ../development/python-modules/pygtail { };

  pygtk = callPackage ../development/python-modules/pygtk { libglade = null; };

  pygtksourceview = callPackage ../development/python-modules/pygtksourceview { };

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

  pymatgen = callPackage ../development/python-modules/pymatgen { };

  pymatgen-lammps = callPackage ../development/python-modules/pymatgen-lammps { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pyparser = callPackage ../development/python-modules/pyparser { };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix {
    pythonPackages = self;
  };

  pyqt5 = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt/5.x.nix {
    pythonPackages = self;
  };

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

  pystache = callPackage ../development/python-modules/pystache { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-lz4 = callPackage ../development/python-modules/python-lz4 { };

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

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

  python-utils = callPackage ../development/python-modules/python-utils { };

  pytimeparse =  callPackage ../development/python-modules/pytimeparse { };

  PyWebDAV = callPackage ../development/python-modules/pywebdav { };

  pyxml = disabledIf isPy3k (callPackage ../development/python-modules/pyxml{ });

  pyvoro = callPackage ../development/python-modules/pyvoro { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  rhpl = disabledIf isPy3k (callPackage ../development/python-modules/rhpl {});

  rlp = callPackage ../development/python-modules/rlp { };

  rx = callPackage ../development/python-modules/rx { };

  sabyenc = callPackage ../development/python-modules/sabyenc { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  selectors2 = callPackage ../development/python-modules/selectors2 { };

  serversyncstorage = callPackage ../development/python-modules/serversyncstorage {};

  shellingham = callPackage ../development/python-modules/shellingham {};

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  singledispatch = callPackage ../development/python-modules/singledispatch { };

  sip = callPackage ../development/python-modules/sip { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  slackclient = callPackage ../development/python-modules/slackclient { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  spglib = callPackage ../development/python-modules/spglib { };

  sslib = callPackage ../development/python-modules/sslib { };

  statistics = callPackage ../development/python-modules/statistics { };

  sumo = callPackage ../development/python-modules/sumo { };

  supervise_api = callPackage ../development/python-modules/supervise_api { };

  syncserver = callPackage ../development/python-modules/syncserver {};

  tables = callPackage ../development/python-modules/tables {
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  };

  trueskill = callPackage ../development/python-modules/trueskill { };

  trustme = callPackage ../development/python-modules/trustme {};

  trio = callPackage ../development/python-modules/trio {};

  sniffio = callPackage ../development/python-modules/sniffio { };

  tokenserver = callPackage ../development/python-modules/tokenserver {};

  toml = callPackage ../development/python-modules/toml { };

  unifi = callPackage ../development/python-modules/unifi { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  pyunbound = callPackage ../tools/networking/unbound/python.nix { };

  # packages defined here

  aafigure = callPackage ../development/python-modules/aafigure { };

  altair = callPackage ../development/python-modules/altair { };

  vega = callPackage ../development/python-modules/vega { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  adal = callPackage ../development/python-modules/adal { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aioh2 = callPackage ../development/python-modules/aioh2 { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp/cors.nix { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aioprocessing = callPackage ../development/python-modules/aioprocessing { };

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

  # argparse is part of stdlib in 2.7 and 3.2+
  argparse = null;

  astroid = if isPy3k then callPackage ../development/python-modules/astroid { }
            else callPackage ../development/python-modules/astroid/1.6.nix { };

  attrdict = callPackage ../development/python-modules/attrdict { };

  attrs = callPackage ../development/python-modules/attrs { };

  atsim_potentials = callPackage ../development/python-modules/atsim_potentials { };

  audioread = callPackage ../development/python-modules/audioread { };

  audiotools = callPackage ../development/python-modules/audiotools { };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  av = callPackage ../development/python-modules/av { };

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

  binwalk = callPackage ../development/python-modules/binwalk { };

  binwalk-full = appendToName "full" (self.binwalk.override {
    pyqtgraph = self.pyqtgraph;
  });

  bitmath = callPackage ../development/python-modules/bitmath { };

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

  pyezminc = callPackage ../development/python-modules/pyezminc { };

  billiard = callPackage ../development/python-modules/billiard { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  bitbucket_api = callPackage ../development/python-modules/bitbucket-api { };

  bitbucket-cli = callPackage ../development/python-modules/bitbucket-cli { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  blaze = callPackage ../development/python-modules/blaze { };

  html5-parser = callPackage ../development/python-modules/html5-parser {};

  httpserver = callPackage ../development/python-modules/httpserver {};

  bleach = callPackage ../development/python-modules/bleach { };

  blinker = callPackage ../development/python-modules/blinker { };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

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

  cairosvg = callPackage ../development/python-modules/cairosvg {};

  carrot = callPackage ../development/python-modules/carrot {};

  case = callPackage ../development/python-modules/case {};

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  cccolutils = callPackage ../development/python-modules/cccolutils {};

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

  click-didyoumean = callPackage ../development/python-modules/click-didyoumean {};

  click-log = callPackage ../development/python-modules/click-log {};

  click-plugins = callPackage ../development/python-modules/click-plugins {};

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

  CommonMark_54 = self.CommonMark.overridePythonAttrs (oldAttrs: rec {
    version = "0.5.4";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "34d73ec8085923c023930dfc0bcd1c4286e28a2a82de094bb72fabcc0281cbe5";
    };
  });

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

  pytest = self.pytest_37;

  pytest_37 = callPackage ../development/python-modules/pytest {
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

  dockerpty = callPackage ../development/python-modules/dockerpty {};

  docker_pycreds = callPackage ../development/python-modules/docker-pycreds {};

  docopt = callPackage ../development/python-modules/docopt { };

  doctest-ignore-unicode = callPackage ../development/python-modules/doctest-ignore-unicode { };

  dogpile_cache = callPackage ../development/python-modules/dogpile.cache { };

  dogpile_core = callPackage ../development/python-modules/dogpile.core { };

  dopy = callPackage ../development/python-modules/dopy { };

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

  eccodes = disabledIf (!isPy27)
    (toPythonModule (pkgs.eccodes.override {
      enablePython = true;
      pythonPackages = self;
    }));

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

  fedpkg = callPackage ../development/python-modules/fedpkg { };

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

  fudge_9 = self.fudge.overridePythonAttrs (old: rec {
     version = "0.9.6";

     src = fetchPypi {
      pname = "fudge";
      inherit version;
      sha256 = "34690c4692e8717f4d6a2ab7d841070c93c8d0ea0d2615b47064e291f750b1a0";
    };
  });

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  functools32 = callPackage ../development/python-modules/functools32 { };

  gateone = callPackage ../development/python-modules/gateone { };

  gcutil = callPackage ../development/python-modules/gcutil { };

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

  gpapi = callPackage ../development/python-modules/gpapi { };
  gplaycli = callPackage ../development/python-modules/gplaycli { };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  grip = callPackage ../development/python-modules/grip { };

  gst-python = callPackage ../development/python-modules/gst-python {
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

  hovercraft = callPackage ../development/python-modules/hovercraft { };

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
    libsexy = pkgs.libsexy;
  };

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libthumbor = callPackage ../development/python-modules/libthumbor { };

  lightblue = callPackage ../development/python-modules/lightblue { };

  lightning = callPackage ../development/python-modules/lightning { };

  jupyter = callPackage ../development/python-modules/jupyter { };

  jupyter_console = callPackage ../development/python-modules/jupyter_console { };

  jupyterlab_launcher = callPackage ../development/python-modules/jupyterlab_launcher { };

  jupyterlab = callPackage ../development/python-modules/jupyterlab {};

  PyLTI = callPackage ../development/python-modules/pylti { };

  lmdb = callPackage ../development/python-modules/lmdb { };

  logilab_astng = callPackage ../development/python-modules/logilab_astng { };

  lpod = callPackage ../development/python-modules/lpod { };

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

  # These used to be here but were moved to all-packages, but I'll leave them around for a while.
  pants = pkgs.pants;

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

  django_2_0 = callPackage ../development/python-modules/django/2_0.nix {
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

  django-sampledatahelper = callPackage ../development/python-modules/django-sampledatahelper { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django_tagging = callPackage ../development/python-modules/django_tagging { };

  django_tagging_0_4_3 = if
       self.django.version != "1.8.18"
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

  docker_compose = callPackage ../development/python-modules/docker_compose {};

  pyftpdlib = callPackage ../development/python-modules/pyftpdlib { };

  fdroidserver = callPackage ../development/python-modules/fdroidserver { };

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

  flask_sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask_testing = callPackage ../development/python-modules/flask-testing { };

  flask_wtf = callPackage ../development/python-modules/flask-wtf { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  graph-tool = callPackage ../development/python-modules/graph-tool/2.x.x.nix { };

  grappelli_safe = callPackage ../development/python-modules/grappelli_safe { };

  pytorch = callPackage ../development/python-modules/pytorch {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

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
  future15 = self.future.overridePythonAttrs (old: rec {
    name = "future-${version}";
    version = "0.15.2";
    src = fetchPypi {
      pname = "future";
      version = "0.15.2";
      sha256 = "15wvcfzssc68xqnqi1dq4fhd0848hwi9jn42hxyvlqna40zijfrx";
    };
  });

  futures = callPackage ../development/python-modules/futures { };

  gcovr = callPackage ../development/python-modules/gcovr { };

  gdal = toPythonModule (pkgs.gdal.override {
    pythonPackages = self;
  });

  gdrivefs = callPackage ../development/python-modules/gdrivefs { };

  genshi = callPackage ../development/python-modules/genshi { };

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

  google_cloud_core = callPackage ../development/python-modules/google_cloud_core { };

  google_cloud_speech = callPackage ../development/python-modules/google_cloud_speech { };

  gpgme = toPythonModule (pkgs.gpgme.override { pythonSupport=true; });

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

  gspread = callPackage ../development/python-modules/gspread { };

  gyp = callPackage ../development/python-modules/gyp { };

  guessit = callPackage ../development/python-modules/guessit { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  gunicorn = callPackage ../development/python-modules/gunicorn { };

  hawkauthlib = callPackage ../development/python-modules/hawkauthlib { };

  hdbscan = callPackage ../development/python-modules/hdbscan { };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hcs_utils = callPackage ../development/python-modules/hcs_utils { };

  hetzner = callPackage ../development/python-modules/hetzner { };

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

  iptools = callPackage ../development/python-modules/iptools { };

  ipy = callPackage ../development/python-modules/IPy { };

  ipykernel = callPackage ../development/python-modules/ipykernel { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  # Newer versions of IPython no longer support Python 2.7.
  ipython = if isPy27 then self.ipython_5 else self.ipython_6;

  ipython_5 = callPackage ../development/python-modules/ipython/5.nix { };

  ipython_6 = callPackage ../development/python-modules/ipython { };

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

  j2cli = callPackage ../development/python-modules/j2cli { };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2_time = callPackage ../development/python-modules/jinja2_time { };

  jinja2_pluralize = callPackage ../development/python-modules/jinja2_pluralize { };

  jmespath = callPackage ../development/python-modules/jmespath { };

  journalwatch = callPackage ../tools/system/journalwatch {
    inherit (self) systemd pytest;
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

  kerberos = callPackage ../development/python-modules/kerberos { };

  lazy-object-proxy = callPackage ../development/python-modules/lazy-object-proxy { };

  ldaptor = callPackage ../development/python-modules/ldaptor { };

  le = callPackage ../development/python-modules/le { };

  lektor = callPackage ../development/python-modules/lektor { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  python_openzwave = callPackage ../development/python-modules/python_openzwave { };

  python-Levenshtein = callPackage ../development/python-modules/python-levenshtein { };

  fs = callPackage ../development/python-modules/fs { };

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
    fuse = pkgs.fuse;  # use "real" fuse, not the python module
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

  matplotlib = callPackage ../development/python-modules/matplotlib {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    enableGhostscript = true;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  matrix-client = callPackage ../development/python-modules/matrix-client { };

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

  graphviz = callPackage ../development/python-modules/graphviz { };

  pygraphviz = callPackage ../development/python-modules/pygraphviz { };

  pymc3 = callPackage ../development/python-modules/pymc3 { };

  pympler = callPackage ../development/python-modules/pympler { };

  pymysqlsa = callPackage ../development/python-modules/pymysqlsa { };

  monosat = disabledIf (!isPy3k) (pkgs.monosat.python { inherit buildPythonPackage; inherit (self) cython; });

  monotonic = callPackage ../development/python-modules/monotonic { };

  MySQL_python = callPackage ../development/python-modules/mysql_python { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  namebench = callPackage ../development/python-modules/namebench { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

  slixmpp = callPackage ../development/python-modules/slixmpp { };

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

  nose-exclude = callPackage ../development/python-modules/nose-exclude { };

  nose2 = callPackage ../development/python-modules/nose2 { };

  nose-cover3 = callPackage ../development/python-modules/nose-cover3 { };

  nosexcover = callPackage ../development/python-modules/nosexcover { };

  nosejs = callPackage ../development/python-modules/nosejs { };

  nose-cprof = callPackage ../development/python-modules/nose-cprof { };

  nose_warnings_filters = callPackage ../development/python-modules/nose_warnings_filters { };

  notebook = callPackage ../development/python-modules/notebook { };

  notify = callPackage ../development/python-modules/notify { };

  notify2 = callPackage ../development/python-modules/notify2 {};

  notmuch = callPackage ../development/python-modules/notmuch { };

  emoji = callPackage ../development/python-modules/emoji { };

  ntfy = callPackage ../development/python-modules/ntfy { };

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

  objgraph = callPackage ../development/python-modules/objgraph { };

  odo = callPackage ../development/python-modules/odo { };

  offtrac = callPackage ../development/python-modules/offtrac { };

  openpyxl = callPackage ../development/python-modules/openpyxl { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  ordereddict = callPackage ../development/python-modules/ordereddict { };

  orderedset = callPackage ../development/python-modules/orderedset { };

  python-otr = callPackage ../development/python-modules/python-otr { };

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  ply = callPackage ../development/python-modules/ply { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  osc = callPackage ../development/python-modules/osc { };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

   cachetools_1 = callPackage ../development/python-modules/cachetools/1.nix {};
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

  lz4 = buildPythonPackage rec {
    name = "lz4-0.8.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/b5/f0/e1de2bb7feb54011f3c4dcf35b7cca3536e19526764db051b50ea26b58e7/lz4-0.8.2.tar.gz";
      sha256 = "1irad4sq4hdr30fr53smvv3zzk4rddcf9b4jx19w8s9xsxhr1x3b";
    };

    buildInputs= with self; [ nose ];

    meta = with stdenv.lib; {
      description = "Compression library";
      homepage = https://github.com/python-lz4/python-lz4;
      license = licenses.bsd3;
    };
  };

 retrying = buildPythonPackage rec {
    name = "retrying-${version}";
    version = "1.3.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/retrying/retrying-1.3.3.tar.gz";
      sha256 = "0fwp86xv0rvkncjdvy2mwcvbglw4w9k0fva25i7zx8kd19b3kh08";
    };

    propagatedBuildInputs = with self; [ six ];

    # doesn't ship tests in tarball
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = https://github.com/rholder/retrying;
    };
  };

  fasteners = buildPythonPackage rec {
    name = "fasteners-${version}";
    version = "0.14.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/fasteners/${name}.tar.gz";
      sha256 = "063y20kx01ihbz2mziapmjxi2cd0dq48jzg587xdsdp07xvpcz22";
    };

    propagatedBuildInputs = with self; [ six monotonic testtools ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';
    # Tests are written for Python 3.x only (concurrent.futures)
    doCheck = isPy3k;


    meta = with stdenv.lib; {
      description = "Fasteners";
      homepage = https://github.com/harlowja/fasteners;
    };
  };

  aioeventlet = buildPythonPackage rec {
    name = "aioeventlet-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/aioeventlet/aioeventlet-0.4.tar.gz";
      sha256 = "19krvycaiximchhv1hcfhz81249m3w3jrbp2h4apn1yf4yrc4y7y";
    };

    propagatedBuildInputs = with self; [ eventlet trollius asyncio ];
    buildInputs = with self; [ mock ];

    # 2 tests error out
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} runtests.py
    '';

    meta = with stdenv.lib; {
      description = "aioeventlet implements the asyncio API (PEP 3156) on top of eventlet. It makes";
      homepage = http://aioeventlet.readthedocs.org/;
    };
  };

  olefile = callPackage ../development/python-modules/olefile { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  mox3 = buildPythonPackage rec {
    name = "mox3-${version}";
    version = "0.23.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mox3/${name}.tar.gz";
      sha256 = "0q26sg0jasday52a7y0cch13l0ssjvr4yqnvswqxsinj1lv5ld88";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    #  FAIL: mox3.tests.test_mox.RegexTest.testReprWithFlags
    #  ValueError: cannot use LOCALE flag with a str pattern
    doCheck = !isPy36;

    buildInputs = with self; [ subunit testrepository testtools six ];
    propagatedBuildInputs = with self; [ pbr fixtures ];
  };

  doc8 = callPackage ../development/python-modules/doc8 { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  pagerduty = buildPythonPackage rec {
    name = "pagerduty-${version}";
    version = "0.2.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
        url = "mirror://pypi/p/pagerduty/pagerduty-${version}.tar.gz";
        sha256 = "e8c237239d3ffb061069aa04fc5b3d8ae4fb0af16a9713fe0977f02261d323e9";
    };
  };

  pandas = callPackage ../development/python-modules/pandas { };

  pandas_0_17_1 = callPackage ../development/python-modules/pandas/0.17.1.nix { };

  xlrd = buildPythonPackage rec {
    name = "xlrd-${version}";

    version = "0.9.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xlrd/xlrd-${version}.tar.gz";
      sha256 = "8e8d3359f39541a6ff937f4030db54864836a06e42988c452db5b6b86d29ea72";
    };

    buildInputs = with self; [ nose ];
    checkPhase = ''
      nosetests -v
    '';

  };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt { };

  pamqp = buildPythonPackage rec {
    version = "1.6.1";
    name = "pamqp-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pamqp/${name}.tar.gz";
      sha256 = "1vmyvynqzx5zvbipaxff4fnzy3h3dvl3zicyr15yb816j93jl2ca";
    };

    buildInputs = with self; [ mock nose pep8 pylint mccabe ];

    meta = {
      description = "RabbitMQ Focused AMQP low-level library";
      homepage = https://pypi.python.org/pypi/pamqp;
      license = licenses.bsd3;
    };
  };

  parsedatetime = buildPythonPackage rec {
    name = "parsedatetime-${version}";
    version = "2.3";

    meta = {
      description = "Parse human-readable date/time text";
      homepage = "https://github.com/bear/parsedatetime";
      license = licenses.asl20;
    };

    buildInputs = with self; [ pytest pytestrunner ];
    propagatedBuildInputs = with self; [ future ];

    src = pkgs.fetchurl {
        url = "mirror://pypi/p/parsedatetime/${name}.tar.gz";
        sha256 = "1vkrmd398s11h1zn3zaqqsiqhj9lwy1ikcg6irx2lrgjzjg3rjll";
    };
  };

  paramiko = callPackage ../development/python-modules/paramiko { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  paramz = callPackage ../development/python-modules/paramz { };

  parsel = buildPythonPackage rec {
    name = "parsel-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/parsel/${name}.tar.gz";
      sha256 = "0a34d1c0bj1fzb5dk5744m2ag6v3b8glk4xp0amqxdan9ldbcd97";
    };

    buildInputs = with self; [ pytest pytestrunner ];
    propagatedBuildInputs = with self; [ six w3lib lxml cssselect ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = "https://github.com/scrapy/parsel";
      description = "Parsel is a library to extract data from HTML and XML using XPath and CSS selectors";
      license = licenses.bsd3;
    };
  };

  parso = callPackage ../development/python-modules/parso { };

  partd = callPackage ../development/python-modules/partd { };

  patch = buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "1.16";
    pname = "patch";

    src = pkgs.fetchzip {
      url = "mirror://pypi/p/${pname}/${name}.zip";
      sha256 = "1nj55hvyvzax4lxq7vkyfbw91pianzr3hp7ka7j12pgjxccac50g";
      stripRoot = false;
    };

    # No tests included in archive
    doCheck = false;

    meta = {
      description = "A library to parse and apply unified diffs";
      homepage = https://github.com/techtonik/python-patch/;
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ maintainers.igsha ];
    };
  };

  pathos = buildPythonPackage rec {
    name = "pathos-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pathos/${name}.tgz";
      sha256 = "e35418af733bf434da83746d46acca94375d6e306b3df330b2a1808db026a188";
    };

    propagatedBuildInputs = with self; [ dill pox ppft multiprocess ];

    # Require network
    doCheck = false;

    meta = {
      description = "Parallel graph management and execution in heterogeneous computing";
      homepage = http://www.cacr.caltech.edu/~mmckerns/pathos.htm;
      license = licenses.bsd3;
    };
  };

  patsy = callPackage ../development/python-modules/patsy { };

  paste = buildPythonPackage rec {
    name = "paste-${version}";
    version = "2.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/Paste/Paste-${version}.tar.gz";
      sha256 = "062jk0nlxf6lb2wwj6zc20rlvrwsnikpkh90y0dn8cjch93s6ii3";
    };

    checkInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six ];

    # Certain tests require network
    checkPhase = ''
      NOSE_EXCLUDE=test_ok,test_form,test_error,test_stderr,test_paste_website nosetests
    '';

    meta = {
      description = "Tools for using a Web Server Gateway Interface stack";
      homepage = http://pythonpaste.org/;
    };
  };


  PasteDeploy = buildPythonPackage rec {
    version = "1.5.2";
    name = "paste-deploy-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PasteDeploy/PasteDeploy-${version}.tar.gz";
      sha256 = "d5858f89a255e6294e63ed46b73613c56e3b9a2d82a42f1df4d06c8421a9e3cb";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "Load, configure, and compose WSGI applications and servers";
      homepage = http://pythonpaste.org/deploy/;
      platforms = platforms.all;
    };
  };

   pasteScript = buildPythonPackage rec {
    version = "1.7.5";
    name = "PasteScript-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PasteScript/${name}.tar.gz";
      sha256 = "2b685be69d6ac8bc0fe6f558f119660259db26a15e16a4943c515fbee8093539";
    };

    doCheck = false;
    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six paste PasteDeploy cheetah argparse ];

    meta = {
      description = "A pluggable command-line frontend, including commands to setup package file layouts";
      homepage = http://pythonpaste.org/script/;
      platforms = platforms.all;
    };
  };

  patator = callPackage ../development/python-modules/patator { };

  pathlib2 = callPackage ../development/python-modules/pathlib2 { };

  pathpy = callPackage ../development/python-modules/path.py { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbr = callPackage ../development/python-modules/pbr { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  pelican = callPackage ../development/python-modules/pelican {
    inherit (pkgs) glibcLocales git;
  };

  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pep8/${name}.tar.gz";
      sha256 = "a113d5f5ad7a7abacef9df5ec3f2af23a20a28005921577b15dd584d099d5900";
    };

    meta = {
      homepage = "http://pep8.readthedocs.org/";
      description = "Python style guide checker";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pep257 = callPackage ../development/python-modules/pep257 { };

  percol = buildPythonPackage rec {
    name = "percol-${version}";
    version = "0.0.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/percol/${name}.tar.gz";
      sha256 = "169s5mhw1s60qbsd6pkf9bb2x6wfgx8hn8nw9d4qgc68qnnpp2cj";
    };

    propagatedBuildInputs = with self; [ ];

    meta = {
      homepage = https://github.com/mooz/percol;
      description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
      license = licenses.mit;
      maintainers = with maintainers; [ koral ];
    };
  };

  pexif = buildPythonPackage rec {
    name = "pexif-${version}";
    version = "0.15";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pexif/pexif-0.15.tar.gz";
      sha256 = "45a3be037c7ba8b64bbfc48f3586402cc17de55bb9d7357ef2bc99954a18da3f";
    };

    meta = {
      description = "A module for editing JPEG EXIF data";
      homepage = http://www.benno.id.au/code/pexif/;
      license = licenses.mit;
    };
  };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pdfkit = buildPythonPackage rec {
    name = "pdfkit-${version}";
    version = "0.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pdfkit/${name}.zip";
      sha256 = "1p1m6gp51ql3wzjs2iwds8sc3hg1i48yysii9inrky6qc3s6q5vf";
    };

    buildInputs = with self; [ ];
    # tests are not distributed
    doCheck = false;

    meta = {
      homepage = https://pypi.python.org/pypi/pdfkit;
      description = "Wkhtmltopdf python wrapper to convert html to pdf using the webkit rendering engine and qt";
      license = licenses.mit;
    };
  };

    periodictable = callPackage ../development/python-modules/periodictable { };

  pg8000 = buildPythonPackage rec {
    name = "pg8000-1.10.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pg8000/${name}.tar.gz";
      sha256 = "188658db63c2ca931ae1bf0167b34efaac0ecc743b707f0118cc4b87e90ce488";
    };

    propagatedBuildInputs = with self; [ pytz ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.linux;
    };
  };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  pickleshare = buildPythonPackage rec {
    version = "0.7.4";
    name = "pickleshare-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pickleshare/${name}.tar.gz";
      sha256 = "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b";
    };

    propagatedBuildInputs = with self; [pathpy] ++ optional (pythonOlder "3.4") pathlib2;

    # No proper test suite
    doCheck = false;

    meta = {
      description = "Tiny 'shelve'-like database with concurrency support";
      homepage = https://github.com/vivainio/pickleshare;
      license = licenses.mit;
    };
  };

  piep = buildPythonPackage rec {
    version = "0.8.0";
    name = "piep-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/piep/piep-${version}.tar.gz";
      sha256 = "1wgkg1kc28jpya5k4zvbc9jmpa60b3d5c3gwxfbp15hw6smyqirj";
    };

    propagatedBuildInputs = with self; [pygments];

    meta = {
      description = "Bringing the power of python to stream editing";
      homepage = https://github.com/timbertson/piep;
      maintainers = with maintainers; [ timbertson ];
      license = licenses.gpl3;
    };
  };

  piexif = callPackage ../development/python-modules/piexif { };

  pip = callPackage ../development/python-modules/pip { };

  pip-tools = callPackage ../development/python-modules/pip-tools {
    git = pkgs.gitMinimal;
    glibcLocales = pkgs.glibcLocales;
  };

  pika = buildPythonPackage rec {
    name = "pika-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pika/${name}.tar.gz";
      sha256 = "0nb4h08di432lv7dy2v9kpwgk0w92f24sqc2hw2s9vwr5b8v8xvj";
    };

    # Tests require twisted which is only availalble for python-2.x
    doCheck = !isPy3k;

    buildInputs = with self; [ nose mock pyyaml unittest2 pyev ] ++ optionals (!isPy3k) [ twisted tornado ];

    meta = {
      description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
      homepage = https://pika.readthedocs.org;
      license = licenses.bsd3;
    };
  };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  kmsxx = (callPackage ../development/libraries/kmsxx {
    inherit (pkgs.kmsxx) stdenv;
  }).overrideAttrs (oldAttrs: {
    name = "${python.libPrefix}-${pkgs.kmsxx.name}";
  });

  pvlib = callPackage ../development/python-modules/pvlib { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibmc = callPackage ../development/python-modules/pylibmc {};

  pymetar = callPackage ../development/python-modules/pymetar { };

  pysftp = buildPythonPackage rec {
    name = "pysftp-${version}";
    version = "0.2.9";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysftp/${name}.tar.gz";
      sha256 = "0jl5qix5cxzrv4lb8rfpjkpcghbkacnxkb006ikn7mkl5s05mxgv";
    };

    propagatedBuildInputs = with self; [ paramiko ];

    meta = {
      homepage = https://bitbucket.org/dundeemt/pysftp;
      description = "A friendly face on SFTP";
      license = licenses.mit;
      longDescription = ''
        A simple interface to SFTP. The module offers high level abstractions
        and task based routines to handle your SFTP needs. Checkout the Cook
        Book, in the docs, to see what pysftp can do for you.
      '';
    };
  };

  pysoundfile = callPackage ../development/python-modules/pysoundfile { };

  python3pika = buildPythonPackage {
    name = "python3-pika-0.9.14";
    disabled = !isPy3k;

    # Unit tests adds dependencies on pyev, tornado and twisted (and twisted is disabled for Python 3)
    doCheck = false;

    src = pkgs.fetchurl {
      url = mirror://pypi/p/python3-pika/python3-pika-0.9.14.tar.gz;
      sha256 = "1c3hifwvn04kvlja88iawf0awyz726jynwnpcb6gn7376b4nfch7";
    };
    buildInputs = with self; [ nose mock pyyaml ];

    propagatedBuildInputs = with self; [ unittest2 ];
  };


  python-jenkins = buildPythonPackage rec {
    name = "python-jenkins-${version}";
    version = "0.4.14";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-jenkins/${name}.tar.gz";
      sha256 = "1n8ikvd9jf4dlki7nqlwjlsn8wpsx4x7wg4h3d6bkvyvhwwf8yqf";
    };
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ mock ];
    propagatedBuildInputs = with self; [ pbr pyyaml six multi_key_dict testtools
     testscenarios testrepository kerberos ];

    meta = {
      description = "Python bindings for the remote Jenkins API";
      homepage = https://pypi.python.org/pypi/python-jenkins;
      license = licenses.bsd3;
    };
  };

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

  posix_ipc = buildPythonPackage rec {
    name = "posix_ipc-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/posix_ipc/${name}.tar.gz";
      sha256 = "1jzg66708pi5n9w07fbz6rlxx30cjds9hp2yawjjfryafh1hg4ww";
    };

    meta = {
      description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
      license = licenses.bsd3;
      homepage = http://semanchuk.com/philip/posix_ipc/;
    };
  };

  portend = callPackage ../development/python-modules/portend { };

  powerline = callPackage ../development/python-modules/powerline { };

  pox = buildPythonPackage rec {
    name = "pox-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pox/${name}.tgz";
      sha256 = "22e97ac6d2918c754e65a9581dbe02e9d00ae4a54ca48d05118f87c1ea92aa19";
    };

    meta = {
      description = "Utilities for filesystem exploration and automated builds";
      license = licenses.bsd3;
      homepage = http://www.cacr.caltech.edu/~mmckerns/pox.htm;
    };
  };

  ppft = buildPythonPackage rec {
    name = "ppft-${version}";
    version = "1.6.4.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/ppft/${name}.tgz";
      sha256 = "6f99c861822884cb00badbd5f364ee32b90a157084a6768040793988c6b92bff";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Distributed and parallel python";
      homepage = https://github.com/uqfoundation;
      license = licenses.bsd3;
    };
  };

  praw = callPackage ../development/python-modules/praw { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  premailer = callPackage ../development/python-modules/premailer { };

  prettytable = buildPythonPackage rec {
    name = "prettytable-0.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PrettyTable/${name}.tar.bz2";
      sha256 = "599bc5b4b9602e28294cf795733c889c26dd934aa7e0ee9cff9b905d4fbad188";
    };

    buildInputs = [ pkgs.glibcLocales ];

    preCheck = ''
      export LANG="en_US.UTF-8"
    '';

    meta = {
      description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = http://code.google.com/p/prettytable/;
    };
  };


  prompt_toolkit = callPackage ../development/python-modules/prompt_toolkit { };

  protobuf = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    doCheck = !isPy3k;
    protobuf = pkgs.protobuf;
  };

  protobuf3_1 = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    doCheck = !isPy3k;
    protobuf = pkgs.protobuf3_1;
  };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psutil = callPackage ../development/python-modules/psutil { };

  psycopg2 = callPackage ../development/python-modules/psycopg2 {};

  ptpython = callPackage ../development/python-modules/ptpython {};

  publicsuffix = callPackage ../development/python-modules/publicsuffix {};

  py = callPackage ../development/python-modules/py { };

  pyacoustid = buildPythonPackage rec {
    name = "pyacoustid-1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyacoustid/${name}.tar.gz";
      sha256 = "0117039cb116af245e6866e8e8bf3c9c8b2853ad087142bd0c2dfc0acc09d452";
    };

    propagatedBuildInputs = with self; [ requests audioread ];

    patches = [ ../development/python-modules/pyacoustid-py3.patch ];

    postPatch = ''
      sed -i \
          -e '/^FPCALC_COMMAND *=/s|=.*|= "${pkgs.chromaprint}/bin/fpcalc"|' \
          acoustid.py
    '';

    meta = {
      description = "Bindings for Chromaprint acoustic fingerprinting";
      homepage = "https://github.com/sampsyo/pyacoustid";
      license = licenses.mit;
    };
  };


  pyalgotrade = buildPythonPackage {
    name = "pyalgotrade-0.16";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyAlgoTrade/PyAlgoTrade-0.16.tar.gz";
      sha256 = "a253617254194b91cfebae7bfd184cb109d4e48a8c70051b9560000a2c0f94b3";
    };

    propagatedBuildInputs = with self; [ numpy scipy pytz ];

    meta = {
      description = "Python Algorithmic Trading";
      homepage = http://gbeced.github.io/pyalgotrade/;
      license = licenses.asl20;
    };
  };


  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyaudio = buildPythonPackage rec {
    name = "python-pyaudio-${version}";
    version = "0.2.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyAudio/PyAudio-${version}.tar.gz";
      sha256 = "bfd694272b3d1efc51726d0c27650b3c3ba1345f7f8fdada7e86c9751ce0f2a1";
    };

    disabled = isPyPy;

    buildInputs = with self; [ pkgs.portaudio ];

    meta = {
      description = "Python bindings for PortAudio";
      homepage = "http://people.csail.mit.edu/hubert/pyaudio/";
      license = licenses.mit;
    };
  };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = buildPythonPackage rec {
    name = "pysaml2-${version}";
    version = "3.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysaml2/${name}.tar.gz";
      sha256 = "0y2iw1dddcvi13xjh3l52z1mvnrbc41ik9k4nn7lwj8x5kimnk9n";
    };

    patches = [
      (pkgs.fetchpatch {
        name = "CVE-2016-10127.patch";
        url = "https://sources.debian.net/data/main/p/python-pysaml2/3.0.0-5/debian/patches/fix-xxe-in-xml-parsing.patch";
        sha256 = "184lkwdayjqiahzsn4yp15parqpmphjsb1z7zwd636jvarxqgs2q";
      })
    ];

    propagatedBuildInputs = with self; [
      repoze_who paste cryptography pycrypto pyopenssl ipaddress six cffi idna
      enum34 pytz setuptools zope_interface dateutil requests pyasn1 webob decorator pycparser
      defusedxml
    ];
    buildInputs = with self; [
      Mako pytest memcached pymongo mongodict pkgs.xmlsec
    ];

    preConfigure = ''
      sed -i 's/pymongo==3.0.1/pymongo/' setup.py
    '';

    # 16 failed, 427 passed, 17 error in 88.85 seconds
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "https://github.com/rohe/pysaml2";
    };
  };

  python-pushover = callPackage ../development/python-modules/pushover {};

  pystemd = callPackage ../development/python-modules/pystemd { systemd = pkgs.systemd; };

  mongodict = buildPythonPackage rec {
    name = "mongodict-${version}";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mongodict/${name}.tar.gz";
      sha256 = "0nv5amfs337m0gbxpjb0585s20rndqfc3mfrzq1iwgnds5gxcrlw";
    };

    propagatedBuildInputs = with self; [
      pymongo
    ];

    meta = with stdenv.lib; {
      description = "MongoDB-backed Python dict-like interface";
      homepage = "https://github.com/turicas/mongodict/";
    };
  };


  repoze_who = buildPythonPackage rec {
    name = "repoze.who-${version}";
    version = "2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/repoze.who/${name}.tar.gz";
      sha256 = "12wsviar45nwn35w2y4i8b929dq2219vmwz8013wx7bpgkn2j9ij";
    };

    propagatedBuildInputs = with self; [
      zope_interface webob
    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      description = "WSGI Authentication Middleware / API";
      homepage = "http://www.repoze.org";
    };
  };

  vobject = callPackage ../development/python-modules/vobject { };

  pycarddav = buildPythonPackage rec {
    version = "0.7.0";
    name = "pycarddav-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyCardDAV/pyCardDAV-${version}.tar.gz";
      sha256 = "0avkrcpisfvhz103v7vmq2jd83hvmpqrb4mlbx6ikkk1wcvclsx8";
    };

    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ vobject lxml requests urwid pyxdg ];

    meta = {
      description = "Command-line interface carddav client";
      homepage = http://lostpackets.de/pycarddav;
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  Babel = callPackage ../development/python-modules/Babel { };

  pybfd = callPackage ../development/python-modules/pybfd { };

  pyblock = stdenv.mkDerivation rec {
    name = "pyblock-${version}";
    version = "0.53";
    md5_path = "f6d33a8362dee358517d0a9e2ebdd044";

    src = pkgs.fetchurl rec {
      url = "http://src.fedoraproject.org/repo/pkgs/python-pyblock/"
          + "${name}.tar.bz2/${md5_path}/${name}.tar.bz2";
      sha256 = "f6cef88969300a6564498557eeea1d8da58acceae238077852ff261a2cb1d815";
    };

    postPatch = ''
      sed -i -e 's|/usr/include/python|${python}/include/python|' \
             -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
    '';

    buildInputs = with self; [ python pkgs.lvm2 pkgs.dmraid ];

    makeFlags = [
      "USESELINUX=0"
      "SITELIB=$(out)/${python.sitePackages}"
    ];

    meta = {
      description = "Interface for working with block devices";
      license = licenses.gpl2Plus;
      broken = isPy3k; # doesn't build on python 3, 2018-04-11
    };
  };

  pybcrypt = buildPythonPackage rec {
    pname = "pybcrypt";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/py-bcrypt/py-bcrypt-${version}.tar.gz";
      sha256 = "5fa13bce551468350d66c4883694850570f3da28d6866bb638ba44fe5eabda78";
    };

    meta = {
      description = "bcrypt password hashing and key derivation";
      homepage = https://code.google.com/p/py-bcrypt2;
      license = "BSD";
    };
  };

  pyblosxom = buildPythonPackage rec {
    name = "pyblosxom-${version}";
    disabled = isPy3k;
    version = "1.5.3";
    # FAIL:test_generate_entry and test_time
    # both tests fail due to time issue that doesn't seem to matter in practice
    doCheck = false;
    src = pkgs.fetchurl {
      url = "https://github.com/pyblosxom/pyblosxom/archive/v${version}.tar.gz";
      sha256 = "0de9a7418f4e6d1c45acecf1e77f61c8f96f036ce034493ac67124626fd0d885";
    };

    propagatedBuildInputs = with self; [ pygments markdown ];

    meta = {
      homepage = "http://pyblosxom.github.io";
      description = "File-based blogging engine";
      license = licenses.mit;
    };
  };


  pycapnp = buildPythonPackage rec {
    name = "pycapnp-0.5.1";
    disabled = isPyPy || isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycapnp/${name}.tar.gz";
      sha256 = "1kp97il34419gcrhn866n6a10lvh8qr13bnllnnh9473n4cq0cvk";
    };

    buildInputs = with pkgs; [ capnproto self.cython ];

    # import setuptools as soon as possible, to minimize monkeypatching mayhem.
    postConfigure = ''
      sed -i '3iimport setuptools' setup.py
    '';

    meta = {
      maintainers = with maintainers; [ cstrahan ];
      license = licenses.bsd2;
      platforms = platforms.all;
      homepage = "http://jparyani.github.io/pycapnp/index.html";
      broken = true; # 2018-04-11
    };
  };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycdio = buildPythonPackage rec {
    name = "pycdio-2.0.0";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycdio/${name}.tar.gz";
      sha256 = "1a1h0lmfl56a2a9xqhacnjclv81nv3906vdylalybxrk4bhrm3hj";
    };

    prePatch = "sed -i -e '/DRIVER_BSDI/d' pycdio.py";

    preConfigure = ''
      patchShebangs .
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ self.setuptools self.nose pkgs.swig pkgs.libcdio ]
      ++ stdenv.lib.optional stdenv.isDarwin pkgs.libiconv;

    # Run tests using nosetests but first need to install the binaries
    # to the root source directory where they can be found.
    checkPhase = ''
      ./setup.py install_lib -d .
      nosetests
    '';

    meta = {
      homepage = http://www.gnu.org/software/libcdio/;
      description = "Wrapper around libcdio (CD Input and Control library)";
      maintainers = with maintainers; [ rycee ];
      license = licenses.gpl3Plus;
    };
  };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycryptopp = buildPythonPackage (rec {
    name = "pycryptopp-0.6.0.1206569328141510525648634803928199668821045408958";
    disabled = isPy3k || isPyPy;  # see https://bitbucket.org/pypy/pypy/issue/1190/

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycryptopp/${name}.tar.gz";
      sha256 = "0n90h1yg7bfvlbhnc54xb6dbqm286ykaksyg04kxlhyjgf8mhq8i";
    };

    # Prefer crypto++ library from the Nix store over the one that's included
    # in the pycryptopp distribution.
    preConfigure = "export PYCRYPTOPP_DISABLE_EMBEDDED_CRYPTOPP=1";

    buildInputs = with self; [ setuptoolsDarcs darcsver pkgs.cryptopp ];

    meta = {
      homepage = http://allmydata.org/trac/pycryptopp;

      description = "Python wrappers for the Crypto++ library";

      license = licenses.gpl2Plus;

      maintainers = [ ];
      platforms = platforms.linux;
    };
  });

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycurl2 = buildPythonPackage (rec {
    name = "pycurl2-7.20.0";
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = "https://github.com/Lispython/pycurl.git";
      rev = "0f00109950b883d680bd85dc6e8a9c731a7d0d13";
      sha256 = "1qmw3cm93kxj94s71a8db9lwv2cxmr2wjv7kp1r8zildwdzhaw7j";
    };

    # error: (6, "Couldn't resolve host 'h.wrttn.me'")
    doCheck = false;

    buildInputs = with self; [ pkgs.curl simplejson unittest2 nose ];

    meta = {
      homepage = https://pypi.python.org/pypi/pycurl2;
      description = "A fork from original PycURL library that no maintained from 7.19.0";
      platforms = platforms.linux;
    };
  });

  pydispatcher = buildPythonPackage (rec {
    version = "2.0.5";
    name = "pydispatcher-${version}";
    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyDispatcher/PyDispatcher-${version}.tar.gz";
      sha256 = "1bswbmhlbqdxlgbxlb6xrlm4k253sg8nvpl1whgsys8p3fg0cw2m";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = http://pydispatcher.sourceforge.net/;
      description = "Signal-registration and routing infrastructure for use in multiple contexts";
      license = licenses.bsd3;
    };
   });

  pydot = callPackage ../development/python-modules/pydot { };

  pydot_ng = buildPythonPackage rec {
    name = "pydot_ng-1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pydot-ng/${name}.tar.gz";
      sha256 = "0h8k8wlzvnb40v4js7afgfyhp3wasmb1kg4gr6z7ck63iv8fq864";
    };

    buildInputs = [ self.pytest self.unittest2 ];
    propagatedBuildInputs = [ pkgs.graphviz self.pyparsing ];

    checkPhase = ''
      mkdir test/my_tests
      py.test test
    '';

    meta = {
      homepage = "https://pypi.python.org/pypi/pydot-ng";
      description = "Python 3-compatible update of pydot, a Python interface to Graphviz's Dot";
      license = licenses.mit;
      maintainers = [ maintainers.bcdarwin ];
    };
  };

  pyelftools = buildPythonPackage rec {
    pname = "pyelftools";
    version = "0.24";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "17259kf6hwwsmizr5myp9jv3k9g5i3dvmnl8m646pfd5hpb9gpg9";
    };

    checkPhase = ''
      ${python.interpreter} test/all_tests.py
    '';
    # Tests cannot pass against system-wide readelf
    # https://github.com/eliben/pyelftools/issues/65
    doCheck = false;

    meta = {
      description = "A library for analyzing ELF files and DWARF debugging information";
      homepage = https://github.com/eliben/pyelftools;
      license = licenses.publicDomain;
      platforms = platforms.all;
      maintainers = [ maintainers.igsha ];
    };
  };

  pyenchant = buildPythonPackage rec {
    name = "pyenchant-1.6.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyenchant/pyenchant-1.6.6.tar.gz";
      sha256 = "25c9d2667d512f8fc4410465fdd2e868377ca07eb3d56e2b6e534a86281d64d3";
    };

    propagatedBuildInputs = [ pkgs.enchant ];

    patchPhase = let
      path_hack_script = "s|LoadLibrary(e_path)|LoadLibrary('${pkgs.enchant}/lib/' + e_path)|";
    in ''
      sed -i "${path_hack_script}" enchant/_enchant.py

      # They hardcode a bad path for Darwin in their library search code
      substituteInPlace enchant/_enchant.py --replace '/opt/local/lib/' ""
    '';

    # dictionaries needed for tests
    doCheck = false;

    meta = {
      description = "pyenchant: Python bindings for the Enchant spellchecker";
      homepage = https://pythonhosted.org/pyenchant/;
      license = licenses.lgpl21;
    };
  };

  pyev = callPackage ../development/python-modules/pyev { };

  pyexcelerator = buildPythonPackage rec {
    name = "pyexcelerator-${version}";
    version = "0.6.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyexcelerator/${name}.tar.bz2";
      sha256 = "18rcnc9f71lj06h8nppnv6idzb7xfmh2rp1zfqayskcg686lilrb";
    };

    disabled = isPy3k;

    # No tests are included in archive
    doCheck = false;

    meta = {
      description = "library for generating Excel 97/2000/XP/2003 and OpenOffice Calc compatible spreadsheets.";
      homepage = "https://sourceforge.net/projects/pyexcelerator";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ womfoo ];
    };
  };

  pyext = callPackage ../development/python-modules/pyext { };

  pyfantom = buildPythonPackage rec {
     name = "pyfantom-${version}";
     version = "unstable-2013-12-18";

     src = pkgs.fetchgit {
       url = "http://git.ni.fr.eu.org/pyfantom.git";
       sha256 = "1m53n8bxslq5zmvcf7i1xzsgq5bdsf1z529br5ypmj5bg0s86j4q";
     };

     # No tests included
     doCheck = false;

     meta = {
       homepage = http://pyfantom.ni.fr.eu.org/;
       description = "Wrapper for the LEGO Mindstorms Fantom Driver";
       license = licenses.gpl2;
     };
   };

  pyfftw = callPackage ../development/python-modules/pyfftw { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pygeoip = callPackage ../development/python-modules/pygeoip {};

  PyGithub = callPackage ../development/python-modules/pyGithub {};

  pyglet = callPackage ../development/python-modules/pyglet {};

  pygments = callPackage ../development/python-modules/Pygments { };

  pygpgme = callPackage ../development/python-modules/pygpgme { };

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

  pysmbc = callPackage ../development/python-modules/pysmbc { };

  pyspread = callPackage ../development/python-modules/pyspread { };

  pyx = buildPythonPackage rec {
    name = "pyx-${version}";
    version = "0.14.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyX/PyX-${version}.tar.gz";
      sha256 = "05d1b7fc813379d2c12fcb5bd0195cab522b5aabafac88f72913f1d47becd912";
    };

    disabled = !isPy3k;

    # No tests in archive
    doCheck = false;

    meta = {
      description = "Python package for the generation of PostScript, PDF, and SVG files";
      homepage = http://pyx.sourceforge.net/;
      license = with licenses; [ gpl2 ];
    };
  };

  mmpython = buildPythonPackage rec {
    version = "0.4.10";
    name = "mmpython-${version}";

    src = pkgs.fetchurl {
      url = http://sourceforge.net/projects/mmpython/files/latest/download;
      sha256 = "1b7qfad3shgakj37gcj1b9h78j1hxlz6wp9k7h76pb4sq4bfyihy";
      name = "${name}.tar.gz";
    };

    disabled = isPyPy || isPy3k;

    meta = {
      description = "Media Meta Data retrieval framework";
      homepage = https://sourceforge.net/projects/mmpython/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ];
    };
  };

  kaa-base = buildPythonPackage rec {
    version = "0.99.2dev-384-2b73caca";
    name = "kaa-base-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kaa-base/kaa-base-0.99.2dev-384-2b73caca.tar.gz";
      sha256 = "0k3zzz84wzz9q1fl3vvqr2ys96z9pcf4viq9q6s2a63zaysmcfd2";
    };

    doCheck = false;

    disabled = isPyPy || isPy3k;

    # Same as in buildPythonPackage except that it does not pass --old-and-unmanageable
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/${python.libPrefix}/site-packages"

      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"

      eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
      if [ -e "$eapth" ]; then
          mv "$eapth" $(dirname "$eapth")/${name}.pth
      fi

      rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

      runHook postInstall
    '';

    meta = {
      description = "Generic application framework, providing the foundation for other modules";
      homepage = https://github.com/freevo/kaa-base;
      license = licenses.lgpl21;
      maintainers = with maintainers; [ ];
    };
  };

  kaa-metadata = buildPythonPackage rec {
    version = "0.7.8dev-r4569-20111003";
    name = "kaa-metadata-${version}";

    doCheck = false;

    buildInputs = [ pkgs.libdvdread ];

    disabled = isPyPy || isPy3k;

    # Same as in buildPythonPackage except that it does not pass --old-and-unmanageable
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/${python.libPrefix}/site-packages"

      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"

      eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
      if [ -e "$eapth" ]; then
          mv "$eapth" $(dirname "$eapth")/${name}.pth
      fi

      rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

      runHook postInstall
    '';

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kaa-metadata/kaa-metadata-0.7.8dev-r4569-20111003.tar.gz";
      sha256 = "0bkbzfgxvmby8lvzkqjp86anxvv3vjd9nksv2g4l7shsk1n7y27a";
    };

    propagatedBuildInputs = with self; [ kaa-base ];

    meta = {
      description = "Python library for parsing media metadata, which can extract metadata (e.g., such as id3 tags) from a wide range of media files";
      homepage = https://github.com/freevo/kaa-metadata;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ];
    };
  };

  PyICU = buildPythonPackage rec {
    name = "PyICU-2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyICU/${name}.tar.gz";
      sha256 = "0wq9y5fi1ighgf5aws9nr87vi1w44p7q1k83rx2y3qj5d2xyhspa";
    };

    patches = [
      (pkgs.fetchpatch {
        url = https://sources.debian.org/data/main/p/pyicu/2.2-1/debian/patches/icu_test.patch;
        sha256 = "1iavdkyqixm9i753svl17barla93b7jzgkw09dn3hnggamx7zwx9";
      })
    ];

    buildInputs = [ pkgs.icu60 self.pytest ];

    propagatedBuildInputs = [ self.six ];

    meta = {
      homepage = https://pypi.python.org/pypi/PyICU/;
      description = "Python extension wrapping the ICU C++ API";
      license = licenses.mit;
      platforms = platforms.linux; # Maybe other non-darwin Unix
      maintainers = [ maintainers.rycee ];
    };
  };

  pyinputevent = buildPythonPackage rec {
    name = "pyinputevent-2016-10-18";

    src = pkgs.fetchFromGitHub {
      owner = "ntzrmtthihu777";
      repo = "pyinputevent";
      rev = "d2075fa5db5d8a402735fe788bb33cf9fe272a5b";
      sha256 = "0rkis0xp8f9jc00x7jb9kbvhdla24z1vl30djqa6wy6fx0cr6sib";
    };

    meta = {
      homepage = "https://github.com/ntzrmtthihu777/pyinputevent";
      description = "Python interface to the Input Subsystem's input_event and uinput";
      license = licenses.bsd3;
      platforms = platforms.linux;
    };
  };

  pyinotify = buildPythonPackage rec {
    name = "pyinotify-${version}";
    version = "0.9.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${name}/${name}.tar.gz";
      sha256 = "1x3i9wmzw33fpkis203alygfnrkcmq9w1aydcm887jh6frfqm6cw";
    };

    # No tests distributed
    doCheck = false;

    meta = {
      homepage = https://github.com/seb-m/pyinotify/wiki;
      description = "Monitor filesystems events on Linux platforms with inotify";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  pyinsane2 = buildPythonPackage rec {
    name = "pyinsane2-${version}";
    version = "2.0.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyinsane2/${name}.tar.gz";
      sha256 = "00d1wqb3w9bn1rxb2dwmdqbar2lr96izq855l5vzprc17dkgip3j";
    };

    postPatch = ''
      # pyinsane2 forks itself, so we need to re-inject the PYTHONPATH.
      sed -i -e '/os.putenv.*PYINSANE_DAEMON/ {
        a \        os.putenv("PYTHONPATH", ":".join(sys.path))
      }' pyinsane2/sane/abstract_proc.py

      sed -i -e 's,"libsane.so.1","${pkgs.sane-backends}/lib/libsane.so",' \
        pyinsane2/sane/rawapi.py
    '';

    # Tests require a scanner to be physically connected, so let's just do a
    # quick check whether initialization works.
    checkPhase = ''
      python -c 'import pyinsane2; pyinsane2.init()'
    '';

    # This is needed by setup.py regardless of whether tests are enabled.
    buildInputs = [ self.nose ];

    propagatedBuildInputs = [ self.pillow ];

    meta = {
      homepage = "https://github.com/jflesch/pyinsane";
      description = "Access and use image scanners";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
    };
  };

  pyjwt = callPackage ../development/python-modules/pyjwt { };

  pykickstart = buildPythonPackage rec {
    name = "pykickstart-${version}";
    version = "1.99.39";
    md5_path = "d249f60aa89b1b4facd63f776925116d";

    src = pkgs.fetchurl rec {
      url = "http://src.fedoraproject.org/repo/pkgs/pykickstart/"
          + "${name}.tar.gz/${md5_path}/${name}.tar.gz";
      sha256 = "e0d0f98ac4c5607e6a48d5c1fba2d50cc804de1081043f9da68cbfc69cad957a";
    };

    postPatch = ''
      sed -i -e "s/for tst in tstList/for tst in sorted(tstList, \
                 key=lambda m: m.__name__)/" tests/baseclass.py
    '';

    propagatedBuildInputs = with self; [ urlgrabber ];

    checkPhase = ''
      ${python.interpreter} tests/baseclass.py -vv
    '';

    meta = {
      homepage = "http://fedoraproject.org/wiki/Pykickstart";
      description = "Read and write Fedora kickstart files";
      license = licenses.gpl2Plus;
    };
  };

  pyobjc = if stdenv.isDarwin
    then callPackage ../development/python-modules/pyobjc {}
    else throw "pyobjc can only be built on Mac OS";

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyocr = callPackage ../development/python-modules/pyocr { };

  pyparsing = callPackage ../development/python-modules/pyparsing { };

  pyparted = buildPythonPackage rec {
    name = "pyparted-${version}";
    version = "3.10.7";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/rhinstaller/pyparted/archive/v${version}.tar.gz";
      sha256 = "0c9ljrdggwawd8wdzqqqzrna9prrlpj6xs59b0vkxzip0jkf652r";
    };

    postPatch = ''
      sed -i -e 's|mke2fs|${pkgs.e2fsprogs}/bin/mke2fs|' tests/baseclass.py
      sed -i -e '
        s|e\.path\.startswith("/tmp/temp-device-")|"temp-device-" in e.path|
      ' tests/test__ped_ped.py
    '' + optionalString stdenv.isi686 ''
      # remove some integers in this test case which overflow on 32bit systems
      sed -i -r -e '/class *UnitGetSizeTestCase/,/^$/{/[0-9]{11}/d}' \
        tests/test__ped_ped.py
    '';

    preConfigure = ''
      PATH="${pkgs.parted}/sbin:$PATH"
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];

    propagatedBuildInputs = with self; [ pkgs.parted ];

    checkPhase = ''
      patchShebangs Makefile
      make test PYTHON=${python.executable}
    '';

    meta = {
      homepage = "https://fedorahosted.org/pyparted/";
      description = "Python interface for libparted";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
    };
  };


  pyptlib = buildPythonPackage (rec {
    name = "pyptlib-${version}";
    disabled = isPyPy || isPy3k;
    version = "0.0.6";

    doCheck = false;  # No such file or directory errors on 32bit

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyptlib/pyptlib-${version}.tar.gz";
      sha256 = "01y6vbwncqb0hxlnin6whd9wrrm5my4qzjhk76fnix78v7ip515r";
    };
    meta = {
      description = "A python implementation of the Pluggable Transports for Circumvention specification for Tor";
      license = licenses.bsd2;
    };
  });

  pyqtgraph = buildPythonPackage rec {
    name = "pyqtgraph-${version}";
    version = "0.9.10";

    doCheck = false;  # "PyQtGraph requires either PyQt4 or PySide; neither package could be imported."

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyqtgraph/${name}.tar.gz";
      sha256 = "188pcxf3sxxjf0aipjn820lx2rf9f42zzp0sibmcl90955a3ipf1";
    };

    propagatedBuildInputs = with self; [ scipy numpy pyqt4 pyopengl ];

    meta = {
      description = "Scientific Graphics and GUI Library for Python";
      homepage = http://www.pyqtgraph.org/;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ koral ];
    };
  };

  PyStemmer = callPackage ../development/python-modules/pystemmer {};

  serpent = callPackage ../development/python-modules/serpent { };

  selectors34 = callPackage ../development/python-modules/selectors34 { };

  Pyro4 = callPackage ../development/python-modules/pyro4 { };

  pyrsistent = buildPythonPackage (rec {
    name = "pyrsistent-0.11.12";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyrsistent/${name}.tar.gz";
      sha256 = "0jgyhkkq36wn36rymn4jiyqh2vdslmradq4a2mjkxfbk2cz6wpi5";
    };

    propagatedBuildInputs = with self; [ six ];
    buildInputs = with self; [ pytest hypothesis ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = https://github.com/tobgu/pyrsistent/;
      description = "Persistent/Functional/Immutable data structures";
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
  });

  PyRSS2Gen = buildPythonPackage (rec {
    pname = "PyRSS2Gen";
    version = "1.1";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1rvf5jw9hknqz02rp1vg8abgb1lpa0bc65l7ylmlillqx7bswq3r";
    };

    # No tests in archive
    doCheck = false;

    meta = {
      homepage = http://www.dalkescientific.om/Python/PyRSS2Gen.html;
      description = "Library for generating RSS 2.0 feeds";
      license = licenses.bsd2;
      maintainers = with maintainers; [ domenkozar ];
    };
  });

  pysmi = buildPythonPackage rec {
    version = "0.0.7";
    name = "pysmi-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysmi/${name}.tar.gz";
      sha256 = "05h1lv2a687b9qjc399w6728ildx7majbn338a0c4k3gw6wnv7wr";
    };

    # Tests require pysnmp, which in turn requires pysmi => infinite recursion
    doCheck = false;

    propagatedBuildInputs = with self; [ ply ];

    meta = {
      homepage = http://pysmi.sf.net;
      description = "SNMP SMI/MIB Parser";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  pysnmp = buildPythonPackage rec {
    version = "4.3.2";
    name = "pysnmp-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysnmp/${name}.tar.gz";
      sha256 = "0xw925f3p02vdpb3f0ls60qj59w44aiyfs3s0nhdr9vsy4fxhavw";
    };

    # NameError: name 'mibBuilder' is not defined
    doCheck = false;

    propagatedBuildInputs = with self; [ pyasn1 pycrypto pysmi ];

    meta = {
      homepage = http://pysnmp.sf.net;
      description = "A pure-Python SNMPv1/v2c/v3 library";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  pysocks = buildPythonPackage rec {
    name = "pysocks-${version}";
    version = "1.6.6";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/P/PySocks/PySocks-${version}.tar.gz";
      sha256 = "0h9zwr8z9j6l313ns335irjrkk6qnk4qzvwmjqygrp7mbwi9lh82";
    };

    doCheck = false;

    meta = {
      description = "SOCKS module for Python";
      license     = licenses.bsd3;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  python_fedora = callPackage ../development/python-modules/python_fedora {};

  python-simple-hipchat = callPackage ../development/python-modules/python-simple-hipchat {};
  python_simple_hipchat = self.python-simple-hipchat;

  python_keyczar = buildPythonPackage rec {
    name = "python-keyczar-0.71c";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/p/python-keyczar/${name}.tar.gz";
      sha256 = "18mhiwqq6vp65ykmi8x3i5l3gvrvrrr8z2kv11z1rpixmyr7sw1p";
    };

    meta = {
      description = "Toolkit for safe and simple cryptography";
      homepage    = https://pypi.python.org/pypi/python-keyczar;
      license     = licenses.asl20;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    buildInputs = with self; [ pyasn1 pycrypto ];
  };

  python-language-server = callPackage ../development/python-modules/python-language-server {};

  python-jsonrpc-server = callPackage ../development/python-modules/python-jsonrpc-server {};

  pyls-black = callPackage ../development/python-modules/pyls-black {};

  pyls-isort = callPackage ../development/python-modules/pyls-isort {};

  pyls-mypy = callPackage ../development/python-modules/pyls-mypy {};

  pyudev = callPackage ../development/python-modules/pyudev {
    inherit (pkgs) systemd;
  };

  pynmea2 = callPackage ../development/python-modules/pynmea2 {};

  pynzb = buildPythonPackage (rec {
    name = "pynzb-0.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pynzb/${name}.tar.gz";
      sha256 = "0735b3889a1174bbb65418ee503629d3f5e4a63f04b16f46ffba18253ec3ef17";
    };

    # Can't get them working
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m unittest -s pynzb -t .
    '';

    meta = {
      homepage = https://github.com/ericflo/pynzb;
      description = "Unified API for parsing NZB files";
      license = licenses.bsd3;
      maintainers = with maintainers; [ domenkozar ];
    };
  });

  process-tests = buildPythonPackage rec {
    pname = "process-tests";
    name = "${pname}-${version}";
    version = "1.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "65c9d7a0260f31c15b4a22a851757e61f7072d0557db5f8a976112fbe81ff7e9";
    };

    # No tests
    doCheck = false;

    meta = {
      description = "Tools for testing processes";
      license = licenses.bsd2;
      homepage = https://github.com/ionelmc/python-process-tests;
    };
  };

  progressbar = callPackage ../development/python-modules/progressbar {};

  progressbar2 = callPackage ../development/python-modules/progressbar2 { };

  progressbar231 = callPackage ../development/python-modules/progressbar231 { };

  progressbar33 = callPackage ../development/python-modules/progressbar33 { };

  ldap = callPackage ../development/python-modules/ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  ldap3 = callPackage ../development/python-modules/ldap3 {};

  ptest = buildPythonPackage rec {
    name = pname + "-" + version;
    pname = "ptest";
    version =  "1.5.3";
    src = pkgs.fetchFromGitHub {
      owner = "KarlGong";
      repo = pname;
      rev = version + "-release";
      sha256 = "1r50lm6n59jzdwpp53n0c0hp3aj1jxn304bk5gh830226gsaf2hn";
    };
    meta = {
      description = "Test classes and test cases using decorators, execute test cases by command line, and get clear reports";
      homepage = https://pypi.python.org/pypi/ptest;
      license = licenses.asl20;
    };
  };

  ptyprocess = callPackage ../development/python-modules/ptyprocess { };

  pylibacl = callPackage ../development/python-modules/pylibacl { };

  pylibgen = callPackage ../development/python-modules/pylibgen { };

  pyliblo = buildPythonPackage rec {
    name = "pyliblo-${version}";
    version = "0.9.2";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://das.nasophon.de/download/${name}.tar.gz";
      sha256 = "382ee7360aa00aeebf1b955eef65f8491366657a626254574c647521b36e0eb0";
    };

    propagatedBuildInputs = with self ; [ pkgs.liblo ];

    meta = {
      homepage = http://das.nasophon.de/pyliblo/;
      description = "Python wrapper for the liblo OSC library";
      license = licenses.lgpl21;
    };
  };

  pypcap = callPackage ../development/python-modules/pypcap {};

  pyplatec = buildPythonPackage rec {
    name = "PyPlatec-${version}";
    version = "1.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyPlatec/${name}.tar.gz";
      sha256 = "0kqx33flcrrlipccmqs78d14pj5749bp85b6k5fgaq2c7yzz02jg";
    };

    meta = {
      description = "Library to simulate plate tectonics with Python bindings";
      homepage    = https://github.com/Mindwerks/plate-tectonics;
      license     = licenses.lgpl3;
    };
  };

  purepng = buildPythonPackage rec {
    name = "purepng-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/purepng/${name}.tar.gz";
      sha256 = "1kcl7a6d7d59360fbz2jwfk6ha6pmqgn396962p4s62j893d2r0d";
    };

    meta = {
      description = "Pure Python library for PNG image encoding/decoding";
      homepage    = https://github.com/scondo/purepng;
      license     = licenses.mit;
    };
  };

  pymaging = buildPythonPackage rec {
    name = "pymaging-unstable-2016-11-16";

    src = pkgs.fetchFromGitHub {
      owner = "ojii";
      repo = "pymaging";
      rev = "596a08fce5664e58d6e8c96847393fbe987783f2";
      sha256 = "18g3n7kfrark30l4vzykh0gdbnfv5wb1zvvjbs17sj6yampypn38";
    };

    meta = {
      description = "Pure Python imaging library with Python 2.6, 2.7, 3.1+ support";
      homepage    = http://pymaging.rtfd.org;
      license     = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
    };
  };

  pymaging_png = buildPythonPackage rec {
    name = "pymaging-png-unstable-2016-11-16";

    src = pkgs.fetchFromGitHub {
      owner = "ojii";
      repo = "pymaging-png";
      rev = "83d85c44e4b2342818e6c068065e031a9f81bb9f";
      sha256 = "1mknxvsq0lr1ffm8amzm3w2prn043c6ghqgpxlkw83r988p5fn57";
    };

    propagatedBuildInputs = with self; [ pymaging ];

    meta = {
      description = "Pure Python imaging library with Python 2.6, 2.7, 3.1+ support";
      homepage    = https://github.com/ojii/pymaging-png/;
      license     = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
    };
  };

  pyPdf = buildPythonPackage rec {
    name = "pyPdf-1.13";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyPdf/${name}.tar.gz";
      sha256 = "3aede4c3c9c6ad07c98f059f90db0b09ed383f7c791c46100f649e1cabda0e3b";
    };

    buildInputs = with self; [ ];

    # Not supported. Package is no longer maintained.
    disabled = isPy3k;

    meta = {
      description = "Pure-Python PDF toolkit";
      homepage = "http://pybrary.net/pyPdf/";
      license = licenses.bsd3;
    };
  };

  pypdf2 = buildPythonPackage rec {
    name = "PyPDF2-${version}";
    version = "1.26.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyPDF2/${name}.tar.gz";
      sha256 = "11a3aqljg4sawjijkvzhs3irpw0y67zivqpbjpm065ha5wpr13z2";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = [ pkgs.glibcLocales ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s Tests
    '';

    # Tests broken on Python 3.x
    doCheck = !(isPy3k);

    meta = {
      description = "A Pure-Python library built as a PDF toolkit";
      homepage = "http://mstamy2.github.com/PyPDF2/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ desiderius vrthra ];
    };
  };

  pyopengl = buildPythonPackage rec {
    name = "pyopengl-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyOpenGL/PyOpenGL-${version}.tar.gz";
      sha256 = "9b47c5c3a094fa518ca88aeed35ae75834d53e4285512c61879f67a48c94ddaf";
    };
    propagatedBuildInputs = [ pkgs.libGLU_combined pkgs.freeglut self.pillow ];
    patchPhase = let
      ext = stdenv.hostPlatform.extensions.sharedLibrary; in ''
      substituteInPlace OpenGL/platform/glx.py \
        --replace "'GL'" "'${pkgs.libGL}/lib/libGL${ext}'" \
        --replace "'GLU'" "'${pkgs.libGLU}/lib/libGLU${ext}'" \
        --replace "'glut'" "'${pkgs.freeglut}/lib/libglut${ext}'"
      substituteInPlace OpenGL/platform/darwin.py \
        --replace "'OpenGL'" "'${pkgs.libGL}/lib/libGL${ext}'" \
        --replace "'GLUT'" "'${pkgs.freeglut}/lib/libglut${ext}'"
    '';
    meta = {
      homepage = http://pyopengl.sourceforge.net/;
      description = "PyOpenGL, the Python OpenGL bindings";
      longDescription = ''
        PyOpenGL is the cross platform Python binding to OpenGL and
        related APIs.  The binding is created using the standard (in
        Python 2.5) ctypes library, and is provided under an extremely
        liberal BSD-style Open-Source license.
      '';
      license = "BSD-style";
      platforms = platforms.mesaPlatforms;
    };

    # Need to fix test runner
    # Tests have many dependencies
    # Extension types could not be found.
    # Should run test suite from $out/${python.sitePackages}
    doCheck = false;
  };

  pyopenssl = callPackage ../development/python-modules/pyopenssl { };

  pyquery = buildPythonPackage rec {
    name = "pyquery-${version}";
    version = "1.2.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyquery/${name}.zip";
      sha256 = "00p6f1dfma65192hc72dxd506491lsq3g5wgxqafi1xpg2w1xia6";
    };

    propagatedBuildInputs = with self; [ cssselect lxml webob ];
    # circular dependency on webtest
    doCheck = false;
  };

  pyreport = buildPythonPackage (rec {
    name = "pyreport-0.3.4c";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyreport/${name}.tar.gz";
      sha256 = "1584607596b7b310bf0b6ce79f424bd44238a017fd870aede11cd6732dbe0d4d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = https://pypi.python.org/pypi/pyreport;
      license = "BSD";
      description = "Pyreport makes notes out of a python script";
    };
  });

  pyreadability = callPackage ../development/python-modules/pyreadability { };

  pyscss = buildPythonPackage rec {
    name = "pyScss-${version}";
    version = "1.3.5";

    src = pkgs.fetchFromGitHub {
      sha256 = "0lfsan74vcw6dypb196gmbprvlbran8p7w6czy8hyl2b1l728mhz";
      rev = "v1.3.5";
      repo = "pyScss";
      owner = "Kronuz";
    };

    checkInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [ six ]
      ++ (optionals (pythonOlder "3.4") [ enum34 pathlib ])
      ++ (optionals (pythonOlder "2.7") [ ordereddict ]);

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "A Scss compiler for Python";
      homepage = http://pyscss.readthedocs.org/en/latest/;
      license = licenses.mit;
    };
  };

  pyserial = callPackage ../development/python-modules/pyserial {};

  pymongo = callPackage ../development/python-modules/pymongo {};

  pymongo_2_9_1 = buildPythonPackage rec {
    name = "pymongo-2.9.1";
    version = "2.9.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pymongo/${name}.tar.gz";
      sha256 = "1nrr1fxyrlxd69bgxl7bvaj2j4z7v3zaciij5sbhxg0vqiz6ny50";
    };

    # Tests call a running mongodb instance
    doCheck = false;

    meta = {
      homepage = https://github.com/mongodb/mongo-python-driver;
      license = licenses.asl20;
      description = "Python driver for MongoDB ";
    };
  };

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pysqlite = buildPythonPackage rec {
    name = "pysqlite-2.8.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysqlite/${name}.tar.gz";
      sha256 = "17d3335863e8cf8392eea71add33dab3f96d060666fe68ab7382469d307f4490";
    };

    # Need to use the builtin sqlite3 on Python 3
    disabled = isPy3k;

    # Since the `.egg' file is zipped, the `NEEDED' of the `.so' files
    # it contains is not taken into account.  Thus, we must explicitly make
    # it a propagated input.
    propagatedBuildInputs = with self; [ pkgs.sqlite ];

    patchPhase = ''
      substituteInPlace "setup.cfg"                                     \
              --replace "/usr/local/include" "${pkgs.sqlite.dev}/include"   \
              --replace "/usr/local/lib" "${pkgs.sqlite.out}/lib"
      ${stdenv.lib.optionalString (!stdenv.isDarwin) ''export LDSHARED="$CC -pthread -shared"''}
    '';

    meta = {
      homepage = http://pysqlite.org/;
      description = "Python bindings for the SQLite embedded relational database engine";
      longDescription = ''
        pysqlite is a DB-API 2.0-compliant database interface for SQLite.

        SQLite is a relational database management system contained in
        a relatively small C library.  It is a public domain project
        created by D. Richard Hipp.  Unlike the usual client-server
        paradigm, the SQLite engine is not a standalone process with
        which the program communicates, but is linked in and thus
        becomes an integral part of the program.  The library
        implements most of SQL-92 standard, including transactions,
        triggers and most of complex queries.

        pysqlite makes this powerful embedded SQL engine available to
        Python programmers.  It stays compatible with the Python
        database API specification 2.0 as much as possible, but also
        exposes most of SQLite's native API, so that it is for example
        possible to create user-defined SQL functions and aggregates
        in Python.
      '';
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };


  pysvn = buildPythonPackage rec {
    name = "pysvn-1.8.0";
    format = "other";

    src = pkgs.fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/${name}.tar.gz";
      sha256 = "0srjr2qgxfs69p65d9vvdib2lc142x10w8afbbdrqs7dhi46yn9r";
    };

    buildInputs = with self; [ pkgs.subversion pkgs.apr pkgs.aprutil pkgs.expat pkgs.neon pkgs.openssl ]
      ++ (if stdenv.isLinux then [pkgs.e2fsprogs] else []);

    # There seems to be no way to pass that path to configure.
    NIX_CFLAGS_COMPILE="-I${pkgs.aprutil.dev}/include/apr-1";

    preConfigure = ''
      cd Source
      ${python.interpreter} setup.py backport
      ${python.interpreter} setup.py configure \
        --apr-inc-dir=${pkgs.apr.dev}/include \
        --apu-inc-dir=${pkgs.aprutil.dev}/include \
        --apr-lib-dir=${pkgs.apr.out}/lib \
        --svn-lib-dir=${pkgs.subversion.out}/lib \
        --svn-bin-dir=${pkgs.subversion.out}/bin \
        --svn-root-dir=${pkgs.subversion.dev}
    '' + (if !stdenv.isDarwin then "" else ''
      sed -i -e 's|libpython2.7.dylib|lib/libpython2.7.dylib|' Makefile
    '');

    checkPhase = "make -C ../Tests";

    disabled = isPy3k;

    installPhase = ''
      dest=$(toPythonPath $out)/pysvn
      mkdir -p $dest
      cp pysvn/__init__.py $dest/
      cp pysvn/_pysvn*.so $dest/
      mkdir -p $out/share/doc
      mv -v ../Docs $out/share/doc/pysvn-1.7.2
      rm -v $out/share/doc/pysvn-1.7.2/generate_cpp_docs_from_html_docs.py
    '';

    meta = {
      description = "Python bindings for Subversion";
      homepage = "http://pysvn.tigris.org/";
    };
  };

  python-ptrace = callPackage ../development/python-modules/python-ptrace { };

  python-wifi = buildPythonPackage rec {
    name = "python-wifi-${version}";
    version = "0.6.1";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-wifi/${name}.tar.bz2";
      sha256 = "149c3dznb63d82143cz5hqdim0mqjysz6p3yk0zv271vq3xnmzvv";
    };

    meta = {
      inherit version;
      description = "Read & write wireless card capabilities using the Linux Wireless Extensions";
      homepage = http://pythonwifi.tuxfamily.org/;
      # From the README: "pythonwifi is licensed under LGPLv2+, however, the
      # examples (e.g. iwconfig.py and iwlist.py) are licensed under GPLv2+."
      license = with licenses; [ lgpl2Plus gpl2Plus ];
    };
  };

  python-etcd = buildPythonPackage rec {
    name = "python-etcd-${version}";
    version = "0.4.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-etcd/${name}.tar.gz";
      sha256 = "cf53262b3890d185fe637eed15fe39c8d7a8261864ddcd7037b22c961456d7fc";
    };

    buildInputs = with self; [ nose mock pyopenssl ];

    propagatedBuildInputs = with self; [ urllib3 dnspython ];

    postPatch = ''
      sed -i '19s/dns/"dnspython"/' setup.py
    '';

    # Some issues with etcd not in path even though most tests passed
    doCheck = false;

    meta = {
      description = "A python client for Etcd";
      homepage = https://github.com/jplana/python-etcd;
      license = licenses.mit;
    };
  };

  pythonnet = callPackage ../development/python-modules/pythonnet {
    # `mono >= 4.6` required to prevent crashes encountered with earlier versions.
    mono = pkgs.mono46;
  };

  pytz = callPackage ../development/python-modules/pytz { };

  pytzdata = callPackage ../development/python-modules/pytzdata { };

  pyutil = buildPythonPackage (rec {
    name = "pyutil-2.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyutil/${name}.tar.gz";
      sha256 = "1fsg9yz5mi2sb0h6c1vvcqchx56i89nbvdb5gfgv1ia3b2w5ra8c";
    };

    buildInputs = with self; [ setuptoolsDarcs setuptoolsTrial ] ++ (if doCheck then [ simplejson ] else []);
    propagatedBuildInputs = with self; [ zbase32 argparse twisted ];
    # Tests fail because they try to write new code into the twisted
    # package, apparently some kind of plugin.
    doCheck = false;

    prePatch = optionalString isPyPy ''
      grep -rl 'utf-8-with-signature-unix' ./ | xargs sed -i -e "s|utf-8-with-signature-unix|utf-8|g"
    '';

    meta = {
      description = "Pyutil, a collection of mature utilities for Python programmers";

      longDescription = ''
        These are a few data structures, classes and functions which
        we've needed over many years of Python programming and which
        seem to be of general use to other Python programmers. Many of
        the modules that have existed in pyutil over the years have
        subsequently been obsoleted by new features added to the
        Python language or its standard library, thus showing that
        we're not alone in wanting tools like these.
      '';

      homepage = http://allmydata.org/trac/pyutil;

      license = licenses.gpl2Plus;
    };
  });


  pywebkitgtk = buildPythonPackage rec {
    name = "pywebkitgtk-${version}";
    version = "1.1.8";
    format = "other";

    src = pkgs.fetchurl {
      url = "http://pywebkitgtk.googlecode.com/files/${name}.tar.bz2";
      sha256 = "1svlwyl61rvbqbcbalkg6pbf38yjyv7qkq9sx4x35yk69lscaac2";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [
      pkgs.gtk2 self.pygtk pkgs.libxml2
      pkgs.libxslt pkgs.libsoup pkgs.webkitgtk24x-gtk2 pkgs.icu
    ];

    meta = {
      homepage = "https://code.google.com/p/pywebkitgtk/";
      description = "Python bindings for the WebKit GTK+ port";
      license = licenses.lgpl2Plus;
    };
  };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pyxattr = callPackage ../development/python-modules/pyxattr { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  rabbitpy = buildPythonPackage rec {
    version = "0.26.2";
    name = "rabbitpy-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rabbitpy/${name}.tar.gz";
      sha256 = "0pgijv7mgxc4sm7p9s716dhl600l8isisxzyg4hz7ng1sk09p1w3";
    };

    buildInputs = with self; [ mock nose ];

    propagatedBuildInputs = with self; [ pamqp ];

    meta = {
      description = "A pure python, thread-safe, minimalistic and pythonic RabbitMQ client library";
      homepage = https://pypi.python.org/pypi/rabbitpy;
      license = licenses.bsd3;
    };
  };

  radicale_infcloud = callPackage ../development/python-modules/radicale_infcloud {};

  recaptcha_client = buildPythonPackage rec {
    name = "recaptcha-client-1.0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/recaptcha-client/${name}.tar.gz";
      sha256 = "28c6853c1d13d365b7dc71a6b05e5ffb56471f70a850de318af50d3d7c0dea2f";
    };

    disabled = isPy35 || isPy36;

    meta = {
      description = "A CAPTCHA for Python using the reCAPTCHA service";
      homepage = http://recaptcha.net/;
    };
  };

  rbtools = buildPythonPackage rec {
    name = "rbtools-0.7.2";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/RBTools/0.7/RBTools-0.7.2.tar.gz";
      sha256 = "1ng8l8cx81cz23ls7fq9wz4ijs0zbbaqh4kj0mj6plzcqcf8na4i";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six ];

    checkPhase = "nosetests";

    disabled = isPy3k;

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  rencode = buildPythonPackage rec {
    name = "rencode-${version}";
    version = "git20150810";
    disabled = isPy33;

    src = pkgs.fetchgit {
      url = https://github.com/aresch/rencode;
      rev = "b45e04abdca0dea36e383a8199783269f186c99e";
      sha256 = "b4bd82852d4220e8a9493d3cfaecbc57b1325708a2d48c0f8acf262edb10dc40";
    };

    buildInputs = with self; [ cython ];

    meta = {
      homepage = https://github.com/aresch/rencode;
      description = "Fast (basic) object serialization similar to bencode";
      license = licenses.gpl3;
    };
  };

  reportlab = callPackage ../development/python-modules/reportlab { };

  requests2 = throw "requests2 has been deprecated. Use requests instead.";

  # use requests, not requests_2
  requests = callPackage ../development/python-modules/requests { };

  requests_download = callPackage ../development/python-modules/requests_download { };

  requestsexceptions = callPackage ../development/python-modules/requestsexceptions {};

  requests_ntlm = callPackage ../development/python-modules/requests_ntlm { };

  requests_oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };
  requests_toolbelt = self.requests-toolbelt; # Old attr, 2017-09-26

  retry_decorator = buildPythonPackage rec {
    name = "retry_decorator-1.0.0";
    src = pkgs.fetchurl {
      url = mirror://pypi/r/retry_decorator/retry_decorator-1.0.0.tar.gz;
      sha256 = "086zahyb6yn7ggpc58909c5r5h3jz321i1694l1c28bbpaxnlk88";
    };
    meta = {
      homepage = https://github.com/pnpnpn/retry-decorator;
      license = licenses.mit;
    };
  };

  quandl = callPackage ../development/python-modules/quandl { };
  # alias for an older package which did not support Python 3
  Quandl = callPackage ../development/python-modules/quandl { };

  qscintilla = disabledIf (isPy3k || isPyPy)
    (buildPythonPackage rec {
      # TODO: Qt5 support
      name = "qscintilla-${version}";
      version = pkgs.qscintilla.version;
      format = "other";

      src = pkgs.qscintilla.src;

      buildInputs = with self; [ pkgs.xorg.lndir pyqt4.qt pyqt4 ];

      preConfigure = ''
        mkdir -p $out
        lndir ${self.pyqt4} $out
        rm -rf "$out/nix-support"
        cd Python
        ${python.executable} ./configure-old.py \
            --destdir $out/lib/${python.libPrefix}/site-packages/PyQt4 \
            --apidir $out/api/${python.libPrefix} \
            -n ${pkgs.qscintilla}/include \
            -o ${pkgs.qscintilla}/lib \
            --sipdir $out/share/sip
      '';

      meta = with stdenv.lib; {
        description = "A Python binding to QScintilla, Qt based text editing control";
        license = licenses.lgpl21Plus;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.unix;
      };
    });


  qserve = buildPythonPackage rec {
    name = "qserve-0.2.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/qserve/${name}.zip";
      sha256 = "0b04b2d4d11b464ff1efd42a9ea9f8136187d59f4076f57c9ba95361d41cd7ed";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "Job queue server";
      homepage = "https://github.com/pediapress/qserve";
      license = licenses.bsd3;
    };
  };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  quantities = callPackage ../development/python-modules/quantities { };

  qutip = buildPythonPackage rec {
    name = "qutip-2.2.0";

    src = pkgs.fetchurl {
      url = "https://qutip.googlecode.com/files/QuTiP-2.2.0.tar.gz";
      sha256 = "a26a639d74b2754b3a1e329d91300e587e8c399d8a81d8f18a4a74c6d6f02ba3";
    };

    propagatedBuildInputs = with self; [ numpy scipy matplotlib pyqt4
      cython ];

    buildInputs = [ pkgs.gcc pkgs.qt4 pkgs.blas self.nose ];

    meta = {
      description = "QuTiP - Quantum Toolbox in Python";
      longDescription = ''
        QuTiP is open-source software for simulating the dynamics of
        open quantum systems. The QuTiP library depends on the
        excellent Numpy and Scipy numerical packages. In addition,
        graphical output is provided by Matplotlib. QuTiP aims to
        provide user-friendly and efficient numerical simulations of a
        wide variety of Hamiltonians, including those with arbitrary
        time-dependence, commonly found in a wide range of physics
        applications such as quantum optics, trapped ions,
        superconducting circuits, and quantum nanomechanical
        resonators.
      '';
      homepage = http://qutip.org/;
    };
  };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  redis = callPackage ../development/python-modules/redis { };

  rednose = callPackage ../development/python-modules/rednose { };

  reikna = callPackage ../development/python-modules/reikna { };

  repocheck = buildPythonPackage rec {
    name = "repocheck-2015-08-05";

    src = pkgs.fetchFromGitHub {
      sha256 = "1jc4v5zy7z7xlfmbfzvyzkyz893f5x2k6kvb3ni3rn2df7jqhc81";
      rev = "ee48d0e88d3f5814d24a8d1f22d5d83732824688";
      repo = "repocheck";
      owner = "kynikos";
    };

    meta = {
      inherit (src.meta) homepage;
      description = "Check the status of code repositories under a root directory";
      license = licenses.gpl3Plus;
    };
  };

  restview = callPackage ../development/python-modules/restview { };

  readme = buildPythonPackage rec {
    name = "readme-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/readme/readme-${version}.tar.gz";
      sha256 = "08j2w67nilczn1i5r7h22vag9673i6vnfhyq2rv27r1bdmi5a30m";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [
      six docutils pygments bleach html5lib
    ];

    checkPhase = ''
      py.test
    '';

    # Tests fail, possibly broken.
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Readme";
      homepage = "https://github.com/pypa/readme";
    };
  };

  readme_renderer = callPackage ../development/python-modules/readme_renderer { };

  rivet = disabledIf isPy3k (toPythonModule (pkgs.rivet.override {
    python2 = python;
  }));

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  geoalchemy2 = buildPythonPackage rec {
    name = "GeoAlchemy2-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/G/GeoAlchemy2/${name}.tar.gz";
      sha256 = "0p2h1kgl5b0jz8wadx485vjh1mmm5s67p71yxh9lhp1441hkfswf";
    };

    propagatedBuildInputs = with self ; [ sqlalchemy shapely ];

    meta = {
      homepage =  http://geoalchemy.org/;
      license = licenses.mit;
      description = "Toolkit for working with spatial databases";
    };
  };

  geopy = buildPythonPackage rec {
    name = "geopy-${version}";
    version = "1.11.0";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/geopy/geopy-${version}.tar.gz";
      sha256 = "04j1lxcsfyv03h0n0q7p2ig7a4n13x4x20fzxn8bkazpx6lyal22";
    };

    doCheck = false;  # too much

    buildInputs = with self; [ mock tox pylint ];
    meta = with stdenv.lib; {
      homepage = "https://github.com/geopy/geopy";
    };
  };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  isodate = buildPythonPackage rec {
    name = "isodate-${version}";
    version = "0.5.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/isodate/${name}.tar.gz";
      sha256 = "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31";
    };

    # Judging from SyntaxError
    doCheck = !(isPy3k);

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s src/isodate/tests
    '';

    meta = {
      description = "ISO 8601 date/time parser";
      homepage = http://cheeseshop.python.org/pypi/isodate;
    };
  };

  resampy = buildPythonPackage rec {
    pname = "resampy";
    version = "0.1.4";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "cf4f149d8699af70a1b4b0769fa16fab21835d936ea7ff25e98446aa49e743d4";
    };

    checkInputs = with self; [ pytest pytestcov ];
    # No tests included
    doCheck = false;
    propagatedBuildInputs = with self; [ numpy scipy cython six ];

    meta = {
      homepage = https://github.com/bmcfee/resampy;
      description = "Efficient signal resampling";
      license = licenses.isc;
    };
  };

  restructuredtext_lint = callPackage ../development/python-modules/restructuredtext_lint { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-selenium2library = buildPythonPackage rec {
    version = "1.6.0";
    name = "robotframework-selenium2library-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/robotframework-selenium2library/${name}.tar.gz";
      sha256 = "1asdwrpb4s7q08bx641yrh3yicgba14n3hxmsqs58mqf86ignwly";
    };

    # error: invalid command 'test'
    #doCheck = false;

    propagatedBuildInputs = with self; [ robotframework selenium docutils decorator ];

    meta = {
      description = "";
      homepage = http://robotframework.org/;
      license = licenses.asl20;
    };
  };


  robotframework-tools = buildPythonPackage rec {
    version = "0.1a115";
    name = "robotframework-tools-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/robotframework-tools/${name}.tar.gz";
      sha256 = "04gkn1zpf3rsvbqdxrrjqqi8sa0md9gqwh6n5w2m03fdwjg4lc7q";
    };

    propagatedBuildInputs = with self; [ robotframework moretools pathpy six setuptools ];

    meta = {
      description = "Python Tools for Robot Framework and Test Libraries";
      homepage = https://bitbucket.org/userzimmermann/robotframework-tools;
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  robotframework-ride = callPackage ../development/python-modules/robotframework-ride { };

  robotframework-requests = buildPythonPackage rec {
    version = "0.4.6";
    name = "robotframework-requests-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/ad/da/51359b11d2005ff425984205677890fafaf270a71b03df22c255501bc99d/robotframework-requests-0.4.6.tar.gz";
      sha256 = "0416rxg7g0pfg77akljnkass0xz0id26v4saag2q2h1fgwrm7n4q";
    };

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ robotframework lxml requests ];

    meta = {
      description = "Robot Framework keyword library wrapper around the HTTP client library requests";
      homepage = https://github.com/bulkan/robotframework-requests;
    };
  };

  root_numpy = callPackage ../development/python-modules/root_numpy { };

  rootpy = callPackage ../development/python-modules/rootpy { };

  rope = callPackage ../development/python-modules/rope { };

  ropper = callPackage ../development/python-modules/ropper { };

  routes = buildPythonPackage rec {
    pname = "Routes";
    version = "2.4.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1zamff3m0kc4vyfniyhxpkkcqv1rrgnmh37ykxv34nna1ws47vi6";
    };

    propagatedBuildInputs = with self; [ repoze_lru six webob ];

    checkInputs = with self; [ coverage webtest ];

    meta = {
      description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
      homepage = http://routes.groovie.org/;
    };
  };

  rpkg = callPackage ../development/python-modules/rpkg {};

  rply = callPackage ../development/python-modules/rply {};

  rpm = toPythonModule (pkgs.rpm.override{inherit python;});

  rpmfluff = callPackage ../development/python-modules/rpmfluff {};

  rpy2 = callPackage ../development/python-modules/rpy2 {};

  rpyc = buildPythonPackage rec {
    name = "rpyc-${version}";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rpyc/${name}.tar.gz";
      sha256 = "43fa845314f0bf442f5f5fab15bb1d1b5fe2011a8fc603f92d8022575cef8b4b";
    };

    propagatedBuildInputs = with self; [ nose plumbum ];

    meta = {
      description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
      homepage = http://rpyc.readthedocs.org;
      license = licenses.mit;
    };
  };

  rsa = buildPythonPackage rec {
    name = "rsa-${version}";
    version = "3.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rsa/${name}.tar.gz";
      sha256 = "1dcxvszbikgzh99ybdc7jq0zb9wspy2ds8z9mjsqiyv3q884xpr5";
    };

    nativeBuildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ pyasn1 ];

    meta = {
      homepage = https://stuvel.eu/rsa;
      license = licenses.asl20;
      description = "A pure-Python RSA implementation";
    };
  };

  Rtree = callPackage ../development/python-modules/Rtree { inherit (pkgs) libspatialindex; };

  squaremap = buildPythonPackage rec {
    name = "squaremap-1.0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/SquareMap/SquareMap-1.0.4.tar.gz";
      sha256 = "feab6cb3b222993df68440e34825d8a16de2c74fdb290ae3974c86b1d5f3eef8";
    };

    meta = {
      description = "Hierarchic visualization control for wxPython";
      homepage = https://launchpad.net/squaremap;
      license = licenses.bsd3;
    };
  };

  ruamel_base = buildPythonPackage rec {
    name = "ruamel.base-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ruamel.base/${name}.tar.gz";
      sha256 = "1wswxrn4givsm917mfl39rafgadimf1sldpbjdjws00g1wx36hf0";
    };

    meta = {
      description = "Common routines for ruamel packages";
      homepage = https://bitbucket.org/ruamel/base;
      license = licenses.mit;
    };
  };

  ruamel_ordereddict = buildPythonPackage rec {
    name = "ruamel.ordereddict-${version}";
    version = "0.4.9";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ruamel.ordereddict/${name}.tar.gz";
      sha256 = "1xmkl8v9l9inm2pyxgc1fm5005yxm7fkd5gv74q7lj1iy5qc8n3h";
    };

    meta = {
      description = "A version of dict that keeps keys in insertion resp. sorted order";
      homepage = https://bitbucket.org/ruamel/ordereddict;
      license = licenses.mit;
    };
  };

  typing = callPackage ../development/python-modules/typing { };

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  ruamel_yaml = buildPythonPackage rec {
    name = "ruamel.yaml-${version}";
    version = "0.15.35";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ruamel.yaml/${name}.tar.gz";
      sha256 = "0xggyfaj6vprggahf7cq8kp9j79rb7hn8ndk3bxj2sxvwhhliiwd";
    };

    # Tests cannot load the module to test
    doCheck = false;

    propagatedBuildInputs = with self; [ ruamel_base typing ] ++
    (optional (!isPy3k) self.ruamel_ordereddict);

    meta = {
      description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
      homepage = https://bitbucket.org/ruamel/yaml;
      license = licenses.mit;
    };
  };

  runsnakerun = buildPythonPackage rec {
    name = "runsnakerun-2.0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/R/RunSnakeRun/RunSnakeRun-2.0.4.tar.gz";
      sha256 = "61d03a13f1dcb3c1829f5a146da1fe0cc0e27947558a51e848b6d469902815ef";
    };

    propagatedBuildInputs = with self; [ squaremap wxPython ];

    meta = {
      description = "GUI Viewer for Python profiling runs";
      homepage = http://www.vrplumber.com/programming/runsnakerun/;
      license = licenses.bsd3;
    };
  };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  pysendfile = buildPythonPackage rec {
    name = "pysendfile-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysendfile/pysendfile-${version}.tar.gz";
      sha256 = "05qf0m32isflln1zjgxlpw0wf469lj86vdwwqyizp1h94x5l22ji";
    };

    checkPhase = ''
      # this test takes too long
      sed -i 's/test_big_file/noop/' test/test_sendfile.py
      ${self.python.executable} test/test_sendfile.py
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/giampaolo/pysendfile";
    };
  };

  qpid-python = buildPythonPackage rec {
    name = "qpid-python-${version}";
    version = "0.32";
    disabled = isPy3k;  # not supported

    src = pkgs.fetchurl {
      url = "http://www.us.apache.org/dist/qpid/${version}/${name}.tar.gz";
      sha256 = "09hdfjgk8z4s3dr8ym2r6xn97j1f9mkb2743pr6zd0bnj01vhsv4";
    };

    # needs a broker running and then ./qpid-python-test
    doCheck = false;

  };

  xattr = buildPythonPackage rec {
    name = "xattr-0.7.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xattr/${name}.tar.gz";
      sha256 = "0nbqfghgy26jyp5q7wl3rj78wr8s39m5042df2jlldg3fx6j0417";
    };

    # https://github.com/xattr/xattr/issues/43
    doCheck = false;

    postBuild = ''
      ${python.interpreter} -m compileall -f xattr
    '';

    propagatedBuildInputs = [ self.cffi ];
  };

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

  scripttest = buildPythonPackage rec {
    version = "1.3";
    name = "scripttest-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/scripttest/scripttest-${version}.tar.gz";
      sha256 = "951cfc25219b0cd003493a565f2e621fd791beaae9f9a3bdd7024d8626419c38";
    };

    buildInputs = with self; [ pytest ];

    # Tests are not included. See https://github.com/pypa/scripttest/issues/11
    doCheck = false;

    meta = {
      description = "A library for testing interactive command-line applications";
      homepage = https://pypi.python.org/pypi/ScriptTest/;
    };
  };

  seaborn = callPackage ../development/python-modules/seaborn { };

  selenium = callPackage ../development/python-modules/selenium { };

  serpy = callPackage ../development/python-modules/serpy { };

  setuptools_scm = callPackage ../development/python-modules/setuptools_scm { };

  setuptoolsDarcs = buildPythonPackage rec {
    name = "setuptools_darcs-${version}";
    version = "1.2.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/setuptools_darcs/${name}.tar.gz";
      sha256 = "1wsh0g1fn10msqk87l5jrvzs0yj5mp6q9ld3gghz6zrhl9kqzdn1";
    };

    # In order to break the dependency on darcs -> ghc, we don't add
    # darcs as a propagated build input.
    propagatedBuildInputs = with self; [ darcsver ];

    # ugly hack to specify version that should otherwise come from darcs
    patchPhase = ''
      substituteInPlace setup.py --replace "name=PKG" "name=PKG, version='${version}'"
    '';

    meta = {
      description = "Setuptools plugin for the Darcs version control system";
      homepage = http://allmydata.org/trac/setuptools_darcs;
      license = "BSD";
    };
  };

  setuptoolsTrial = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "setuptools_trial";
    version = "0.6.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "14220f8f761c48ba1e2526f087195077cf54fad7098b382ce220422f0ff59b12";
    };
    buildInputs = with self; [ pytest virtualenv pytestrunner pytest-virtualenv ];
    propagatedBuildInputs = with self; [ twisted pathlib2 ];
    postPatch = ''
      sed -i '12,$d' tests/test_main.py
    '';

    # Couldn't get tests working
    doCheck = false;

    meta = {
      description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit.";
      homepage = "https://github.com/rutsky/setuptools-trial";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ryansydnor nand0p ];
      platforms   = platforms.all;
    };
  };

  shippai = callPackage ../development/python-modules/shippai {};

  simanneal = callPackage ../development/python-modules/simanneal { };

  simplebayes = buildPythonPackage rec {
    name = "simplebayes-${version}";
    version = "1.5.8";

    # Use GitHub instead of pypi, because it contains tests.
    src = pkgs.fetchFromGitHub {
      repo = "simplebayes";
      owner = "hickeroar";
      # NOTE: This is actually 1.5.8 but the tag is wrong!
      rev = "1.5.7";
      sha256 = "0mp7rvfdmpfxnka4czw3lv5kkh6gdxh6dm4r6hcln1zzfg9lxp4h";
    };

    checkInputs = [ self.nose self.mock ];

    postPatch = optionalString isPy3k ''
      sed -i -e 's/open *(\([^)]*\))/open(\1, encoding="utf-8")/' setup.py
    '';

    checkPhase = "nosetests tests/test.py";

    meta = {
      description = "Memory-based naive bayesian text classifier";
      homepage = "https://github.com/hickeroar/simplebayes";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  shortuuid = buildPythonPackage rec {
    name = "shortuuid-${version}";
    version = "0.4.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/shortuuid/${name}.tar.gz";
      sha256 = "4606dbb19124d98109c00e2cafae2df8117aec02115623e18fb2abe3f766d293";
    };

    buildInputs = with self; [pep8];

    meta = {
      description = "A generator library for concise, unambiguous and URL-safe UUIDs";
      homepage = https://github.com/stochastic-technologies/shortuuid/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ zagy ];
    };
  };

  shouldbe = buildPythonPackage rec {
    version = "0.1.0";
    name = "shouldbe-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/shouldbe/${name}.tar.gz";
      sha256 = "07pchxpv1xvjbck0xy44k3a1jrvklg0wbyccn14w0i7d135d4174";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [ forbiddenfruit ];

    doCheck = false;  # Segmentation fault on py 3.5

    meta = {
      description = "Python Assertion Helpers inspired by Shouldly";
      homepage =  https://pypi.python.org/pypi/shouldbe/;
      license = licenses.mit;
    };
  };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simpleparse = buildPythonPackage rec {
    version = "2.1.1";
    name = "simpleparse-${version}";

    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/SimpleParse/SimpleParse-${version}.tar.gz";
      sha256 = "1n8msk71lpl3kv086xr2sv68ppgz6228575xfnbszc6p1mwr64rg";
    };

    doCheck = false;  # weird error

    meta = {
      description = "A Parser Generator for Python";
      homepage = https://pypi.python.org/pypi/SimpleParse;
      platforms = platforms.all;
      maintainers = with maintainers; [ ];
    };
  };

  slimit = callPackage ../development/python-modules/slimit { };

  slob = buildPythonPackage rec {
    name = "slob-unstable-2016-11-03";

    disabled = !isPy3k;

    src = pkgs.fetchFromGitHub {
      owner = "itkach";
      repo = "slob";
      rev = "d1ed71e4778729ecdfc2fe27ed783689a220a6cd";
      sha256 = "1r510s4r124s121wwdm9qgap6zivlqqxrhxljz8nx0kv0cdyypi5";
    };

    propagatedBuildInputs = [ self.PyICU ];

    checkPhase = "python3 -m unittest slob";

    meta = {
      homepage = https://github.com/itkach/slob/;
      description = "Reference implementation of the slob (sorted list of blobs) format";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  slowaes = buildPythonPackage rec {
    name = "slowaes-${version}";
    version = "0.1a1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/slowaes/${name}.tar.gz";
      sha256 = "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09";
    };

    disabled = isPy3k;

    meta = {
      homepage = "http://code.google.com/p/slowaes/";
      description = "AES implemented in pure python";
      license = with licenses; [ asl20 ];
    };
  };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  sqlite3dbm = buildPythonPackage rec {
    name = "sqlite3dbm-0.1.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sqlite3dbm/${name}.tar.gz";
      sha256 = "4721607e0b817b89efdba7e79cab881a03164b94777f4cf796ad5dd59a7612c5";
    };

    meta = {
      description = "sqlite-backed dictionary";
      homepage = https://github.com/Yelp/sqlite3dbm;
      license = licenses.asl20;
    };
  };

  sqlobject = buildPythonPackage rec {
    pname = "SQLObject";
    version = "3.3.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0p2dxrxh7xrv5yys09v5z95d0z40w22aq3xc01ghdidd7hr79xy9";
    };

    checkInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [
      FormEncode
      PasteDeploy
      paste
      pydispatcher
    ];

    meta = {
      description = "Object Relational Manager for providing an object interface to your database";
      homepage = "http://www.sqlobject.org/";
      license = licenses.lgpl21;
    };
  };

  sqlmap = callPackage ../development/python-modules/sqlmap { };
  pgpdump = self.buildPythonPackage rec {
    pname = "pgpdump";
    version = "1.5";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0s4nh8h7qsdj2yf29bspjs1zvxd4lcd11r6g11dp7fppgf2h0iqw";
    };

    # Disabling check because of: https://github.com/toofishes/python-pgpdump/issues/18
    doCheck = false;

    meta = {
      description = "Python library for parsing PGP packets";
      homepage = https://github.com/toofishes/python-pgpdump;
      license = licenses.bsd3;
    };
  };

  spambayes = callPackage ../development/python-modules/spambayes { };

  shapely = callPackage ../development/python-modules/shapely { };

  sharedmem = callPackage ../development/python-modules/sharedmem { };

  soco = callPackage ../development/python-modules/soco { };

  sopel = buildPythonPackage rec {
    name = "sopel-6.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sopel/${name}.tar.gz";
      sha256 = "1swvw7xw8n5anb8ah8jilk4vk1y30y62fkibfd9vm9fbk45d1q48";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ praw xmltodict pytz pyenchant pygeoip ];

    disabled = isPyPy || isPy27;

    checkPhase = ''
    ${python.interpreter} test/*.py                                         #*/
    '';
    meta = {
      description = "Simple and extensible IRC bot";
      homepage = "http://sopel.chat";
      license = licenses.efl20;
      maintainers = with maintainers; [ mog ];
    };
  };

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

  tilestache = self.buildPythonPackage rec {
    name = "tilestache-${version}";
    version = "1.50.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/T/TileStache/TileStache-${version}.tar.gz";
      sha256 = "1z1j35pz77lhhjdn69sq5rmz62b5m444507d8zjnp0in5xqaj6rj";
    };

    disabled = !isPy27;

    propagatedBuildInputs = with self;
      [ modestmaps pillow pycairo python-mapnik simplejson werkzeug ];

    meta = {
      description = "A tile server for rendered geographic data";
      homepage = http://tilestache.org;
      license = licenses.bsd3;
    };
  };

  timelib = buildPythonPackage rec {
    name = "timelib-0.2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/timelib/${name}.zip";
      sha256 = "49142233bdb5971d64a41e05a1f80a408a02be0dc7d9f8c99e7bdd0613ba81cb";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "Parse english textual date descriptions";
      homepage = "https://github.com/pediapress/timelib/";
      license = licenses.zlib;
    };
  };

  timeout-decorator = callPackage ../development/python-modules/timeout-decorator { };

  pid = buildPythonPackage rec {
    name = "pid-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pid/${name}.tar.gz";
      sha256 = "0cylj8p25nwkdfgy4pzai21wyzmrxdqlwwbzqag9gb5qcjfdwk05";
    };

    buildInputs = with self; [ nose ];

    # No tests included
    doCheck = false;

    meta = {
      description = "Pidfile featuring stale detection and file-locking";
      homepage = https://github.com/trbs/pid/;
      license = licenses.asl20;
    };
  };

  pip2nix = buildPythonPackage rec {
    name = "pip2nix-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pip2nix/${name}.tar.gz";
      sha256 = "1s76i8r4khq8y5r6g4218jg2c6qldmw5xhzymxad51ii8hafpwq6";
    };

    propagatedBuildInputs = with self; [ click configobj contexter jinja2 pytest ];

    meta.broken = true;
  };

  pychef = buildPythonPackage rec {
    name    = "PyChef-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/f9/31/17cde137e3b8ada4d7c80fd4504264f2abed329a9a8100c3622a044c485e/PyChef-0.3.0.tar.gz";
      sha256 = "0zdz8lw545cd3a34cpib7mdwnad83gr2mrrxyj3v74h4zhwabhmg";
    };

    propagatedBuildInputs = with self; [ six requests mock unittest2 ];

    # FIXME
    doCheck = false;
  };

  pydns =
    let
      py3 = buildPythonPackage rec {
        name = "${pname}-${version}";
        pname = "py3dns";
        version = "3.1.1a";

        src = fetchPypi {
          inherit pname version;
          sha256 = "0z0qmx9j1ivpgg54gqqmh42ljnzxaychc5inz2gbgv0vls765smz";
        };

        preConfigure = ''
          sed -i \
            -e '/import DNS/d' \
            -e 's/DNS.__version__/"${version}"/g' \
            setup.py
        '';

        doCheck = false;
      };

      py2 = buildPythonPackage rec {
        name = "${pname}-${version}";
        pname = "pydns";
        version = "2.3.6";

        src = fetchPypi {
          inherit pname version;
          sha256 = "0qnv7i9824nb5h9psj0rwzjyprwgfiwh5s5raa9avbqazy5hv5pi";
        };

        doCheck = false;
      };
    in if isPy3k then py3 else py2;

  python-daemon = callPackage ../development/python-modules/python-daemon { };

  sympy = callPackage ../development/python-modules/sympy { };

  pilkit = buildPythonPackage rec {
    name = "pilkit-1.1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pilkit/${name}.tar.gz";
      sha256 = "e00585f5466654ea2cdbf7decef9862cb00e16fd363017fa7ef6623a16b0d2c7";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
    '';

    # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
    doCheck = false;

    buildInputs = with self; [ pillow nose_progressive nose mock blessings ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  clint = buildPythonPackage rec {
    name = "clint-0.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/clint/${name}.tar.gz";
      sha256 = "1an5lkkqk1zha47198p42ji3m94xmzx1a03dn7866m87n4r4q8h5";
    };


    LC_ALL="en_US.UTF-8";

    checkPhase = ''
      ${python.interpreter} test_clint.py
    '';

    buildInputs = with self; [ mock blessings nose nose_progressive pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ pillow blessings args ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  argh = buildPythonPackage rec {
    name = "argh-0.26.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/argh/${name}.tar.gz";
      sha256 = "1nqham81ihffc9xmw85dz3rg3v90rw7h0dp3dy0bh3qkp4n499q6";
    };

    checkPhase = ''
      export LANG="en_US.UTF-8"
      py.test
    '';

    buildInputs = with self; [ pytest py mock pkgs.glibcLocales ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  nose_progressive = buildPythonPackage rec {
    name = "nose-progressive-1.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose-progressive/${name}.tar.gz";
      sha256 = "0mfbjv3dcg23q0a130670g7xpfyvgza4wxkj991xxh8w9hs43ga4";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pillow blessings ];

    # fails with obscure error
    doCheck = !isPy3k;

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  blessings = buildPythonPackage rec {
    name = "blessings-1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/blessings/${name}.tar.gz";
      sha256 = "01rhgn2c3xjf9h1lxij9m05iwf2ba6d0vd7nic26c2gic4q73igd";
    };

    # 4 failing tests, 2to3
    doCheck = false;

    propagatedBuildInputs = with self; [ ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  secretstorage = callPackage ../development/python-modules/secretstorage { };

  semantic = buildPythonPackage rec {
    name = "semantic-1.0.3";

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ quantities numpy ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/semantic/semantic-1.0.3.tar.gz";
      sha256 = "bbc47dad03dddb1ba5895612fdfa1e43cfb3c497534976cebacd4f3684b505b4";
    };

    # strange setuptools error (can not import semantic.test)
    doCheck = false;

    meta = with pkgs.stdenv.lib; {
      description = "Common Natural Language Processing Tasks for Python";
      homepage = https://github.com/crm416/semantic;
      license = licenses.mit;
    };
  };

  sandboxlib = buildPythonPackage rec {
    name = "sandboxlib-${version}";
    version = "0.31";

    disabled = isPy3k;

    buildInputs = [ self.pbr ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sandboxlib/sandboxlib-0.3.1.tar.gz";
      sha256 = "0csj8hbpylqdkxcpqkcfs73dfvdqkyj23axi8m9drqdi4dhxb41h";
    };

    meta = {
      description = "Sandboxing Library for Python";
      homepage = https://pypi.python.org/pypi/sandboxlib/0.3.1;
      license = licenses.gpl2;
    };
  };

  scales = buildPythonPackage rec {
    name = "scales-${version}";
    version = "1.0.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/scales/${name}.tar.gz";
      sha256 = "8b6930f7d4bf115192290b44c757af5e254e3fcfcb75ff9a51f5c96a404e2753";
    };

    buildInputs = with self; optionals doCheck [ nose ];
    # No tests included
    doCheck = false;

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Stats for Python processes";
      homepage = https://www.github.com/Cue/scales;
      license = licenses.asl20;
    };
  };

  secp256k1 = callPackage ../development/python-modules/secp256k1 {
    inherit (pkgs) secp256k1 pkgconfig;
  };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  sexpdata = buildPythonPackage rec {
    name = "sexpdata-0.0.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sexpdata/${name}.tar.gz";
      sha256 = "eb696bc66b35def5fb356de09481447dff4e9a3ed926823134e1d0f35eade428";
    };

    doCheck = false;

    meta = {
      description = "S-expression parser for Python";
      homepage = "https://github.com/tkf/sexpdata";
    };
  };

  sh = callPackage ../development/python-modules/sh { };

  sipsimple = buildPythonPackage rec {
    name = "sipsimple-${version}";
    version = "3.1.1";
    disabled = isPy3k;

    src = pkgs.fetchdarcs {
      url = http://devel.ag-projects.com/repositories/python-sipsimple;
      rev = "release-${version}";
      sha256 = "0jdilm11f5aahxrzrkxrfx9sgjgkbla1r0wayc5dzd2wmjrdjyrg";
    };

    preConfigure = ''
      chmod +x ./deps/pjsip/configure ./deps/pjsip/aconfigure
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ alsaLib ffmpeg libv4l sqlite libvpx ];
    propagatedBuildInputs = with self; [ cython pkgs.openssl dnspython dateutil xcaplib msrplib lxml python-otr ];

    meta = {
      description = "SIP SIMPLE implementation for Python";
      homepage = http://sipsimpleclient.org/;
      license = licenses.gpl3;
      maintainers = with maintainers; [ pSub ];
    };
  };


  six = callPackage ../development/python-modules/six { };

  smartdc = buildPythonPackage rec {
    name = "smartdc-0.1.12";

    src = pkgs.fetchurl {
      url = mirror://pypi/s/smartdc/smartdc-0.1.12.tar.gz;
      sha256 = "36206f4fddecae080c66faf756712537e650936b879abb23a8c428731d2415fe";
    };

    propagatedBuildInputs = with self; [ requests http_signature ];

    meta = {
      description = "Joyent SmartDataCenter CloudAPI connector using http-signature authentication via Requests";
      homepage = https://github.com/atl/py-smartdc;
      license = licenses.mit;
    };
  };

  socksipy-branch = buildPythonPackage rec {
    name = "SocksiPy-branch-1.01";
    src = pkgs.fetchurl {
      url = mirror://pypi/S/SocksiPy-branch/SocksiPy-branch-1.01.tar.gz;
      sha256 = "01l41v4g7fy9fzvinmjxy6zcbhgqaif8dhdqm4w90fwcw9h51a8p";
    };
    meta = {
      homepage = http://code.google.com/p/socksipy-branch/;
      description = "This Python module allows you to create TCP connections through a SOCKS proxy without any special effort";
      license = licenses.bsd3;
    };
  };

  sockjs-tornado = callPackage ../development/python-modules/sockjs-tornado { };

  sorl_thumbnail = buildPythonPackage rec {
    name = "sorl-thumbnail-11.12";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sorl-thumbnail/${name}.tar.gz";
      sha256 = "050b9kzbx7jvs3qwfxxshhis090hk128maasy8pi5wss6nx5kyw4";
    };

    # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
    doCheck = false;

    meta = {
      homepage = http://sorl-thumbnail.readthedocs.org/en/latest/;
      description = "Thumbnails for Django";
      license = licenses.bsd3;
    };
  };

  supervisor = callPackage ../development/python-modules/supervisor {};

  subprocess32 = callPackage ../development/python-modules/subprocess32 { };

  spark_parser = callPackage ../development/python-modules/spark_parser { };

  sphinx = callPackage ../development/python-modules/sphinx { };

  sphinx_1_2 = self.sphinx.overridePythonAttrs rec {
    name = "sphinx-1.2.3";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinx/sphinx-1.2.3.tar.gz";
      sha256 = "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04";
    };
    postPatch = '''';
    # Tests requires Pygments >=2.0.2 which isn't worth keeping around for this:
    doCheck = false;
  };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  sphinx_rtd_theme = buildPythonPackage (rec {
    name = "sphinx_rtd_theme-0.2.5b2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinx_rtd_theme/${name}.tar.gz";
      sha256 = "0grf16fi4g0p3dfh11b1624ic34iqkjhf5i1g6hvsh4nlm0ll00q";
    };

    meta = {
      description = "ReadTheDocs.org theme for Sphinx";
      homepage = https://github.com/snide/sphinx_rtd_theme/;
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  });

  guzzle_sphinx_theme = callPackage ../development/python-modules/guzzle_sphinx_theme { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex {};

  sphinxcontrib-blockdiag = buildPythonPackage (rec {
    name = "${pname}-${version}";
    pname = "sphinxcontrib-blockdiag";
    version = "1.5.5";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "1w7q2hhpzk159wd35hlbwkh80hnglqa475blcd9vjwpkv1kgkpvw";
    };

    buildInputs = with self; [ mock sphinx-testing ];
    propagatedBuildInputs = with self; [ sphinx blockdiag ];

    # Seems to look for files in the wrong dir
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m unittest discover -s tests
    '';

    meta = {
      description = "Sphinx blockdiag extension";
      homepage = "https://github.com/blockdiag/sphinxcontrib-blockdiag";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.bsd2;
    };
  });

  sphinxcontrib-openapi = buildPythonPackage (rec {
    name = "sphinxcontrib-openapi-0.3.0";

    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-openapi/${name}.tar.gz";
      sha256 = "0fyniq37nnmhrk4j7mzvg6vfcpb624hb9x70g6mccyw4xrnhadv6";
    };

    propagatedBuildInputs = with self; [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];
  });

  sphinxcontrib_httpdomain = buildPythonPackage (rec {
    name = "sphinxcontrib-httpdomain-1.5.0";

    # Check is disabled due to this issue:
    # https://bitbucket.org/pypa/setuptools/issue/137/typeerror-unorderable-types-str-nonetype
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-httpdomain/${name}.tar.gz";
      sha256 = "0srg8lwf4m1hyhz942fcdfxh689xphndngiidb575qmfbi89gc7a";
    };

    propagatedBuildInputs = with self; [sphinx];

    meta = {
      description = "Provides a Sphinx domain for describing RESTful HTTP APIs";

      homepage = https://bitbucket.org/birkenfeld/sphinx-contrib;

      license = "BSD";
    };
  });

  sphinx-navtree = callPackage ../development/python-modules/sphinx-navtree {};

  sphinxcontrib_newsfeed = buildPythonPackage (rec {
    name = "sphinxcontrib-newsfeed-${version}";
    version = "0.1.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-newsfeed/${name}.tar.gz";
      sha256 = "1d7gam3mn8v4in4p16yn3v10vps7nnaz6ilw99j4klij39dqd37p";
    };

    propagatedBuildInputs = with self; [sphinx];

    meta = {
      description = "Extension for adding a simple Blog, News or Announcements section to a Sphinx website";
      homepage = https://bitbucket.org/prometheus/sphinxcontrib-newsfeed;
      license = licenses.bsd2;
    };
  });

  sphinxcontrib_plantuml = buildPythonPackage (rec {
    name = "sphinxcontrib-plantuml-0.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-plantuml/${name}.tar.gz";
      sha256 = "011yprqf41dcm1824zgk2w8vi9115286pmli6apwhlrsxc6b6cwv";
    };

    # No tests included.
    doCheck = false;

    propagatedBuildInputs = with self; [sphinx plantuml];

    meta = {
      description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
      homepage = https://bitbucket.org/birkenfeld/sphinx-contrib;
      license = with licenses; [ bsd2 ];
    };
  });

  sphinxcontrib-spelling = buildPythonPackage (rec {
    name = "${pname}-${version}";
    pname = "sphinxcontrib-spelling";
    version = "2.2.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "1f0fymrk4kvhqs0vj9gay4lhacxkfrlrpj4gvg0p4wjdczplxd3z";
    };
    propagatedBuildInputs = with self; [ sphinx pyenchant pbr ];
    # No tests included
    doCheck = false;
    meta = {
      description = "Sphinx spelling extension";
      homepage = https://bitbucket.org/dhellmann/sphinxcontrib-spelling;
      maintainers = with maintainers; [ nand0p ];
      license = licenses.bsd2;
    };
  });

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  sphinx_pypi_upload = buildPythonPackage (rec {
    name = "Sphinx-PyPI-upload-0.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/Sphinx-PyPI-upload/${name}.tar.gz";
      sha256 = "5f919a47ce7a7e6028dba809de81ae1297ac192347cf6fc54efca919d4865159";
    };

    meta = {
      description = "Setuptools command for uploading Sphinx documentation to PyPI";

      homepage = https://bitbucket.org/jezdez/sphinx-pypi-upload/;

      license = "BSD";
    };
  });

  splinter = callPackage ../development/python-modules/splinter { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  Pweave = buildPythonPackage (rec {
    name = "Pweave-0.25";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/f6/2f/e9735b04747ae5ef29d64e0b215fb0e11f1c89826097ac17342efebbbb84/Pweave-0.25.tar.gz";
      sha256 = "1isqjz66c7vxdaqfwpkspki9p4054dsfx7pznwz28ik634hnj3qw";
    };

    buildInputs = with self; [ mock pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [
      matplotlib
    ];

    # fails due to trying to run CSS as test
    doCheck = false;

    meta = {
      description = "Scientific reports with embedded python computations with reST, LaTeX or markdown";
      homepage = http://mpastell.com/pweave/ ;
      license = licenses.bsd3;
    };
  });

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  SQLAlchemy-ImageAttach = buildPythonPackage rec {
    pname = "SQLAlchemy-ImageAttach";
    version = "1.0.0";
    name = "${pname}-${version}";

    src = pkgs.fetchFromGitHub {
      repo = "sqlalchemy-imageattach";
      owner = "dahlia";
      rev = "${version}";
      sha256 = "0ba97pn5dh00qvxyjbr0mr3pilxqw5kb3a6jd4wwbsfcv6nngqig";
    };

    checkInputs = with self; [ pytest Wand.imagemagick webob ];
    propagatedBuildInputs = with self; [ sqlalchemy Wand ];

    checkPhase = ''
      cd tests
      export MAGICK_HOME="${pkgs.imagemagick.dev}"
      export PYTHONPATH=$PYTHONPATH:../
      py.test
      cd ..
    '';
    doCheck = !isPyPy;  # failures due to sqla version mismatch

    meta = {
      homepage = https://github.com/dahlia/sqlalchemy-imageattach;
      description = "SQLAlchemy extension for attaching images to entity objects";
      license = licenses.mit;
    };
  };

  sqlalchemy_migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  sqlparse = buildPythonPackage rec {
    name = "sqlparse-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sqlparse/${name}.tar.gz";
      sha256 = "08dszglfhf1c4rwqinkbp4x55v0b90rgm1fxc1l4dy965imjjinl";
    };

    buildInputs = with self; [ pytest ];
    checkPhase = ''
      py.test
    '';

    # Package supports 3.x, but tests are clearly 2.x only.
    doCheck = !isPy3k;

    meta = {
      description = "Non-validating SQL parser for Python";
      longDescription = ''
        Provides support for parsing, splitting and formatting SQL statements.
      '';
      homepage = https://github.com/andialbrecht/sqlparse;
      license = licenses.bsd3;
    };
  };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  python_statsd = buildPythonPackage rec {
    name = "python-statsd-${version}";
    version = "1.6.0";
    disabled = isPy3k;  # next release will be py3k compatible

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-statsd/${name}.tar.gz";
      sha256 = "3d2fc153e0d894aa9983531ef47d20d75bd4ee9fd0e46a9d82f452dde58a0a71";
    };

    buildInputs = with self; [ mock nose coverage ];

    meta = {
      description = "A client for Etsy's node-js statsd server";
      homepage = https://github.com/WoLpH/python-statsd;
      license = licenses.bsd3;
    };
  };


  stompclient = buildPythonPackage (rec {
    name = "stompclient-0.3.2";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/stompclient/${name}.tar.gz";
      sha256 = "95a4e98dd0bba348714439ea11a25ee8a74acb8953f95a683924b5bf2a527e4e";
    };

    buildInputs = with self; [ mock nose ];

    # XXX: Ran 0 tests in 0.217s

    meta = {
      description = "Lightweight and extensible STOMP messaging client";
      homepage = https://bitbucket.org/hozn/stompclient;
      license = licenses.asl20;
    };
  });

  subdownloader = buildPythonPackage rec {
    version = "2.0.18";
    name = "subdownloader-${version}";

    src = pkgs.fetchurl {
      url = "https://launchpad.net/subdownloader/trunk/2.0.18/+download/subdownloader_2.0.18.orig.tar.gz";
      sha256 = "0manlfdpb585niw23ibb8n21mindd1bazp0pnxvmdjrp2mnw97ig";
    };

    propagatedBuildInputs = with self; [ mmpython pyqt4 ];

    setup = ''
      import os
      import sys

      try:
          if os.environ.get("NO_SETUPTOOLS"):
              raise ImportError()
          from setuptools import setup, Extension
          SETUPTOOLS = True
      except ImportError:
          SETUPTOOLS = False
          # Use distutils.core as a fallback.
          # We won t be able to build the Wheel file on Windows.
          from distutils.core import setup, Extension

      with open("README") as fp:
          long_description = fp.read()

      requirements = [ ]

      install_options = {
          "name": "subdownloader",
          "version": "2.0.18",
          "description": "Tool for automatic download/upload subtitles for videofiles using fast hashing",
          "long_description": long_description,
          "url": "http://www.subdownloader.net",

          "scripts": ["run.py"],
          "packages": ["cli", "FileManagement", "gui", "languages", "modules"],

      }
      if SETUPTOOLS:
          install_options["install_requires"] = requirements

      setup(**install_options)
    '';

    postUnpack = ''
      echo '${setup}' > $sourceRoot/setup.py
    '';

    meta = {
      description = "Tool for automatic download/upload subtitles for videofiles using fast hashing";
      homepage = http://www.subdownloader.net;
      license = licenses.gpl3;
      maintainers = with maintainers; [ ];
    };
  };

  subunit = buildPythonPackage rec {
    name = pkgs.subunit.name;
    src = pkgs.subunit.src;

    propagatedBuildInputs = with self; [ testtools testscenarios ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.check pkgs.cppunit ];

    patchPhase = ''
      sed -i 's/version=VERSION/version="${pkgs.subunit.version}"/' setup.py
    '';

    meta = pkgs.subunit.meta;
  };

  sure = buildPythonPackage rec {
    name = "sure-${version}";
    version = "1.2.24";

    LC_ALL="en_US.UTF-8";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sure/${name}.tar.gz";
      sha256 = "1lyjq0rvkbv585dppjdq90lbkm6gyvag3wgrggjzyh7cpyh5c12w";
    };

    buildInputs = with self; [ nose pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [ six mock ];

    meta = {
      description = "Utility belt for automated testing";
      homepage = https://falcao.it/sure/;
      license = licenses.gpl3Plus;
    };
  };

  structlog = callPackage ../development/python-modules/structlog { };

  svgwrite = buildPythonPackage rec {
    name = "svgwrite-${version}";
    version = "1.1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/svgwrite/${name}.tar.gz";
      sha256 = "1f018813072aa4d7e95e58f133acb3f68fa7de0a0d89ec9402cc38406a0ec5b8";
    };

    buildInputs = with self; [ setuptools ];
    propagatedBuildInputs = with self; [ pyparsing ];

    meta = {
      description = "A Python library to create SVG drawings";
      homepage = https://bitbucket.org/mozman/svgwrite;
      license = licenses.mit;
    };
  };

  freezegun = buildPythonPackage rec {
    name = "freezegun-${version}";
    version = "0.3.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/freezegun/freezegun-${version}.tar.gz";
      sha256 = "1sf38d3ibv1jhhvr52x7dhrsiyqk1hm165dfv8w8wh0fhmgxg151";
    };

    propagatedBuildInputs = with self; [
      dateutil six
    ];
    buildInputs = [ self.mock self.nose ];

    meta = with stdenv.lib; {
      description = "FreezeGun: Let your Python tests travel through time";
      homepage = "https://github.com/spulec/freezegun";
      license = licenses.asl20;
    };
  };

  sybil = callPackage ../development/python-modules/sybil { };

  # legacy alias
  syncthing-gtk = pkgs.syncthing-gtk;

  systemd = callPackage ../development/python-modules/systemd {
    inherit (pkgs) pkgconfig systemd;
  };

  tabulate = callPackage ../development/python-modules/tabulate { };

  taskw = buildPythonPackage rec {
    version = "1.0.3";
    name = "taskw-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/taskw/${name}.tar.gz";
      sha256 = "1fa7bv5996ppfbryv02lpnlhk5dra63lhlwrb1i4ifqbziqfqh5n";
    };

    patches = [ ../development/python-modules/taskw/use-template-for-taskwarrior-install-path.patch ];
    postPatch = ''
      substituteInPlace taskw/warrior.py \
        --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
    '';

    # https://github.com/ralphbean/taskw/issues/98
    doCheck = false;

    buildInputs = with self; [ nose pkgs.taskwarrior tox ];
    propagatedBuildInputs = with self; [ six dateutil pytz ];

    meta = {
      homepage =  https://github.com/ralphbean/taskw;
      description = "Python bindings for your taskwarrior database";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron ];
    };
  };

  tempita = callPackage ../development/python-modules/tempita { };

  terminado = callPackage ../development/python-modules/terminado { };

  terminaltables = buildPythonPackage rec {
    name = "terminaltables-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/terminaltables/${name}.tar.gz";
      sha256 = "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81";
    };

    meta = {
      description = "Display simple tables in terminals";
      homepage = "https://github.com/Robpol86/terminaltables";
      license = licenses.mit;
    };
  };

  testscenarios = buildPythonPackage rec {
    name = "testscenarios-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/testscenarios/${name}.tar.gz";
      sha256 = "1671jvrvqlmbnc42j7pc5y6vc37q44aiwrq0zic652pxyy2fxvjg";
    };

    propagatedBuildInputs = with self; [ testtools ];

    meta = {
      description = "A pyunit extension for dependency injection";
      homepage = https://pypi.python.org/pypi/testscenarios;
      license = licenses.asl20;
    };
  };

  testpath = buildPythonPackage rec {
    pname = "testpath";
    version = "0.3";
    name = "${pname}-${version}";

    #format = "flit";
    #src = pkgs.fetchFromGitHub {
    #  owner = "jupyter";
    #  repo = pname;
    #  rev = "${version}";
    #  sha256 = "1ghzmkrsrk9xrj42pjsq5gl7v3g2v0ji0xy0xzzxp5aizd3wrvl9";
    #};
    #doCheck = true;
    #checkPhase = ''
    #  ${python.interpreter} -m unittest discover
    #'';
    format = "wheel";
    src = fetchPypi {
      inherit pname version format;
      sha256 = "f16b2cb3b03e1ada4fb0200b265a4446f92f3ba4b9d88ace34f51c54ab6d294e";
    };

    meta = {
      description = "Test utilities for code working with files and commands";
      license = licenses.mit;
      homepage = https://github.com/jupyter/testpath;
    };
  };

  testrepository = buildPythonPackage rec {
    name = "testrepository-${version}";
    version = "0.0.20";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/testrepository/${name}.tar.gz";
      sha256 = "1ssqb07c277010i6gzzkbdd46gd9mrj0bi0i8vn560n2k2y4j93m";
    };

    buildInputs = with self; [ testtools testresources ];
    propagatedBuildInputs = with self; [ pbr subunit fixtures ];

    checkPhase = ''
      ${python.interpreter} ./testr
    '';

    meta = {
      description = "A database of test results which can be used as part of developer workflow";
      homepage = https://pypi.python.org/pypi/testrepository;
      license = licenses.bsd2;
    };
  };

  testresources = callPackage ../development/python-modules/testresources { };

  testtools = callPackage ../development/python-modules/testtools { };

  traitlets = callPackage ../development/python-modules/traitlets { };

  transitions = callPackage ../development/python-modules/transitions { };

  python_mimeparse = buildPythonPackage rec {
    name = "python-mimeparse-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-mimeparse/${name}.tar.gz";
      sha256 = "1hyxg09kaj02ri0rmwjqi86wk4nd1akvv7n0dx77azz76wga4s9w";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
      homepage = https://code.google.com/p/mimeparse/;
      license = licenses.mit;
    };
  };


  extras = callPackage ../development/python-modules/extras { };

  texttable = callPackage ../development/python-modules/texttable { };

  tiros = callPackage ../development/python-modules/tiros { };

  tifffile = callPackage ../development/python-modules/tifffile { };

  # Tkinter/tkinter is part of the Python standard library.
  # The Python interpreters in Nixpkgs come without tkinter by default.
  # To make the module available, we make it available as any other
  # Python package.
  tkinter = let
    py = python.override{x11Support=true;};
  in buildPythonPackage rec {
    name = "tkinter-${python.version}";
    src = py;
    format = "other";

    disabled = isPyPy;

    installPhase = ''
      # Move the tkinter module
      mkdir -p $out/${py.sitePackages}
      mv lib/${py.libPrefix}/lib-dynload/_tkinter* $out/${py.sitePackages}/
    '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
      # Update the rpath to point to python without x11Support
      old_rpath=$(patchelf --print-rpath $out/${py.sitePackages}/_tkinter*)
      new_rpath=$(sed "s#${py}#${python}#g" <<< "$old_rpath" )
      patchelf --set-rpath $new_rpath $out/${py.sitePackages}/_tkinter*
    '';

    meta = py.meta;
  };

  tlslite = buildPythonPackage rec {
    name = "tlslite-${version}";
    version = "0.4.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tlslite/${name}.tar.gz";
      sha256 = "1fxx6d3nw5r1hqna1h2jvqhcygn9fyshlm0gh3gp0b1ji824gd6r";
    };

    meta = {
      description = "A pure Python implementation of SSL and TLS";
      homepage = https://pypi.python.org/pypi/tlslite;
      license = licenses.bsd3;
    };
  };

  qrcode = buildPythonPackage rec {
    name = "qrcode-${version}";
    version = "5.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/qrcode/${name}.tar.gz";
      sha256 = "0kljfrfq0c2rmxf8am57333ia41kd0snbm2rnqbdy816hgpcq5a1";
    };

    propagatedBuildInputs = with self; [ six pillow pymaging_png ];
    checkInputs = [ self.mock ];

    meta = {
      description = "Quick Response code generation for Python";
      homepage = "https://pypi.python.org/pypi/qrcode";
      license = licenses.bsd3;
    };
  };

  tmdb3 = callPackage ../development/python-modules/tmdb3 { };

  toolz = callPackage ../development/python-modules/toolz { };

  tox = callPackage ../development/python-modules/tox { };

  tqdm = callPackage ../development/python-modules/tqdm { };

  smmap = callPackage ../development/python-modules/smmap { };

  smmap2 = callPackage ../development/python-modules/smmap2 { };

  traits = buildPythonPackage rec {
    name = "traits-${version}";
    version = "4.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/traits/${name}.tar.gz";
      sha256 = "0w43qv36wnrimlh0nzzgg81315a18yza3vk494wqxf1l19g390jx";
    };

    # Use pytest because its easier to discover tests
    buildInputs = with self; [ pytest ];
    checkPhase = ''
      py.test $out/${python.sitePackages}
    '';

    # Test suite is broken for 3.x on latest release
    # https://github.com/enthought/traits/issues/187
    # https://github.com/enthought/traits/pull/188
    # Furthermore, some tests fail due to being in a chroot
    doCheck = isPy33;

    propagatedBuildInputs = with self; [ numpy ];

    meta = {
      description = "Explicitly typed attributes for Python";
      homepage = https://pypi.python.org/pypi/traits;
      license = "BSD";
    };
  };


  transaction = callPackage ../development/python-modules/transaction { };


  transmissionrpc = buildPythonPackage rec {
    name = "transmissionrpc-${version}";
    version = "0.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/transmissionrpc/${name}.tar.gz";
      sha256 = "ec43b460f9fde2faedbfa6d663ef495b3fd69df855a135eebe8f8a741c0dde60";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python implementation of the Transmission bittorent client RPC protocol";
      homepage = https://pypi.python.org/pypi/transmissionrpc/;
      license = licenses.mit;
    };
  };

  eggdeps  = buildPythonPackage rec {
     name = "eggdeps-${version}";
     version = "0.4";

     src = pkgs.fetchurl {
       url = "mirror://pypi/t/tl.eggdeps/tl.${name}.tar.gz";
       sha256 = "a99de5e4652865224daab09b2e2574a4f7c1d0d9a267048f9836aa914a2caf3a";
     };

     # tests fail, see http://hydra.nixos.org/build/4316603/log/raw
     doCheck = false;

     propagatedBuildInputs = with self; [ zope_interface zope_testing ];
     meta = {
       description = "A tool which computes a dependency graph between active Python eggs";
       homepage = http://thomas-lotze.de/en/software/eggdeps/;
       license = licenses.zpl20;
     };
   };

  TurboCheetah = callPackage ../development/python-modules/TurboCheetah { };

  tweepy = callPackage ../development/python-modules/tweepy { };

  twiggy = buildPythonPackage rec {
    name = "Twiggy-${version}";
    version = "0.4.5";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/T/Twiggy/Twiggy-0.4.5.tar.gz";
      sha256 = "4e8f1894e5aee522db6cb245ccbfde3c5d1aa08d31330c7e3af783b0e66eec23";
    };

    doCheck = false;

    meta = {
      homepage = http://twiggy.wearpants.org;
      # Taken from http://i.wearpants.org/blog/meet-twiggy/
      description = "Twiggy is the first totally new design for a logger since log4j";
      license     = licenses.bsd3;
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron ];
    };
  };

  twill = callPackage ../development/python-modules/twill { };

  twitter = buildPythonPackage rec {
    name = "twitter-${version}";
    version = "1.15.0";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/t/twitter/${name}.tar.gz";
      sha256 = "1m6b17irb9klc345k8174pni724jzy2973z2x2jg69h83hipjw2c";
    };

    doCheck = false;

    meta = {
      description = "Twitter API library";
      license     = licenses.mit;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  twitter-common-collections = buildPythonPackage rec {
    pname   = "twitter.common.collections";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0wf8ks6y2kalx2inzayq0w4kh3kg25daik1ac7r6y79i03fslsc5";
    };

    propagatedBuildInputs = with self; [ twitter-common-lang ];

    meta = {
      description = "Twitter's common collections";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-confluence = buildPythonPackage rec {
    pname   = "twitter.common.confluence";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1i2fjn23cmms81f1fhvvkg6hgzqpw07dlqg3ydz6cqv2glw7zq26";
    };

    propagatedBuildInputs = with self; [ twitter-common-log ];

    meta = {
      description = "Twitter's API to the confluence wiki";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-dirutil = buildPythonPackage rec {
    pname   = "twitter.common.dirutil";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1wpjfmmxsdwnbx5dl13is4zkkpfcm94ksbzas9y2qhgswfa9jqha";
    };

    propagatedBuildInputs = with self; [ twitter-common-lang ];

    meta = {
      description = "Utilities for manipulating and finding files and directories";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-lang = buildPythonPackage rec {
    pname   = "twitter.common.lang";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1l8fmnsrx7hgg3ivslg588rnl9n1gfjn2w6224fr8rs7zmkd5lan";
    };

    meta = {
      description = "Twitter's 2.x / 3.x compatibility swiss-army knife";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-log = buildPythonPackage rec {
    pname   = "twitter.common.log";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1bdzbxx2bxwpf57xaxfz1nblzgfvhlidz8xqd7s84c62r3prh02v";
    };

    propagatedBuildInputs = with self; [ twitter-common-options twitter-common-dirutil ];

    meta = {
      description = "Twitter's common logging library";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-options = buildPythonPackage rec {
    pname   = "twitter.common.options";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0d1czag5mcxg0vcnlklspl2dvdab9kmznsycj04d3vggi158ljrd";
    };

    meta = {
      description = "Twitter's optparse wrapper";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twine = callPackage ../development/python-modules/twine { };

  twisted = callPackage ../development/python-modules/twisted { };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  ua-parser = callPackage ../development/python-modules/ua-parser { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  umalqurra = buildPythonPackage rec {
    name = "umalqurra-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/umalqurra/umalqurra-0.2.tar.gz";
      sha256 = "719f6a36f908ada1c29dae0d934dd0f1e1f6e3305784edbec23ad719397de678";
    };

    # No tests included
    doCheck = false;

    # See for license
    # https://github.com/tytkal/python-hijiri-ummalqura/issues/4
    meta = {
      description = "Date Api that support Hijri Umalqurra calendar";
      homepage = https://github.com/tytkal/python-hijiri-ummalqura;
      license = with licenses; [ publicDomain ];
    };

  };

  umemcache = callPackage ../development/python-modules/umemcache {};

  unicodecsv = buildPythonPackage rec {
    version = "0.14.1";
    name = "unicodecsv-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/unicodecsv/${name}.tar.gz";
      sha256 = "1z7pdwkr6lpsa7xbyvaly7pq3akflbnz8gq62829lr28gl1hi301";
    };

    # ImportError: No module named runtests
    doCheck = false;

    meta = {
      description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
      homepage = https://github.com/jdunck/python-unicodecsv;
      maintainers = with maintainers; [ koral ];
    };
  };

  unittest2 = buildPythonPackage rec {
    version = "1.1.0";
    name = "unittest2-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/unittest2/unittest2-${version}.tar.gz";
      sha256 = "0y855kmx7a8rnf81d3lh5lyxai1908xjp0laf4glwa4c8472m212";
    };

    # # 1.0.0 and up create a circle dependency with traceback2/pbr
    doCheck = false;

    postPatch = ''
      # argparse is needed for python < 2.7, which we do not support anymore.
      substituteInPlace setup.py --replace "argparse" ""

      # # fixes a transient error when collecting tests, see https://bugs.launchpad.net/python-neutronclient/+bug/1508547
      sed -i '510i\        return None, False' unittest2/loader.py
      # https://github.com/pypa/packaging/pull/36
      sed -i 's/version=VERSION/version=str(VERSION)/' setup.py
    '';

    propagatedBuildInputs = with self; [ six traceback2 ];

    meta = {
      description = "A backport of the new features added to the unittest testing framework";
      homepage = https://pypi.python.org/pypi/unittest2;
    };
  };

    unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

    uritemplate_py = buildPythonPackage rec {
    name = "uritemplate.py-${version}";
    version = "3.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/uritemplate.py/${name}.tar.gz";
      sha256 = "1k5zvc5fyyrgv33mi3p86a9jn5n0pqffs9cviz92fw6q1kf7zvmr";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/uri-templates/uritemplate-py;
      description = "Python implementation of URI Template";
      license = licenses.asl20;
      maintainers = with maintainers; [ pSub ];
    };
  };

  uritools = callPackage ../development/python-modules/uritools { };

  traceback2 = buildPythonPackage rec {
    version = "1.4.0";
    name = "traceback2-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/traceback2/traceback2-${version}.tar.gz";
      sha256 = "0c1h3jas1jp1fdbn9z2mrgn3jj0hw1x3yhnkxp7jw34q15xcdb05";
    };

    propagatedBuildInputs = with self; [ pbr linecache2 ];
    # circular dependencies for tests
    doCheck = false;

    meta = {
      description = "A backport of traceback to older supported Pythons";
      homepage = https://pypi.python.org/pypi/traceback2/;
    };
  };

  linecache2 = buildPythonPackage rec {
    name = "linecache2-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/linecache2/${name}.tar.gz";
      sha256 = "0z79g3ds5wk2lvnqw0y2jpakjf32h95bd9zmnvp7dnqhf57gy9jb";
    };

    buildInputs = with self; [ pbr ];
    # circular dependencies for tests
    doCheck = false;

    meta = with stdenv.lib; {
      description = "A backport of linecache to older supported Pythons";
      homepage = "https://github.com/testing-cabal/linecache2";
    };
  };

  upass = buildPythonPackage rec {
    version = "0.1.4";
    name = "upass-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/Kwpolska/upass/archive/v${version}.tar.gz";
      sha256 = "0f2lyi7xhvb60pvzx82dpc13ksdj5k92ww09czclkdz8k0dxa7hb";
    };

    propagatedBuildInputs = with self; [
      pyperclip
      urwid
    ];

    doCheck = false;

    meta = {
      description = "Console UI for pass";
      homepage = https://github.com/Kwpolska/upass;
      license = licenses.bsd3;
    };
  };

  update_checker = callPackage ../development/python-modules/update_checker {};

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uproot = callPackage ../development/python-modules/uproot {};

  uproot-methods = callPackage ../development/python-modules/uproot-methods { };

  uptime = buildPythonPackage rec {
    name = "uptime-${version}";
    version = "3.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/uptime/${name}.tar.gz";
      sha256 = "0wr9jkixprlywz0plyn5p42a5fd31aiwvjrxdvj7r02vfxa04c3w";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/Cairnarvon/uptime;
      description = "Cross-platform way to retrieve system uptime and boot time";
      license = licenses.bsd2;
      maintainers = with maintainers; [ rob ];
    };
  };

  urlgrabber = callPackage ../development/python-modules/urlgrabber {};

  urwid = callPackage ../development/python-modules/urwid {};

  urwidtrees = buildPythonPackage rec {
    name = "urwidtrees-${rev}";
    rev = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "pazz";
      repo = "urwidtrees";
      inherit rev;
      sha256 = "03gpcdi45z2idy1fd9zv8v9naivmpfx65hshm8r984k9wklv1dsa";
    };

    propagatedBuildInputs = with self; [ urwid ];

    meta = {
      description = "Tree widgets for urwid";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ];
    };
  };

  user-agents = callPackage ../development/python-modules/user-agents { };

  pyuv = buildPythonPackage rec {
    name = "pyuv-1.2.0";
    disabled = isPyPy;  # see https://github.com/saghul/pyuv/issues/49

    src = pkgs.fetchurl {
      url = "https://github.com/saghul/pyuv/archive/${name}.tar.gz";
      sha256 = "19yl1l5l6dq1xr8xcv6dhx1avm350nr4v2358iggcx4ma631rycx";
    };

    patches = [ ../development/python-modules/pyuv-external-libuv.patch ];

    buildInputs = with self; [ pkgs.libuv ];

    meta = {
      description = "Python interface for libuv";
      homepage = https://github.com/saghul/pyuv;
      repositories.git = git://github.com/saghul/pyuv.git;
      license = licenses.mit;
    };
  };

  vega_datasets = callPackage ../development/python-modules/vega_datasets { };

  virtkey = callPackage ../development/python-modules/virtkey { };

  virtual-display = callPackage ../development/python-modules/virtual-display { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  virtualenv-clone = buildPythonPackage rec {
    name = "virtualenv-clone-0.2.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/virtualenv-clone/${name}.tar.gz";
      sha256 = "7087ba4eb48acfd5209a3fd03e15d072f28742619127c98333057e32748d91c4";
    };

    buildInputs = with self; [pytest];
    propagatedBuildInputs = with self; [virtualenv];

    # needs tox to run the tests
    doCheck = false;

    meta = {
      description = "Script to clone virtualenvs";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  virtualenvwrapper = buildPythonPackage (rec {
    name = "virtualenvwrapper-4.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/virtualenvwrapper/${name}.tar.gz";
      sha256 = "514cbc22218347bf7b54bdbe49e1a5f550d2d53b1ad2491c10e91ddf48fb528f";
    };

    # pip depend on $HOME setting
    preConfigure = "export HOME=$TMPDIR";

    buildInputs = with self; [ pbr pip pkgs.which ];
    propagatedBuildInputs = with self; [
      stevedore
      virtualenv
      virtualenv-clone
    ];

    postPatch = ''
      for file in "virtualenvwrapper.sh" "virtualenvwrapper_lazy.sh"; do
        substituteInPlace "$file" --replace "which" "${pkgs.which}/bin/which"

        # We can't set PYTHONPATH in a normal way (like exporting in a wrapper
        # script) because the user has to evaluate the script and we don't want
        # modify the global PYTHONPATH which would affect the user's
        # environment.
        # Furthermore it isn't possible to just use VIRTUALENVWRAPPER_PYTHON
        # for this workaround, because this variable is well quoted inside the
        # shell script.
        # (the trailing " -" is required to only replace things like these one:
        # "$VIRTUALENVWRAPPER_PYTHON" -c "import os,[...] and not in
        # if-statements or anything like that.
        # ...and yes, this "patch" is hacky :)
        substituteInPlace "$file" --replace '"$VIRTUALENVWRAPPER_PYTHON" -' 'env PYTHONPATH="$VIRTUALENVWRAPPER_PYTHONPATH" "$VIRTUALENVWRAPPER_PYTHON" -'
      done
    '';

    postInstall = ''
      # This might look like a dirty hack but we can't use the makeWrapper function because
      # the wrapped file were then called via "exec". The virtualenvwrapper shell scripts
      # aren't normal executables. Instead, the user has to evaluate them.

      for file in "virtualenvwrapper.sh" "virtualenvwrapper_lazy.sh"; do
        local wrapper="$out/bin/$file"
        local wrapped="$out/bin/.$file-wrapped"
        mv "$wrapper" "$wrapped"

        # WARNING: Don't indent the lines below because that would break EOF
        cat > "$wrapper" << EOF
export PATH="${python}/bin:\$PATH"
export VIRTUALENVWRAPPER_PYTHONPATH="$PYTHONPATH:$(toPythonPath $out)"
source "$wrapped"
EOF

        chmod -x "$wrapped"
        chmod +x "$wrapper"
      done
    '';

    meta = {
      description = "Enhancements to virtualenv";
      homepage = "https://pypi.python.org/pypi/virtualenvwrapper";
      license = licenses.mit;
    };
  });

  vmprof = buildPythonPackage rec {
    version = "0.3.3";
    name = "vmprof-${version}";

    # Url using old scheme doesn't seem to work
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/c3/f3/f039ca77e727c5c2d3e61967a2a5c9ecc0ef6ca235012fd5559febb77cd0/vmprof-0.3.3.tar.gz";
      sha256 = "991bc2f1dc824c63e9b399f9e8606deded92a52378d0e449f258807d7556b039";
    };

    propagatedBuildInputs = with self; [ requests six];

    # No tests included
    doCheck = false;

    meta = {
      description = "A vmprof client";
      license = licenses.mit;
      homepage = https://vmprof.readthedocs.org/;
    };

  };

  vultr = buildPythonPackage rec {
    version = "0.1.2";
    name = "vultr-${version}";

    src = pkgs.fetchFromGitHub {
        owner = "spry-group";
        repo = "python-vultr";
        rev = "${version}";
        sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
    };

    propagatedBuildInputs = with self; [ requests ];

    # Tests disabled. They fail because they try to access the network
    doCheck = false;

    meta = {
      description = "Vultr.com API Client";
      homepage = "https://github.com/spry-group/python-vultr";
      license = licenses.mit;
      maintainers = with maintainers; [ lihop ];
      platforms = platforms.all;
    };
  };

  waitress = buildPythonPackage rec {
    name = "waitress-1.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/waitress/${name}.tar.gz";
      sha256 = "0pw6yyxi348r2xpq3ykqnf7gwi881azv2422d2ixb0xi5jws2ky7";
    };

    doCheck = false;

    meta = {
       maintainers = with maintainers; [ garbas domenkozar ];
       platforms = platforms.all;
    };
  };

  waitress-django = callPackage ../development/python-modules/waitress-django { };

  webassets = callPackage ../development/python-modules/webassets { };

  webcolors = callPackage ../development/python-modules/webcolors { };

  webencodings = callPackage ../development/python-modules/webencodings { };

  websockets = callPackage ../development/python-modules/websockets { };

  Wand = callPackage ../development/python-modules/Wand {
    imagemagick = pkgs.imagemagickBig;
  };

  wcwidth = callPackage ../development/python-modules/wcwidth { };

  web = buildPythonPackage rec {
    version = "0.37";
    name = "web.py-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/web.py/web.py-${version}.tar.gz";
      sha256 = "748c7e99ad9e36f62ea19f7965eb7dd7860b530e8f563ed60ce3e53e7409a550";
    };

    meta = {
      description = "Makes web apps";
      longDescription = ''
        Think about the ideal way to write a web app.
        Write the code to make it happen.
      '';
      homepage = "http://webpy.org/";
      license = licenses.publicDomain;
      maintainers = with maintainers; [ layus ];
    };
  };

  webob = buildPythonPackage rec {
    pname = "WebOb";
    version = "1.7.3";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "10vjp2rvqiyvw157fk3sy7yds1gknzw97z4gk0qv1raskx5s2p76";
    };

    propagatedBuildInputs = with self; [ nose pytest ];

    meta = {
      description = "WSGI request and response object";
      homepage = http://pythonpaste.org/webob/;
      platforms = platforms.all;
    };
  };


  websockify = buildPythonPackage rec {
    version = "0.7.0";
    name = "websockify-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/websockify/websockify-${version}.tar.gz";
      sha256 = "1v6pmamjprv2x55fvbdaml26ppxdw8v6xz8p0sav3368ajwwgcqc";
    };

    propagatedBuildInputs = with self; [ numpy ];

    meta = {
      description = "WebSockets support for any application/server";
      homepage = https://github.com/kanaka/websockify;
    };
  };


  webtest = buildPythonPackage rec {
    version = "2.0.20";
    name = "webtest-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WebTest/WebTest-${version}.tar.gz";
      sha256 = "0bv0qhdjakdsdgj4sk21gnpp8xp8bga4x03p6gjb83ihrsb7n4xv";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace "nose<1.3.0" "nose"
    '';

    propagatedBuildInputs = with self; [
      nose
      webob
      six
      beautifulsoup4
      waitress
      mock
      pyquery
      wsgiproxy2
      PasteDeploy
      coverage
    ];

    meta = {
      description = "Helper to test WSGI applications";
      homepage = http://webtest.readthedocs.org/en/latest/;
      platforms = platforms.all;
    };
  };

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  wheel = callPackage ../development/python-modules/wheel { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  wordfreq = callPackage ../development/python-modules/wordfreq { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  magic-wormhole-transit-relay = callPackage ../development/python-modules/magic-wormhole-transit-relay { };

  wsgiproxy2 = buildPythonPackage rec {
    name = "WSGIProxy2-0.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WSGIProxy2/${name}.zip";
      sha256 = "13kf9bdxrc95y9vriaz0viry3ah11nz4rlrykcfvb8nlqpx3dcm4";
    };

    # circular dep on webtest
    doCheck = false;
    propagatedBuildInputs = with self; [ six webob ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
    };
  };

  wxPython = self.wxPython30;

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
  };

  xcaplib = buildPythonPackage rec {
    pname = "python-xcaplib";
    name = "${pname}-${version}";
    version = "1.2.0";
    disabled = isPy3k;

    src = pkgs.fetchdarcs {
      url = "http://devel.ag-projects.com/repositories/${pname}";
      rev = "release-${version}";
      sha256 = "0vna5r4ihv7z1yx6r93954jqskcxky77znzy1m9dg9vna1dgwfdn";
    };

    propagatedBuildInputs = with self; [ eventlib application ];
  };

  xlib = buildPythonPackage (rec {
    name = "xlib-${version}";
    version = "0.17";

    src = pkgs.fetchFromGitHub {
      owner = "python-xlib";
      repo = "python-xlib";
      rev = "${version}";
      sha256 = "1iiz2nq2hq9x6laavngvfngnmxbgnwh54wdbq6ncx4va7v98liyi";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = with self; [ six setuptools_scm pkgs.xorg.libX11 ];

    meta = {
      description = "Fully functional X client library for Python programs";

      homepage = http://python-xlib.sourceforge.net/;

      license = licenses.gpl2Plus;
    };
  });

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xarray = callPackage ../development/python-modules/xarray { };

  xlwt = callPackage ../development/python-modules/xlwt { };

  youtube-dl = callPackage ../tools/misc/youtube-dl {};

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
    phantomjsSupport = false;
  };

  zbase32 = buildPythonPackage (rec {
    name = "zbase32-1.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zbase32/${name}.tar.gz";
      sha256 = "2f44b338f750bd37b56e7887591bf2f1965bfa79f163b6afcbccf28da642ec56";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = with self; [ setuptoolsDarcs ];

    meta = {
      description = "zbase32, a base32 encoder/decoder";
      homepage = https://pypi.python.org/pypi/zbase32;
      license = "BSD";
    };
  });


  zconfig = callPackage ../development/python-modules/zconfig { };


  zc_lockfile = callPackage ../development/python-modules/zc_lockfile { };

  zdaemon = buildPythonPackage rec {
    name = "zdaemon-${version}";
    version = "4.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zdaemon/${name}.tar.gz";
      sha256 = "82d7eaa4d831ff1ecdcffcb274f3457e095c0cc86e630bc72009a863c341ab9f";
    };

    propagatedBuildInputs = [ self.zconfig ];

    # too many deps..
    doCheck = false;

    meta = {
      description = "A daemon process control library and tools for Unix-based systems";
      homepage = https://pypi.python.org/pypi/zdaemon;
      license = licenses.zpl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zfec = buildPythonPackage (rec {
    name = "zfec-1.4.24";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zfec/${name}.tar.gz";
      sha256 = "1ks94zlpy7n8sb8380gf90gx85qy0p9073wi1wngg6mccxp9xsg3";
    };

    buildInputs = with self; [ setuptoolsDarcs ];
    propagatedBuildInputs = with self; [ pyutil argparse ];

    meta = {
      homepage = http://allmydata.org/trac/zfec;

      description = "Zfec, a fast erasure codec which can be used with the command-line, C, Python, or Haskell";

      longDescription = ''
        Fast, portable, programmable erasure coding a.k.a. "forward
        error correction": the generation of redundant blocks of
        information such that if some blocks are lost then the
        original data can be recovered from the remaining blocks. The
        zfec package includes command-line tools, C API, Python API,
        and Haskell API.
      '';

      license = licenses.gpl2Plus;
    };
  });

  zipstream = callPackage ../development/python-modules/zipstream { };

  zodb = callPackage ../development/python-modules/zodb {};

  zodbpickle = callPackage ../development/python-modules/zodbpickle {};

  BTrees = callPackage ../development/python-modules/btrees {};

  persistent = callPackage ../development/python-modules/persistent {};

  xdot = callPackage ../development/python-modules/xdot { };

  zetup = callPackage ../development/python-modules/zetup { };

  zope_broken = buildPythonPackage rec {
    name = "zope.broken-3.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.broken/${name}.zip";
      sha256 = "b9b8776002da4f7b6b12dfcce77eb642ae62b39586dbf60e1d9bdc992c9f2999";
    };

    buildInputs = with self; [ zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_component = buildPythonPackage rec {
    name = "zope.component-4.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.component/zope.component-4.2.1.tar.gz";
      sha256 = "1gzbr0j6c2h0cqnpi2cjss38wrz1bcwx8xahl3vykgz5laid15l6";
    };

    propagatedBuildInputs = with self; [
      zope_configuration zope_event zope_i18nmessageid zope_interface
      zope_testing
    ];

    # ignore tests because of a circular dependency on zope_security
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_configuration = buildPythonPackage rec {
    name = "zope.configuration-4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.configuration/zope.configuration-4.0.3.tar.gz";
      sha256 = "1x9dfqypgympnlm25p9m43xh4qv3p7d75vksv9pzqibrb4cggw5n";
    };

    propagatedBuildInputs = with self; [ zope_i18nmessageid zope_schema ];

    # Trouble with implicit namespace packages on Python3
    # see https://github.com/pypa/setuptools/issues/912
    doCheck = !isPy3k;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_contenttype = buildPythonPackage rec {
    name = "zope.contenttype-4.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.contenttype/${name}.tar.gz";
      sha256 = "9decc7531ad6925057f1a667ac0ef9d658577a92b0b48dafa7daa97b78a02bbb";
    };

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_dottedname = buildPythonPackage rec {
    name = "zope.dottedname-3.4.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.dottedname/${name}.tar.gz";
      sha256 = "331d801d98e539fa6c5d50c3835ecc144c429667f483281505de53fc771e6bf5";
    };
    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_event = buildPythonPackage rec {
    name = "zope.event-${version}";
    version = "4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.event/${name}.tar.gz";
      sha256 = "1w858k9kmgzfj36h65kp27m9slrmykvi5cjq6c119xqnaz5gdzgm";
    };

    meta = {
      description = "An event publishing system";
      homepage = https://pypi.python.org/pypi/zope.event;
      license = licenses.zpl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_exceptions = buildPythonPackage rec {
     name = "zope.exceptions-${version}";
     version = "4.0.8";

     src = pkgs.fetchurl {
       url = "mirror://pypi/z/zope.exceptions/${name}.tar.gz";
       sha256 = "0zwxaaa66sqxg5k7zcrvs0fbg9ym1njnxnr28dfmchzhwjvwnfzl";
     };

     propagatedBuildInputs = with self; [ zope_interface ];

     # circular deps
     doCheck = false;

     meta = {
       description = "Exception interfaces and implementations";
       homepage = https://pypi.python.org/pypi/zope.exceptions;
       license = licenses.zpl20;
       maintainers = with maintainers; [ goibhniu ];
     };
   };


  zope_filerepresentation = buildPythonPackage rec {
    name = "zope.filerepresentation-3.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.filerepresentation/${name}.tar.gz";
      sha256 = "d775ebba4aff7687e0381f050ebda4e48ce50900c1438f3f7e901220634ed3e0";
    };

    propagatedBuildInputs = with self; [ zope_schema ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_i18n = buildPythonPackage rec {
    name = "zope.i18n-3.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.i18n/${name}.tar.gz";
      sha256 = "045nnimmshibcq71yym2d8yrs6wzzhxq5gl7wxjnkpyjm5y0hfkm";
    };

    propagatedBuildInputs = with self; [ pytz zope_component ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_i18nmessageid = buildPythonPackage rec {
    name = "zope.i18nmessageid-4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.i18nmessageid/zope.i18nmessageid-4.0.3.tar.gz";
      sha256 = "1rslyph0klk58dmjjy4j0jxy21k03azksixc3x2xhqbkv97cmzml";
    };

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_lifecycleevent = buildPythonPackage rec {
    name = "zope.lifecycleevent-3.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.lifecycleevent/${name}.tar.gz";
      sha256 = "0s5brphqzzz89cykg61gy7zcmz0ryq1jj2va7gh2n1b3cccllp95";
    };

    propagatedBuildInputs = with self; [ zope_event zope_component ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_location = buildPythonPackage rec {
    name = "zope.location-4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.location/zope.location-4.0.3.tar.gz";
      sha256 = "1nj9da4ksiyv3h8n2vpzwd0pb03mdsh7zy87hfpx72b6p2zcwg74";
    };

    propagatedBuildInputs = with self; [ zope_proxy ];

    # ignore circular dependency on zope_schema
    preBuild = ''
      sed -i '/zope.schema/d' setup.py
    '';

    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_proxy = buildPythonPackage rec {
    name = "zope.proxy-4.1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.proxy/${name}.tar.gz";
      sha256 = "0pqwwmvm1prhwv1ziv9lp8iirz7xkwb6n2kyj36p2h0ppyyhjnm4";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    # circular deps
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_schema = buildPythonPackage rec {
    name = "zope.schema-4.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.schema/${name}.tar.gz";
      sha256 = "1p943jdxb587dh7php4vx04qvn7b2877hr4qs5zyckvp5afhhank";
    };

    propagatedBuildInputs = with self; [ zope_location zope_event zope_interface zope_testing ];

    # ImportError: No module named 'zope.event'
    # even though zope_event has been included.
    # Package seems to work fine.
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_size = buildPythonPackage rec {
    name = "zope.size-3.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.size/${name}.tar.gz";
      sha256 = "006xfkhvmypwd3ww9gbba4zly7n9w30bpp1h74d53la7l7fiqk2f";
    };

    propagatedBuildInputs = with self; [ zope_i18nmessageid zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_testing = buildPythonPackage rec {
    name = "zope.testing-${version}";
    version = "4.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.testing/${name}.tar.gz";
      sha256 = "1vvxhjmzl7vw2i1akfj1xbggwn36270ym7f2ic9xwbaswfw1ap56";
    };

    doCheck = !isPyPy;

    propagatedBuildInputs = with self; [ zope_interface zope_exceptions zope_location ];

    meta = {
      description = "Zope testing helpers";
      homepage =  http://pypi.python.org/pypi/zope.testing;
      license = licenses.zpl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_testrunner = callPackage ../development/python-modules/zope_testrunner { };


  zope_interface = callPackage ../development/python-modules/zope_interface { };


  hgsvn = buildPythonPackage rec {
    name = "hgsvn-0.3.11";
    src = pkgs.fetchurl rec {
      url = "mirror://pypi/h/hgsvn/${name}-hotfix.zip";
      sha256 = "0yvhwdh8xx8rvaqd3pnnyb99hfa0zjdciadlc933p27hp9rf880p";
    };
    disabled = isPy3k || isPyPy;
    doCheck = false;  # too many assumptions

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ hglib ];

    meta = {
      homepage = https://pypi.python.org/pypi/hgsvn;
    };
  };

  cliapp = buildPythonPackage rec {
    name = "cliapp-${version}";
    version = "1.20150305";
    disabled = isPy3k;

    src = pkgs.fetchgit {
        url = "http://git.liw.fi/cgi-bin/cgit/cgit.cgi/cliapp";
        rev = "569df8a5959cd8ef46f78c9497461240a5aa1123";
        sha256 = "882c5daf933e4cf089842995efc721e54361d98f64e0a075e7373b734cd899f3";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/cliapp/;
      description = "Python framework for Unix command line programs";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  cmdtest = buildPythonPackage rec {
    name = "cmdtest-${version}";
    version = "0.18";
    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ cliapp ttystatus markdown ];

    # TODO: cmdtest tests must be run before the buildPhase
    doCheck = false;

    src = pkgs.fetchurl {
      url = "http://code.liw.fi/debian/pool/main/c/cmdtest/cmdtest_0.18.orig.tar.xz";
      sha256 = "068f24k8ad520hcf8g3gj7wvq1wspyd46ay0k9xa360jlb4dv2mn";
    };

    meta = {
      homepage = http://liw.fi/cmdtest/;
      description = "Black box tests Unix command line tools";
    };
  };

  tornado = callPackage ../development/python-modules/tornado { };
  tornado_4 = callPackage ../development/python-modules/tornado { version = "4.5.3"; };

  tokenlib = buildPythonPackage rec {
    name = "tokenlib-${version}";
    version = "0.3.1";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/tokenlib.git;
      rev = "refs/tags/${version}";
      sha256 = "0bq6dqyfwh29pg8ngmrm4mx4q27an9lsj0p9l79p9snn4g2rxzc8";
    };

    propagatedBuildInputs = with self; [ requests webob ];
  };

  tunigo = callPackage ../development/python-modules/tunigo { };

  tarman = buildPythonPackage rec {
    version = "0.1.3";
    name = "tarman-${version}";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tarman/tarman-${version}.zip";
      sha256 = "0ri6gj883k042xaxa2d5ymmhbw2bfcxdzhh4bz7700ibxwxxj62h";
    };

    buildInputs = with self; [ unittest2 nose mock ];
    propagatedBuildInputs = with self; [ libarchive ];

    # tests are still failing
    doCheck = false;
  };


  libarchive = self.python-libarchive; # The latter is the name upstream uses
  python-libarchive = buildPythonPackage rec {
    version = "3.1.2-1";
    name = "libarchive-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://python-libarchive.googlecode.com/files/python-libarchive-${version}.tar.gz";
      sha256 = "0j4ibc4mvq64ljya9max8832jafi04jciff9ia9qy0xhhlwkcx8x";
    };

    propagatedBuildInputs = with self; [ pkgs.libarchive.lib ];
    meta.broken = true;
  };

  libarchive-c = buildPythonPackage rec {
    name = "libarchive-c-${version}";
    version = "2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/libarchive-c/${name}.tar.gz";
      sha256 = "011bfsmqpcwd6920kckllh7zhw2y4rrasgmddb7wjzn2hg1xpsjn";
    };

    LC_ALL="en_US.UTF-8";

    postPatch = ''
      substituteInPlace libarchive/ffi.py --replace \
        "find_library('archive')" "'${pkgs.libarchive.lib}/lib/libarchive.so'"
    '';
    checkPhase = ''
      py.test tests -k 'not test_check_archiveentry_with_unicode_entries_and_name_zip and not test_check_archiveentry_using_python_testtar'
    '';

    buildInputs = with self; [ pytest pkgs.glibcLocales ];
  };

  libasyncns = callPackage ../development/python-modules/libasyncns {
    inherit (pkgs) libasyncns pkgconfig;
  };

  libarcus = callPackage ../development/python-modules/libarcus { };

  pybrowserid = callPackage ../development/python-modules/pybrowserid { };

  pyzmq = callPackage ../development/python-modules/pyzmq { };

  testfixtures = callPackage ../development/python-modules/testfixtures {};

  tissue = buildPythonPackage rec {
    name = "tissue-0.9.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tissue/${name}.tar.gz";
      sha256 = "7e34726c3ec8fae358a7faf62de172db15716f5582e5192a109e33348bd76c2e";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pep8 ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  titlecase = callPackage ../development/python-modules/titlecase { };

  tracing = buildPythonPackage rec {
    name = "tracing-${version}";
    version = "0.8";

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-tracing/python-tracing_${version}.orig.tar.gz";
      sha256 = "1l4ybj5rvrrcxf8csyq7qx52izybd502pmx70zxp46gxqm60d2l0";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/tracing/;
      description = "Python debug logging helper";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  translationstring = buildPythonPackage rec {
    name = "translationstring-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/translationstring/${name}.tar.gz";
      sha256 = "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d";
    };

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };


  ttystatus = buildPythonPackage rec {
    name = "ttystatus-${version}";
    version = "0.23";
    disabled = isPy3k;

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-ttystatus/python-ttystatus_${version}.orig.tar.gz";
      sha256 = "0ymimviyjyh2iizqilg88g4p26f5vpq1zm3cvg7dr7q4y3gmik8y";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/ttystatus/;
      description = "Progress and status updates on terminals for Python";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  larch = buildPythonPackage rec {
    name = "larch-${version}";
    version = "1.20131130";

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-larch/python-larch_${version}.orig.tar.gz";
      sha256 = "1hfanp9l6yc5348i3f5sb8c5s4r43y382hflnbl6cnz4pm8yh5r7";
    };

    buildInputs = with self; [ sphinx ];
    propagatedBuildInputs = with self; [ tracing ttystatus cliapp ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/larch/;
      description = "Python B-tree library";
      maintainers = with maintainers; [ rickynils ];
    };
  };


  websocket_client = callPackage ../development/python-modules/websockets_client { };


  webhelpers = buildPythonPackage rec {
    name = "WebHelpers-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WebHelpers/${name}.tar.gz";
      sha256 = "ea86f284e929366b77424ba9a89341f43ae8dee3cbeb8702f73bcf86058aa583";
    };

    buildInputs = with self; [ routes markupsafe webob nose ];

    # TODO: failing tests https://bitbucket.org/bbangert/webhelpers/pull-request/1/fix-error-on-webob-123/diff
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  whichcraft = callPackage ../development/python-modules/whichcraft { };

  whisper = callPackage ../development/python-modules/whisper { };

  worldengine = buildPythonPackage rec {
    name = "worldengine-${version}";
    version = "0.19.0";

    src = pkgs.fetchFromGitHub {
      owner = "Mindwerks";
      repo = "worldengine";
      rev = "v${version}";
      sha256 = "1xrckb0dn2841gvp32n18gib14bpi77hmjw3r9jiyhg402iip7ry";
    };

    src-data = pkgs.fetchFromGitHub {
      owner = "Mindwerks";
      repo = "worldengine-data";
      rev = "029051e";
      sha256 = "06xbf8gj3ljgr11v1n8jbs2q8pdf9wz53xdgkhpm8hdnjahgdxdm";
    };

    postUnpack = ''
      ln -s ${src-data} worldengine-data
    '';

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ noise numpy pyplatec protobuf purepng argparse h5py gdal ];

    prePatch = ''
      substituteInPlace setup.py \
        --replace pypng>=0.0.18 purepng \
        --replace 'numpy>=1.9.2, <= 1.10.0.post2' 'numpy' \
        --replace 'argparse==1.2.1' "" \
        --replace 'protobuf==3.0.0a3' 'protobuf' \
        --replace 'noise==1.2.2' 'noise' \
        --replace 'PyPlatec==1.4.0' 'PyPlatec' \
    '';

    doCheck = true;
    postCheck = ''
      nosetests tests
    '';

    meta = {
      homepage = http://world-engine.org;
      description = "World generator using simulation of plates, rain shadow, erosion, etc";
      platforms = platforms.all;
      maintainers = with maintainers; [ rardiol ];
    };
  };

  carbon = callPackage ../development/python-modules/carbon { };

  ujson = buildPythonPackage rec {
    name = "ujson-1.35";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/ujson/${name}.tar.gz";
      sha256 = "11jz5wi7mbgqcsz52iqhpyykiaasila4lq8cmc2d54bfa3jp6q7n";
    };

    meta = {
      homepage = https://pypi.python.org/pypi/ujson;
      description = "Ultra fast JSON encoder and decoder for Python";
      license = licenses.bsd3;
    };
  };


  unidecode = callPackage ../development/python-modules/unidecode {};

  pyusb = callPackage ../development/python-modules/pyusb { libusb1 = pkgs.libusb1; };

  BlinkStick = callPackage ../development/python-modules/blinkstick { };

  usbtmc = callPackage ../development/python-modules/usbtmc {};

  txgithub = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "txgithub";
    version = "15.0.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/${pname}/${name}.tar.gz";
      sha256 = "16gbizy8vkxasxylwzj4p66yw8979nvzxdj6csidgmng7gi2k8nx";
    };
    propagatedBuildInputs = with self; [ pyopenssl twisted service-identity ];
    # fix python3 issues
    patchPhase = ''
      sed -i 's/except usage.UsageError, errortext/except usage.UsageError as errortext/' txgithub/scripts/create_token.py
      sed -i 's/except usage.UsageError, errortext/except usage.UsageError as errortext/' txgithub/scripts/gist.py
      sed -i 's/print response\[\x27html_url\x27\]/print(response\[\x27html_url\x27\])/' txgithub/scripts/gist.py
      sed -i '41d' txgithub/scripts/gist.py
      sed -i '41d' txgithub/scripts/gist.py
    '';

    # No tests distributed
    doCheck = false;
    meta = {
      description = "GitHub API client implemented using Twisted.";
      homepage    = "https://github.com/tomprince/txgithub";
      license     = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };
  };

  txrequests = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "txrequests";
    version = "0.9.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/${pname}/${name}.tar.gz";
      sha256 = "0kkxxd17ar5gyjkz9yrrdr15a64qw6ym60ndi0zbwx2s634yfafw";
    };
    propagatedBuildInputs = with self; [ twisted requests cryptography ];

    # Require network access
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';
    meta = {
      description = "Asynchronous Python HTTP for Humans.";
      homepage    = "https://github.com/tardyp/txrequests";
      license     = licenses.asl20;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };
  };

  txamqp = buildPythonPackage rec {
    name = "txamqp-${version}";
    version = "0.3";

    src = pkgs.fetchurl rec {
      url = "https://launchpad.net/txamqp/trunk/${version}/+download/python-txamqp_${version}.orig.tar.gz";
      sha256 = "1r2ha0r7g14i4b5figv2spizjrmgfpspdbl1m031lw9px2hhm463";
    };

    buildInputs = with self; [ twisted ];

    meta = {
      homepage = https://launchpad.net/txamqp;
      description = "Library for communicating with AMQP peers and brokers using Twisted";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  versiontools = buildPythonPackage rec {
    name = "versiontools-1.9.1";
    doCheck = (!isPy3k);

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/versiontools/${name}.tar.gz";
      sha256 = "1xhl6kl7f4srgnw6zw4lr8j2z5vmrbaa83nzn2c9r2m1hwl36sd9";
    };

  };

  veryprettytable = buildPythonPackage rec {
    name = "veryprettytable-${version}";
    version = "0.8.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/veryprettytable/${name}.tar.gz";
      sha256 = "1k1rifz8x6qcicmx2is9vgxcj0qb2f5pvzrp7zhmvbmci3yack3f";
    };

    propagatedBuildInputs = [ self.termcolor self.colorama ];

    meta = {
      description = "A simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = https://github.com/smeggingsmegger/VeryPrettyTable;
      license = licenses.free;
    };
  };

  graphite-web = callPackage ../development/python-modules/graphite-web { };

  graphite_api = callPackage ../development/python-modules/graphite-api { };

  graphite_beacon = callPackage ../development/python-modules/graphite_beacon { };

  influxgraph = callPackage ../development/python-modules/influxgraph { };

  graphitepager = callPackage ../development/python-modules/graphitepager { };

  pyspotify = buildPythonPackage rec {
    name = "pyspotify-${version}";

    version = "2.0.5";

    src = pkgs.fetchurl {
      url = "https://github.com/mopidy/pyspotify/archive/v${version}.tar.gz";
      sha256 = "1ilbz2w1gw3f1bpapfa09p84dwh08bf7qcrkmd3aj0psz57p2rls";
    };

    propagatedBuildInputs = with self; [ cffi ];
    buildInputs = [ pkgs.libspotify ];

    # python zip complains about old timestamps
    preConfigure = ''
      find -print0 | xargs -0 touch
    '';

    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      find "$out" -name _spotify.so -exec \
          install_name_tool -change \
          @loader_path/../Frameworks/libspotify.framework/libspotify \
          ${pkgs.libspotify}/lib/libspotify.dylib \
          {} \;
    '';

    # There are no tests
    doCheck = false;

    meta = {
      homepage    = http://pyspotify.mopidy.com;
      description = "A Python interface to Spotify’s online music streaming service";
      license     = licenses.unfree;
      maintainers = with maintainers; [ lovek323 rickynils ];
      platforms   = platforms.unix;
    };
  };

  pykka = buildPythonPackage rec {
    name = "pykka-${version}";

    version = "1.2.0";

    src = pkgs.fetchgit {
      url = "https://github.com/jodal/pykka.git";
      rev = "refs/tags/v${version}";
      sha256 = "0qlfw1054ap0cha1m6dbnq51kjxqxaf338g7jwnwy33b3gr8x0hg";
    };

    # There are no tests
    doCheck = false;

    meta = {
      homepage = http://www.pykka.org;
      description = "A Python implementation of the actor model";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  ws4py = callPackage ../development/python-modules/ws4py {};

  gdata = buildPythonPackage rec {
    name = "gdata-${version}";
    version = "2.0.18";

    src = pkgs.fetchurl {
      url = "https://gdata-python-client.googlecode.com/files/${name}.tar.gz";
      sha256 = "1dpxl5hwyyqd71avpm5vkvw8fhlvf9liizmhrq9jphhrx0nx5rsn";
    };

    # Fails with "error: invalid command 'test'"
    doCheck = false;

    meta = {
      homepage = https://code.google.com/p/gdata-python-client/;
      description = "Python client library for Google data APIs";
      license = licenses.asl20;
    };
  };

  IMAPClient = buildPythonPackage rec {
    name = "IMAPClient-${version}";
    version = "0.13";
    disabled = isPy34 || isPy35;

    src = pkgs.fetchurl {
      url = "http://freshfoo.com/projects/IMAPClient/${name}.tar.gz";
      sha256 = "0v7kd1crdbff0rmh4ddm5qszkis6hpk9084qh94al8h7g4y9l3is";
    };

    buildInputs = with self; [ mock ];

    preConfigure = ''
      sed -i '/distribute_setup/d' setup.py
      substituteInPlace setup.py --replace "mock==0.8.0" "mock"
    '';

    meta = {
      homepage = http://imapclient.freshfoo.com/;
      description = "Easy-to-use, Pythonic and complete IMAP client library";
      license = licenses.bsd3;
    };
  };

  Logbook = callPackage ../development/python-modules/Logbook { };

  libversion = callPackage ../development/python-modules/libversion {
    inherit (pkgs) libversion;
  };

  libvirt = callPackage ../development/python-modules/libvirt {
    inherit (pkgs) libvirt;
  };

  rpdb = buildPythonPackage rec {
    name = "rpdb-0.1.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rpdb/${name}.tar.gz";
      sha256 = "0rql1hq3lziwcql0h3dy05w074cn866p397ng9bv6qbz85ifw1bk";
    };

    meta = {
      description = "pdb wrapper with remote access via tcp socket";
      homepage = https://github.com/tamentis/rpdb;
      license = licenses.bsd2;
    };
  };


  grequests = buildPythonPackage rec {
    pname = "grequests";
    version = "0.3.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0lafzax5igbh8y4x0krizr573wjsxz7bhvwygiah6qwrzv83kv5c";
    };

    # No tests in archive
    doCheck = false;

    propagatedBuildInputs = with self; [ requests gevent ];

    meta = {
      description = "Asynchronous HTTP requests";
      homepage = https://github.com/kennethreitz/grequests;
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ matejc ];
    };
  };

  first = callPackage ../development/python-modules/first {};

  flaskbabel = buildPythonPackage rec {
    name = "Flask-Babel-0.11.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-Babel/${name}.tar.gz";
      sha256 = "16b80cipdba9xj3jlaiaq6wgrgpjb70w3j01jjy9hbp4k71kd6yj";
    };

    propagatedBuildInputs = with self; [ flask jinja2 speaklater Babel pytz ];

    meta = {
      description = "Adds i18n/l10n support to Flask applications";
      homepage = https://github.com/mitsuhiko/flask-babel;
      license = "bsd";
      maintainers = with maintainers; [ matejc ];
    };
  };

  speaklater = buildPythonPackage rec {
    name = "speaklater-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/speaklater/${name}.tar.gz";
      sha256 = "1ab5dbfzzgz6cnz4xlwx79gz83id4bhiw67k1cgqrlzfs0va7zjr";
    };

    meta = {
      description = "Implements a lazy string for python useful for use with gettext";
      homepage = https://github.com/mitsuhiko/speaklater;
      license = "bsd";
      maintainers = with maintainers; [ matejc ];
    };
  };

  speedtest-cli = callPackage ../development/python-modules/speedtest-cli { };

  pushbullet = callPackage ../development/python-modules/pushbullet { };

  power = buildPythonPackage rec {
    name = "power-1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/power/${name}.tar.gz";
      sha256 = "7d7d60ec332acbe3a7d00379b45e39abf650bf7ee311d61da5ab921f52f060f0";
    };

    # Tests can't work because there is no power information available.
    doCheck = false;

    meta = {
      description = "Cross-platform system power status information";
      homepage = https://github.com/Kentzo/Power;
      license = licenses.mit;
    };
  };

  # added 2018-05-23, can be removed once 18.09 is branched off
  udiskie = throw "pythonPackages.udiskie has been replaced by udiskie";

  pythonefl = callPackage ../development/python-modules/python-efl { };

  tlsh = buildPythonPackage rec {
    name = "tlsh-3.4.5";
    src = pkgs.fetchFromGitHub {
      owner = "trendmicro";
      repo = "tlsh";
      rev = "22fa9a62068b92c63f2b5a87004a7a7ceaac1930";
      sha256 = "1ydliir308xn4ywy705mmsh7863ldlixdvpqwdhbipzq9vfpmvll";
    };
    buildInputs = with pkgs; [ cmake ];
    # no test data
    doCheck = false;
    preConfigure = ''
      mkdir build
      cd build
      cmake ..
      cd ../py_ext
    '';
    meta = with stdenv.lib; {
      description = "Trend Micro Locality Sensitive Hash";
      homepage = https://github.com/trendmicro/tlsh;
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };

  toposort = buildPythonPackage rec {
    name = "toposort-${version}";
    version = "1.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/toposort/toposort-1.1.tar.gz";
      sha256 = "1izmirbwmd9xrk7rq83p486cvnsslfa5ljvl7rijj1r64zkcnf3a";
    };
    meta = {
      description = "A topological sort algorithm";
      homepage = https://pypi.python.org/pypi/toposort/1.1;
      maintainers = with maintainers; [ tstrobel ];
      platforms = platforms.linux;
      #license = licenses.apache;
    };
  };

  snapperGUI = buildPythonPackage rec {
    name = "Snapper-GUI";

    src = pkgs.fetchgit {
      url = "https://github.com/ricardomv/snapper-gui";
      rev = "11d98586b122180c75a86fccda45c4d7e3137591";
      sha256 = "7a9f86fc17dbf130526e70c3e925eac30e2c74d6b932efbf7e7cd9fbba6dc4b1";
    };

    # no tests available
    doCheck = false;

    propagatedBuildInputs = with self; [ pygobject3 dbus-python ];

    meta = {
      homepage = https://github.com/ricardomv/snapper-gui;
      description = "Graphical frontend for snapper";
      license = licenses.gpl2;
      maintainers = with maintainers; [ tstrobel ];
    };
  };

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  funcy = buildPythonPackage rec {
    name = "funcy-1.6";

    src = pkgs.fetchurl {
        url = "mirror://pypi/f/funcy/${name}.tar.gz";
        sha256 = "511495db0c5660af18d3151b008c6ce698ae7fbf60887278e79675e35eed1f01";
    };

    # No tests
    doCheck = false;

    meta = {
      description = "Collection of fancy functional tools focused on practicality";
      homepage = "http://funcy.readthedocs.org/";
      license = licenses.bsd3;

    };
  };

  vxi11 = callPackage ../development/python-modules/vxi11 { };

  svg2tikz = self.buildPythonPackage {
    name = "svg2tikz-1.0.0";
    disabled = ! isPy27;

    propagatedBuildInputs = with self; [lxml];

    src = pkgs.fetchgit {
      url = "https://github.com/kjellmf/svg2tikz";
      sha256 = "429428ec435e53672b85cdfbb89bb8af0ff9f8238f5d05970729e5177d252d5f";
      rev = "ad36f2c3818da13c4136d70a0fd8153acf8daef4";
    };

    meta = {
      homepage = https://github.com/kjellmf/svg2tikz;
      description = "An SVG to TikZ converter";
      license = licenses.gpl2Plus;
      maintainers =  with maintainers; [ gal_bolle ];
    };
  };

  WSGIProxy = buildPythonPackage rec {
    name = "WSGIProxy-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WSGIProxy/WSGIProxy-${version}.tar.gz";
      sha256 = "0wqz1q8cvb81a37gb4kkxxpv4w7k8192a08qzyz67rn68ln2wcig";
    };

    propagatedBuildInputs = with self; [
      paste six
    ];

    disabled = isPy3k; # Judging from SyntaxError

    meta = with stdenv.lib; {
      description = "WSGIProxy gives tools to proxy arbitrary(ish) WSGI requests to other";
      homepage = "http://pythonpaste.org/wsgiproxy/";
    };
  };

  blist = buildPythonPackage rec {
    name = "blist-${version}";
    version = "1.3.6";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/blist/blist-${version}.tar.gz";
      sha256 = "1hqz9pqbwx0czvq9bjdqjqh5bwfksva1is0anfazig81n18c84is";
    };
  };

  canonicaljson = callPackage ../development/python-modules/canonicaljson { };

  daemonize = buildPythonPackage rec {
    name = "daemonize-${version}";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/daemonize/daemonize-${version}.tar.gz";
      sha256 = "0y139sq657bpzfv6k0aqm4071z4s40i6ybpni9qvngvdcz6r86n2";
    };
  };

  pydenticon = buildPythonPackage rec {
    name = "pydenticon-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pydenticon/pydenticon-0.2.tar.gz";
      sha256 = "035dawcspgjw2rksbnn863s7b0i9ac8cc1nshshvd1l837ir1czp";
    };
    propagatedBuildInputs = with self; [
      pillow mock
    ];
  };

  pynac = buildPythonPackage rec {
    name = "pynac-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/project/pynac/pynac/pynac-0.2/pynac-0.2.tar.gz";
      sha256 = "0avzqqcxl54karjmla9jbsyid98mva36lxahwmrsx5h40ys2ggxp";
    };

    propagatedBuildInputs = with self; [];
  };

  pybindgen = callPackage ../development/python-modules/pybindgen {};

  pygccxml = callPackage ../development/python-modules/pygccxml {};

  pymacaroons-pynacl = callPackage ../development/python-modules/pymacaroons-pynacl { };

  pynacl = callPackage ../development/python-modules/pynacl { };

  service-identity = callPackage ../development/python-modules/service_identity { };

  signedjson = buildPythonPackage rec {
    name = "signedjson-${version}";
    version = "1.0.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-signedjson.git";
      rev = "refs/tags/v${version}";
      sha256 = "0b8xxhc3npd4567kqapfp4gs7m0h057xam3an7424az262ind82n";
    };

    propagatedBuildInputs = with self; [
      canonicaljson unpaddedbase64 pynacl
    ];
  };

  unpaddedbase64 = buildPythonPackage rec {
    name = "unpaddedbase64-${version}";
    version = "1.1.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-unpaddedbase64.git";
      rev = "refs/tags/v${version}";
      sha256 = "0if3fjfxga0bwdq47v77fs9hrcqpmwdxry2i2a7pdqsp95258nxd";
    };
  };


  thumbor = callPackage ../development/python-modules/thumbor { };

  thumborPexif = self.buildPythonPackage rec {
    name = "thumbor-pexif-0.14";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/thumbor-pexif/${name}.tar.gz";
      sha256 = "715cd24760c7c28d6270c79c9e29b55b8d952a24e0e56833d827c2c62451bc3c";
    };

    meta = {
      description = "Module to parse and edit the EXIF data tags in a JPEG image";
      homepage = http://www.benno.id.au/code/pexif/;
      license = licenses.mit;
    };
  };

  pync = buildPythonPackage rec {
    version  = "1.4";
    baseName = "pync";
    name     = "${baseName}-${version}";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${baseName}/${name}.tar.gz";
      sha256 = "0lc1x0pai85avm1r452xnvxc12wijnhz87xv20yp3is9fs6rnkrh";
    };

    buildInputs = with self; [ pkgs.coreutils ];

    propagatedBuildInputs = with self; [ dateutil ];

    preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.terminal-notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
    '';

    meta = {
      description = "Python Wrapper for Mac OS 10.8 Notification Center";
      homepage    = https://pypi.python.org/pypi/pync/1.4;
      license     = licenses.mit;
      platforms   = platforms.darwin;
      maintainers = with maintainers; [ lovek323 ];
    };
  };

  weboob = callPackage ../development/python-modules/weboob { };

  datadiff = buildPythonPackage rec {
    name = "datadiff-1.1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/datadiff/datadiff-1.1.6.zip";
      sha256 = "f1402701063998f6a70609789aae8dc05703f3ad0a34882f6199653654c55543";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "DataDiff";
      homepage = https://sourceforge.net/projects/datadiff/;
      license = licenses.asl20;
    };
  };

  termcolor = buildPythonPackage rec {
    name = "termcolor-1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/termcolor/termcolor-1.1.0.tar.gz";
      sha256 = "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b";
    };

    meta = {
      description = "Termcolor";
      homepage = https://pypi.python.org/pypi/termcolor;
      license = licenses.mit;
    };
  };

  html2text = buildPythonPackage rec {
    name = "html2text-2016.9.19";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/html2text/${name}.tar.gz";
      sha256 = "554ef5fd6c6cf6e3e4f725a62a3e9ec86a0e4d33cd0928136d1c79dbeb7b2d55";
    };

    meta = {
      description = "Turn HTML into equivalent Markdown-structured text";
      homepage = https://github.com/Alir3z4/html2text/;
      license = licenses.gpl3;
    };
  };

  pychart = callPackage ../development/python-modules/pychart {};

  parsimonious = buildPythonPackage rec {
    version = "0.7.0";
    name = "parsimonious-${version}";
    src = pkgs.fetchFromGitHub {
      repo = "parsimonious";
      owner = "erikrose";
      rev = version;
      sha256 = "087npc8ccryrxabmqifcz56w4wd0hzmv0mc91wrbhc1sil196j0a";
    };

    propagatedBuildInputs = with self; [ nose six ];

    meta = {
      homepage = "https://github.com/erikrose/parsimonious";
      description = "Fast arbitrary-lookahead parser written in pure Python";
      license = licenses.mit;
    };
  };

  networkx = callPackage ../development/python-modules/networkx { };

  ofxclient = callPackage ../development/python-modules/ofxclient {};

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = buildPythonPackage rec {
    name = "ofxparse-0.14";
    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ofxparse/${name}.tar.gz";
      sha256 = "d8c486126a94d912442d040121db44fbc4a646ea70fa935df33b5b4dbfbbe42a";
    };

    propagatedBuildInputs = with self; [ six beautifulsoup4 ];

    meta = {
      homepage = "http://sites.google.com/site/ofxparse";
      description = "Tools for working with the OFX (Open Financial Exchange) file format";
      license = licenses.mit;
    };
  };

  ofxtools = buildPythonPackage rec {
    name = "ofxtools-0.3.8";
    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ofxtools/${name}.tar.gz";
      sha256 = "88f289a60f4312a1599c38a8fb3216e2b46d10cc34476f9a16a33ac8aac7ec35";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s ofxtools
    '';

    buildInputs = with self; [ sqlalchemy ];

    meta = {
      homepage = "https://github.com/csingley/ofxtools";
      description = "Library for working with Open Financial Exchange (OFX) formatted data used by financial institutions";
      license = licenses.mit;
      broken = true;
    };
  };

  basemap = buildPythonPackage rec {
    name = "basemap-1.0.7";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/project/matplotlib/matplotlib-toolkits/basemap-1.0.7/basemap-1.0.7.tar.gz";
      sha256 = "0ca522zirj5sj10vg3fshlmgi615zy5gw2assapcj91vsvhc4zp0";
    };

    propagatedBuildInputs = with self; [ numpy matplotlib pillow ];
    buildInputs = with self; with pkgs ; [ setuptools geos proj ];

    # Standard configurePhase from `buildPythonPackage` seems to break the setup.py script
    configurePhase = ''
      export GEOS_DIR=${pkgs.geos}
    '';

    # The 'check' target is not supported by the `setup.py` script.
    # TODO : do the post install checks (`cd examples && ${python.interpreter} run_all.py`)
    doCheck = false;

    meta = {
      homepage = "https://matplotlib.org/basemap/";
      description = "Plot data on map projections with matplotlib";
      longDescription = ''
        An add-on toolkit for matplotlib that lets you plot data on map projections with
        coastlines, lakes, rivers and political boundaries. See
        http://matplotlib.github.com/basemap/users/examples.html for examples of what it can do.
      '';
      license = with licenses; [ mit gpl2 ];
    };
  };

  dicttoxml = callPackage ../development/python-modules/dicttoxml { };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  evernote = buildPythonPackage rec {
    name = "evernote-${version}";
    version = "1.25.0";
    disabled = ! isPy27; #some dependencies do not work with py3

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/evernote/${name}.tar.gz";
      sha256 = "1lwlg6fpi3530245jzham1400a5b855bm4sbdyck229h9kg1v02d";
    };

     propagatedBuildInputs = with self; [ oauth2 ];

     meta = {
      description = "Evernote SDK for Python";
      homepage = http://dev.evernote.com;
      license = licenses.asl20;
      maintainers = with maintainers; [ hbunke ];
     };
  };

  setproctitle = buildPythonPackage rec {
    name = "python-setproctitle-${version}";
    version = "1.1.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/setproctitle/setproctitle-${version}.tar.gz";
      sha256 = "1mqadassxcm0m9r1l02m5vr4bbandn48xz8gifvxmb4wiz8i8d0w";
    };

    meta = {
      description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
      homepage =  https://github.com/dvarrazzo/py-setproctitle;
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ exi ];
    };
  };

  thrift = buildPythonPackage rec {
    name = "thrift-${version}";
    version = "0.9.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/thrift/${name}.tar.gz";
      sha256 = "dfbc3d3bd19d396718dab05abaf46d93ae8005e2df798ef02e32793cd963877e";
    };

    # No tests. Breaks when not disabling.
    doCheck = false;

    meta = {
      description = "Python bindings for the Apache Thrift RPC system";
      homepage = http://thrift.apache.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ hbunke ];

    };
  };

  geeknote = buildPythonPackage rec {
    version = "2015-05-11";
    name = "geeknote-${version}";
    disabled = ! isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "VitaliyRodnenko";
      repo = "geeknote";
      rev = "8489a87d044e164edb321ba9acca8d4631de3dca";
      sha256 = "0l16v4xnyqnsf84b1pma0jmdyxvmfwcv3sm8slrv3zv7zpmcm3lf";
    };

    /* build with tests fails with "Can not create application dirictory :
     /homeless-shelter/.geeknotebuilder". */
    doCheck = false;

    propagatedBuildInputs = with self; [
        thrift
        beautifulsoup4
        markdown2
        sqlalchemy
        html2text
        evernote
    ];

    meta = {
      description = "Work with Evernote from command line";
      homepage = http://www.geeknote.me;
      license = licenses.gpl1;
      maintainers = with maintainers; [ hbunke ];

    };
  };

  trollius = callPackage ../development/python-modules/trollius {};

  neovim = callPackage ../development/python-modules/neovim {};

  neovim_gui = buildPythonPackage rec {
    name = "neovim-pygui-${self.neovim.version}";
    version = "0.1.3";
    disabled = !isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "python-gui";
      rev = version;
      sha256 = "1vpvr3zm3f9sxg1z1cl7f7gi8v1xksjdvxj62qnw65aqj3zqxnkz";
    };

    propagatedBuildInputs = [
      self.neovim
      self.click
      self.pygobject3
      pkgs.gobjectIntrospection
      pkgs.makeWrapper
      pkgs.gtk3
    ];

    patchPhase = ''
      sed -i -e "s|entry_points=entry_points,|entry_points=dict(console_scripts=['pynvim=neovim.ui.cli:main [GUI]']),|" setup.py
    '';

    postInstall = ''
      wrapProgram $out/bin/pynvim \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix PYTHONPATH : "${self.pygobject3}/lib/python2.7/site-packages:$PYTHONPATH"
    '';
  };

  typogrify = buildPythonPackage rec {
    name = "typogrify-2.0.7";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/typogrify/${name}.tar.gz";
      sha256 = "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38";
    };
    disabled = isPyPy;
    # Wants to set up Django
    doCheck = false;
    propagatedBuildInputs = with self; [ django smartypants jinja2 ];
    meta = {
      description = "Filters to enhance web typography, including support for Django & Jinja templates";
      homepage = "https://github.com/mintchaos/typogrify";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  };

  smartypants = buildPythonPackage rec {
    version = "1.8.6";
    name = "smartypants-${version}";
    src = pkgs.fetchhg {
      url = "https://bitbucket.org/livibetter/smartypants.py";
      rev = "v${version}";
      sha256 = "1cmzz44d2hm6y8jj2xcq1wfr26760gi7iq92ha8xbhb1axzd7nq6";
    };
    disabled = isPyPy;
    buildInputs = with self; [ ]; #docutils pygments ];
    meta = {
      description = "Python with the SmartyPants";
      homepage = "https://bitbucket.org/livibetter/smartypants.py";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pypeg2 = buildPythonPackage rec {
    version = "2.15.2";
    name = "pypeg2-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyPEG2/pyPEG2-${version}.tar.gz";
      sha256 = "0v8ziaam2r637v94ra4dbjw6jzxz99gs5x4i585kgag1v204yb9b";
    };

    checkPhase = ''
      # The tests assume that test_xmlast does not run before test_pyPEG2.
      python -m unittest pypeg2.test.test_pyPEG2 pypeg2.test.test_xmlast
    '';

    #https://bitbucket.org/fdik/pypeg/issues/36/test-failures-on-py35
    doCheck = !isPy3k;

    meta = {
      description = "PEG parser interpreter in Python";
      homepage = http://fdik.org/pyPEG;
      license = licenses.gpl2;
    };
  };

  torchvision = callPackage ../development/python-modules/torchvision { };

  jenkinsapi = buildPythonPackage rec {
    name = "jenkinsapi-${version}";
    version = "0.2.32";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jenkinsapi/${name}.tar.gz";
      sha256 = "0fcc78b8dfc87237942aad2a8be54dbc08bc4afceaa7f6897f3d894e7d4bfd22";
    };

    propagatedBuildInputs = with self; [ pytz requests ];

    buildInputs = with self; [ coverage mock nose unittest2 ];

    meta = {
      description = "A Python API for accessing resources on a Jenkins continuous-integration server";
      homepage = https://github.com/salimfadhley/jenkinsapi;
      maintainers = with maintainers; [ drets ];
      license = licenses.mit;
    };
  };

  jenkins-job-builder = buildPythonPackage rec {
    name = "jenkins-job-builder-2.0.0.0b2";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jenkins-job-builder/${name}.tar.gz";
      sha256 = "1y0yl2w6c9c91f9xbjkvff1ag8p72r24nzparrzrw9sl8kn9632x";
    };

    patchPhase = ''
      export HOME=$TMPDIR
    '';

    buildInputs = with self; [
      pip
    ];

    propagatedBuildInputs = with self; [
      pbr
      mock
      python-jenkins
      pyyaml
      six
      stevedore
    ];

    meta = {
      description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
      homepage = "https://docs.openstack.org/infra/system-config/jjb.html";
      license = licenses.asl20;
      maintainers = with maintainers; [ garbas ];
    };
  };

  dot2tex = buildPythonPackage rec {
    name = "dot2tex-2.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dot2tex/dot2tex-2.9.0.tar.gz";
      sha256 = "7d3e54add7dccdaeb6cc9e61ceaf7b587914cf8ebd6821cfea008acdc1e50d4a";
    };

    # Tests fail with 3.x. Furthermore, package is no longer maintained.
    disabled = isPy3k;

    propagatedBuildInputs = with self; [
      pyparsing
    ];

    meta = {
      description = "Convert graphs generated by Graphviz to LaTeX friendly formats";
      homepage = "https://github.com/kjellmf/dot2tex";
      license = licenses.mit;
    };
  };

  poezio = callPackage ../applications/networking/instant-messengers/poezio { };

  potr = callPackage ../development/python-modules/potr {};

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  pluggy = callPackage ../development/python-modules/pluggy {};

  xcffib = callPackage ../development/python-modules/xcffib {};

  pafy = callPackage ../development/python-modules/pafy { };

  suds = buildPythonPackage rec {
    name = "suds-0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/suds/suds-0.4.tar.gz";
      sha256 = "1w4s9051iv90c0gs73k80c3d51y2wbx1xgfdgg2hk7mv4gjlllnm";
    };

    patches = [ ../development/python-modules/suds-0.4-CVE-2013-2217.patch ];

    meta = with stdenv.lib; {
      # Broken for security issues:
      # - https://github.com/NixOS/nixpkgs/issues/19678
      # - https://lwn.net/Vulnerabilities/559200/
      broken = true;
      description = "Lightweight SOAP client";
      homepage = https://fedorahosted.org/suds;
      license = licenses.lgpl3Plus;
    };
  };

  suds-jurko = buildPythonPackage rec {
    name = "suds-jurko-${version}";
    version = "0.6";
    disabled = isPyPy;  # lots of failures

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/suds-jurko/${name}.zip";
      sha256 = "1s4radwf38kdh3jrn5acbidqlr66sx786fkwi0rgq61hn4n2bdqw";
    };

    buildInputs = [ self.pytest ];

    preBuild = ''
      # fails
      substituteInPlace tests/test_transport_http.py \
        --replace "test_sending_unicode_data" "noop"
    '';

    meta = with stdenv.lib; {
      description = "Lightweight SOAP client (Jurko's fork)";
      homepage = https://bitbucket.org/jurko/suds;
    };
  };

  mailcap-fix = buildPythonPackage rec {
    name = "mailcap-fix-${version}";
    version = "1.0.1";

    disabled = isPy36; # this fix is merged into python 3.6

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mailcap-fix/${name}.tar.gz";
      sha256 = "02lijkq6v379r8zkqg9q2srin3i80m4wvwik3hcbih0s14v0ng0i";
    };

    meta = with stdenv.lib; {
      description = "A patched mailcap module that conforms to RFC 1524";
      homepage = "https://github.com/michael-lazar/mailcap_fix";
      license = licenses.unlicense;
    };
  };

  maildir-deduplicate = buildPythonPackage rec {
    name = "maildir-deduplicate-${version}";
    version = "1.0.2";

    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/maildir-deduplicate/${name}.tar.gz";
      sha256 = "1xy5z756alrjgpl9qx2gdx898rw1mryrqkwmipbh39mgrvkl3fz9";
    };

    propagatedBuildInputs = with self; [ click ];

    meta = with stdenv.lib; {
      description = "Command-line tool to deduplicate mails from a set of maildir folders";
      homepage = "https://github.com/kdeldycke/maildir-deduplicate";
      license = licenses.gpl2;
    };
  };


  mps-youtube = buildPythonPackage rec {
    name = "mps-youtube-${version}";
    version = "0.2.7.1";

    disabled = (!isPy3k);

    # disabled due to error in loading unittest
    # don't know how to make test from: <mps_youtube. ...>
    doCheck = false;

    # before check create a directory and redirect XDG_CONFIG_HOME to it
    preCheck = ''
      mkdir -p check-phase
      export XDG_CONFIG_HOME=$(pwd)/check-phase
    '';

    src = pkgs.fetchFromGitHub {
      owner = "mps-youtube";
      repo = "mps-youtube";
      rev = "v${version}";
      sha256 = "16zn5gwb3568w95lr21b88zkqlay61p1541sa9c3x69zpi8v0pys";
    };

    propagatedBuildInputs = with self; [ pafy ];

    meta = with stdenv.lib; {
      description = "Terminal based YouTube player and downloader";
      homepage = https://github.com/np1/mps-youtube;
      license = licenses.gpl3;
      maintainers = with maintainers; [ odi ];
    };
  };

  d2to1 = callPackage ../development/python-modules/d2to1 { };

  ovh = callPackage ../development/python-modules/ovh { };

  willow = buildPythonPackage rec {
    name = "willow-${version}";
    version = "0.2.2";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/Willow/Willow-${version}.tar.gz";
      sha256 = "111c82fbfcda2710ce6201b0b7e0cfa1ff3c4f2f0dc788cc8dfc8db933c39c73";
    };

    propagatedBuildInputs = with self; [ six pillow ];

    # Test data is not included
    # https://github.com/torchbox/Willow/issues/34
    doCheck = false;

    meta = {
      description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
      homepage = https://github.com/torchbox/Willow/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  importmagic = buildPythonPackage rec {
    simpleName = "importmagic";
    name = "${simpleName}-${version}";
    version = "0.1.3";
    doCheck = false;  # missing json file from tarball

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/${simpleName}/${name}.tar.gz";
      sha256 = "194bl8l8sc2ibwi6g5kz6xydkbngdqpaj6r2gcsaw1fc73iswwrj";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python Import Magic - automagically add, remove and manage imports";
      homepage = https://github.com/alecthomas/importmagic;
      license = "bsd";
    };
  };

  xgboost = callPackage ../development/python-modules/xgboost {
    xgboost = pkgs.xgboost;
  };

  xkcdpass = buildPythonPackage rec {
    name = "xkcdpass-${version}";
    version = "1.4.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xkcdpass/xkcdpass-1.4.2.tar.gz";
      sha256 = "4c1f8bee886820c42ccc64c15c3a2275dc6d01028cf6af7c481ded87267d8269";
    };

    # No tests included
    # https://github.com/redacted/XKCD-password-generator/issues/32
    doCheck = false;

    meta = {
      homepage = https://pypi.python.org/pypi/xkcdpass/;
      description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };

  xlsx2csv = buildPythonPackage rec {
    name = "xlsx2csv-${version}";
    version = "0.7.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xlsx2csv/${name}.tar.gz";
      sha256 = "7c6c8fa6c2774224d03a6a96049e116822484dccfa3634893397212ebcd23866";
    };
    meta = {
      homepage = https://github.com/bitprophet/alabaster;
      description = "Convert xlsx to csv";
      license = licenses.bsd3;
      maintainers = with maintainers; [ jb55 ];
    };
  };

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

  trezor_agent = buildPythonPackage rec{
    name = "${pname}-${version}";
    pname = "trezor_agent";
    version = "0.9.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1i5cdamlf3c0ym600pjklij74p8ifj9cv7xrpnrfl1b8nkadswbz";
    };

    propagatedBuildInputs = with self; [
      trezor libagent ecdsa ed25519
      mnemonic keepkey semver
    ];

    meta = {
      description = "Using Trezor as hardware SSH agent";
      homepage = https://github.com/romanz/trezor-agent;
      license = licenses.gpl3;
      maintainers = with maintainers; [ np ];
    };
  };

  x11_hash = buildPythonPackage rec{
    version = "1.4";
    name = "x11_hash-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/x11_hash/${name}.tar.gz";
      sha256 = "172skm9xbbrivy1p4xabxihx9lsnzi53hvzryfw64m799k2fmp22";
    };

    meta = {
      description = "Binding for X11 proof of work hashing";
      homepage = https://github.com/mazaclub/x11_hash;
      license = licenses.mit;
      maintainers = with maintainers; [ np ];
    };
  };

  termstyle = callPackage ../development/python-modules/termstyle { };

  green = callPackage ../development/python-modules/green { };

  topydo = throw "python3Packages.topydo was moved to topydo"; # 2017-09-22

  w3lib = buildPythonPackage rec {
    name = "w3lib-${version}";
    version = "1.17.0";

    buildInputs = with self ; [ six pytest ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/w3lib/${name}.tar.gz";
      sha256 = "0vshh300ay5wn5hwl9qcb32m71pz5s6miy0if56vm4nggy159inq";
    };

    meta = {
      description = "A library of web-related functions";
      homepage = "https://github.com/scrapy/w3lib";
      license = licenses.bsd3;
      maintainers = with maintainers; [ drewkett ];
    };
  };

  queuelib = buildPythonPackage rec {
    name = "queuelib-${version}";
    version = "1.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/queuelib/${name}.tar.gz";
      sha256 = "a6829918157ed433fafa87b0bb1e93e3e63c885270166db5884a02c34c86f914";
    };

    buildInputs = with self ; [ pytest ];

    meta = {
      description = "A collection of persistent (disk-based) queues for Python";
      homepage = "https://github.com/scrapy/queuelib";
      license = licenses.bsd3;
      maintainers = with maintainers; [ drewkett ];
    };
  };

  scrapy = callPackage ../development/python-modules/scrapy { };

  pandocfilters = buildPythonPackage rec{
    version = "1.4.1";
    pname = "pandocfilters";
    name = pname + "-${version}";

    src = fetchPypi{
      inherit pname version;
      sha256 = "ec8bcd100d081db092c57f93462b1861bcfa1286ef126f34da5cb1d969538acd";
    };
    # No tests available
    doCheck = false;

    meta = {
      description = "A python module for writing pandoc filters, with a collection of examples";
      homepage = https://github.com/jgm/pandocfilters;
      license = licenses.mit;
      maintainers = with maintainers; [];
    };
  };

  htmltreediff = callPackage ../development/python-modules/htmltreediff { };

  repeated_test = buildPythonPackage rec {
    name = "repeated_test-${version}";
    version = "0.1a3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/repeated-test/${name}.tar.gz";
      sha256 = "062syp7kl2g0x6qx3z8zb5sdycpi7qcpxp9iml2v8dqzqnij9bpg";
    };

    buildInputs = with self; [
      unittest2
    ];
    propagatedBuildInputs = with self; [
      six
    ];

    meta = {
      description = "A quick unittest-compatible framework for repeating a test function over many fixtures";
      homepage = "https://github.com/epsy/repeated_test";
      license = licenses.mit;
    };
  };

  Keras = callPackage ../development/python-modules/keras { };

  keras-applications = callPackage ../development/python-modules/keras-applications { };

  keras-preprocessing = callPackage ../development/python-modules/keras-preprocessing { };

  Lasagne = buildPythonPackage rec {
    name = "Lasagne-${version}";
    version = "0.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lasagne/${name}.tar.gz";
      sha256 = "0cqj86rdm6c7y5vq3i13qy76fg5xi3yjp4r0hpqy8hvynv54wqrw";
    };

    propagatedBuildInputs = with self; [
      numpy
      Theano
    ];

    # there are no tests
    doCheck = false;

    meta = {
      description = "Lightweight library to build and train neural networks in Theano";
      homepage = "https://github.com/Lasagne/Lasagne";
      maintainers = with maintainers; [ NikolaMandic ];
      license = licenses.mit;
    };
  };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sigtools = buildPythonPackage rec {
    name = "sigtools-${version}";
    version = "1.1a3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sigtools/${name}.tar.gz";
      sha256 = "190w14vzbiyvxcl9jmyyimpahar5b0bq69v9iv7chi852yi71w6w";
    };

    buildInputs = with self; [
      repeated_test
      sphinx
      mock
      coverage
      unittest2
    ];
    propagatedBuildInputs = with self; [
      funcsigs
      six
    ];

    patchPhase = ''sed -i s/test_suite="'"sigtools.tests"'"/test_suite="'"unittest2.collector"'"/ setup.py'';

    meta = {
      description = "Utilities for working with 3.3's inspect.Signature objects.";
      homepage = "https://pypi.python.org/pypi/sigtools";
      license = licenses.mit;
    };
  };

  clize = buildPythonPackage rec {
    name = "clize-${version}";
    version = "3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/clize/${name}.tar.gz";
      sha256 = "1xkr3h404d7pgj5gdpg6bddv3v3yq2hgx8qlwkgw5abg218k53hm";
    };

    buildInputs = with self; [
      dateutil
    ];
    propagatedBuildInputs = with self; [
      sigtools
    ];

    meta = {
      description = "Command-line argument parsing for Python";
      homepage = "https://github.com/epsy/clize";
      license = licenses.mit;
    };
  };

  zerobin = buildPythonPackage rec {
    name = "zerobin-${version}";
    version = "20160108";

    src = pkgs.fetchFromGitHub {
      owner = "sametmax";
      repo = "0bin";
      rev = "7da1615";
      sha256 = "1pzcwy454kn5216pvwjqzz311s6jbh7viw9s6kw4xps6f5h44bid";
    };

    propagatedBuildInputs = with self; [
      cherrypy
      bottle
      lockfile
      clize
    ];
    # zerobin doesn't have any tests, but includes a copy of cherrypy which
    # can wrongly fail the check phase.
    doCheck = false;
    meta = {
      description = "A client side encrypted pastebin";
      homepage = https://0bin.net/;
      license = licenses.wtfpl;
    };
  };

  tensorflow-tensorboard = callPackage ../development/python-modules/tensorflow-tensorboard { };

  tensorflow =
    if stdenv.isDarwin
    then callPackage ../development/python-modules/tensorflow/bin.nix { }
    else callPackage ../development/python-modules/tensorflow/bin.nix rec {
      cudaSupport = pkgs.config.cudaSupport or false;
      inherit (pkgs.linuxPackages) nvidia_x11;
      cudatoolkit = pkgs.cudatoolkit_9_0;
      cudnn = pkgs.cudnn_cudatoolkit_9_0;
    };

  tensorflowWithoutCuda = self.tensorflow.override {
    cudaSupport = false;
  };

  tensorflowWithCuda = self.tensorflow.override {
    cudaSupport = true;
  };

  tflearn = callPackage ../development/python-modules/tflearn { };

  simpleai = buildPythonPackage rec {
     version = "0.7.11";
     name = "simpleai-${version}";

     src = pkgs.fetchurl {
       url= "https://pypi.python.org/packages/source/s/simpleai/${name}.tar.gz";
       sha256 = "03frjc5jxsz9xm24jz7qa4hcp0dicgazrxkdsa2rsnir672lwkwz";
     };

     propagatedBuildInputs = with self; [ numpy ];

     disabled = isPy3k;

     #No tests in archive
     doCheck = false;

     meta = {
       homepage = https://github.com/simpleai-team/simpleai;
       description = "This lib implements many of the artificial intelligence algorithms described on the book 'Artificial Intelligence, a Modern Approach'";
       maintainers = with maintainers; [ NikolaMandic ];
     };
  };

  word2vec = buildPythonPackage rec {
    name = "word2vec-${version}";
    version = "0.9.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/word2vec/${name}.tar.gz";
      sha256 = "a811e3e98a8e6dfe7bc851ebbbc2d6e5ab5142f2a134dd3c03daac997b546faa";
    };

    propagatedBuildInputs = with self; [ cython numpy ];

    checkPhase = ''
     cd word2vec/tests;
      ${python.interpreter} test_word2vec.py
    '';

    meta = {
      description = "Tool for computing continuous distributed representations of words";
      homepage = "https://github.com/danielfrg/word2vec";
      license     = licenses.asl20;
      maintainers = with maintainers; [ NikolaMandic ];
    };
  };

  tvdb_api = buildPythonPackage rec {
    name = "tvdb_api-${version}";
    version = "1.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tvdb_api/${name}.tar.gz";
      sha256 = "0hq887yb3rwc0rcw32lh7xdkk9bbrqy274aspzqkd6f7dyhp73ih";
    };

    propagatedBuildInputs = with self; [ requests-cache ];

    meta = {
      description = "Simple to use TVDB (thetvdb.com) API in Python.";
      homepage = "https://github.com/dbr/tvdb_api";
      license = licenses.unlicense;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  tvnamer = buildPythonPackage rec {
    name = "tvnamer-${version}";
    version = "2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tvnamer/${name}.tar.gz";
      sha256 = "10iizmwna2xpyc2694hsrvny68y3bdq576p8kxsvg5gj2spnsxav";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ tvdb_api ];

    # a ton of tests fail with: IOError: tvnamer/main.py could not be found in . or ..
    doCheck = false;

    meta = {
      description = "Automatic TV episode file renamer, uses data from thetvdb.com via tvdb_api.";
      homepage = "https://github.com/dbr/tvnamer";
      license = licenses.unlicense;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  threadpool = buildPythonPackage rec {
    name = "threadpool-${version}";
    version = "1.3.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/threadpool/${name}.tar.bz2";
      sha256 = "197gzrxn9lbk0q1v079814c6s05cr4rwzyl6c1m6inkyif4yzr6c";
    };
  };

  rocket-errbot = callPackage ../development/python-modules/rocket-errbot {  };

  Yapsy = buildPythonPackage rec {
    name = "Yapsy-${version}";
    version = "1.11.223";

    src = pkgs.fetchurl {
      url = "mirror://pypi/y/yapsy/${name}.tar.gz";
      sha256 = "19pjsnqizswnczhlav4lb7zlzs0n73ijrsgksy4374b14jkkkfs5";
    };

    doCheck = false;
  };

  ansi = callPackage ../development/python-modules/ansi { };

  pygments-markdown-lexer = buildPythonPackage rec {
    name = "pygments-markdown-lexer-${version}";
    version = "0.1.0.dev39";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pygments-markdown-lexer/${name}.zip";
      sha256 = "1pzb5wy23q3fhs0rqzasjnw6hdzwjngpakb73i98cn0b8lk8q4jc";
    };

    doCheck = false;

    propagatedBuildInputs = with self; [ pygments ];
  };

  telegram = buildPythonPackage rec {
    name = "telegram-${version}";
    version = "0.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/telegram/${name}.tar.gz";
      sha256 = "1495l2ml8mg120wfvqhikqkfczhwwaby40vdmsz8v2l69jps01fl";
    };
  };

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

  pivy = buildPythonPackage rec {
    version = "20101207";
    name = "pivy-${version}";
    src = pkgs.fetchhg {
      url = "https://bitbucket.org/Coin3D/pivy";
      rev = "8eab90908f2a3adcc414347566f4434636202344";
      sha256 = "18n14ha2d3j3ghg2f2aqnf2mks94nn7ma9ii7vkiwcay93zm82cf";
    };
    disabled = isPy3k; # Judging from SyntaxError
    buildInputs = with self; [ pkgs.swig1 pkgs.coin3d pkgs.soqt pkgs.libGLU_combined pkgs.xorg.libXi ];
  };

  smugpy = callPackage ../development/python-modules/smugpy { };

  smugline = stdenv.mkDerivation rec {
    name    = pname + "-" + version;
    pname   = "smugline";
    version = "20160106";

    src = pkgs.fetchFromGitHub {
      owner  = "gingerlime";
      repo   = pname;
      rev    = "134554c574c2d282112ba60165a8c5ffe0f16fd4";
      sha256 = "00n012ijkdrx8wsl8x3ghdcxcdp29s4kwr3yxvlyj79g5yhfvaj6";
    };

    phases = [ "unpackPhase" "installPhase" ];

    buildInputs = [ python pkgs.makeWrapper ];

    propagatedBuildInputs = with self; [ docopt requests smugpy ];

    installPhase = ''
      mkdir -p $out/bin $out/libexec
      cp smugline.py $out/libexec
      makeWrapper ${python.interpreter} $out/bin/smugline \
        --add-flags "$out/libexec/smugline.py" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    '';
  };

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
  pywbem = disabledIf isPy36
    (callPackage ../development/python-modules/pywbem { libxml2 = pkgs.libxml2; });

  unicorn = callPackage ../development/python-modules/unicorn { };

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  packaging = callPackage ../development/python-modules/packaging { };

  pytoml = callPackage ../development/python-modules/pytoml { };

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  yamllint = callPackage ../development/python-modules/yamllint { };

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

  z3 = (toPythonModule (pkgs.z3.override {
    inherit python;
  })).python;

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  foundationdb51 = (toPythonModule (pkgs.fdbPackages.override {
    inherit python;
  }).foundationdb51).python;

  foundationdb52 = (toPythonModule (pkgs.fdbPackages.override {
    inherit python;
  }).foundationdb52).python;

  foundationdb60 = (toPythonModule (pkgs.fdbPackages.override {
    inherit python;
  }).foundationdb60).python;

  libtorrentRasterbar = (toPythonModule (pkgs.libtorrentRasterbar.override {
    inherit python;
  })).python;

  libiio = (toPythonModule (pkgs.libiio.override {
    inherit python;
  })).python;

});

in fix' (extends overrides packages)
