# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Expressions for Python libraries are supposed to be in `pkgs/development/python-modules/<name>/default.nix`.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

{ pkgs
, stdenv
, lib
, python
}:

with lib;

self:

let
  inherit (self) callPackage;
  inherit (python.passthru) isPy27 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast pythonOlder;

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

  buildPythonPackage = makeOverridablePythonPackage ( makeOverridable (callPackage ../development/interpreters/python/mk-python-derivation.nix {
    inherit namePrefix;     # We want Python libraries to be named like e.g. "python3.6-${name}"
    inherit toPythonModule; # Libraries provide modules
  }));

  buildPythonApplication = makeOverridablePythonPackage ( makeOverridable (callPackage ../development/interpreters/python/mk-python-derivation.nix {
    namePrefix = "";        # Python applications should not have any prefix
    toPythonModule = x: x;  # Application does not provide modules.
  }));

  # See build-setupcfg/default.nix for documentation.
  buildSetupcfg = import ../build-support/build-setupcfg self;

  fetchPypi = callPackage ../development/interpreters/python/fetchpypi.nix { };

  # Check whether a derivation provides a Python module.
  hasPythonModule = drv: drv?pythonModule && drv.pythonModule == python;

  # Get list of required Python modules given a list of derivations.
  requiredPythonModules = drvs: let
    modules = filter hasPythonModule drvs;
  in unique ([python] ++ modules ++ concatLists (catAttrs "requiredPythonModules" modules));

  # Create a PYTHONPATH from a list of derivations. This function recurses into the items to find derivations
  # providing Python modules.
  makePythonPath = drvs: lib.makeSearchPath python.sitePackages (requiredPythonModules drvs);

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

  disabled = drv: throw "${removePythonPrefix (drv.pname or drv.name)} not supported for interpreter ${python.executable}";

  disabledIf = x: drv: if x then disabled drv else drv;

  # CUDA-related packages that are compatible with the currently packaged version
  # of TensorFlow, used to keep these versions in sync in related packages like `jaxlib`.
  tensorflow_compat_cudatoolkit = pkgs.cudatoolkit_11_2;
  tensorflow_compat_cudnn = pkgs.cudnn_cudatoolkit_11_2;
  tensorflow_compat_nccl = pkgs.nccl_cudatoolkit_11;

in {

  inherit pkgs stdenv;

  inherit (python.passthru) isPy27 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast pythonOlder;
  inherit python bootstrapped-pip buildPythonPackage buildPythonApplication;
  inherit fetchPypi;
  inherit hasPythonModule requiredPythonModules makePythonPath disabled disabledIf;
  inherit toPythonModule toPythonApplication;
  inherit buildSetupcfg;

  inherit (callPackage ../development/interpreters/python/hooks { })
    condaInstallHook
    condaUnpackHook
    eggUnpackHook
    eggBuildHook
    eggInstallHook
    flitBuildHook
    pipBuildHook
    pipInstallHook
    pytestCheckHook
    pythonCatchConflictsHook
    pythonImportsCheckHook
    pythonNamespacesHook
    pythonRecompileBytecodeHook
    pythonRemoveBinBytecodeHook
    pythonRemoveTestsDirHook
    setuptoolsBuildHook
    setuptoolsCheckHook
    venvShellHook
    wheelUnpackHook;

  # Not all packages are compatible with the latest pytest yet.
  # We need to override the hook to select an older pytest, however,
  # it should not override the version of pytest that is used for say
  # Python 2. This is an ugly hack that is needed now because the hook
  # propagates the package.
  pytestCheckHook_6_1 = if isPy3k then
    self.pytestCheckHook.override { pytest = self.pytest_6_1; }
  else
    self.pytestCheckHook;

  # helpers

  # We use build packages because we are making a setup hook to be used as a
  # native build input. The script itself references both the build-time
  # (build) and run-time (host) python from the explicitly passed in `python`
  # attribute, so the `buildPackages` doesn't effect that.
  wrapPython = pkgs.buildPackages.callPackage ../development/interpreters/python/wrap-python.nix {
    inherit python;
  };

  # Dont take pythonPackages from "global" pkgs scope to avoid mixing python versions
  pythonPackages = self;

  # specials

  recursivePthLoader = callPackage ../development/python-modules/recursive-pth-loader { };

  setuptools = callPackage ../development/python-modules/setuptools { };

  aadict = callPackage ../development/python-modules/aadict { };

  aafigure = callPackage ../development/python-modules/aafigure { };

  abodepy = callPackage ../development/python-modules/abodepy { };

  absl-py = callPackage ../development/python-modules/absl-py { };

  accuweather = callPackage ../development/python-modules/accuweather { };

  accupy = callPackage ../development/python-modules/accupy { };

  acebinf = callPackage ../development/python-modules/acebinf { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  acoustics = callPackage ../development/python-modules/acoustics { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  adafruit-platformdetect = callPackage ../development/python-modules/adafruit-platformdetect { };

  adafruit-pureio = callPackage ../development/python-modules/adafruit-pureio { };

  adal = callPackage ../development/python-modules/adal { };

  adax = callPackage ../development/python-modules/adax { };

  adax-local = callPackage ../development/python-modules/adax-local { };

  adb-enhanced = callPackage ../development/python-modules/adb-enhanced { };

  adb-homeassistant = callPackage ../development/python-modules/adb-homeassistant { };

  adb-shell = callPackage ../development/python-modules/adb-shell { };

  adblock = callPackage ../development/python-modules/adblock {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  addict = callPackage ../development/python-modules/addict { };

  addic7ed-cli = callPackage ../development/python-modules/addic7ed-cli { };

  adext = callPackage ../development/python-modules/adext { };

  adguardhome = callPackage ../development/python-modules/adguardhome { };

  adjusttext = callPackage ../development/python-modules/adjusttext { };

  advantage-air = callPackage ../development/python-modules/advantage-air { };

  aemet-opendata = callPackage ../development/python-modules/aemet-opendata { };

  aenum = callPackage ../development/python-modules/aenum { };

  afdko = callPackage ../development/python-modules/afdko { };

  affine = callPackage ../development/python-modules/affine { };

  afsapi = callPackage ../development/python-modules/afsapi { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  agent-py = callPackage ../development/python-modules/agent-py { };

  aio-geojson-client = callPackage ../development/python-modules/aio-geojson-client { };

  aio-geojson-geonetnz-quakes = callPackage ../development/python-modules/aio-geojson-geonetnz-quakes { };

  aio-geojson-geonetnz-volcano = callPackage ../development/python-modules/aio-geojson-geonetnz-volcano { };

  aio-geojson-nsw-rfs-incidents = callPackage ../development/python-modules/aio-geojson-nsw-rfs-incidents { };

  aio-georss-client = callPackage ../development/python-modules/aio-georss-client { };

  aio-georss-gdacs = callPackage ../development/python-modules/aio-georss-gdacs { };

  aioambient = callPackage ../development/python-modules/aioambient { };

  aioapns = callPackage ../development/python-modules/aioapns { };

  aiocron = callPackage ../development/python-modules/aiocron { };

  ailment = callPackage ../development/python-modules/ailment { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  aioaseko = callPackage ../development/python-modules/aioaseko { };

  aioasuswrt = callPackage ../development/python-modules/aioasuswrt { };

  aioazuredevops = callPackage ../development/python-modules/aioazuredevops { };

  aiocache = callPackage ../development/python-modules/aiocache { };

  aiocoap = callPackage ../development/python-modules/aiocoap { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiocontextvars = callPackage ../development/python-modules/aiocontextvars { };

  aiocurrencylayer = callPackage ../development/python-modules/aiocurrencylayer { };

  aiodiscover = callPackage ../development/python-modules/aiodiscover { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aioeafm = callPackage ../development/python-modules/aioeafm { };

  aioeagle = callPackage ../development/python-modules/aioeagle { };

  aioemonitor = callPackage ../development/python-modules/aioemonitor { };

  aioesphomeapi = callPackage ../development/python-modules/aioesphomeapi { };

  aioextensions = callPackage ../development/python-modules/aioextensions { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aioflo = callPackage ../development/python-modules/aioflo { };

  aioftp = callPackage ../development/python-modules/aioftp { };

  aioguardian = callPackage ../development/python-modules/aioguardian { };

  aiogithubapi = callPackage ../development/python-modules/aiogithubapi { };

  aioh2 = callPackage ../development/python-modules/aioh2 { };

  aioharmony = callPackage ../development/python-modules/aioharmony { };

  aiohomekit = callPackage ../development/python-modules/aiohomekit { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp-cors { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aiohttp-retry = callPackage ../development/python-modules/aiohttp-retry { };

  aiohttp-socks = callPackage ../development/python-modules/aiohttp-socks { };

  aiohttp-swagger = callPackage ../development/python-modules/aiohttp-swagger { };

  aiohttp-wsgi = callPackage ../development/python-modules/aiohttp-wsgi { };

  aioitertools = callPackage ../development/python-modules/aioitertools { };

  aiobotocore = callPackage ../development/python-modules/aiobotocore { };

  aiobroadlink = callPackage ../development/python-modules/aiobroadlink { };

  aiohue = callPackage ../development/python-modules/aiohue { };

  aiohwenergy = callPackage ../development/python-modules/aiohwenergy { };

  aioimaplib = callPackage ../development/python-modules/aioimaplib { };

  aioinflux = callPackage ../development/python-modules/aioinflux { };

  aiojobs = callPackage ../development/python-modules/aiojobs { };

  aiokafka = callPackage ../development/python-modules/aiokafka { };

  aiokef = callPackage ../development/python-modules/aiokef { };

  aiolookin = callPackage ../development/python-modules/aiolookin { };

  aiolifx = callPackage ../development/python-modules/aiolifx { };

  aiolifx-effects = callPackage ../development/python-modules/aiolifx-effects { };

  aiolip = callPackage ../development/python-modules/aiolip { };

  aiolyric = callPackage ../development/python-modules/aiolyric { };

  aiomodernforms = callPackage ../development/python-modules/aiomodernforms { };

  aiomultiprocess = callPackage ../development/python-modules/aiomultiprocess { };

  aiomusiccast = callPackage ../development/python-modules/aiomusiccast { };

  aiomysql = callPackage ../development/python-modules/aiomysql { };

  aionanoleaf = callPackage ../development/python-modules/aionanoleaf { };

  aionotify = callPackage ../development/python-modules/aionotify { };

  aionotion = callPackage ../development/python-modules/aionotion { };

  aiooncue = callPackage ../development/python-modules/aiooncue { };

  aiopg = callPackage ../development/python-modules/aiopg { };

  aioprocessing = callPackage ../development/python-modules/aioprocessing { };

  aiopulse = callPackage ../development/python-modules/aiopulse { };

  aiopvapi = callPackage ../development/python-modules/aiopvapi { };

  aiopvpc = callPackage ../development/python-modules/aiopvpc { };

  aiopylgtv = callPackage ../development/python-modules/aiopylgtv { };

  aiorecollect = callPackage ../development/python-modules/aiorecollect { };

  aioredis = callPackage ../development/python-modules/aioredis { };

  aioresponses = callPackage ../development/python-modules/aioresponses { };

  aioridwell = callPackage ../development/python-modules/aioridwell { };

  aiorpcx = callPackage ../development/python-modules/aiorpcx { };

  aiorun = callPackage ../development/python-modules/aiorun { };

  aiosenseme = callPackage ../development/python-modules/aiosenseme { };

  aiosenz = callPackage ../development/python-modules/aiosenz { };

  aioserial = callPackage ../development/python-modules/aioserial { };

  aioshelly = callPackage ../development/python-modules/aioshelly { };

  aiosignal = callPackage ../development/python-modules/aiosignal { };

  aiosmb = callPackage ../development/python-modules/aiosmb { };

  aiosmtpd = callPackage ../development/python-modules/aiosmtpd { };

  aiosqlite = callPackage ../development/python-modules/aiosqlite { };

  aiostream = callPackage ../development/python-modules/aiostream { };

  aioswitcher = callPackage ../development/python-modules/aioswitcher { };

  aiosyncthing = callPackage ../development/python-modules/aiosyncthing { };

  aiotractive = callPackage ../development/python-modules/aiotractive { };

  aiounifi = callPackage ../development/python-modules/aiounifi { };

  aiounittest = callPackage ../development/python-modules/aiounittest { };

  aiovlc = callPackage ../development/python-modules/aiovlc { };

  aiowatttime = callPackage ../development/python-modules/aiowatttime { };

  aiowebostv = callPackage ../development/python-modules/aiowebostv { };

  aiowinreg = callPackage ../development/python-modules/aiowinreg { };

  aioymaps = callPackage ../development/python-modules/aioymaps { };

  aiozeroconf = callPackage ../development/python-modules/aiozeroconf { };

  airly = callPackage ../development/python-modules/airly { };

  airthings-cloud = callPackage ../development/python-modules/airthings-cloud { };

  airtouch4pyapi = callPackage ../development/python-modules/airtouch4pyapi { };

  ajpy = callPackage ../development/python-modules/ajpy { };

  ajsonrpc = callPackage ../development/python-modules/ajsonrpc { };

  alabaster = callPackage ../development/python-modules/alabaster { };

  aladdin-connect = callPackage ../development/python-modules/aladdin-connect { };

  alarmdecoder = callPackage ../development/python-modules/alarmdecoder { };

  alectryon = callPackage ../development/python-modules/alectryon { };

  alembic = callPackage ../development/python-modules/alembic { };

  algebraic-data-types = callPackage ../development/python-modules/algebraic-data-types { };

  allpairspy = callPackage ../development/python-modules/allpairspy { };

  allure-python-commons = callPackage ../development/python-modules/allure-python-commons { };

  allure-python-commons-test = callPackage ../development/python-modules/allure-python-commons-test { };

  allure-pytest = callPackage ../development/python-modules/allure-pytest { };

  alpha-vantage = callPackage ../development/python-modules/alpha-vantage { };

  altair = callPackage ../development/python-modules/altair { };

  amazon_kclpy = callPackage ../development/python-modules/amazon_kclpy { };

  ambee = callPackage ../development/python-modules/ambee { };

  amberelectric = callPackage ../development/python-modules/amberelectric { };

  ambiclimate = callPackage ../development/python-modules/ambiclimate { };

  amcrest = callPackage ../development/python-modules/amcrest { };

  amiibo-py = callPackage ../development/python-modules/amiibo-py { };

  amply = callPackage ../development/python-modules/amply { };

  amqp = callPackage ../development/python-modules/amqp { };

  amqplib = callPackage ../development/python-modules/amqplib { };

  amqtt = callPackage ../development/python-modules/amqtt { };

  android-backup = callPackage ../development/python-modules/android-backup { };

  androidtv = callPackage ../development/python-modules/androidtv { };

  androguard = callPackage ../development/python-modules/androguard { };

  angr = callPackage ../development/python-modules/angr { };

  angrcli = callPackage ../development/python-modules/angrcli {
    inherit (pkgs) coreutils;
  };

  angrop = callPackage ../development/python-modules/angrop { };

  aniso8601 = callPackage ../development/python-modules/aniso8601 { };

  annexremote = callPackage ../development/python-modules/annexremote { };

  annoy = callPackage ../development/python-modules/annoy { };

  anonip = callPackage ../development/python-modules/anonip { };

  ansi2html = callPackage ../development/python-modules/ansi2html { };

  ansible = callPackage ../development/python-modules/ansible/legacy.nix { };

  ansible-base = callPackage ../development/python-modules/ansible/base.nix { };

  ansible-core = callPackage ../development/python-modules/ansible/core.nix { };

  ansible-kernel = callPackage ../development/python-modules/ansible-kernel { };

  ansible-lint = callPackage ../development/python-modules/ansible-lint { };

  ansible-runner = callPackage ../development/python-modules/ansible-runner { };

  ansi = callPackage ../development/python-modules/ansi { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  ansicolors = callPackage ../development/python-modules/ansicolors { };

  ansiconv = callPackage ../development/python-modules/ansiconv { };

  ansimarkup = callPackage ../development/python-modules/ansimarkup { };

  ansiwrap = callPackage ../development/python-modules/ansiwrap { };

  antlr4-python3-runtime = callPackage ../development/python-modules/antlr4-python3-runtime {
    inherit (pkgs) antlr4;
  };

  anyascii = callPackage ../development/python-modules/anyascii { };

  anybadge = callPackage ../development/python-modules/anybadge { };

  anyio = callPackage ../development/python-modules/anyio { };

  anyjson = callPackage ../development/python-modules/anyjson { };

  anytree = callPackage ../development/python-modules/anytree {
    inherit (pkgs) graphviz;
  };

  aocd = callPackage ../development/python-modules/aocd { };

  apache-airflow = callPackage ../development/python-modules/apache-airflow { };

  apache-beam = callPackage ../development/python-modules/apache-beam { };

  apcaccess = callPackage ../development/python-modules/apcaccess { };

  apipkg = callPackage ../development/python-modules/apipkg { };

  apispec = callPackage ../development/python-modules/apispec { };

  aplpy = callPackage ../development/python-modules/aplpy { };

  appdirs = callPackage ../development/python-modules/appdirs { };

  appleseed = toPythonModule (pkgs.appleseed.override { python3 = self.python; });

  applicationinsights = callPackage ../development/python-modules/applicationinsights { };

  appnope = callPackage ../development/python-modules/appnope { };

  apprise = callPackage ../development/python-modules/apprise { };

  approvaltests = callPackage ../development/python-modules/approvaltests { };

  apptools = callPackage ../development/python-modules/apptools { };

  appthreat-vulnerability-db = callPackage ../development/python-modules/appthreat-vulnerability-db { };

  aprslib = callPackage ../development/python-modules/aprslib { };

  APScheduler = callPackage ../development/python-modules/APScheduler { };

  apsw = callPackage ../development/python-modules/apsw { };

  apycula = callPackage ../development/python-modules/apycula { };

  aqualogic = callPackage ../development/python-modules/aqualogic { };

  arabic-reshaper = callPackage ../development/python-modules/arabic-reshaper { };

  arcam-fmj = callPackage ../development/python-modules/arcam-fmj { };

  archinfo = callPackage ../development/python-modules/archinfo { };

  area = callPackage ../development/python-modules/area { };

  arelle = callPackage ../development/python-modules/arelle {
    gui = true;
  };

  arelle-headless = callPackage ../development/python-modules/arelle {
    gui = false;
  };

  aresponses = callPackage ../development/python-modules/aresponses { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  argh = callPackage ../development/python-modules/argh { };

  argon2_cffi = callPackage ../development/python-modules/argon2_cffi { };

  args = callPackage ../development/python-modules/args { };

  aria2p = callPackage ../development/python-modules/aria2p { };

  arrayqueues = callPackage ../development/python-modules/arrayqueues { };

  arrow = callPackage ../development/python-modules/arrow { };

  arviz = callPackage ../development/python-modules/arviz { };

  arxiv2bib = callPackage ../development/python-modules/arxiv2bib { };

  asana = callPackage ../development/python-modules/asana { };

  ascii-magic = callPackage ../development/python-modules/ascii-magic { };

  asciimatics = callPackage ../development/python-modules/asciimatics { };

  asciitree = callPackage ../development/python-modules/asciitree { };

  asdf = callPackage ../development/python-modules/asdf { };

  ase = callPackage ../development/python-modules/ase { };

  asgi-csrf = callPackage ../development/python-modules/asgi-csrf { };

  asgineer = callPackage ../development/python-modules/asgineer { };

  asgiref = callPackage ../development/python-modules/asgiref { };

  asmog = callPackage ../development/python-modules/asmog { };

  asn1 = callPackage ../development/python-modules/asn1 { };

  asn1ate = callPackage ../development/python-modules/asn1ate { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  aspell-python = callPackage ../development/python-modules/aspell-python { };

  aspy-yaml = callPackage ../development/python-modules/aspy.yaml { };

  assertpy = callPackage ../development/python-modules/assertpy { };

  asteval = callPackage ../development/python-modules/asteval { };

  astor = callPackage ../development/python-modules/astor { };

  astral = callPackage ../development/python-modules/astral { };

  astroid = callPackage ../development/python-modules/astroid { };

  astropy = callPackage ../development/python-modules/astropy { };

  astropy-healpix = callPackage ../development/python-modules/astropy-healpix { };

  astropy-helpers = callPackage ../development/python-modules/astropy-helpers { };

  astropy-extension-helpers = callPackage ../development/python-modules/astropy-extension-helpers { };

  astroquery = callPackage ../development/python-modules/astroquery { };

  asttokens = callPackage ../development/python-modules/asttokens { };

  astunparse = callPackage ../development/python-modules/astunparse { };

  async_generator = callPackage ../development/python-modules/async_generator { };

  async-dns = callPackage ../development/python-modules/async-dns { };

  async-lru = callPackage ../development/python-modules/async-lru { };

  asyncclick = callPackage ../development/python-modules/asyncclick { };

  asynccmd = callPackage ../development/python-modules/asynccmd { };

  asyncio-dgram = callPackage ../development/python-modules/asyncio-dgram { };

  asyncio-mqtt = callPackage ../development/python-modules/asyncio_mqtt { };

  asyncio-rlock = callPackage ../development/python-modules/asyncio-rlock { };

  asyncmy = callPackage ../development/python-modules/asyncmy { };

  asyncio-throttle = callPackage ../development/python-modules/asyncio-throttle { };

  asyncpg = callPackage ../development/python-modules/asyncpg { };

  asyncssh = callPackage ../development/python-modules/asyncssh { };

  asyncstdlib = callPackage ../development/python-modules/asyncstdlib { };

  async_stagger = callPackage ../development/python-modules/async_stagger { };

  asynctest = callPackage ../development/python-modules/asynctest { };

  async-timeout = callPackage ../development/python-modules/async_timeout { };

  async-upnp-client = callPackage ../development/python-modules/async-upnp-client { };

  asyncwhois = callPackage ../development/python-modules/asyncwhois { };

  asysocks = callPackage ../development/python-modules/asysocks { };

  atenpdu = callPackage ../development/python-modules/atenpdu { };

  atlassian-python-api = callPackage ../development/python-modules/atlassian-python-api { };

  atom = callPackage ../development/python-modules/atom { };

  atomiclong = callPackage ../development/python-modules/atomiclong { };

  atomicwrites = callPackage ../development/python-modules/atomicwrites { };

  atomman = callPackage ../development/python-modules/atomman { };

  atpublic = callPackage ../development/python-modules/atpublic { };

  atsim_potentials = callPackage ../development/python-modules/atsim_potentials { };

  attrdict = callPackage ../development/python-modules/attrdict { };

  attrs = callPackage ../development/python-modules/attrs { };

  aubio = callPackage ../development/python-modules/aubio { };

  audio-metadata = callPackage ../development/python-modules/audio-metadata { };

  audioread = callPackage ../development/python-modules/audioread { };

  audiotools = callPackage ../development/python-modules/audiotools {
    inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox AudioUnit CoreServices;
  };

  augeas = callPackage ../development/python-modules/augeas {
    inherit (pkgs) augeas;
  };

  auroranoaa = callPackage ../development/python-modules/auroranoaa { };

  aurorapy = callPackage ../development/python-modules/aurorapy { };

  auth0-python = callPackage ../development/python-modules/auth0-python { };

  authcaptureproxy = callPackage ../development/python-modules/authcaptureproxy { };

  authheaders = callPackage ../development/python-modules/authheaders { };

  authlib = callPackage ../development/python-modules/authlib { };

  authres = callPackage ../development/python-modules/authres { };

  autobahn = callPackage ../development/python-modules/autobahn { };

  autograd = callPackage ../development/python-modules/autograd { };

  autoit-ripper = callPackage ../development/python-modules/autoit-ripper { };

  autologging = callPackage ../development/python-modules/autologging { };

  automat = callPackage ../development/python-modules/automat { };

  automate-home = callPackage ../development/python-modules/automate-home { };

  autopage = callPackage ../development/python-modules/autopage { };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  avahi = toPythonModule (pkgs.avahi.override {
    inherit python;
    withPython = true;
  });

  av = callPackage ../development/python-modules/av { };

  avea = callPackage ../development/python-modules/avea { };

  avion = callPackage ../development/python-modules/avion { };

  avro3k = callPackage ../development/python-modules/avro3k { };

  avro = callPackage ../development/python-modules/avro { };

  avro-python3 = callPackage ../development/python-modules/avro-python3 { };

  awesome-slugify = callPackage ../development/python-modules/awesome-slugify { };

  awesomeversion = callPackage ../development/python-modules/awesomeversion { };

  awkward0 = callPackage ../development/python-modules/awkward0 { };
  awkward = callPackage ../development/python-modules/awkward { };

  aws-adfs = callPackage ../development/python-modules/aws-adfs { };

  aws-lambda-builders = callPackage ../development/python-modules/aws-lambda-builders { };

  aws-sam-translator = callPackage ../development/python-modules/aws-sam-translator { };

  aws-xray-sdk = callPackage ../development/python-modules/aws-xray-sdk { };

  awscrt = callPackage ../development/python-modules/awscrt {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  awsiotpythonsdk = callPackage ../development/python-modules/awsiotpythonsdk { };

  awslambdaric = callPackage ../development/python-modules/awslambdaric { };

  axis = callPackage ../development/python-modules/axis { };

  azure-appconfiguration = callPackage ../development/python-modules/azure-appconfiguration { };

  azure-applicationinsights = callPackage ../development/python-modules/azure-applicationinsights { };

  azure-batch = callPackage ../development/python-modules/azure-batch { };

  azure-common = callPackage ../development/python-modules/azure-common { };

  azure-core = callPackage ../development/python-modules/azure-core { };

  azure-cosmos = callPackage ../development/python-modules/azure-cosmos { };

  azure-cosmosdb-nspkg = callPackage ../development/python-modules/azure-cosmosdb-nspkg { };

  azure-cosmosdb-table = callPackage ../development/python-modules/azure-cosmosdb-table { };

  azure-datalake-store = callPackage ../development/python-modules/azure-datalake-store { };

  azure-eventgrid = callPackage ../development/python-modules/azure-eventgrid { };

  azure-eventhub = callPackage ../development/python-modules/azure-eventhub { };

  azure-functions-devops-build = callPackage ../development/python-modules/azure-functions-devops-build { };

  azure-graphrbac = callPackage ../development/python-modules/azure-graphrbac { };

  azure-identity = callPackage ../development/python-modules/azure-identity { };

  azure-keyvault = callPackage ../development/python-modules/azure-keyvault { };

  azure-keyvault-administration = callPackage ../development/python-modules/azure-keyvault-administration { };

  azure-keyvault-certificates = callPackage ../development/python-modules/azure-keyvault-certificates { };

  azure-keyvault-keys = callPackage ../development/python-modules/azure-keyvault-keys { };

  azure-keyvault-nspkg = callPackage ../development/python-modules/azure-keyvault-nspkg { };

  azure-keyvault-secrets = callPackage ../development/python-modules/azure-keyvault-secrets { };

  azure-loganalytics = callPackage ../development/python-modules/azure-loganalytics { };

  azure-mgmt-advisor = callPackage ../development/python-modules/azure-mgmt-advisor { };

  azure-mgmt-apimanagement = callPackage ../development/python-modules/azure-mgmt-apimanagement { };

  azure-mgmt-appconfiguration = callPackage ../development/python-modules/azure-mgmt-appconfiguration { };

  azure-mgmt-applicationinsights = callPackage ../development/python-modules/azure-mgmt-applicationinsights { };

  azure-mgmt-authorization = callPackage ../development/python-modules/azure-mgmt-authorization { };

  azure-mgmt-batchai = callPackage ../development/python-modules/azure-mgmt-batchai { };

  azure-mgmt-batch = callPackage ../development/python-modules/azure-mgmt-batch { };

  azure-mgmt-billing = callPackage ../development/python-modules/azure-mgmt-billing { };

  azure-mgmt-botservice = callPackage ../development/python-modules/azure-mgmt-botservice { };

  azure-mgmt-cdn = callPackage ../development/python-modules/azure-mgmt-cdn { };

  azure-mgmt-cognitiveservices = callPackage ../development/python-modules/azure-mgmt-cognitiveservices { };

  azure-mgmt-commerce = callPackage ../development/python-modules/azure-mgmt-commerce { };

  azure-mgmt-common = callPackage ../development/python-modules/azure-mgmt-common { };

  azure-mgmt-compute = callPackage ../development/python-modules/azure-mgmt-compute { };

  azure-mgmt-consumption = callPackage ../development/python-modules/azure-mgmt-consumption { };

  azure-mgmt-containerinstance = callPackage ../development/python-modules/azure-mgmt-containerinstance { };

  azure-mgmt-containerregistry = callPackage ../development/python-modules/azure-mgmt-containerregistry { };

  azure-mgmt-containerservice = callPackage ../development/python-modules/azure-mgmt-containerservice { };

  azure-mgmt-core = callPackage ../development/python-modules/azure-mgmt-core { };

  azure-mgmt-cosmosdb = callPackage ../development/python-modules/azure-mgmt-cosmosdb { };

  azure-mgmt-databoxedge = callPackage ../development/python-modules/azure-mgmt-databoxedge { };

  azure-mgmt-datafactory = callPackage ../development/python-modules/azure-mgmt-datafactory { };

  azure-mgmt-datalake-analytics = callPackage ../development/python-modules/azure-mgmt-datalake-analytics { };

  azure-mgmt-datalake-nspkg = callPackage ../development/python-modules/azure-mgmt-datalake-nspkg { };

  azure-mgmt-datalake-store = callPackage ../development/python-modules/azure-mgmt-datalake-store { };

  azure-mgmt-datamigration = callPackage ../development/python-modules/azure-mgmt-datamigration { };

  azure-mgmt-deploymentmanager = callPackage ../development/python-modules/azure-mgmt-deploymentmanager { };

  azure-mgmt-devspaces = callPackage ../development/python-modules/azure-mgmt-devspaces { };

  azure-mgmt-devtestlabs = callPackage ../development/python-modules/azure-mgmt-devtestlabs { };

  azure-mgmt-dns = callPackage ../development/python-modules/azure-mgmt-dns { };

  azure-mgmt-eventgrid = callPackage ../development/python-modules/azure-mgmt-eventgrid { };

  azure-mgmt-eventhub = callPackage ../development/python-modules/azure-mgmt-eventhub { };

  azure-mgmt-extendedlocation = callPackage ../development/python-modules/azure-mgmt-extendedlocation { };

  azure-mgmt-hanaonazure = callPackage ../development/python-modules/azure-mgmt-hanaonazure { };

  azure-mgmt-hdinsight = callPackage ../development/python-modules/azure-mgmt-hdinsight { };

  azure-mgmt-imagebuilder = callPackage ../development/python-modules/azure-mgmt-imagebuilder { };

  azure-mgmt-iotcentral = callPackage ../development/python-modules/azure-mgmt-iotcentral { };

  azure-mgmt-iothub = callPackage ../development/python-modules/azure-mgmt-iothub { };

  azure-mgmt-iothubprovisioningservices = callPackage ../development/python-modules/azure-mgmt-iothubprovisioningservices { };

  azure-mgmt-keyvault = callPackage ../development/python-modules/azure-mgmt-keyvault { };

  azure-mgmt-kusto = callPackage ../development/python-modules/azure-mgmt-kusto { };

  azure-mgmt-loganalytics = callPackage ../development/python-modules/azure-mgmt-loganalytics { };

  azure-mgmt-logic = callPackage ../development/python-modules/azure-mgmt-logic { };

  azure-mgmt-machinelearningcompute = callPackage ../development/python-modules/azure-mgmt-machinelearningcompute { };

  azure-mgmt-managedservices = callPackage ../development/python-modules/azure-mgmt-managedservices { };

  azure-mgmt-managementgroups = callPackage ../development/python-modules/azure-mgmt-managementgroups { };

  azure-mgmt-managementpartner = callPackage ../development/python-modules/azure-mgmt-managementpartner { };

  azure-mgmt-maps = callPackage ../development/python-modules/azure-mgmt-maps { };

  azure-mgmt-marketplaceordering = callPackage ../development/python-modules/azure-mgmt-marketplaceordering { };

  azure-mgmt-media = callPackage ../development/python-modules/azure-mgmt-media { };

  azure-mgmt-monitor = callPackage ../development/python-modules/azure-mgmt-monitor { };

  azure-mgmt-msi = callPackage ../development/python-modules/azure-mgmt-msi { };

  azure-mgmt-netapp = callPackage ../development/python-modules/azure-mgmt-netapp { };

  azure-mgmt-network = callPackage ../development/python-modules/azure-mgmt-network { };

  azure-mgmt-notificationhubs = callPackage ../development/python-modules/azure-mgmt-notificationhubs { };

  azure-mgmt-nspkg = callPackage ../development/python-modules/azure-mgmt-nspkg { };

  azure-mgmt-policyinsights = callPackage ../development/python-modules/azure-mgmt-policyinsights { };

  azure-mgmt-powerbiembedded = callPackage ../development/python-modules/azure-mgmt-powerbiembedded { };

  azure-mgmt-privatedns = callPackage ../development/python-modules/azure-mgmt-privatedns { };

  azure-mgmt-rdbms = callPackage ../development/python-modules/azure-mgmt-rdbms { };

  azure-mgmt-recoveryservicesbackup = callPackage ../development/python-modules/azure-mgmt-recoveryservicesbackup { };

  azure-mgmt-recoveryservices = callPackage ../development/python-modules/azure-mgmt-recoveryservices { };

  azure-mgmt-redhatopenshift = callPackage ../development/python-modules/azure-mgmt-redhatopenshift { };

  azure-mgmt-redis = callPackage ../development/python-modules/azure-mgmt-redis { };

  azure-mgmt-relay = callPackage ../development/python-modules/azure-mgmt-relay { };

  azure-mgmt-reservations = callPackage ../development/python-modules/azure-mgmt-reservations { };

  azure-mgmt-resource = callPackage ../development/python-modules/azure-mgmt-resource { };

  azure-mgmt-scheduler = callPackage ../development/python-modules/azure-mgmt-scheduler { };

  azure-mgmt-search = callPackage ../development/python-modules/azure-mgmt-search { };

  azure-mgmt-security = callPackage ../development/python-modules/azure-mgmt-security { };

  azure-mgmt-servicebus = callPackage ../development/python-modules/azure-mgmt-servicebus { };

  azure-mgmt-servicefabric = callPackage ../development/python-modules/azure-mgmt-servicefabric { };

  azure-mgmt-servicefabricmanagedclusters = callPackage ../development/python-modules/azure-mgmt-servicefabricmanagedclusters { };

  azure-mgmt-servicelinker = callPackage ../development/python-modules/azure-mgmt-servicelinker { };

  azure-mgmt-signalr = callPackage ../development/python-modules/azure-mgmt-signalr { };

  azure-mgmt-sql = callPackage ../development/python-modules/azure-mgmt-sql { };

  azure-mgmt-sqlvirtualmachine = callPackage ../development/python-modules/azure-mgmt-sqlvirtualmachine { };

  azure-mgmt-storage = callPackage ../development/python-modules/azure-mgmt-storage { };

  azure-mgmt-subscription = callPackage ../development/python-modules/azure-mgmt-subscription { };

  azure-mgmt-synapse = callPackage ../development/python-modules/azure-mgmt-synapse { };

  azure-mgmt-trafficmanager = callPackage ../development/python-modules/azure-mgmt-trafficmanager { };

  azure-mgmt-web = callPackage ../development/python-modules/azure-mgmt-web { };

  azure-multiapi-storage = callPackage ../development/python-modules/azure-multiapi-storage { };

  azure-nspkg = callPackage ../development/python-modules/azure-nspkg { };

  azure-servicebus = callPackage ../development/python-modules/azure-servicebus { };

  azure-servicefabric = callPackage ../development/python-modules/azure-servicefabric { };

  azure-servicemanagement-legacy = callPackage ../development/python-modules/azure-servicemanagement-legacy { };

  azure-storage-blob = callPackage ../development/python-modules/azure-storage-blob { };

  azure-storage = callPackage ../development/python-modules/azure-storage { };

  azure-storage-common = callPackage ../development/python-modules/azure-storage-common { };

  azure-storage-file = callPackage ../development/python-modules/azure-storage-file { };

  azure-storage-file-share = callPackage ../development/python-modules/azure-storage-file-share { };

  azure-storage-nspkg = callPackage ../development/python-modules/azure-storage-nspkg { };

  azure-storage-queue = callPackage ../development/python-modules/azure-storage-queue { };

  azure-synapse-accesscontrol = callPackage ../development/python-modules/azure-synapse-accesscontrol { };

  azure-synapse-artifacts = callPackage ../development/python-modules/azure-synapse-artifacts { };

  azure-synapse-managedprivateendpoints = callPackage ../development/python-modules/azure-synapse-managedprivateendpoints { };

  azure-synapse-spark = callPackage ../development/python-modules/azure-synapse-spark { };

  b2sdk = callPackage ../development/python-modules/b2sdk { };

  Babel = callPackage ../development/python-modules/Babel { };

  babelfish = callPackage ../development/python-modules/babelfish { };

  babelgladeextractor = callPackage ../development/python-modules/babelgladeextractor { };

  backcall = callPackage ../development/python-modules/backcall { };

  backoff = callPackage ../development/python-modules/backoff { };

  backports_abc = callPackage ../development/python-modules/backports_abc { };

  backports_csv = callPackage ../development/python-modules/backports_csv { };

  backports-datetime-fromisoformat = callPackage ../development/python-modules/backports-datetime-fromisoformat { };

  backports-entry-points-selectable = callPackage ../development/python-modules/backports-entry-points-selectable { };

  backports_functools_lru_cache = callPackage ../development/python-modules/backports_functools_lru_cache { };

  backports_shutil_get_terminal_size = callPackage ../development/python-modules/backports_shutil_get_terminal_size { };

  backports-shutil-which = callPackage ../development/python-modules/backports-shutil-which { };

  backports_ssl_match_hostname = callPackage ../development/python-modules/backports_ssl_match_hostname { };

  backports_tempfile = callPackage ../development/python-modules/backports_tempfile { };

  backports_unittest-mock = callPackage ../development/python-modules/backports_unittest-mock { };

  backports_weakref = callPackage ../development/python-modules/backports_weakref { };

  backports-zoneinfo = callPackage ../development/python-modules/backports-zoneinfo { };

  bacpypes = callPackage ../development/python-modules/bacpypes { };

  bagit = callPackage ../development/python-modules/bagit { };

  banal = callPackage ../development/python-modules/banal { };

  bandit = callPackage ../development/python-modules/bandit { };

  bap = callPackage ../development/python-modules/bap {
    inherit (pkgs.ocaml-ng.ocamlPackages) bap;
  };

  baron = callPackage ../development/python-modules/baron { };

  base36 = callPackage ../development/python-modules/base36 { };

  base58 = callPackage ../development/python-modules/base58 { };

  base58check = callPackage ../development/python-modules/base58check { };

  baseline = callPackage ../development/python-modules/baseline { };

  baselines = callPackage ../development/python-modules/baselines { };

  basemap = callPackage ../development/python-modules/basemap { };

  bash_kernel = callPackage ../development/python-modules/bash_kernel { };

  bashlex = callPackage ../development/python-modules/bashlex { };

  basiciw = callPackage ../development/python-modules/basiciw { };

  batchgenerators = callPackage ../development/python-modules/batchgenerators { };

  batchspawner = callPackage ../development/python-modules/batchspawner { };

  batinfo = callPackage ../development/python-modules/batinfo { };

  bayesian-optimization = callPackage ../development/python-modules/bayesian-optimization { };

  bayespy = callPackage ../development/python-modules/bayespy { };

  bbox = callPackage ../development/python-modules/bbox { };

  bc-python-hcl2 = callPackage ../development/python-modules/bc-python-hcl2 { };

  bcdoc = callPackage ../development/python-modules/bcdoc { };

  bcrypt = callPackage ../development/python-modules/bcrypt { };

  beaker = callPackage ../development/python-modules/beaker { };

  beancount = callPackage ../development/python-modules/beancount { };

  beancount_docverif = callPackage ../development/python-modules/beancount_docverif { };

  beanstalkc = callPackage ../development/python-modules/beanstalkc { };

  beautifulsoup4 = callPackage ../development/python-modules/beautifulsoup4 { };

  beautifultable = callPackage ../development/python-modules/beautifultable { };

  bedup = callPackage ../development/python-modules/bedup { };

  behave = callPackage ../development/python-modules/behave { };

  bellows = callPackage ../development/python-modules/bellows { };

  beniget = callPackage ../development/python-modules/beniget { };

  bespon = callPackage ../development/python-modules/bespon { };

  betacode = callPackage ../development/python-modules/betacode { };

  betamax = callPackage ../development/python-modules/betamax { };

  betamax-matchers = callPackage ../development/python-modules/betamax-matchers { };

  betamax-serializers = callPackage ../development/python-modules/betamax-serializers { };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  bidict = callPackage ../development/python-modules/bidict { };

  bids-validator = callPackage ../development/python-modules/bids-validator { };

  billiard = callPackage ../development/python-modules/billiard { };

  bimmer-connected = callPackage ../development/python-modules/bimmer-connected { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  binho-host-adapter = callPackage ../development/python-modules/binho-host-adapter { };

  binwalk = callPackage ../development/python-modules/binwalk { };

  binwalk-full = appendToName "full" (self.binwalk.override {
    visualizationSupport = true;
  });

  biopython = callPackage ../development/python-modules/biopython { };

  biplist = callPackage ../development/python-modules/biplist { };

  bip_utils = callPackage ../development/python-modules/bip_utils { };

  bitarray = callPackage ../development/python-modules/bitarray { };

  bitbox02 = callPackage ../development/python-modules/bitbox02 { };

  bitcoinlib = callPackage ../development/python-modules/bitcoinlib { };

  bitcoin-price-api = callPackage ../development/python-modules/bitcoin-price-api { };

  bitcoin-utils-fork-minimal = callPackage ../development/python-modules/bitcoin-utils-fork-minimal { };

  bitcoinrpc = callPackage ../development/python-modules/bitcoinrpc { };

  bitlist = callPackage ../development/python-modules/bitlist { };

  bitmath = callPackage ../development/python-modules/bitmath { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  bitstruct = callPackage ../development/python-modules/bitstruct { };

  bitvavo-aio = callPackage ../development/python-modules/bitvavo-aio { };

  bizkaibus = callPackage ../development/python-modules/bizkaibus { };

  bjoern = callPackage ../development/python-modules/bjoern { };

  bkcharts = callPackage ../development/python-modules/bkcharts { };

  black = callPackage ../development/python-modules/black { };

  black-macchiato = callPackage ../development/python-modules/black-macchiato { };

  bleach = callPackage ../development/python-modules/bleach { };

  bleak = callPackage ../development/python-modules/bleak { };

  blebox-uniapi = callPackage ../development/python-modules/blebox-uniapi { };

  blessed = callPackage ../development/python-modules/blessed { };

  blessings = callPackage ../development/python-modules/blessings { };

  blinker = callPackage ../development/python-modules/blinker { };

  blinkpy = callPackage ../development/python-modules/blinkpy { };

  BlinkStick = callPackage ../development/python-modules/blinkstick { };

  blis = callPackage ../development/python-modules/blis { };

  blockchain = callPackage ../development/python-modules/blockchain { };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

  block-io = callPackage ../development/python-modules/block-io { };

  blocksat-cli = callPackage ../development/python-modules/blocksat-cli { };

  blspy = callPackage ../development/python-modules/blspy { };

  bluepy = callPackage ../development/python-modules/bluepy { };

  bluepy-devices = callPackage ../development/python-modules/bluepy-devices { };

  blurhash = callPackage ../development/python-modules/blurhash { };

  bme680 = callPackage ../development/python-modules/bme680 { };

  bokeh = callPackage ../development/python-modules/bokeh { };

  boltons = callPackage ../development/python-modules/boltons { };

  boltztrap2 = callPackage ../development/python-modules/boltztrap2 { };

  bond-api = callPackage ../development/python-modules/bond-api { };

  booleanoperations = callPackage ../development/python-modules/booleanoperations { };

  boolean-py = callPackage ../development/python-modules/boolean-py { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (pkgs.boost.override {
    inherit (self) python numpy;
    enablePython = true;
  });

  boost169 = toPythonModule (pkgs.boost169.override {
    inherit (self) python numpy;
    enablePython = true;
  });

  boschshcpy = callPackage ../development/python-modules/boschshcpy { };

  boost-histogram = callPackage ../development/python-modules/boost-histogram {
    inherit (pkgs) boost;
  };

  boto3 = callPackage ../development/python-modules/boto3 { };

  boto = callPackage ../development/python-modules/boto { };

  botocore = callPackage ../development/python-modules/botocore { };

  bottle = callPackage ../development/python-modules/bottle { };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  boxx = callPackage ../development/python-modules/boxx { };

  bpycv = callPackage ../development/python-modules/bpycv {};

  bpython = callPackage ../development/python-modules/bpython { };

  braceexpand = callPackage ../development/python-modules/braceexpand { };

  bracex = callPackage ../development/python-modules/bracex { };

  braintree = callPackage ../development/python-modules/braintree { };

  branca = callPackage ../development/python-modules/branca { };

  bravado-core = callPackage ../development/python-modules/bravado-core { };

  bravia-tv = callPackage ../development/python-modules/bravia-tv { };

  breathe = callPackage ../development/python-modules/breathe { };

  breezy = callPackage ../development/python-modules/breezy { };

  brelpy = callPackage ../development/python-modules/brelpy { };

  broadlink = callPackage ../development/python-modules/broadlink { };

  brother = callPackage ../development/python-modules/brother { };

  brother-ql = callPackage ../development/python-modules/brother-ql { };

  brotli = callPackage ../development/python-modules/brotli { };

  brotlicffi = callPackage ../development/python-modules/brotlicffi {
    inherit (pkgs) brotli;
  };

  brotlipy = callPackage ../development/python-modules/brotlipy { };

  brottsplatskartan = callPackage ../development/python-modules/brottsplatskartan { };

  browser-cookie3 = callPackage ../development/python-modules/browser-cookie3 { };

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  bsdiff4 = callPackage ../development/python-modules/bsdiff4 { };

  bsblan = callPackage ../development/python-modules/bsblan { };

  bson = callPackage ../development/python-modules/bson { };

  btchip = callPackage ../development/python-modules/btchip { };

  bt-proximity = callPackage ../development/python-modules/bt-proximity { };

  BTrees = callPackage ../development/python-modules/btrees { };

  btrfs = callPackage ../development/python-modules/btrfs { };

  bugsnag = callPackage ../development/python-modules/bugsnag { };

  bugwarrior = callPackage ../development/python-modules/bugwarrior { };

  bugz = callPackage ../development/python-modules/bugz { };

  bugzilla = callPackage ../development/python-modules/bugzilla { };

  buienradar = callPackage ../development/python-modules/buienradar { };

  buildbot = callPackage ../development/python-modules/buildbot { };

  buildbot-ui = self.buildbot.withPlugins (with self.buildbot-plugins; [ www ]);

  buildbot-full = self.buildbot.withPlugins (with self.buildbot-plugins; [ www console-view waterfall-view grid-view wsgi-dashboards ]);

  buildbot-pkg = callPackage ../development/python-modules/buildbot/pkg.nix { };

  buildbot-plugins = pkgs.recurseIntoAttrs (callPackage ../development/python-modules/buildbot/plugins.nix { });

  buildbot-worker = callPackage ../development/python-modules/buildbot/worker.nix { };

  build = callPackage ../development/python-modules/build { };

  buildcatrust = callPackage ../development/python-modules/buildcatrust { };

  bumps = callPackage ../development/python-modules/bumps { };

  bunch = callPackage ../development/python-modules/bunch { };

  bx-python = callPackage ../development/python-modules/bx-python { };

  bwapy = callPackage ../development/python-modules/bwapy { };

  bytecode = callPackage ../development/python-modules/bytecode { };

  bz2file = callPackage ../development/python-modules/bz2file { };

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cached-property = callPackage ../development/python-modules/cached-property { };

  cachelib = callPackage ../development/python-modules/cachelib { };

  cachetools = callPackage ../development/python-modules/cachetools { };

  cachey = callPackage ../development/python-modules/cachey { };

  cachy = callPackage ../development/python-modules/cachy { };

  cadquery = callPackage ../development/python-modules/cadquery {
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  caffe = toPythonModule (pkgs.caffe.override {
    pythonSupport = true;
    inherit (self) python numpy boost;
  });

  cairocffi = callPackage ../development/python-modules/cairocffi { };

  cairosvg = callPackage ../development/python-modules/cairosvg { };

  caldav = callPackage ../development/python-modules/caldav { };

  calmjs-parse = callPackage ../development/python-modules/calmjs-parse { };

  can = callPackage ../development/python-modules/can { };

  canmatrix = callPackage ../development/python-modules/canmatrix { };

  canonicaljson = callPackage ../development/python-modules/canonicaljson { };

  canopen = callPackage ../development/python-modules/canopen { };

  capstone = callPackage ../development/python-modules/capstone {
    inherit (pkgs) capstone;
  };

  capturer = callPackage ../development/python-modules/capturer { };

  carbon = callPackage ../development/python-modules/carbon { };

  carrot = callPackage ../development/python-modules/carrot { };

  cart = callPackage ../development/python-modules/cart { };

  cartopy = callPackage ../development/python-modules/cartopy { };

  casa-formats-io = callPackage ../development/python-modules/casa-formats-io { };

  casbin = callPackage ../development/python-modules/casbin { };

  case = callPackage ../development/python-modules/case { };

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  castepxbin = callPackage ../development/python-modules/castepxbin { };

  casttube = callPackage ../development/python-modules/casttube { };

  catalogue = callPackage ../development/python-modules/catalogue { };

  catboost = callPackage ../development/python-modules/catboost { };

  cattrs = callPackage ../development/python-modules/cattrs { };

  cbeams = callPackage ../misc/cbeams { };

  cbor2 = callPackage ../development/python-modules/cbor2 { };

  cbor = callPackage ../development/python-modules/cbor { };

  cccolutils = callPackage ../development/python-modules/cccolutils { };

  cchardet = callPackage ../development/python-modules/cchardet { };

  cdcs = callPackage ../development/python-modules/cdcs { };

  celery = callPackage ../development/python-modules/celery { };

  cement = callPackage ../development/python-modules/cement { };

  censys = callPackage ../development/python-modules/censys { };

  connect-box = callPackage ../development/python-modules/connect_box { };

  connection-pool = callPackage ../development/python-modules/connection-pool { };

  coqpit = callPackage ../development/python-modules/coqpit { };

  cepa = callPackage ../development/python-modules/cepa { };

  cerberus = callPackage ../development/python-modules/cerberus { };

  cert-chain-resolver = callPackage ../development/python-modules/cert-chain-resolver { };

  certauth = callPackage ../development/python-modules/certauth { };

  certbot = callPackage ../development/python-modules/certbot { };

  certbot-dns-cloudflare = callPackage ../development/python-modules/certbot-dns-cloudflare { };

  certbot-dns-rfc2136 = callPackage ../development/python-modules/certbot-dns-rfc2136 { };

  certbot-dns-google = callPackage ../development/python-modules/certbot-dns-google { };

  certbot-dns-route53 = callPackage ../development/python-modules/certbot-dns-route53 { };

  certifi = callPackage ../development/python-modules/certifi { };

  certipy = callPackage ../development/python-modules/certipy { };

  certvalidator = callPackage ../development/python-modules/certvalidator { };

  cffi = callPackage ../development/python-modules/cffi { };

  cffsubr = callPackage ../development/python-modules/cffsubr { };

  cfgv = callPackage ../development/python-modules/cfgv { };

  cfn-flip = callPackage ../development/python-modules/cfn-flip { };

  cfn-lint = callPackage ../development/python-modules/cfn-lint { };

  cftime = callPackage ../development/python-modules/cftime { };

  cgen = callPackage ../development/python-modules/cgen { };

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils { };

  chai = callPackage ../development/python-modules/chai { };

  chainer = callPackage ../development/python-modules/chainer {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  chainmap = callPackage ../development/python-modules/chainmap { };

  chalice = callPackage ../development/python-modules/chalice { };

  chameleon = callPackage ../development/python-modules/chameleon { };

  channels = callPackage ../development/python-modules/channels { };

  channels-redis = callPackage ../development/python-modules/channels-redis { };

  characteristic = callPackage ../development/python-modules/characteristic { };

  chardet = callPackage ../development/python-modules/chardet { };

  charset-normalizer = callPackage ../development/python-modules/charset-normalizer { };

  chart-studio = callPackage ../development/python-modules/chart-studio { };

  check-manifest = callPackage ../development/python-modules/check-manifest { };

  cheetah3 = callPackage ../development/python-modules/cheetah3 { };

  cheroot = callPackage ../development/python-modules/cheroot { };

  cherrypy = callPackage ../development/python-modules/cherrypy { };

  chess = callPackage ../development/python-modules/chess { };

  chevron = callPackage ../development/python-modules/chevron { };

  chex = callPackage ../development/python-modules/chex { };

  chiabip158 = callPackage ../development/python-modules/chiabip158 { };

  chiapos = callPackage ../development/python-modules/chiapos { };

  chiavdf = callPackage ../development/python-modules/chiavdf { };

  chirpstack-api = callPackage ../development/python-modules/chirpstack-api { };

  ci-info = callPackage ../development/python-modules/ci-info { };

  ci-py = callPackage ../development/python-modules/ci-py { };

  circuit-webhook = callPackage ../development/python-modules/circuit-webhook { };

  circuitbreaker = callPackage ../development/python-modules/circuitbreaker { };

  cirq = callPackage ../development/python-modules/cirq { };

  cirq-aqt = callPackage ../development/python-modules/cirq-aqt { };

  cirq-core = callPackage ../development/python-modules/cirq-core { };

  cirq-ionq = callPackage ../development/python-modules/cirq-ionq { };

  cirq-google = callPackage ../development/python-modules/cirq-google { };

  cirq-rigetti = callPackage ../development/python-modules/cirq-rigetti { };

  cirq-pasqal = callPackage ../development/python-modules/cirq-pasqal { };

  cirq-web = callPackage ../development/python-modules/cirq-web { };

  ciscomobilityexpress = callPackage ../development/python-modules/ciscomobilityexpress { };

  ciso8601 = callPackage ../development/python-modules/ciso8601 { };

  citeproc-py = callPackage ../development/python-modules/citeproc-py { };

  cjkwrap = callPackage ../development/python-modules/cjkwrap { };

  ckcc-protocol = callPackage ../development/python-modules/ckcc-protocol { };

  claripy = callPackage ../development/python-modules/claripy { };

  cld2-cffi = callPackage ../development/python-modules/cld2-cffi { };

  cle = callPackage ../development/python-modules/cle { };

  cleo = callPackage ../development/python-modules/cleo { };

  clevercsv = callPackage ../development/python-modules/clevercsv { };

  clf = callPackage ../development/python-modules/clf { };

  cock = callPackage ../development/python-modules/cock { };

  click = callPackage ../development/python-modules/click { };

  clickclick = callPackage ../development/python-modules/clickclick { };

  click-completion = callPackage ../development/python-modules/click-completion { };

  click-configfile = callPackage ../development/python-modules/click-configfile { };

  click-datetime = callPackage ../development/python-modules/click-datetime { };

  click-default-group = callPackage ../development/python-modules/click-default-group { };

  click-didyoumean = callPackage ../development/python-modules/click-didyoumean { };

  click-help-colors = callPackage ../development/python-modules/click-help-colors { };

  click-log = callPackage ../development/python-modules/click-log { };

  click-option-group = callPackage ../development/python-modules/click-option-group { };

  click-plugins = callPackage ../development/python-modules/click-plugins { };

  click-spinner = callPackage ../development/python-modules/click-spinner { };

  click-repl = callPackage ../development/python-modules/click-repl { };

  click-threading = callPackage ../development/python-modules/click-threading { };

  clickgen = callPackage ../development/python-modules/clickgen { };

  clickhouse-cityhash = callPackage ../development/python-modules/clickhouse-cityhash { };

  clickhouse-cli = callPackage ../development/python-modules/clickhouse-cli { };

  clickhouse-driver = callPackage ../development/python-modules/clickhouse-driver { };

  cliff = callPackage ../development/python-modules/cliff { };

  clifford = callPackage ../development/python-modules/clifford { };

  cligj = callPackage ../development/python-modules/cligj { };

  cli-helpers = callPackage ../development/python-modules/cli-helpers { };

  clikit = callPackage ../development/python-modules/clikit { };

  clint = callPackage ../development/python-modules/clint { };

  clintermission = callPackage ../development/python-modules/clintermission { };

  clize = callPackage ../development/python-modules/clize { };

  clldutils = callPackage ../development/python-modules/clldutils { };

  cloudflare = callPackage ../development/python-modules/cloudflare { };

  cloudpickle = callPackage ../development/python-modules/cloudpickle { };

  cloudscraper = callPackage ../development/python-modules/cloudscraper { };

  cloudsmith-api = callPackage ../development/python-modules/cloudsmith-api { };

  cloudsplaining = callPackage ../development/python-modules/cloudsplaining { };

  clustershell = callPackage ../development/python-modules/clustershell { };

  clvm = callPackage ../development/python-modules/clvm { };

  clvm-rs = callPackage ../development/python-modules/clvm-rs { };

  clvm-tools = callPackage ../development/python-modules/clvm-tools { };

  cma = callPackage ../development/python-modules/cma { };

  cmarkgfm = callPackage ../development/python-modules/cmarkgfm { };

  cmd2 = callPackage ../development/python-modules/cmd2 { };

  cmdline = callPackage ../development/python-modules/cmdline { };

  cmigemo = callPackage ../development/python-modules/cmigemo {
    inherit (pkgs) cmigemo;
  };

  cmsis-svd = callPackage ../development/python-modules/cmsis-svd { };

  cntk = callPackage ../development/python-modules/cntk { };

  cnvkit = callPackage ../development/python-modules/cnvkit { };

  co2signal = callPackage ../development/python-modules/co2signal { };

  coapthon3 = callPackage ../development/python-modules/coapthon3 { };

  coconut = callPackage ../development/python-modules/coconut { };

  cocotb = callPackage ../development/python-modules/cocotb { };

  cocotb-bus = callPackage ../development/python-modules/cocotb-bus { };

  codecov = callPackage ../development/python-modules/codecov { };

  codespell = callPackage ../development/python-modules/codespell { };

  cogapp = callPackage ../development/python-modules/cogapp { };

  ColanderAlchemy = callPackage ../development/python-modules/colanderalchemy { };

  colander = callPackage ../development/python-modules/colander { };

  collections-extended = callPackage ../development/python-modules/collections-extended { };

  colorama = callPackage ../development/python-modules/colorama { };

  colorcet = callPackage ../development/python-modules/colorcet { };

  colorclass = callPackage ../development/python-modules/colorclass { };

  colored = callPackage ../development/python-modules/colored { };

  colored-traceback = callPackage ../development/python-modules/colored-traceback { };

  coloredlogs = callPackage ../development/python-modules/coloredlogs { };

  colorful = callPackage ../development/python-modules/colorful { };

  colorlog = callPackage ../development/python-modules/colorlog { };

  colorlover = callPackage ../development/python-modules/colorlover { };

  colormath = callPackage ../development/python-modules/colormath { };

  colorspacious = callPackage ../development/python-modules/colorspacious { };

  colorthief = callPackage ../development/python-modules/colorthief { };

  colour = callPackage ../development/python-modules/colour { };

  cometblue-lite = callPackage ../development/python-modules/cometblue-lite { };

  commandparse = callPackage ../development/python-modules/commandparse { };

  commentjson = callPackage ../development/python-modules/commentjson { };

  commoncode = callPackage ../development/python-modules/commoncode { };

  CommonMark = callPackage ../development/python-modules/commonmark { };

  compiledb = callPackage ../development/python-modules/compiledb { };

  compreffor = callPackage ../development/python-modules/compreffor { };

  concurrent-log-handler = callPackage ../development/python-modules/concurrent-log-handler { };

  conda = callPackage ../development/python-modules/conda { };

  configargparse = callPackage ../development/python-modules/configargparse { };

  configobj = callPackage ../development/python-modules/configobj { };

  configparser = callPackage ../development/python-modules/configparser { };

  configshell = callPackage ../development/python-modules/configshell { };

  confluent-kafka = callPackage ../development/python-modules/confluent-kafka { };

  confuse = callPackage ../development/python-modules/confuse { };

  confight = callPackage ../development/python-modules/confight { };

  connexion = callPackage ../development/python-modules/connexion { };

  consonance = callPackage ../development/python-modules/consonance { };

  constantly = callPackage ../development/python-modules/constantly { };

  construct = callPackage ../development/python-modules/construct { };

  consul = callPackage ../development/python-modules/consul { };

  contexter = callPackage ../development/python-modules/contexter { };

  contextlib2 = callPackage ../development/python-modules/contextlib2 { };

  contextvars = callPackage ../development/python-modules/contextvars { };

  convertdate = callPackage ../development/python-modules/convertdate { };

  cookiecutter = callPackage ../development/python-modules/cookiecutter { };

  cookies = callPackage ../development/python-modules/cookies { };

  coordinates = callPackage ../development/python-modules/coordinates { };

  coreapi = callPackage ../development/python-modules/coreapi { };

  coreschema = callPackage ../development/python-modules/coreschema { };

  cornice = callPackage ../development/python-modules/cornice { };

  coronavirus = callPackage ../development/python-modules/coronavirus { };

  corsair-scan = callPackage ../development/python-modules/corsair-scan { };

  cot = callPackage ../development/python-modules/cot { };

  covCore = callPackage ../development/python-modules/cov-core { };

  coverage = callPackage ../development/python-modules/coverage { };

  coveralls = callPackage ../development/python-modules/coveralls { };

  cppe = callPackage ../development/python-modules/cppe {
    cppe = pkgs.cppe;
  };

  cppheaderparser = callPackage ../development/python-modules/cppheaderparser { };

  cppy = callPackage ../development/python-modules/cppy { };

  cpyparsing = callPackage ../development/python-modules/cpyparsing { };

  cram = callPackage ../development/python-modules/cram { };

  cramjam = callPackage ../development/python-modules/cramjam { };

  crashtest = callPackage ../development/python-modules/crashtest { };

  crate = callPackage ../development/python-modules/crate { };

  crayons = callPackage ../development/python-modules/crayons { };

  crc16 = callPackage ../development/python-modules/crc16 { };

  crc32c = callPackage ../development/python-modules/crc32c { };

  crccheck = callPackage ../development/python-modules/crccheck { };

  crcmod = callPackage ../development/python-modules/crcmod { };

  credstash = callPackage ../development/python-modules/credstash { };

  criticality-score = callPackage ../development/python-modules/criticality-score { };

  croniter = callPackage ../development/python-modules/croniter { };

  crownstone-cloud = callPackage ../development/python-modules/crownstone-cloud { };

  crownstone-core = callPackage ../development/python-modules/crownstone-core { };

  crownstone-sse = callPackage ../development/python-modules/crownstone-sse { };

  crownstone-uart = callPackage ../development/python-modules/crownstone-uart { };

  cryptacular = callPackage ../development/python-modules/cryptacular { };

  cryptography = callPackage ../development/python-modules/cryptography {
    inherit (pkgs.darwin) libiconv;
  };

  cryptography_vectors = callPackage ../development/python-modules/cryptography/vectors.nix { };

  crytic-compile = callPackage ../development/python-modules/crytic-compile { };

  csrmesh  = callPackage ../development/python-modules/csrmesh { };

  csscompressor = callPackage ../development/python-modules/csscompressor { };

  cssmin = callPackage ../development/python-modules/cssmin { };

  css-html-js-minify = callPackage ../development/python-modules/css-html-js-minify { };

  css-parser = callPackage ../development/python-modules/css-parser { };

  cssselect2 = callPackage ../development/python-modules/cssselect2 { };

  cssselect = callPackage ../development/python-modules/cssselect { };

  cssutils = callPackage ../development/python-modules/cssutils { };

  csvw = callPackage ../development/python-modules/csvw { };

  cucumber-tag-expressions = callPackage ../development/python-modules/cucumber-tag-expressions { };

  cufflinks = callPackage ../development/python-modules/cufflinks { };

  cupy = callPackage ../development/python-modules/cupy {
    cudatoolkit = pkgs.cudatoolkit_11;
    cudnn = pkgs.cudnn_cudatoolkit_11;
    nccl = pkgs.nccl_cudatoolkit_11;
    cutensor = pkgs.cutensor_cudatoolkit_11;
  };

  curio = callPackage ../development/python-modules/curio { };

  curtsies = callPackage ../development/python-modules/curtsies { };

  curve25519-donna = callPackage ../development/python-modules/curve25519-donna { };

  cvxopt = callPackage ../development/python-modules/cvxopt { };

  cvxpy = callPackage ../development/python-modules/cvxpy { };

  cwcwidth = callPackage ../development/python-modules/cwcwidth { };

  cx_Freeze = callPackage ../development/python-modules/cx_freeze { };

  cx_oracle = callPackage ../development/python-modules/cx_oracle { };

  cxxfilt = callPackage ../development/python-modules/cxxfilt { };

  cycler = callPackage ../development/python-modules/cycler { };

  cyclonedx-python-lib = callPackage ../development/python-modules/cyclonedx-python-lib { };

  cymem = callPackage ../development/python-modules/cymem { };

  cypari2 = callPackage ../development/python-modules/cypari2 { };

  cysignals = callPackage ../development/python-modules/cysignals { };

  cython = callPackage ../development/python-modules/Cython { };

  cytoolz = callPackage ../development/python-modules/cytoolz { };

  d2to1 = callPackage ../development/python-modules/d2to1 { };

  dacite = callPackage ../development/python-modules/dacite { };

  daemonize = callPackage ../development/python-modules/daemonize { };

  daemonocle = callPackage ../development/python-modules/daemonocle { };

  daphne = callPackage ../development/python-modules/daphne { };

  dash = callPackage ../development/python-modules/dash { };

  dash-core-components = callPackage ../development/python-modules/dash-core-components { };

  dash-html-components = callPackage ../development/python-modules/dash-html-components { };

  dash-renderer = callPackage ../development/python-modules/dash-renderer { };

  dash-table = callPackage ../development/python-modules/dash-table { };

  dask = callPackage ../development/python-modules/dask { };

  dask-gateway = callPackage ../development/python-modules/dask-gateway { };

  dask-gateway-server = callPackage ../development/python-modules/dask-gateway-server { };

  dask-glm = callPackage ../development/python-modules/dask-glm { };

  dask-image = callPackage ../development/python-modules/dask-image { };

  dask-jobqueue = callPackage ../development/python-modules/dask-jobqueue { };

  dask-ml = callPackage ../development/python-modules/dask-ml { };

  dask-mpi = callPackage ../development/python-modules/dask-mpi { };

  dask-xgboost = callPackage ../development/python-modules/dask-xgboost { };

  databases = callPackage ../development/python-modules/databases { };

  databricks-cli = callPackage ../development/python-modules/databricks-cli { };

  databricks-connect = callPackage ../development/python-modules/databricks-connect { };

  dataclasses = callPackage ../development/python-modules/dataclasses { };

  dataclasses-json = callPackage ../development/python-modules/dataclasses-json { };

  datadiff = callPackage ../development/python-modules/datadiff { };

  datadog = callPackage ../development/python-modules/datadog { };

  datafusion = callPackage ../development/python-modules/datafusion { };

  datamodeldict = callPackage ../development/python-modules/datamodeldict { };

  dataset = callPackage ../development/python-modules/dataset { };

  datasets = callPackage ../development/python-modules/datasets { };

  datasette = callPackage ../development/python-modules/datasette { };

  datasette-template-sql = callPackage ../development/python-modules/datasette-template-sql { };

  datashader = callPackage ../development/python-modules/datashader {
    dask = self.dask.override { withExtraComplete = true; };
  };

  datashape = callPackage ../development/python-modules/datashape { };

  datatable = callPackage ../development/python-modules/datatable { };

  dateparser = callPackage ../development/python-modules/dateparser { };

  dateutils = callPackage ../development/python-modules/dateutils { };

  datrie = callPackage ../development/python-modules/datrie { };

  dawg-python = callPackage ../development/python-modules/dawg-python { };

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  dbus-next = callPackage ../development/python-modules/dbus-next { };

  dbus-python = callPackage ../development/python-modules/dbus {
    inherit (pkgs) dbus;
  };

  dbutils = callPackage ../development/python-modules/dbutils { };

  dcmstack = callPackage ../development/python-modules/dcmstack { };

  ddt = callPackage ../development/python-modules/ddt { };

  deap = callPackage ../development/python-modules/deap { };

  debian = callPackage ../development/python-modules/debian { };

  debian-inspector = callPackage ../development/python-modules/debian-inspector { };

  debtcollector = callPackage ../development/python-modules/debtcollector { };

  debts = callPackage ../development/python-modules/debts { };

  debugpy = callPackage ../development/python-modules/debugpy { };

  decli = callPackage ../development/python-modules/decli { };

  decorator = callPackage ../development/python-modules/decorator { };

  decopatch = callPackage ../development/python-modules/decopatch { };

  deemix = callPackage ../development/python-modules/deemix { };

  deep_merge = callPackage ../development/python-modules/deep_merge { };

  deepdiff = callPackage ../development/python-modules/deepdiff { };

  deepdish = callPackage ../development/python-modules/deepdish { };

  deepmerge = callPackage ../development/python-modules/deepmerge { };

  deeptoolsintervals = callPackage ../development/python-modules/deeptoolsintervals { };

  deep-translator = callPackage ../development/python-modules/deep-translator { };

  deezer-py = callPackage ../development/python-modules/deezer-py { };

  deezer-python = callPackage ../development/python-modules/deezer-python { };

  defcon = callPackage ../development/python-modules/defcon { };

  deform = callPackage ../development/python-modules/deform { };

  defusedxml = callPackage ../development/python-modules/defusedxml { };

  delegator-py = callPackage ../development/python-modules/delegator-py { };

  delorean = callPackage ../development/python-modules/delorean { };

  deltachat = callPackage ../development/python-modules/deltachat { };

  deluge-client = callPackage ../development/python-modules/deluge-client { };

  demjson = callPackage ../development/python-modules/demjson { };

  demjson3 = callPackage ../development/python-modules/demjson3 { };

  dendropy = callPackage ../development/python-modules/dendropy { };

  denonavr = callPackage ../development/python-modules/denonavr { };

  dependency-injector = callPackage ../development/python-modules/dependency-injector { };

  deprecated = callPackage ../development/python-modules/deprecated { };

  deprecation = callPackage ../development/python-modules/deprecation { };

  derpconf = callPackage ../development/python-modules/derpconf { };

  descartes = callPackage ../development/python-modules/descartes { };

  desktop-notifier = callPackage ../development/python-modules/desktop-notifier { };

  detect-secrets = callPackage ../development/python-modules/detect-secrets { };

  devolo-home-control-api = callPackage ../development/python-modules/devolo-home-control-api { };

  devolo-plc-api = callPackage ../development/python-modules/devolo-plc-api { };

  devpi-common = callPackage ../development/python-modules/devpi-common { };

  devtools = callPackage ../development/python-modules/devtools { };

  diagrams = callPackage ../development/python-modules/diagrams { };

  diceware = callPackage ../development/python-modules/diceware { };

  dicom2nifti = callPackage ../development/python-modules/dicom2nifti { };

  dict2xml = callPackage ../development/python-modules/dict2xml { };

  dictdiffer = callPackage ../development/python-modules/dictdiffer { };

  dictionaries = callPackage ../development/python-modules/dictionaries { };

  dictpath = callPackage ../development/python-modules/dictpath { };

  dicttoxml = callPackage ../development/python-modules/dicttoxml { };

  diff-cover = callPackage ../development/python-modules/diff-cover { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  digital-ocean = callPackage ../development/python-modules/digitalocean { };

  digi-xbee = callPackage ../development/python-modules/digi-xbee { };

  dill = callPackage ../development/python-modules/dill { };

  dingz = callPackage ../development/python-modules/dingz { };

  diofant = callPackage ../development/python-modules/diofant { };

  dipy = callPackage ../development/python-modules/dipy { };

  directv = callPackage ../development/python-modules/directv { };

  discid = callPackage ../development/python-modules/discid { };

  discogs-client = callPackage ../development/python-modules/discogs-client { };

  discordpy = callPackage ../development/python-modules/discordpy { };

  diskcache = callPackage ../development/python-modules/diskcache { };

  dissononce = callPackage ../development/python-modules/dissononce { };

  distlib = callPackage ../development/python-modules/distlib { };

  distorm3 = callPackage ../development/python-modules/distorm3 { };

  distributed = callPackage ../development/python-modules/distributed { };

  distro = callPackage ../development/python-modules/distro { };

  distutils_extra = callPackage ../development/python-modules/distutils_extra { };

  django = self.django_2;

  # Current LTS
  django_2 = callPackage ../development/python-modules/django/2.nix { };
  django_3 = callPackage ../development/python-modules/django/3.nix { };

  # Current latest
  django_4 = callPackage ../development/python-modules/django/4.nix { };

  django-allauth = callPackage ../development/python-modules/django-allauth { };

  django-anymail = callPackage ../development/python-modules/django-anymail { };

  django_appconf = callPackage ../development/python-modules/django_appconf { };

  django-auth-ldap = callPackage ../development/python-modules/django-auth-ldap { };

  django-cache-url = callPackage ../development/python-modules/django-cache-url { };

  django-cacheops = callPackage ../development/python-modules/django-cacheops { };

  django_classytags = callPackage ../development/python-modules/django_classytags { };

  django-cleanup = callPackage ../development/python-modules/django-cleanup { };

  django_colorful = callPackage ../development/python-modules/django_colorful { };

  django_compat = callPackage ../development/python-modules/django-compat { };

  django_compressor = callPackage ../development/python-modules/django_compressor { };

  django-configurations = callPackage ../development/python-modules/django-configurations { };

  django_contrib_comments = callPackage ../development/python-modules/django_contrib_comments { };

  django-cors-headers = callPackage ../development/python-modules/django-cors-headers { };

  django-csp = callPackage ../development/python-modules/django-csp { };

  django-debug-toolbar = callPackage ../development/python-modules/django-debug-toolbar { };

  django-discover-runner = callPackage ../development/python-modules/django-discover-runner { };

  django-dynamic-preferences = callPackage ../development/python-modules/django-dynamic-preferences { };

  django-environ = callPackage ../development/python-modules/django_environ { };

  django-extensions = callPackage ../development/python-modules/django-extensions { };

  django-filter = callPackage ../development/python-modules/django-filter { };

  django-formtools = callPackage ../development/python-modules/django-formtools { };

  django-graphiql-debug-toolbar = callPackage ../development/python-modules/django-graphiql-debug-toolbar { };

  django-gravatar2 = callPackage ../development/python-modules/django-gravatar2 { };

  django_guardian = callPackage ../development/python-modules/django_guardian { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  django_hijack_admin = callPackage ../development/python-modules/django-hijack-admin { };

  django_hijack = callPackage ../development/python-modules/django-hijack { };
  # This package may need an older version of Django. Override the package set and set e.g. `django = super.django_1_9`. See the Nixpkgs manual for examples on how to override the package set.

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-js-asset = callPackage ../development/python-modules/django-js-asset { };

  django-logentry-admin = callPackage ../development/python-modules/django-logentry-admin { };

  django-mailman3 = callPackage ../development/python-modules/django-mailman3 { };

  django_modelcluster = callPackage ../development/python-modules/django_modelcluster { };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  django-maintenance-mode = callPackage ../development/python-modules/django-maintenance-mode { };

  django-mptt = callPackage ../development/python-modules/django-mptt { };

  django_nose = callPackage ../development/python-modules/django_nose { };

  django-oauth-toolkit = callPackage ../development/python-modules/django-oauth-toolkit { };

  django-paintstore = callPackage ../development/python-modules/django-paintstore { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django_polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-postgresql-netfields = callPackage ../development/python-modules/django-postgresql-netfields { };

  django-prometheus = callPackage ../development/python-modules/django-prometheus { };

  django-q = callPackage ../development/python-modules/django-q { };

  djangoql = callPackage ../development/python-modules/djangoql { };

  django-ranged-response = callPackage ../development/python-modules/django-ranged-response { };

  django-raster = callPackage ../development/python-modules/django-raster { };

  django-redis = callPackage ../development/python-modules/django-redis { };

  django-rest-auth = callPackage ../development/python-modules/django-rest-auth { };

  django-rq = callPackage ../development/python-modules/django-rq { };

  djangorestframework = callPackage ../development/python-modules/djangorestframework { };

  djangorestframework-simplejwt = callPackage ../development/python-modules/djangorestframework-simplejwt { };

  django_reversion = callPackage ../development/python-modules/django_reversion { };

  django-sampledatahelper = callPackage ../development/python-modules/django-sampledatahelper { };

  django-sesame = callPackage ../development/python-modules/django-sesame { };

  django_silk = callPackage ../development/python-modules/django_silk { };

  django-simple-captcha = callPackage ../development/python-modules/django-simple-captcha { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django-statici18n = callPackage ../development/python-modules/django-statici18n { };

  django-storages = callPackage ../development/python-modules/django-storages { };

  django-tables2 = callPackage ../development/python-modules/django-tables2 { };

  django_tagging = callPackage ../development/python-modules/django_tagging { };

  django-taggit = callPackage ../development/python-modules/django-taggit { };

  django-timezone-field = callPackage ../development/python-modules/django-timezone-field { };

  django_treebeard = callPackage ../development/python-modules/django_treebeard { };

  django-versatileimagefield = callPackage ../development/python-modules/django-versatileimagefield { };

  django-webpack-loader = callPackage ../development/python-modules/django-webpack-loader { };

  django-widget-tweaks = callPackage ../development/python-modules/django-widget-tweaks { };

  dj-database-url = callPackage ../development/python-modules/dj-database-url { };

  dj-email-url = callPackage ../development/python-modules/dj-email-url { };

  djmail = callPackage ../development/python-modules/djmail { };

  dj-search-url = callPackage ../development/python-modules/dj-search-url { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  dlib = callPackage ../development/python-modules/dlib {
    inherit (pkgs) dlib;
  };

  dlx = callPackage ../development/python-modules/dlx { };

  dmenu-python = callPackage ../development/python-modules/dmenu { };

  dm-haiku = callPackage ../development/python-modules/dm-haiku { };

  dm-sonnet = callPackage ../development/python-modules/dm-sonnet { };

  dm-tree = callPackage ../development/python-modules/dm-tree { };

  dnachisel = callPackage ../development/python-modules/dnachisel { };

  dnslib = callPackage ../development/python-modules/dnslib { };

  dnspython = callPackage ../development/python-modules/dnspython { };

  dnspythonchia = callPackage ../development/python-modules/dnspythonchia { };

  doc8 = callPackage ../development/python-modules/doc8 { };

  docker = callPackage ../development/python-modules/docker { };

  dockerfile-parse = callPackage ../development/python-modules/dockerfile-parse { };

  dockerpty = callPackage ../development/python-modules/dockerpty { };

  docker_pycreds = callPackage ../development/python-modules/docker-pycreds { };

  docker-py = callPackage ../development/python-modules/docker-py { };

  dockerspawner = callPackage ../development/python-modules/dockerspawner { };

  docloud = callPackage ../development/python-modules/docloud { };

  docstring-to-markdown = callPackage ../development/python-modules/docstring-to-markdown { };

  docstring-parser = callPackage ../development/python-modules/docstring-parser { };

  docopt = callPackage ../development/python-modules/docopt { };

  docopt-ng = callPackage ../development/python-modules/docopt-ng { };

  docplex = callPackage ../development/python-modules/docplex { };

  docrep = callPackage ../development/python-modules/docrep { };

  doctest-ignore-unicode = callPackage ../development/python-modules/doctest-ignore-unicode { };

  docutils = callPackage ../development/python-modules/docutils { };

  docx2python = callPackage ../development/python-modules/docx2python { };

  dodgy = callPackage ../development/python-modules/dodgy { };

  dogpile-cache = callPackage ../development/python-modules/dogpile-cache { };

  dogtail = callPackage ../development/python-modules/dogtail { };

  doit = callPackage ../development/python-modules/doit { };

  dominate = callPackage ../development/python-modules/dominate { };

  doorbirdpy = callPackage ../development/python-modules/doorbirdpy { };

  dopy = callPackage ../development/python-modules/dopy { };

  dotty-dict = callPackage ../development/python-modules/dotty-dict { };

  dot2tex = callPackage ../development/python-modules/dot2tex {
    inherit (pkgs) graphviz;
  };

  dotmap = callPackage ../development/python-modules/dotmap { };

  downloader-cli = callPackage ../development/python-modules/downloader-cli { };

  dparse = callPackage ../development/python-modules/dparse { };

  dpath = callPackage ../development/python-modules/dpath { };

  dpkt = callPackage ../development/python-modules/dpkt { };

  dragonfly = callPackage ../development/python-modules/dragonfly { };

  drf-jwt = callPackage ../development/python-modules/drf-jwt { };

  drf-nested-routers = callPackage ../development/python-modules/drf-nested-routers { };

  drf-yasg = callPackage ../development/python-modules/drf-yasg { };

  drivelib = callPackage ../development/python-modules/drivelib { };

  drms = callPackage ../development/python-modules/drms { };

  dropbox = callPackage ../development/python-modules/dropbox { };

  ds-store = callPackage ../development/python-modules/ds-store { };

  ds4drv = callPackage ../development/python-modules/ds4drv { };

  dsmr-parser = callPackage ../development/python-modules/dsmr-parser { };

  dtlssocket = callPackage ../development/python-modules/dtlssocket { };

  duckdb = callPackage ../development/python-modules/duckdb {
    inherit (pkgs) duckdb;
  };

  duecredit = callPackage ../development/python-modules/duecredit { };

  duet = callPackage ../development/python-modules/duet { };

  dufte = callPackage ../development/python-modules/dufte { };

  dugong = callPackage ../development/python-modules/dugong { };

  dulwich = callPackage ../development/python-modules/dulwich { };

  dungeon-eos = callPackage ../development/python-modules/dungeon-eos { };

  dwdwfsapi = callPackage ../development/python-modules/dwdwfsapi { };

  dyn = callPackage ../development/python-modules/dyn { };

  dynd = callPackage ../development/python-modules/dynd { };

  easydict = callPackage ../development/python-modules/easydict { };

  easygui = callPackage ../development/python-modules/easygui { };

  EasyProcess = callPackage ../development/python-modules/easyprocess { };

  easysnmp = callPackage ../development/python-modules/easysnmp { };

  easy-thumbnails = callPackage ../development/python-modules/easy-thumbnails { };

  easywatch = callPackage ../development/python-modules/easywatch { };

  ebaysdk = callPackage ../development/python-modules/ebaysdk { };

  ec2instanceconnectcli = callPackage ../tools/virtualization/ec2instanceconnectcli { };

  eccodes = toPythonModule (pkgs.eccodes.override {
    enablePython = true;
    pythonPackages = self;
  });

  ecdsa = callPackage ../development/python-modules/ecdsa { };

  ecoaliface = callPackage ../development/python-modules/ecoaliface { };

  ecos = callPackage ../development/python-modules/ecos { };

  ecpy = callPackage ../development/python-modules/ecpy { };

  ecs-logging =  callPackage ../development/python-modules/ecs-logging { };

  ed25519 = callPackage ../development/python-modules/ed25519 { };

  editables = callPackage ../development/python-modules/editables { };

  editdistance = callPackage ../development/python-modules/editdistance { };

  editdistance-s = callPackage ../development/python-modules/editdistance-s { };

  editorconfig = callPackage ../development/python-modules/editorconfig { };

  edward = callPackage ../development/python-modules/edward { };

  effect = callPackage ../development/python-modules/effect { };

  eggdeps = callPackage ../development/python-modules/eggdeps { };

  einops = callPackage ../development/python-modules/einops { };

  elgato = callPackage ../development/python-modules/elgato { };

  elkm1-lib = callPackage ../development/python-modules/elkm1-lib { };

  elastic-apm = callPackage ../development/python-modules/elastic-apm { };

  elasticsearch = callPackage ../development/python-modules/elasticsearch { };

  elasticsearch-dsl = callPackage ../development/python-modules/elasticsearch-dsl { };

  elasticsearchdsl = self.elasticsearch-dsl;

  elegy = callPackage ../development/python-modules/elegy { };

  elementpath = callPackage ../development/python-modules/elementpath { };

  elevate = callPackage ../development/python-modules/elevate { };

  eliot = callPackage ../development/python-modules/eliot { };

  eliqonline = callPackage ../development/python-modules/eliqonline { };

  elmax = callPackage ../development/python-modules/elmax { };

  elmax-api = callPackage ../development/python-modules/elmax-api { };

  emailthreads = callPackage ../development/python-modules/emailthreads { };

  email_validator = callPackage ../development/python-modules/email-validator { };

  embrace = callPackage ../development/python-modules/embrace { };

  emcee = callPackage ../development/python-modules/emcee { };

  emv = callPackage ../development/python-modules/emv { };

  emoji = callPackage ../development/python-modules/emoji { };

  empy = callPackage ../development/python-modules/empy { };

  emulated-roku = callPackage ../development/python-modules/emulated-roku { };

  enaml = callPackage ../development/python-modules/enaml { };

  enamlx = callPackage ../development/python-modules/enamlx { };

  enlighten = callPackage ../development/python-modules/enlighten { };

  enocean = callPackage ../development/python-modules/enocean { };

  enrich = callPackage ../development/python-modules/enrich { };

  entrance = callPackage ../development/python-modules/entrance {
    routerFeatures = false;
  };

  entrance-with-router-features = callPackage ../development/python-modules/entrance {
    routerFeatures = true;
  };

  entry-points-txt = callPackage ../development/python-modules/entry-points-txt { };

  entrypoint2 = callPackage ../development/python-modules/entrypoint2 { };

  entrypoints = callPackage ../development/python-modules/entrypoints { };

  enturclient = callPackage ../development/python-modules/enturclient { };

  enum34 = callPackage ../development/python-modules/enum34 { };

  enum-compat = callPackage ../development/python-modules/enum-compat { };

  env-canada = callPackage ../development/python-modules/env-canada { };

  environmental-override = callPackage ../development/python-modules/environmental-override { };

  environs = callPackage ../development/python-modules/environs { };

  envisage = callPackage ../development/python-modules/envisage { };

  envs = callPackage ../development/python-modules/envs { };

  envoy-reader = callPackage ../development/python-modules/envoy-reader { };

  envoy-utils = callPackage ../development/python-modules/envoy-utils { };

  enzyme = callPackage ../development/python-modules/enzyme { };

  epc = callPackage ../development/python-modules/epc { };

  ephem = callPackage ../development/python-modules/ephem { };

  epson-projector = callPackage ../development/python-modules/epson-projector { };

  eradicate = callPackage ../development/python-modules/eradicate { };

  esprima = callPackage ../development/python-modules/esprima { };

  escapism = callPackage ../development/python-modules/escapism { };

  etcd = callPackage ../development/python-modules/etcd { };

  etelemetry = callPackage ../development/python-modules/etelemetry { };

  etebase = callPackage ../development/python-modules/etebase {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  etebase-server = callPackage ../servers/etebase { };

  eternalegypt = callPackage ../development/python-modules/eternalegypt { };

  etesync = callPackage ../development/python-modules/etesync { };

  eth-hash = callPackage ../development/python-modules/eth-hash { };

  eth-typing = callPackage ../development/python-modules/eth-typing { };

  eth-utils = callPackage ../development/python-modules/eth-utils { };

  et_xmlfile = callPackage ../development/python-modules/et_xmlfile { };

  ev3dev2 = callPackage ../development/python-modules/ev3dev2 { };

  evdev = callPackage ../development/python-modules/evdev { };

  eve = callPackage ../development/python-modules/eve { };

  eventlet = callPackage ../development/python-modules/eventlet { };

  events = callPackage ../development/python-modules/events { };

  evernote = callPackage ../development/python-modules/evernote { };

  evohome-async = callPackage ../development/python-modules/evohome-async { };

  ewmh = callPackage ../development/python-modules/ewmh { };

  exdown = callPackage ../development/python-modules/exdown { };

  exchangelib = callPackage ../development/python-modules/exchangelib { };

  execnet = callPackage ../development/python-modules/execnet { };

  executing = callPackage ../development/python-modules/executing { };

  executor = callPackage ../development/python-modules/executor { };

  exif = callPackage ../development/python-modules/exif { };

  exifread = callPackage ../development/python-modules/exifread { };

  expects = callPackage ../development/python-modules/expects { };

  expiringdict = callPackage ../development/python-modules/expiringdict { };

  explorerscript = callPackage ../development/python-modules/explorerscript { };

  exrex = callPackage ../development/python-modules/exrex { };

  extractcode = callPackage ../development/python-modules/extractcode { };

  extractcode-7z = callPackage ../development/python-modules/extractcode/7z.nix {
    inherit (pkgs) p7zip;
  };

  extractcode-libarchive = callPackage ../development/python-modules/extractcode/libarchive.nix {
    inherit (pkgs)
      libarchive
      libb2
      bzip2
      expat
      lz4
      xz
      zlib
      zstd;
  };

  extras = callPackage ../development/python-modules/extras { };

  eyeD3 = callPackage ../development/python-modules/eyed3 { };

  ezdxf = callPackage ../development/python-modules/ezdxf { };

  Fabric = callPackage ../development/python-modules/Fabric { };

  faadelays = callPackage ../development/python-modules/faadelays { };

  fabulous = callPackage ../development/python-modules/fabulous { };

  facebook-sdk = callPackage ../development/python-modules/facebook-sdk { };

  face = callPackage ../development/python-modules/face { };

  facedancer = callPackage ../development/python-modules/facedancer { };

  face_recognition = callPackage ../development/python-modules/face_recognition { };

  face_recognition_models = callPackage ../development/python-modules/face_recognition_models { };

  factory_boy = callPackage ../development/python-modules/factory_boy { };

  fake_factory = callPackage ../development/python-modules/fake_factory { };

  fake-useragent = callPackage ../development/python-modules/fake-useragent { };

  faker = callPackage ../development/python-modules/faker { };

  fakeredis = callPackage ../development/python-modules/fakeredis { };

  falcon = callPackage ../development/python-modules/falcon { };

  faraday-agent-parameters-types = callPackage ../development/python-modules/faraday-agent-parameters-types { };

  faraday-plugins = callPackage ../development/python-modules/faraday-plugins { };

  fastapi = callPackage ../development/python-modules/fastapi { };

  fastavro = callPackage ../development/python-modules/fastavro { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  fastcore = callPackage ../development/python-modules/fastcore { };

  fastdiff = callPackage ../development/python-modules/fastdiff { };

  fastdtw = callPackage ../development/python-modules/fastdtw { };

  fastecdsa = callPackage ../development/python-modules/fastecdsa { };

  fasteners = callPackage ../development/python-modules/fasteners { };

  fastentrypoints = callPackage ../development/python-modules/fastentrypoints { };

  fastimport = callPackage ../development/python-modules/fastimport { };

  fastjet = toPythonModule (pkgs.fastjet.override {
    withPython = true;
    inherit (self) python;
  });

  fastjsonschema = callPackage ../development/python-modules/fastjsonschema { };

  fastnlo_toolkit = toPythonModule (pkgs.fastnlo_toolkit.override {
    withPython = true;
    inherit (self) python;
  });

  fastnumbers = callPackage ../development/python-modules/fastnumbers { };

  fastpair = callPackage ../development/python-modules/fastpair { };

  fastparquet = callPackage ../development/python-modules/fastparquet { };

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 { };

  fastprogress = callPackage ../development/python-modules/fastprogress { };

  fastrlock = callPackage ../development/python-modules/fastrlock { };

  fasttext = callPackage ../development/python-modules/fasttext { };

  favicon = callPackage ../development/python-modules/favicon { };

  fb-re2 = callPackage ../development/python-modules/fb-re2 { };

  fe25519 = callPackage ../development/python-modules/fe25519 { };

  feedgen = callPackage ../development/python-modules/feedgen { };

  feedgenerator = callPackage ../development/python-modules/feedgenerator {
    inherit (pkgs) glibcLocales;
  };

  feedparser = callPackage ../development/python-modules/feedparser { };

  fenics = callPackage ../development/libraries/science/math/fenics {
    hdf5 = pkgs.hdf5_1_10;
  };

  ffmpeg-python = callPackage ../development/python-modules/ffmpeg-python { };

  ffmpeg-progress-yield = callPackage ../development/python-modules/ffmpeg-progress-yield { };

  fido2 = callPackage ../development/python-modules/fido2 { };

  fields = callPackage ../development/python-modules/fields { };

  file-read-backwards = callPackage ../development/python-modules/file-read-backwards { };

  filebrowser_safe = callPackage ../development/python-modules/filebrowser_safe { };

  filebytes = callPackage ../development/python-modules/filebytes { };

  filelock = callPackage ../development/python-modules/filelock { };

  filemagic = callPackage ../development/python-modules/filemagic { };

  filetype = callPackage ../development/python-modules/filetype { };

  filterpy = callPackage ../development/python-modules/filterpy { };

  finalfusion = callPackage ../development/python-modules/finalfusion { };

  fingerprints = callPackage ../development/python-modules/fingerprints { };

  finitude = callPackage ../development/python-modules/finitude { };

  fints = callPackage ../development/python-modules/fints { };

  fiona = callPackage ../development/python-modules/fiona { };

  fipy = callPackage ../development/python-modules/fipy { };

  fire = callPackage ../development/python-modules/fire { };

  firetv = callPackage ../development/python-modules/firetv { };

  first = callPackage ../development/python-modules/first { };

  fitbit = callPackage ../development/python-modules/fitbit { };

  fixerio = callPackage ../development/python-modules/fixerio { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  fjaraskupan = callPackage ../development/python-modules/fjaraskupan { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-length = callPackage ../development/python-modules/flake8-length { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-docstrings = callPackage ../development/python-modules/flake8-docstrings { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flake8-import-order = callPackage ../development/python-modules/flake8-import-order { };

  flake8-polyfill = callPackage ../development/python-modules/flake8-polyfill { };

  flaky = callPackage ../development/python-modules/flaky { };

  flametree = callPackage ../development/python-modules/flametree { };

  flammkuchen = callPackage ../development/python-modules/flammkuchen { };

  flashtext = callPackage ../development/python-modules/flashtext { };

  flask-admin = callPackage ../development/python-modules/flask-admin { };

  flask-api = callPackage ../development/python-modules/flask-api { };

  flask-appbuilder = callPackage ../development/python-modules/flask-appbuilder { };

  flask_assets = callPackage ../development/python-modules/flask-assets { };

  flask-autoindex = callPackage ../development/python-modules/flask-autoindex { };

  flask-babel = callPackage ../development/python-modules/flask-babel { };

  flaskbabel = callPackage ../development/python-modules/flaskbabel { };

  flask-babelex = callPackage ../development/python-modules/flask-babelex { };

  flask-bcrypt = callPackage ../development/python-modules/flask-bcrypt { };

  flask-bootstrap = callPackage ../development/python-modules/flask-bootstrap { };

  flask-caching = callPackage ../development/python-modules/flask-caching { };

  flask = callPackage ../development/python-modules/flask { };

  flask-common = callPackage ../development/python-modules/flask-common { };

  flask-compress = callPackage ../development/python-modules/flask-compress { };

  flask-cors = callPackage ../development/python-modules/flask-cors { };

  flask_elastic = callPackage ../development/python-modules/flask-elastic { };

  flask-gravatar = callPackage ../development/python-modules/flask-gravatar { };

  flask-httpauth = callPackage ../development/python-modules/flask-httpauth { };

  flask-jwt-extended = callPackage ../development/python-modules/flask-jwt-extended { };

  flask-limiter = callPackage ../development/python-modules/flask-limiter { };

  flask_login = callPackage ../development/python-modules/flask-login { };

  flask_mail = callPackage ../development/python-modules/flask-mail { };

  flask_marshmallow = callPackage ../development/python-modules/flask-marshmallow { };

  flask_migrate = callPackage ../development/python-modules/flask-migrate { };

  flask-mongoengine = callPackage ../development/python-modules/flask-mongoengine { };

  flask-openid = callPackage ../development/python-modules/flask-openid { };

  flask-paginate = callPackage ../development/python-modules/flask-paginate { };

  flask-paranoid = callPackage ../development/python-modules/flask-paranoid { };

  flask_principal = callPackage ../development/python-modules/flask-principal { };

  flask-pymongo = callPackage ../development/python-modules/Flask-PyMongo { };

  flask-restful = callPackage ../development/python-modules/flask-restful { };

  flask-restplus = callPackage ../development/python-modules/flask-restplus { };

  flask-restx = callPackage ../development/python-modules/flask-restx { };

  flask-reverse-proxy-fix = callPackage ../development/python-modules/flask-reverse-proxy-fix { };

  flask_script = callPackage ../development/python-modules/flask-script { };

  flask-seasurf = callPackage ../development/python-modules/flask-seasurf { };

  flask-session = callPackage ../development/python-modules/flask-session { };

  flask-security-too = callPackage ../development/python-modules/flask-security-too { };

  flask-silk = callPackage ../development/python-modules/flask-silk { };

  flask-socketio = callPackage ../development/python-modules/flask-socketio { };

  flask-sockets = callPackage ../development/python-modules/flask-sockets { };

  flask_sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask-sslify = callPackage ../development/python-modules/flask-sslify { };

  flask-swagger = callPackage ../development/python-modules/flask-swagger { };

  flask-swagger-ui = callPackage ../development/python-modules/flask-swagger-ui { };

  flask-talisman = callPackage ../development/python-modules/flask-talisman { };

  flask_testing = callPackage ../development/python-modules/flask-testing { };

  flask-versioned = callPackage ../development/python-modules/flask-versioned { };

  flask_wtf = callPackage ../development/python-modules/flask-wtf { };

  flatbuffers = callPackage ../development/python-modules/flatbuffers {
    inherit (pkgs) flatbuffers;
  };

  flatten-dict = callPackage ../development/python-modules/flatten-dict { };

  flax = callPackage ../development/python-modules/flax { };

  flexmock = callPackage ../development/python-modules/flexmock { };

  flickrapi = callPackage ../development/python-modules/flickrapi { };

  flipr-api = callPackage ../development/python-modules/flipr-api { };

  flit = callPackage ../development/python-modules/flit { };

  flit-core = callPackage ../development/python-modules/flit-core { };

  flower = callPackage ../development/python-modules/flower { };

  flowlogs_reader = callPackage ../development/python-modules/flowlogs_reader { };

  fluent-logger = callPackage ../development/python-modules/fluent-logger { };

  flufl_bounce = callPackage ../development/python-modules/flufl/bounce.nix { };

  flufl_i18n = callPackage ../development/python-modules/flufl/i18n.nix { };

  flufl_lock = callPackage ../development/python-modules/flufl/lock.nix { };

  flux-led = callPackage ../development/python-modules/flux-led { };

  flynt = callPackage ../development/python-modules/flynt { };

  fn = callPackage ../development/python-modules/fn { };

  fnvhash = callPackage ../development/python-modules/fnvhash { };

  folium = callPackage ../development/python-modules/folium { };

  fontforge = toPythonModule (pkgs.fontforge.override {
    withPython = true;
    inherit python;
  });

  fontmath = callPackage ../development/python-modules/fontmath { };

  fontparts = callPackage ../development/python-modules/fontparts { };

  fontpens = callPackage ../development/python-modules/fontpens { };

  fonttools = callPackage ../development/python-modules/fonttools { };

  foobot-async = callPackage ../development/python-modules/foobot-async { };

  foolscap = callPackage ../development/python-modules/foolscap { };

  forbiddenfruit = callPackage ../development/python-modules/forbiddenfruit { };

  fordpass = callPackage ../development/python-modules/fordpass { };

  forecast-solar = callPackage ../development/python-modules/forecast-solar { };

  formbox = callPackage ../development/python-modules/formbox { };

  fortiosapi = callPackage ../development/python-modules/fortiosapi { };

  FormEncode = callPackage ../development/python-modules/FormEncode { };

  foundationdb51 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb51; };
  foundationdb52 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb52; };
  foundationdb60 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb60; };
  foundationdb61 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb61; };

  fountains = callPackage ../development/python-modules/fountains { };

  foxdot = callPackage ../development/python-modules/foxdot { };

  fpdf = callPackage ../development/python-modules/fpdf { };

  fpylll = callPackage ../development/python-modules/fpylll { };

  fpyutils = callPackage ../development/python-modules/fpyutils { };

  freebox-api = callPackage ../development/python-modules/freebox-api { };

  freetype-py = callPackage ../development/python-modules/freetype-py { };

  freezegun = callPackage ../development/python-modules/freezegun { };

  frigidaire = callPackage ../development/python-modules/frigidaire { };

  frilouz = callPackage ../development/python-modules/frilouz { };

  fritzconnection = callPackage ../development/python-modules/fritzconnection { };

  fritzprofiles = callPackage ../development/python-modules/fritzprofiles { };

  frozendict = callPackage ../development/python-modules/frozendict { };

  frozenlist = callPackage ../development/python-modules/frozenlist { };

  fs = callPackage ../development/python-modules/fs { };

  fs-s3fs = callPackage ../development/python-modules/fs-s3fs { };

  fsspec = callPackage ../development/python-modules/fsspec { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  ftputil = callPackage ../development/python-modules/ftputil { };

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  functools32 = callPackage ../development/python-modules/functools32 { };

  funcy = callPackage ../development/python-modules/funcy { };

  furl = callPackage ../development/python-modules/furl { };

  furo = callPackage ../development/python-modules/furo { };

  fuse = callPackage ../development/python-modules/fuse-python {
    inherit (pkgs) fuse;
  };

  fusepy = callPackage ../development/python-modules/fusepy { };

  future = callPackage ../development/python-modules/future { };

  future-fstrings = callPackage ../development/python-modules/future-fstrings { };

  future-typing = callPackage ../development/python-modules/future-typing { };

  fuzzyfinder = callPackage ../development/python-modules/fuzzyfinder { };

  fuzzywuzzy = callPackage ../development/python-modules/fuzzywuzzy { };

  fx2 = callPackage ../development/python-modules/fx2 { };

  galario = toPythonModule (pkgs.galario.override {
    enablePython = true;
    pythonPackages = self;
  });

  gamble = callPackage ../development/python-modules/gamble { };

  gaphas = callPackage ../development/python-modules/gaphas { };

  garminconnect-aio = callPackage ../development/python-modules/garminconnect-aio { };

  garminconnect = callPackage ../development/python-modules/garminconnect { };

  gast = callPackage ../development/python-modules/gast { };

  garages-amsterdam = callPackage ../development/python-modules/garages-amsterdam { };

  gbinder-python = callPackage ../development/python-modules/gbinder-python { };

  gcovr = callPackage ../development/python-modules/gcovr { };

  gcsfs = callPackage ../development/python-modules/gcsfs { };

  gdal = toPythonModule (pkgs.gdal.override { pythonPackages = self; });

  gdata = callPackage ../development/python-modules/gdata { };

  gdcm = toPythonModule (pkgs.gdcm.override {
    inherit (self) python;
    enablePython = true;
  });

  gdown = callPackage ../development/python-modules/gdown { };

  ge25519 = callPackage ../development/python-modules/ge25519 { };

  geant4 = toPythonModule (pkgs.geant4.override {
    enablePython = true;
    python3 = python;
  });

  geeknote = callPackage ../development/python-modules/geeknote { };

  gehomesdk = callPackage ../development/python-modules/gehomesdk { };

  gekitchen = callPackage ../development/python-modules/gekitchen { };

  gemfileparser = callPackage ../development/python-modules/gemfileparser { };

  genanki = callPackage ../development/python-modules/genanki { };

  generic = callPackage ../development/python-modules/generic { };

  genome-collector = callPackage ../development/python-modules/genome-collector { };

  genpy = callPackage ../development/python-modules/genpy { };

  genshi = callPackage ../development/python-modules/genshi { };

  gensim = callPackage ../development/python-modules/gensim { };

  gentools = callPackage ../development/python-modules/gentools { };

  genzshcomp = callPackage ../development/python-modules/genzshcomp { };

  geoalchemy2 = callPackage ../development/python-modules/geoalchemy2 { };

  geocachingapi = callPackage ../development/python-modules/geocachingapi { };

  geographiclib = callPackage ../development/python-modules/geographiclib { };

  geoip2 = callPackage ../development/python-modules/geoip2 { };

  GeoIP = callPackage ../development/python-modules/GeoIP { };

  geojson = callPackage ../development/python-modules/geojson { };

  geojson-client = callPackage ../development/python-modules/geojson-client { };

  geomet = callPackage ../development/python-modules/geomet { };

  geometric = callPackage ../development/python-modules/geometric { };

  geopandas = callPackage ../development/python-modules/geopandas { };

  geopy = callPackage ../development/python-modules/geopy { };

  georss-client = callPackage ../development/python-modules/georss-client { };

  georss-generic-client = callPackage ../development/python-modules/georss-generic-client { };

  georss-ign-sismologia-client = callPackage ../development/python-modules/georss-ign-sismologia-client { };

  georss-ingv-centro-nazionale-terremoti-client = callPackage ../development/python-modules/georss-ingv-centro-nazionale-terremoti-client { };

  georss-nrcan-earthquakes-client = callPackage ../development/python-modules/georss-nrcan-earthquakes-client { };

  georss-qld-bushfire-alert-client = callPackage ../development/python-modules/georss-qld-bushfire-alert-client { };

  georss-tfs-incidents-client = callPackage ../development/python-modules/georss-tfs-incidents-client { };

  georss-wa-dfes-client = callPackage ../development/python-modules/georss-wa-dfes-client { };

  getmac = callPackage ../development/python-modules/getmac { };

  getkey = callPackage ../development/python-modules/getkey { };

  get-video-properties = callPackage ../development/python-modules/get-video-properties { };

  gevent = callPackage ../development/python-modules/gevent { };

  geventhttpclient = callPackage ../development/python-modules/geventhttpclient { };

  gevent-socketio = callPackage ../development/python-modules/gevent-socketio { };

  gevent-websocket = callPackage ../development/python-modules/gevent-websocket { };

  gflags = callPackage ../development/python-modules/gflags { };

  ghapi = callPackage ../development/python-modules/ghapi { };

  ghdiff = callPackage ../development/python-modules/ghdiff { };

  ghp-import = callPackage ../development/python-modules/ghp-import { };

  ghrepo-stats = callPackage ../development/python-modules/ghrepo-stats { };

  gibberish-detector = callPackage ../development/python-modules/gibberish-detector { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  gigalixir = callPackage ../development/python-modules/gigalixir { };

  gin-config = callPackage ../development/python-modules/gin-config { };

  gios = callPackage ../development/python-modules/gios { };

  gipc = callPackage ../development/python-modules/gipc { };

  gistyc = callPackage ../development/python-modules/gistyc { };

  git-annex-adapter =
    callPackage ../development/python-modules/git-annex-adapter { };

  git-filter-repo = callPackage ../development/python-modules/git-filter-repo { };

  gitdb = callPackage ../development/python-modules/gitdb { };

  github3_py = callPackage ../development/python-modules/github3_py { };

  github-to-sqlite = callPackage ../development/python-modules/github-to-sqlite { };

  github-webhook = callPackage ../development/python-modules/github-webhook { };
  GitPython = callPackage ../development/python-modules/GitPython { };

  git-revise = callPackage ../development/python-modules/git-revise { };

  git-sweep = callPackage ../development/python-modules/git-sweep { };

  glances-api = callPackage ../development/python-modules/glances-api { };

  glasgow = callPackage ../development/python-modules/glasgow { };

  glcontext = callPackage ../development/python-modules/glcontext { };

  glean-parser = callPackage ../development/python-modules/glean-parser { };

  glean-sdk = callPackage ../development/python-modules/glean-sdk { };

  glfw = callPackage ../development/python-modules/glfw { };

  glob2 = callPackage ../development/python-modules/glob2 { };

  globre = callPackage ../development/python-modules/globre { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  glom = callPackage ../development/python-modules/glom { };

  glymur = callPackage ../development/python-modules/glymur { };

  gmpy2 = callPackage ../development/python-modules/gmpy2 { };

  gmpy = callPackage ../development/python-modules/gmpy { };

  gntp = callPackage ../development/python-modules/gntp { };

  gnureadline = callPackage ../development/python-modules/gnureadline { };

  goalzero = callPackage ../development/python-modules/goalzero { };

  goobook = callPackage ../development/python-modules/goobook { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  goodwe = callPackage ../development/python-modules/goodwe { };

  google-api-core = callPackage ../development/python-modules/google-api-core { };

  google-api-python-client = callPackage ../development/python-modules/google-api-python-client { };

  googleapis-common-protos = callPackage ../development/python-modules/googleapis-common-protos { };

  google-auth = callPackage ../development/python-modules/google-auth { };

  google-auth-httplib2 = callPackage ../development/python-modules/google-auth-httplib2 { };

  google-auth-oauthlib = callPackage ../development/python-modules/google-auth-oauthlib { };

  google-cloud-access-context-manager = callPackage ../development/python-modules/google-cloud-access-context-manager { };

  google-cloud-appengine-logging = callPackage ../development/python-modules/google-cloud-appengine-logging { };

  google-cloud-asset = callPackage ../development/python-modules/google-cloud-asset { };

  google-cloud-audit-log = callPackage ../development/python-modules/google-cloud-audit-log { };

  google-cloud-automl = callPackage ../development/python-modules/google-cloud-automl { };

  google-cloud-bigquery = callPackage ../development/python-modules/google-cloud-bigquery { };

  google-cloud-bigquery-datatransfer = callPackage ../development/python-modules/google-cloud-bigquery-datatransfer { };

  google-cloud-bigquery-logging = callPackage ../development/python-modules/google-cloud-bigquery-logging { };

  google-cloud-bigtable = callPackage ../development/python-modules/google-cloud-bigtable { };

  google-cloud-container = callPackage ../development/python-modules/google-cloud-container { };

  google-cloud-core = callPackage ../development/python-modules/google-cloud-core { };

  google-cloud-datacatalog = callPackage ../development/python-modules/google-cloud-datacatalog { };

  google-cloud-dataproc = callPackage ../development/python-modules/google-cloud-dataproc { };

  google-cloud-datastore = callPackage ../development/python-modules/google-cloud-datastore { };

  google-cloud-dlp = callPackage ../development/python-modules/google-cloud-dlp { };

  google-cloud-dns = callPackage ../development/python-modules/google-cloud-dns { };

  google-cloud-error-reporting = callPackage ../development/python-modules/google-cloud-error-reporting { };

  google-cloud-firestore = callPackage ../development/python-modules/google-cloud-firestore { };

  google-cloud-iam = callPackage ../development/python-modules/google-cloud-iam { };

  google-cloud-iam-logging = callPackage ../development/python-modules/google-cloud-iam-logging { };

  google-cloud-iot = callPackage ../development/python-modules/google-cloud-iot { };

  google-cloud-kms = callPackage ../development/python-modules/google-cloud-kms { };

  google-cloud-language = callPackage ../development/python-modules/google-cloud-language { };

  google-cloud-logging = callPackage ../development/python-modules/google-cloud-logging { };

  google-cloud-monitoring = callPackage ../development/python-modules/google-cloud-monitoring { };

  google-cloud-org-policy = callPackage ../development/python-modules/google-cloud-org-policy { };

  google-cloud-os-config = callPackage ../development/python-modules/google-cloud-os-config { };

  google-cloud-pubsub = callPackage ../development/python-modules/google-cloud-pubsub { };

  google-cloud-redis = callPackage ../development/python-modules/google-cloud-redis { };

  google-cloud-resource-manager = callPackage ../development/python-modules/google-cloud-resource-manager { };

  google-cloud-runtimeconfig = callPackage ../development/python-modules/google-cloud-runtimeconfig { };

  google-cloud-secret-manager = callPackage ../development/python-modules/google-cloud-secret-manager { };

  google-cloud-securitycenter = callPackage ../development/python-modules/google-cloud-securitycenter { };

  google-cloud-spanner = callPackage ../development/python-modules/google-cloud-spanner { };

  google-cloud-speech = callPackage ../development/python-modules/google-cloud-speech { };

  google-cloud-storage = callPackage ../development/python-modules/google-cloud-storage { };

  google-cloud-tasks = callPackage ../development/python-modules/google-cloud-tasks { };

  google-cloud-testutils = callPackage ../development/python-modules/google-cloud-testutils { };

  google-cloud-texttospeech = callPackage ../development/python-modules/google-cloud-texttospeech { };

  google-cloud-trace = callPackage ../development/python-modules/google-cloud-trace { };

  google-cloud-translate = callPackage ../development/python-modules/google-cloud-translate { };

  google-cloud-videointelligence = callPackage ../development/python-modules/google-cloud-videointelligence { };

  google-cloud-vision = callPackage ../development/python-modules/google-cloud-vision { };

  google-cloud-websecurityscanner = callPackage ../development/python-modules/google-cloud-websecurityscanner { };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-crc32c = callPackage ../development/python-modules/google-crc32c {
    inherit (pkgs) crc32c;
  };

  google-i18n-address = callPackage ../development/python-modules/google-i18n-address { };

  google-nest-sdm = callPackage ../development/python-modules/google-nest-sdm { };

  googlemaps = callPackage ../development/python-modules/googlemaps { };

  google-pasta = callPackage ../development/python-modules/google-pasta { };

  google-re2 = callPackage ../development/python-modules/google-re2 { };

  google-resumable-media = callPackage ../development/python-modules/google-resumable-media { };

  googletrans = callPackage ../development/python-modules/googletrans { };

  gorilla = callPackage ../development/python-modules/gorilla { };

  goveelights = callPackage ../development/python-modules/goveelights { };

  gpapi = callPackage ../development/python-modules/gpapi { };

  gplaycli = callPackage ../development/python-modules/gplaycli { };

  gpgme = toPythonModule (pkgs.gpgme.override {
    pythonSupport = true;
    inherit python;
  });

  gphoto2 = callPackage ../development/python-modules/gphoto2 { };

  gprof2dot = callPackage ../development/python-modules/gprof2dot {
    inherit (pkgs) graphviz;
  };

  gps3 = callPackage ../development/python-modules/gps3 { };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  gpxpy = callPackage ../development/python-modules/gpxpy { };

  gpy = callPackage ../development/python-modules/gpy { };

  gpyopt = callPackage ../development/python-modules/gpyopt { };

  gql = callPackage ../development/python-modules/gql { };

  gradient = callPackage ../development/python-modules/gradient { };

  gradient-utils = callPackage ../development/python-modules/gradient-utils { };

  gradient_statsd = callPackage ../development/python-modules/gradient_statsd { };

  grammalecte = callPackage ../development/python-modules/grammalecte { };

  grandalf = callPackage ../development/python-modules/grandalf { };

  grapheme = callPackage ../development/python-modules/grapheme { };

  graphite_api = callPackage ../development/python-modules/graphite-api { };

  graphite_beacon = callPackage ../development/python-modules/graphite_beacon { };

  graphite-web = callPackage ../development/python-modules/graphite-web { };

  graph_nets = callPackage ../development/python-modules/graph_nets { };

  graphene = callPackage ../development/python-modules/graphene { };

  graphene-django = callPackage ../development/python-modules/graphene-django { };

  graphqlclient= callPackage ../development/python-modules/graphqlclient { };

  graphql-core = callPackage ../development/python-modules/graphql-core { };

  graphql-relay = callPackage ../development/python-modules/graphql-relay { };

  graphql-server-core = callPackage ../development/python-modules/graphql-server-core { };

  graphql-subscription-manager = callPackage ../development/python-modules/graphql-subscription-manager { };

  graph-tool = callPackage ../development/python-modules/graph-tool { };

  graphtage = callPackage ../development/python-modules/graphtage { };

  graphviz = callPackage ../development/python-modules/graphviz {
    inherit (pkgs) graphviz;
  };

  grappelli_safe = callPackage ../development/python-modules/grappelli_safe { };

  graspologic = callPackage ../development/python-modules/graspologic { };

  greatfet = callPackage ../development/python-modules/greatfet { };

  greeclimate = callPackage ../development/python-modules/greeclimate { };

  green = callPackage ../development/python-modules/green { };

  greenlet = callPackage ../development/python-modules/greenlet { };

  grequests = callPackage ../development/python-modules/grequests { };

  gremlinpython = callPackage ../development/python-modules/gremlinpython { };

  growattserver = callPackage ../development/python-modules/growattserver { };

  grip = callPackage ../development/python-modules/grip { };

  groestlcoin_hash = callPackage ../development/python-modules/groestlcoin_hash { };

  grpc-google-iam-v1 = callPackage ../development/python-modules/grpc-google-iam-v1 { };

  grpcio = callPackage ../development/python-modules/grpcio { };

  grpcio-gcp = callPackage ../development/python-modules/grpcio-gcp { };

  grpcio-status = callPackage ../development/python-modules/grpcio-status { };

  grpcio-tools = callPackage ../development/python-modules/grpcio-tools { };

  gruut = callPackage ../development/python-modules/gruut { };

  gruut-ipa = callPackage ../development/python-modules/gruut-ipa { };

  gsd = callPackage ../development/python-modules/gsd { };

  gspread = callPackage ../development/python-modules/gspread { };

  gssapi = callPackage ../development/python-modules/gssapi {
    inherit (pkgs) krb5Full;
    inherit (pkgs.darwin.apple_sdk.frameworks) GSS;
  };

  gst-python = callPackage ../development/python-modules/gst-python {
    inherit (pkgs) meson;
    gst-plugins-base = pkgs.gst_all_1.gst-plugins-base;
  };

  gtfs-realtime-bindings = callPackage ../development/python-modules/gtfs-realtime-bindings { };

  gtimelog = callPackage ../development/python-modules/gtimelog { };

  gtts = callPackage ../development/python-modules/gtts { };

  gtts-token = callPackage ../development/python-modules/gtts-token { };

  guessit = callPackage ../development/python-modules/guessit { };

  guestfs = callPackage ../development/python-modules/guestfs { };

  gudhi = callPackage ../development/python-modules/gudhi { };

  gumath = callPackage ../development/python-modules/gumath { };

  gunicorn = callPackage ../development/python-modules/gunicorn { };

  guppy3 = callPackage ../development/python-modules/guppy3 { };

  gurobipy = if stdenv.hostPlatform.system == "x86_64-darwin" then
    callPackage ../development/python-modules/gurobipy/darwin.nix {
      inherit (pkgs.darwin) cctools insert_dylib;
    }
  else if stdenv.hostPlatform.system == "x86_64-linux" then
    callPackage ../development/python-modules/gurobipy/linux.nix { }
  else
    throw "gurobipy not yet supported on ${stdenv.hostPlatform.system}";

  guzzle_sphinx_theme = callPackage ../development/python-modules/guzzle_sphinx_theme { };

  gvm-tools = callPackage ../development/python-modules/gvm-tools { };

  gviz-api = callPackage ../development/python-modules/gviz-api { };

  gym = callPackage ../development/python-modules/gym { };

  gyp = callPackage ../development/python-modules/gyp { };

  h11 = callPackage ../development/python-modules/h11 { };

  h2 = callPackage ../development/python-modules/h2 { };

  h3 = callPackage ../development/python-modules/h3 {
    inherit (pkgs) h3;
  };

  h5netcdf = callPackage ../development/python-modules/h5netcdf { };

  h5py = callPackage ../development/python-modules/h5py { };

  h5py-mpi = self.h5py.override {
    hdf5 = pkgs.hdf5-mpi;
  };

  habanero = callPackage ../development/python-modules/habanero { };

  habitipy = callPackage ../development/python-modules/habitipy { };

  hachoir = callPackage ../development/python-modules/hachoir { };

  hacking = callPackage ../development/python-modules/hacking { };

  hdate = callPackage ../development/python-modules/hdate { };

  ha-av = callPackage ../development/python-modules/ha-av { };

  ha-ffmpeg = callPackage ../development/python-modules/ha-ffmpeg { };

  ha-philipsjs = callPackage ../development/python-modules/ha-philipsjs{ };

  hahomematic = callPackage ../development/python-modules/hahomematic { };

  halo = callPackage ../development/python-modules/halo { };

  halohome = callPackage ../development/python-modules/halohome { };

  handout = callPackage ../development/python-modules/handout { };

  hangups = callPackage ../development/python-modules/hangups { };

  hap-python = callPackage ../development/python-modules/hap-python { };

  hass-nabucasa = callPackage ../development/python-modules/hass-nabucasa { };

  hatasmota = callPackage ../development/python-modules/hatasmota { };

  haversine = callPackage ../development/python-modules/haversine { };

  hawkauthlib = callPackage ../development/python-modules/hawkauthlib { };

  hcloud = callPackage ../development/python-modules/hcloud { };

  hcs_utils = callPackage ../development/python-modules/hcs_utils { };

  hdbscan = callPackage ../development/python-modules/hdbscan { };

  hdfs = callPackage ../development/python-modules/hdfs { };

  hdlparse = callPackage ../development/python-modules/hdlparse { };

  hdmedians = callPackage ../development/python-modules/hdmedians { };

  headerparser = callPackage ../development/python-modules/headerparser { };

  heapdict = callPackage ../development/python-modules/heapdict { };

  heatzypy = callPackage ../development/python-modules/heatzypy { };

  helpdev = callPackage ../development/python-modules/helpdev { };

  helper = callPackage ../development/python-modules/helper { };

  hepmc3 = toPythonModule (pkgs.hepmc3.override {
    inherit python;
  });

  herepy = callPackage ../development/python-modules/herepy { };

  hetzner = callPackage ../development/python-modules/hetzner { };

  heudiconv = callPackage ../development/python-modules/heudiconv { };

  hg-commitsigs = callPackage ../development/python-modules/hg-commitsigs { };

  hg-evolve = callPackage ../development/python-modules/hg-evolve { };

  hg-git = callPackage ../development/python-modules/hg-git { };

  hglib = callPackage ../development/python-modules/hglib { };

  hickle = callPackage ../development/python-modules/hickle { };

  hid = callPackage ../development/python-modules/hid {
    inherit (pkgs) hidapi;
  };

  hidapi = callPackage ../development/python-modules/hidapi {
    inherit (pkgs) udev libusb1;
  };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  hijri-converter = callPackage ../development/python-modules/hijri-converter { };

  hikvision = callPackage ../development/python-modules/hikvision { };

  hiredis = callPackage ../development/python-modules/hiredis { };

  hiro = callPackage ../development/python-modules/hiro { };

  hiyapyco = callPackage ../development/python-modules/hiyapyco { };

  hjson = callPackage ../development/python-modules/hjson { };

  hkdf = callPackage ../development/python-modules/hkdf { };

  hlk-sw16 = callPackage ../development/python-modules/hlk-sw16 { };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hocr-tools = callPackage ../development/python-modules/hocr-tools { };

  hole = callPackage ../development/python-modules/hole { };

  holidays = callPackage ../development/python-modules/holidays { };

  holoviews = callPackage ../development/python-modules/holoviews { };

  homeassistant-pyozw = callPackage ../development/python-modules/homeassistant-pyozw { };

  homeconnect = callPackage ../development/python-modules/homeconnect { };

  homematicip = callPackage ../development/python-modules/homematicip { };

  homepluscontrol = callPackage ../development/python-modules/homepluscontrol { };

  hoomd-blue = toPythonModule (callPackage ../development/python-modules/hoomd-blue {
    inherit python;
  });

  hopcroftkarp = callPackage ../development/python-modules/hopcroftkarp { };

  howdoi = callPackage ../development/python-modules/howdoi { };

  hpack = callPackage ../development/python-modules/hpack { };

  hsaudiotag3k = callPackage ../development/python-modules/hsaudiotag3k { };

  hsluv = callPackage ../development/python-modules/hsluv { };

  hstspreload = callPackage ../development/python-modules/hstspreload { };

  html2text = callPackage ../development/python-modules/html2text { };

  html5lib = callPackage ../development/python-modules/html5lib { };

  html5-parser = callPackage ../development/python-modules/html5-parser { };

  htmllaundry = callPackage ../development/python-modules/htmllaundry { };

  htmlmin = callPackage ../development/python-modules/htmlmin { };

  html-sanitizer = callPackage ../development/python-modules/html-sanitizer { };

  HTSeq = callPackage ../development/python-modules/HTSeq { };

  httmock = callPackage ../development/python-modules/httmock { };

  httpagentparser = callPackage ../development/python-modules/httpagentparser { };

  httpauth = callPackage ../development/python-modules/httpauth { };

  httpbin = callPackage ../development/python-modules/httpbin { };

  httpcore = callPackage ../development/python-modules/httpcore { };

  http-ece = callPackage ../development/python-modules/http-ece { };

  httplib2 = callPackage ../development/python-modules/httplib2 { };

  http-parser = callPackage ../development/python-modules/http-parser { };

  httpretty = callPackage ../development/python-modules/httpretty { };

  httpserver = callPackage ../development/python-modules/httpserver { };

  httpsig = callPackage ../development/python-modules/httpsig { };

  httptools = callPackage ../development/python-modules/httptools { };

  httpx = callPackage ../development/python-modules/httpx { };

  httpx-ntlm = callPackage ../development/python-modules/httpx-ntlm { };

  httpx-socks = callPackage ../development/python-modules/httpx-socks { };

  huawei-lte-api = callPackage ../development/python-modules/huawei-lte-api { };

  huey = callPackage ../development/python-modules/huey { };

  hug = callPackage ../development/python-modules/hug { };

  huggingface-hub = callPackage ../development/python-modules/huggingface-hub { };

  huisbaasje-client = callPackage ../development/python-modules/huisbaasje-client { };

  humanfriendly = callPackage ../development/python-modules/humanfriendly { };

  humanize = callPackage ../development/python-modules/humanize { };

  humblewx = callPackage ../development/python-modules/humblewx { };

  hupper = callPackage ../development/python-modules/hupper { };

  hvac = callPackage ../development/python-modules/hvac { };

  hvplot = callPackage ../development/python-modules/hvplot { };

  hwi = callPackage ../development/python-modules/hwi { };

  hy = callPackage ../development/python-modules/hy { };

  hydra = callPackage ../development/python-modules/hydra { };

  hydra-check = callPackage ../development/python-modules/hydra-check { };

  hydrawiser = callPackage ../development/python-modules/hydrawiser { };

  hypchat = callPackage ../development/python-modules/hypchat { };

  hypercorn = callPackage ../development/python-modules/hypercorn { };

  hyperframe = callPackage ../development/python-modules/hyperframe { };

  hyperion-py = callPackage ../development/python-modules/hyperion-py { };

  hyperkitty = callPackage ../servers/mail/mailman/hyperkitty.nix { };

  hyperlink = callPackage ../development/python-modules/hyperlink { };

  hyperopt = callPackage ../development/python-modules/hyperopt { };

  hypothesis-auto = callPackage ../development/python-modules/hypothesis-auto { };

  hypothesis = callPackage ../development/python-modules/hypothesis { };

  hypothesmith = callPackage ../development/python-modules/hypothesmith { };

  hyppo = callPackage ../development/python-modules/hyppo { };

  i2c-tools = callPackage ../development/python-modules/i2c-tools {
    inherit (pkgs) i2c-tools;
  };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  i3-py = callPackage ../development/python-modules/i3-py { };

  iapws = callPackage ../development/python-modules/iapws { };

  iaqualink = callPackage ../development/python-modules/iaqualink { };

  ibis = callPackage ../development/python-modules/ibis { };

  ibis-framework = callPackage ../development/python-modules/ibis-framework { };

  ibm-cloud-sdk-core = callPackage ../development/python-modules/ibm-cloud-sdk-core { };

  ibm-watson = callPackage ../development/python-modules/ibm-watson { };

  icalendar = callPackage ../development/python-modules/icalendar { };

  icecream = callPackage ../development/python-modules/icecream { };

  icmplib = callPackage ../development/python-modules/icmplib { };

  ics = callPackage ../development/python-modules/ics { };

  idasen = callPackage ../development/python-modules/idasen { };

  identify = callPackage ../development/python-modules/identify { };

  idna = callPackage ../development/python-modules/idna { };

  idna-ssl = callPackage ../development/python-modules/idna-ssl { };

  ifaddr = callPackage ../development/python-modules/ifaddr { };

  ifconfig-parser = callPackage ../development/python-modules/ifconfig-parser { };

  ifcopenshell = callPackage ../development/python-modules/ifcopenshell { };

  ignite = callPackage ../development/python-modules/ignite { };

  igraph = callPackage ../development/python-modules/igraph {
    inherit (pkgs) igraph;
  };

  ihatemoney = callPackage ../development/python-modules/ihatemoney { };

  ijson = callPackage ../development/python-modules/ijson { };

  ilua = callPackage ../development/python-modules/ilua { };

  imagecodecs-lite = callPackage ../development/python-modules/imagecodecs-lite { };

  imagecorruptions = callPackage ../development/python-modules/imagecorruptions { };

  imageio = callPackage ../development/python-modules/imageio { };

  imageio-ffmpeg = callPackage ../development/python-modules/imageio-ffmpeg { };

  image-go-nord = callPackage ../development/python-modules/image-go-nord { };

  image-match = callPackage ../development/python-modules/image-match { };

  imagesize = callPackage ../development/python-modules/imagesize { };

  imantics = callPackage ../development/python-modules/imantics { };

  imapclient = callPackage ../development/python-modules/imapclient { };

  imaplib2 = callPackage ../development/python-modules/imaplib2 { };

  imap-tools = callPackage ../development/python-modules/imap-tools { };

  imbalanced-learn = callPackage ../development/python-modules/imbalanced-learn { };

  imdbpy = callPackage ../development/python-modules/imdbpy { };

  img2pdf = callPackage ../development/python-modules/img2pdf { };

  imgaug = callPackage ../development/python-modules/imgaug { };

  imgsize = callPackage ../development/python-modules/imgsize { };

  iminuit = callPackage ../development/python-modules/iminuit { };

  immutabledict = callPackage ../development/python-modules/immutabledict { };

  immutables = callPackage ../development/python-modules/immutables { };

  impacket = callPackage ../development/python-modules/impacket { };

  importlab = callPackage ../development/python-modules/importlab { };

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata { };

  importlib-resources = callPackage ../development/python-modules/importlib-resources { };

  importmagic = callPackage ../development/python-modules/importmagic { };

  imread = callPackage ../development/python-modules/imread {
    inherit (pkgs) libjpeg libpng libtiff libwebp;
  };

  imutils = callPackage ../development/python-modules/imutils { };

  in-place = callPackage ../development/python-modules/in-place { };

  incomfort-client = callPackage ../development/python-modules/incomfort-client { };

  incremental = callPackage ../development/python-modules/incremental { };

  inflect = callPackage ../development/python-modules/inflect { };

  inflection = callPackage ../development/python-modules/inflection { };

  influxdb = callPackage ../development/python-modules/influxdb { };

  influxdb-client = callPackage ../development/python-modules/influxdb-client { };

  influxgraph = callPackage ../development/python-modules/influxgraph { };

  inform = callPackage ../development/python-modules/inform { };

  iniconfig = callPackage ../development/python-modules/iniconfig { };

  inifile = callPackage ../development/python-modules/inifile { };

  iniparse = callPackage ../development/python-modules/iniparse { };

  injector = callPackage ../development/python-modules/injector { };

  inkex = callPackage ../development/python-modules/inkex { };

  inotify = callPackage ../development/python-modules/inotify { };

  inotify-simple = callPackage ../development/python-modules/inotify-simple { };

  inotifyrecursive = callPackage ../development/python-modules/inotifyrecursive { };

  inquirer = callPackage ../development/python-modules/inquirer { };

  insegel = callPackage ../development/python-modules/insegel { };

  installer = callPackage ../development/python-modules/installer { };

  intake = callPackage ../development/python-modules/intake { };

  intake-parquet = callPackage ../development/python-modules/intake-parquet { };

  intbitset = callPackage ../development/python-modules/intbitset { };

  intelhex = callPackage ../development/python-modules/intelhex { };

  intellifire4py = callPackage ../development/python-modules/intellifire4py { };

  intensity-normalization = callPackage ../development/python-modules/intensity-normalization { };

  internetarchive = callPackage ../development/python-modules/internetarchive { };

  interruptingcow = callPackage ../development/python-modules/interruptingcow { };

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  intreehooks = callPackage ../development/python-modules/intreehooks { };

  invoke = callPackage ../development/python-modules/invoke { };

  iocapture = callPackage ../development/python-modules/iocapture { };

  iotawattpy = callPackage ../development/python-modules/iotawattpy { };

  iowait = callPackage ../development/python-modules/iowait { };

  ipaddress = callPackage ../development/python-modules/ipaddress { };

  ipdb = callPackage ../development/python-modules/ipdb { };

  ipdbplugin = callPackage ../development/python-modules/ipdbplugin { };

  ipfshttpclient = callPackage ../development/python-modules/ipfshttpclient { };

  i-pi = callPackage ../development/python-modules/i-pi { };

  iptools = callPackage ../development/python-modules/iptools { };

  ipwhl = callPackage ../development/python-modules/ipwhl { };

  ipy = callPackage ../development/python-modules/IPy { };

  ipydatawidgets = callPackage ../development/python-modules/ipydatawidgets { };

  ipykernel = callPackage ../development/python-modules/ipykernel { };

  ipympl = callPackage ../development/python-modules/ipympl { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  ipython_genutils = callPackage ../development/python-modules/ipython_genutils { };

  ipython = callPackage ../development/python-modules/ipython { };

  ipyvue = callPackage ../development/python-modules/ipyvue { };

  ipyvuetify = callPackage ../development/python-modules/ipyvuetify { };

  ipywidgets = callPackage ../development/python-modules/ipywidgets { };

  irc = callPackage ../development/python-modules/irc { };

  ircrobots = callPackage ../development/python-modules/ircrobots { };

  ircstates = callPackage ../development/python-modules/ircstates { };

  irctokens = callPackage ../development/python-modules/irctokens { };

  isbnlib = callPackage ../development/python-modules/isbnlib { };

  islpy = callPackage ../development/python-modules/islpy { };

  iso3166 = callPackage ../development/python-modules/iso3166 { };

  ismartgate = callPackage ../development/python-modules/ismartgate { };

  iso-639 = callPackage ../development/python-modules/iso-639 { };

  iso4217 = callPackage ../development/python-modules/iso4217 { };

  iso8601 = callPackage ../development/python-modules/iso8601 { };

  isodate = callPackage ../development/python-modules/isodate { };

  isort = callPackage ../development/python-modules/isort { };

  isounidecode = callPackage ../development/python-modules/isounidecode { };

  isoweek = callPackage ../development/python-modules/isoweek { };

  itanium_demangler = callPackage ../development/python-modules/itanium_demangler { };

  itemadapter = callPackage ../development/python-modules/itemadapter { };

  itemdb = callPackage ../development/python-modules/itemdb { };

  itemloaders = callPackage ../development/python-modules/itemloaders { };

  iterm2 = callPackage ../development/python-modules/iterm2 { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous { };

  itunespy = callPackage ../development/python-modules/itunespy { };

  itypes = callPackage ../development/python-modules/itypes { };

  j2cli = callPackage ../development/python-modules/j2cli { };

  jaconv = callPackage ../development/python-modules/jaconv { };

  jaeger-client = callPackage ../development/python-modules/jaeger-client { };

  janus = callPackage ../development/python-modules/janus { };

  jaraco_classes = callPackage ../development/python-modules/jaraco_classes { };

  jaraco_collections = callPackage ../development/python-modules/jaraco_collections { };

  jaraco-context = callPackage ../development/python-modules/jaraco-context { };

  jaraco_functools = callPackage ../development/python-modules/jaraco_functools { };

  jaraco_itertools = callPackage ../development/python-modules/jaraco_itertools { };

  jaraco_logging = callPackage ../development/python-modules/jaraco_logging { };

  jaraco_stream = callPackage ../development/python-modules/jaraco_stream { };

  jaraco_text = callPackage ../development/python-modules/jaraco_text { };

  javaobj-py3 = callPackage ../development/python-modules/javaobj-py3 { };

  javaproperties = callPackage ../development/python-modules/javaproperties { };

  jax = callPackage ../development/python-modules/jax { };

  jaxlib-bin = callPackage ../development/python-modules/jaxlib/bin.nix {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudatoolkit_11 = tensorflow_compat_cudatoolkit;
    cudnn = tensorflow_compat_cudnn;
  };

  jaxlib-build = callPackage ../development/python-modules/jaxlib {
    # Some platforms don't have `cudaSupport` defined, hence the need for 'or false'.
    cudaSupport = pkgs.config.cudaSupport or false;
    cudatoolkit = tensorflow_compat_cudatoolkit;
    cudnn = tensorflow_compat_cudnn;
    nccl = tensorflow_compat_nccl;
  };

  jaxlib = self.jaxlib-build;

  jaxlibWithCuda = self.jaxlib-build.override {
    cudaSupport = true;
  };

  jaxlibWithoutCuda = self.jaxlib-build.override {
    cudaSupport = false;
  };

  JayDeBeApi = callPackage ../development/python-modules/JayDeBeApi { };

  jc = callPackage ../development/python-modules/jc { };

  jdatetime = callPackage ../development/python-modules/jdatetime { };

  jdcal = callPackage ../development/python-modules/jdcal { };

  jedi = callPackage ../development/python-modules/jedi { };

  jedi-language-server = callPackage ../development/python-modules/jedi-language-server { };

  jeepney = callPackage ../development/python-modules/jeepney { };

  jellyfin-apiclient-python = callPackage ../development/python-modules/jellyfin-apiclient-python { };

  jellyfish = callPackage ../development/python-modules/jellyfish { };

  jenkinsapi = callPackage ../development/python-modules/jenkinsapi { };

  jenkins-job-builder = callPackage ../development/python-modules/jenkins-job-builder { };

  jieba = callPackage ../development/python-modules/jieba { };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2-git = callPackage ../development/python-modules/jinja2-git { };

  jinja2_pluralize = callPackage ../development/python-modules/jinja2_pluralize { };

  jinja2_time = callPackage ../development/python-modules/jinja2_time { };

  jira = callPackage ../development/python-modules/jira { };

  jmespath = callPackage ../development/python-modules/jmespath { };

  jmp = callPackage ../development/python-modules/jmp { };

  joblib = callPackage ../development/python-modules/joblib { };

  johnnycanencrypt = callPackage ../development/python-modules/johnnycanencrypt {
    inherit (pkgs.darwin.apple_sdk.frameworks) PCSC;
  };

  josepy = callPackage ../development/python-modules/josepy { };

  journalwatch = callPackage ../tools/system/journalwatch {
    inherit (self) systemd pytest;
  };

  jproperties = callPackage ../development/python-modules/jproperties { };

  jpylyzer = callPackage ../development/python-modules/jpylyzer { };

  JPype1 = callPackage ../development/python-modules/JPype1 { };

  jq = callPackage ../development/python-modules/jq {
    inherit (pkgs) jq;
  };

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier { };

  jschema-to-python = callPackage ../development/python-modules/jschema-to-python { };

  jsmin = callPackage ../development/python-modules/jsmin { };

  json5 = callPackage ../development/python-modules/json5 { };

  jsondate = callPackage ../development/python-modules/jsondate { };

  jsondiff = callPackage ../development/python-modules/jsondiff { };

  jsonfield = callPackage ../development/python-modules/jsonfield { };

  jsonlines = callPackage ../development/python-modules/jsonlines { };

  json-logging = callPackage ../development/python-modules/json-logging { };

  jsonmerge = callPackage ../development/python-modules/jsonmerge { };

  json-merge-patch = callPackage ../development/python-modules/json-merge-patch { };

  json-schema-for-humans = callPackage ../development/python-modules/json-schema-for-humans { };

  jsonnet = buildPythonPackage { inherit (pkgs.jsonnet) name src; };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpath = callPackage ../development/python-modules/jsonpath { };

  jsonpath_rw = callPackage ../development/python-modules/jsonpath_rw { };

  jsonpath-ng = callPackage ../development/python-modules/jsonpath-ng { };

  jsonpickle = callPackage ../development/python-modules/jsonpickle { };

  jsonpointer = callPackage ../development/python-modules/jsonpointer { };

  jsonref = callPackage ../development/python-modules/jsonref { };

  json-rpc = callPackage ../development/python-modules/json-rpc { };

  jsonrpc-async = callPackage ../development/python-modules/jsonrpc-async { };

  jsonrpc-base = callPackage ../development/python-modules/jsonrpc-base { };

  jsonrpclib-pelix = callPackage ../development/python-modules/jsonrpclib-pelix { };

  jsonrpc-websocket = callPackage ../development/python-modules/jsonrpc-websocket { };

  jsonschema = callPackage ../development/python-modules/jsonschema { };

  jsonstreams = callPackage ../development/python-modules/jsonstreams { };

  json-tricks = callPackage ../development/python-modules/json-tricks { };

  jug = callPackage ../development/python-modules/jug { };

  junitparser = callPackage ../development/python-modules/junitparser { };

  junit-xml = callPackage ../development/python-modules/junit-xml { };

  junos-eznc = callPackage ../development/python-modules/junos-eznc { };

  jupyter = callPackage ../development/python-modules/jupyter { };

  jupyter-c-kernel = callPackage ../development/python-modules/jupyter-c-kernel { };

  jupyter-client = callPackage ../development/python-modules/jupyter-client { };

  jupyter_console = callPackage ../development/python-modules/jupyter_console { };

  jupyter_core = callPackage ../development/python-modules/jupyter_core { };

  jupyter_server = callPackage ../development/python-modules/jupyter_server { };

  jupyterhub = callPackage ../development/python-modules/jupyterhub { };

  jupyterhub-ldapauthenticator = callPackage ../development/python-modules/jupyterhub-ldapauthenticator { };

  jupyterhub-systemdspawner = callPackage ../development/python-modules/jupyterhub-systemdspawner { };

  jupyterhub-tmpauthenticator = callPackage ../development/python-modules/jupyterhub-tmpauthenticator { };

  jupyterlab = callPackage ../development/python-modules/jupyterlab { };

  jupyterlab-git = callPackage ../development/python-modules/jupyterlab-git { };

  jupyterlab_launcher = callPackage ../development/python-modules/jupyterlab_launcher { };

  jupyterlab-pygments = callPackage ../development/python-modules/jupyterlab-pygments { };

  jupyterlab_server = callPackage ../development/python-modules/jupyterlab_server { };

  jupyterlab-widgets = callPackage ../development/python-modules/jupyterlab-widgets { };

  jupyter-packaging = callPackage ../development/python-modules/jupyter-packaging { };

  jupyter-repo2docker = callPackage ../development/python-modules/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyter-server-mathjax = callPackage ../development/python-modules/jupyter-server-mathjax { };

  jupyter-sphinx = callPackage ../development/python-modules/jupyter-sphinx { };

  jupyter-telemetry = callPackage ../development/python-modules/jupyter-telemetry { };

  jupytext = callPackage ../development/python-modules/jupytext { };

  justbackoff = callPackage ../development/python-modules/justbackoff { };

  jwcrypto = callPackage ../development/python-modules/jwcrypto { };

  jxmlease = callPackage ../development/python-modules/jxmlease { };

  k5test = callPackage ../development/python-modules/k5test {
    inherit (pkgs) krb5Full findutils which;
  };

  kaa-base = callPackage ../development/python-modules/kaa-base { };

  kaa-metadata = callPackage ../development/python-modules/kaa-metadata { };

  kafka-python = callPackage ../development/python-modules/kafka-python { };

  kaggle = callPackage ../development/python-modules/kaggle { };

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  Kajiki = callPackage ../development/python-modules/kajiki { };

  kaldi-active-grammar = callPackage ../development/python-modules/kaldi-active-grammar { };

  kaptan = callPackage ../development/python-modules/kaptan { };

  karton-asciimagic = callPackage ../development/python-modules/karton-asciimagic { };

  karton-autoit-ripper = callPackage ../development/python-modules/karton-autoit-ripper { };

  karton-classifier = callPackage ../development/python-modules/karton-classifier { };

  karton-config-extractor = callPackage ../development/python-modules/karton-config-extractor { };

  karton-core = callPackage ../development/python-modules/karton-core { };

  karton-dashboard = callPackage ../development/python-modules/karton-dashboard { };

  karton-mwdb-reporter = callPackage ../development/python-modules/karton-mwdb-reporter { };

  karton-yaramatcher = callPackage ../development/python-modules/karton-yaramatcher { };

  kazoo = callPackage ../development/python-modules/kazoo { };

  kconfiglib = callPackage ../development/python-modules/kconfiglib { };

  keep = callPackage ../development/python-modules/keep { };

  keepalive = callPackage ../development/python-modules/keepalive { };

  keepkey_agent = callPackage ../development/python-modules/keepkey_agent { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  keras-applications = callPackage ../development/python-modules/keras-applications { };

  keras = callPackage ../development/python-modules/keras { };

  keras-preprocessing = callPackage ../development/python-modules/keras-preprocessing { };

  kerberos = callPackage ../development/python-modules/kerberos { };

  keyboard = callPackage ../development/python-modules/keyboard { };

  keyring = callPackage ../development/python-modules/keyring { };

  keyrings-cryptfile = callPackage ../development/python-modules/keyrings-cryptfile { };

  keyrings-alt = callPackage ../development/python-modules/keyrings-alt { };

  keystone-engine = callPackage ../development/python-modules/keystone-engine { };

  keystoneauth1 = callPackage ../development/python-modules/keystoneauth1 { };

  keyutils = callPackage ../development/python-modules/keyutils {
    inherit (pkgs) keyutils;
  };

  kicad = toPythonModule (pkgs.kicad.override {
    python3 = python;
  }).src;

  kinparse = callPackage ../development/python-modules/kinparse { };

  kitchen = callPackage ../development/python-modules/kitchen { };

  kivy = callPackage ../development/python-modules/kivy {
    inherit (pkgs) mesa;
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices AVFoundation;
  };

  kivy-garden = callPackage ../development/python-modules/kivy-garden { };

  kiwisolver = callPackage ../development/python-modules/kiwisolver { };

  klaus = callPackage ../development/python-modules/klaus { };

  klein = callPackage ../development/python-modules/klein { };

  kmapper = callPackage ../development/python-modules/kmapper { };

  kmsxx = toPythonModule (pkgs.kmsxx.override {
    withPython = true;
  });

  knack = callPackage ../development/python-modules/knack { };

  kombu = callPackage ../development/python-modules/kombu { };

  konnected = callPackage ../development/python-modules/konnected { };

  korean-lunar-calendar = callPackage ../development/python-modules/korean-lunar-calendar { };

  krakenex = callPackage ../development/python-modules/krakenex { };

  kubernetes = callPackage ../development/python-modules/kubernetes { };

  labelbox = callPackage ../development/python-modules/labelbox { };

  labgrid = callPackage ../development/python-modules/labgrid { };

  labmath = callPackage ../development/python-modules/labmath { };

  langcodes = callPackage ../development/python-modules/langcodes { };

  langdetect = callPackage ../development/python-modules/langdetect { };

  language-data = callPackage ../development/python-modules/language-data { };

  lark-parser = callPackage ../development/python-modules/lark-parser { };

  latexcodec = callPackage ../development/python-modules/latexcodec { };

  launchpadlib = callPackage ../development/python-modules/launchpadlib { };

  lazr_config = callPackage ../development/python-modules/lazr/config.nix { };

  lazr_delegates = callPackage ../development/python-modules/lazr/delegates.nix { };

  lazr-restfulclient = callPackage ../development/python-modules/lazr-restfulclient { };

  lazr-uri = callPackage ../development/python-modules/lazr-uri { };

  lazy = callPackage ../development/python-modules/lazy { };

  lazy_import = callPackage ../development/python-modules/lazy_import { };

  lazy-object-proxy = callPackage ../development/python-modules/lazy-object-proxy { };

  lc7001 = callPackage ../development/python-modules/lc7001 { };

  ldap = callPackage ../development/python-modules/ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  ldap3 = callPackage ../development/python-modules/ldap3 { };

  ldapdomaindump = callPackage ../development/python-modules/ldapdomaindump { };

  ldappool = callPackage ../development/python-modules/ldappool { };

  ldaptor = callPackage ../development/python-modules/ldaptor { };

  leather = callPackage ../development/python-modules/leather { };

  leb128 = callPackage ../development/python-modules/leb128 { };

  ledger_agent = callPackage ../development/python-modules/ledger_agent { };

  ledgerblue = callPackage ../development/python-modules/ledgerblue { };

  ledgerwallet = callPackage ../development/python-modules/ledgerwallet {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  lektor = callPackage ../development/python-modules/lektor { };

  leveldb = callPackage ../development/python-modules/leveldb { };

  levenshtein = callPackage ../development/python-modules/levenshtein { };

  lexid = callPackage ../development/python-modules/lexid { };

  lhapdf = toPythonModule (pkgs.lhapdf.override {
    inherit python;
  });

  libagent = callPackage ../development/python-modules/libagent { };

  pa-ringbuffer = callPackage ../development/python-modules/pa-ringbuffer { };

  libais = callPackage ../development/python-modules/libais { };

  libarchive-c = callPackage ../development/python-modules/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libarcus = callPackage ../development/python-modules/libarcus {
    inherit (pkgs) protobuf;
  };

  libasyncns = callPackage ../development/python-modules/libasyncns {
    inherit (pkgs) libasyncns;
  };

  libcloud = callPackage ../development/python-modules/libcloud { };

  libcst = callPackage ../development/python-modules/libcst { };

  libevdev = callPackage ../development/python-modules/libevdev { };

  libfdt = toPythonModule (pkgs.dtc.override {
    inherit python;
    pythonSupport = true;
  });

  libgpiod = toPythonModule (pkgs.libgpiod.override {
    enablePython = true;
    python3 = python;
  });

  libgpuarray = callPackage ../development/python-modules/libgpuarray {
    clblas = pkgs.clblas.override { boost = self.boost; };
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  libiio = (toPythonModule (pkgs.libiio.override { inherit python; })).python;

  libkeepass = callPackage ../development/python-modules/libkeepass { };

  liblarch = callPackage ../development/python-modules/liblarch { };

  liblzfse = callPackage ../development/python-modules/liblzfse {
    inherit (pkgs) lzfse;
  };

  libmodulemd = pipe pkgs.libmodulemd [
    toPythonModule
    (p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ]; # The package always builds python3 bindings
          broken = (super.meta.broken or false) || !isPy3k;
        };
      }))
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libmr = callPackage ../development/python-modules/libmr { };

  libnacl = callPackage ../development/python-modules/libnacl {
    inherit (pkgs) libsodium;
  };

  libpurecool = callPackage ../development/python-modules/libpurecool { };

  libpyfoscam = callPackage ../development/python-modules/libpyfoscam { };

  libpyvivotek = callPackage ../development/python-modules/libpyvivotek { };

  libredwg = toPythonModule (pkgs.libredwg.override {
    enablePython = true;
    inherit (self) python libxml2;
  });

  librepo = pipe pkgs.librepo [
    toPythonModule
    (p: p.overrideAttrs (super: { meta = super.meta // { outputsToInstall = [ "py" ]; }; }))
    (p: p.override { inherit python; })
    (p: p.py)
  ];

  librosa = callPackage ../development/python-modules/librosa { };

  librouteros = callPackage ../development/python-modules/librouteros { };

  libsass = (callPackage ../development/python-modules/libsass {
    inherit (pkgs) libsass;
  });

  libsavitar = callPackage ../development/python-modules/libsavitar { };

  libselinux = pipe pkgs.libselinux [
    toPythonModule
    (p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
          broken = super.meta.broken or isPy27;
        };
      }))
    (p:
      p.override {
        enablePython = true;
        python3 = python;
      })
    (p: p.py)
  ];

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libthumbor = callPackage ../development/python-modules/libthumbor { };

  libtmux = callPackage ../development/python-modules/libtmux { };

  libtorrent-rasterbar = (toPythonModule (pkgs.libtorrent-rasterbar.override { inherit python; })).python;

  libusb1 = callPackage ../development/python-modules/libusb1 {
    inherit (pkgs) libusb1;
  };

  libversion = callPackage ../development/python-modules/libversion {
    inherit (pkgs) libversion;
  };

  libvirt = callPackage ../development/python-modules/libvirt {
    inherit (pkgs) libvirt;
  };

  libxml2 = (toPythonModule (pkgs.libxml2.override {
    pythonSupport = true;
    inherit python;
  })).py;

  libxslt = (toPythonModule (pkgs.libxslt.override {
    pythonSupport = true;
    inherit (self) python libxml2;
  })).py;

  license-expression = callPackage ../development/python-modules/license-expression { };

  lief = (toPythonModule (pkgs.lief.override {
    inherit python;
  })).py;

  life360 = callPackage ../development/python-modules/life360 { };

  lightgbm = callPackage ../development/python-modules/lightgbm { };

  lightning = callPackage ../development/python-modules/lightning { };

  lightparam = callPackage ../development/python-modules/lightparam { };

  lightwave2 = callPackage ../development/python-modules/lightwave2 { };

  lima = callPackage ../development/python-modules/lima { };

  limiter= callPackage ../development/python-modules/limiter { };

  limitlessled = callPackage ../development/python-modules/limitlessled { };

  limits = callPackage ../development/python-modules/limits { };

  limnoria = callPackage ../development/python-modules/limnoria { };

  linecache2 = callPackage ../development/python-modules/linecache2 { };

  line_profiler = callPackage ../development/python-modules/line_profiler { };

  linkify-it-py = callPackage ../development/python-modules/linkify-it-py { };

  linode-api = callPackage ../development/python-modules/linode-api { };

  linode = callPackage ../development/python-modules/linode { };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  liquidctl = callPackage ../development/python-modules/liquidctl { };

  lirc = toPythonModule (pkgs.lirc.override {
    python3 = python;
  });

  littleutils = callPackage ../development/python-modules/littleutils { };

  livelossplot = callPackage ../development/python-modules/livelossplot { };

  livereload = callPackage ../development/python-modules/livereload { };

  livestreamer = callPackage ../development/python-modules/livestreamer { };

  livestreamer-curses = callPackage ../development/python-modules/livestreamer-curses { };

  llfuse = callPackage ../development/python-modules/llfuse {
    inherit (pkgs) fuse;
  };

  llvmlite = callPackage ../development/python-modules/llvmlite {
    # llvmlite always requires a specific version of llvm.
    llvm = pkgs.llvm_11;
  };

  lmdb = callPackage ../development/python-modules/lmdb {
    inherit (pkgs) lmdb;
  };

  lml = callPackage ../development/python-modules/lml { };

  lmnotify = callPackage ../development/python-modules/lmnotify { };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  loca = callPackage ../development/python-modules/loca { };

  localimport = callPackage ../development/python-modules/localimport { };

  localzone = callPackage ../development/python-modules/localzone { };

  locationsharinglib = callPackage ../development/python-modules/locationsharinglib { };

  locket = callPackage ../development/python-modules/locket { };

  lockfile = callPackage ../development/python-modules/lockfile { };

  log-symbols = callPackage ../development/python-modules/log-symbols { };

  Logbook = callPackage ../development/python-modules/Logbook { };

  logfury = callPackage ../development/python-modules/logfury { };

  logilab_astng = callPackage ../development/python-modules/logilab_astng { };

  logilab_common = callPackage ../development/python-modules/logilab/common.nix { };

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix { };

  logster = callPackage ../development/python-modules/logster { };

  loguru = callPackage ../development/python-modules/loguru { };

  logutils = callPackage ../development/python-modules/logutils { };

  logzero = callPackage ../development/python-modules/logzero { };

  lomond = callPackage ../development/python-modules/lomond { };

  loo-py = callPackage ../development/python-modules/loo-py { };

  losant-rest = callPackage ../development/python-modules/losant-rest { };

  lsassy = callPackage ../development/python-modules/lsassy { };

  luddite = callPackage ../development/python-modules/luddite { };

  ludios_wpull = callPackage ../development/python-modules/ludios_wpull { };

  luftdaten = callPackage ../development/python-modules/luftdaten { };

  luhn = callPackage ../development/python-modules/luhn { };

  luxor = callPackage ../development/python-modules/luxor { };

  luxtronik = callPackage ../development/python-modules/luxtronik { };

  lupa = callPackage ../development/python-modules/lupa { };

  lupupy = callPackage ../development/python-modules/lupupy { };

  lxml = callPackage ../development/python-modules/lxml {
    inherit (pkgs) libxml2 libxslt zlib;
  };

  lyricwikia = callPackage ../development/python-modules/lyricwikia { };

  lz4 = callPackage ../development/python-modules/lz4 { };

  lzstring = callPackage ../development/python-modules/lzstring { };

  m2crypto = callPackage ../development/python-modules/m2crypto { };

  m2r = callPackage ../development/python-modules/m2r { };

  m3u8 = callPackage ../development/python-modules/m3u8 { };

  mac_alias = callPackage ../development/python-modules/mac_alias { };

  macfsevents = callPackage ../development/python-modules/macfsevents {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;
  };

  macropy = callPackage ../development/python-modules/macropy { };

  maestral = callPackage ../development/python-modules/maestral { };

  magic = callPackage ../development/python-modules/magic { };

  magicgui = callPackage ../development/python-modules/magicgui { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  magic-wormhole-mailbox-server = callPackage ../development/python-modules/magic-wormhole-mailbox-server { };

  magic-wormhole-transit-relay = callPackage ../development/python-modules/magic-wormhole-transit-relay { };

  mahotas = callPackage ../development/python-modules/mahotas { };

  mailcap-fix = callPackage ../development/python-modules/mailcap-fix { };

  mailchecker = callPackage ../development/python-modules/mailchecker { };

  mailchimp = callPackage ../development/python-modules/mailchimp { };

  mailman = callPackage ../servers/mail/mailman { };

  mailmanclient = callPackage ../development/python-modules/mailmanclient { };

  mailman-hyperkitty = callPackage ../development/python-modules/mailman-hyperkitty { };

  mailman-web = callPackage ../servers/mail/mailman/web.nix { };

  rtmixer = callPackage ../development/python-modules/rtmixer { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  makefun = callPackage ../development/python-modules/makefun { };

  mailsuite = callPackage ../development/python-modules/mailsuite { };

  Mako = callPackage ../development/python-modules/Mako { };

  malduck= callPackage ../development/python-modules/malduck { };

  managesieve = callPackage ../development/python-modules/managesieve { };

  manhole = callPackage ../development/python-modules/manhole { };

  manimpango = callPackage ../development/python-modules/manimpango {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  manifestparser = callPackage ../development/python-modules/marionette-harness/manifestparser.nix { };

  manuel = callPackage ../development/python-modules/manuel { };

  manticore = callPackage ../development/python-modules/manticore {
    inherit (pkgs) z3;
  };

  mapbox = callPackage ../development/python-modules/mapbox { };

  mariadb = callPackage ../development/python-modules/mariadb { };

  marisa-trie = callPackage ../development/python-modules/marisa-trie { };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  markdown = callPackage ../development/python-modules/markdown { };

  markdown-include = callPackage ../development/python-modules/markdown-include { };

  markdown-it-py = callPackage ../development/python-modules/markdown-it-py { };

  markdown-macros = callPackage ../development/python-modules/markdown-macros { };

  markdownsuperscript = callPackage ../development/python-modules/markdownsuperscript { };

  markerlib = callPackage ../development/python-modules/markerlib { };

  markupsafe = callPackage ../development/python-modules/markupsafe { };

  Markups = callPackage ../development/python-modules/Markups { };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-dataclass = callPackage ../development/python-modules/marshmallow-dataclass { };

  marshmallow-enum = callPackage ../development/python-modules/marshmallow-enum { };

  marshmallow-oneofschema = callPackage ../development/python-modules/marshmallow-oneofschema { };

  marshmallow-polyfield = callPackage ../development/python-modules/marshmallow-polyfield { };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  mask-rcnn = callPackage ../development/python-modules/mask-rcnn { };

  mastodon-py = callPackage ../development/python-modules/mastodon-py { };

  mat2 = callPackage ../development/python-modules/mat2 { };

  matchpy = callPackage ../development/python-modules/matchpy { };

  mathlibtools = callPackage ../development/python-modules/mathlibtools { };

  matlink-gpapi = callPackage ../development/python-modules/matlink-gpapi { };

  matplotlib = callPackage ../development/python-modules/matplotlib {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  matplotlib-inline = callPackage ../development/python-modules/matplotlib-inline { };

  matrix-api-async = callPackage ../development/python-modules/matrix-api-async { };

  matrix-client = callPackage ../development/python-modules/matrix-client { };

  matrix-common = callPackage ../development/python-modules/matrix-common { };

  matrix-nio = callPackage ../development/python-modules/matrix-nio { };

  mattermostdriver = callPackage ../development/python-modules/mattermostdriver { };

  mautrix = callPackage ../development/python-modules/mautrix { };

  mautrix-appservice = self.mautrix; # alias 2019-12-28

  maxcube-api = callPackage ../development/python-modules/maxcube-api { };

  maxminddb = callPackage ../development/python-modules/maxminddb { };

  maya = callPackage ../development/python-modules/maya { };

  mayavi = pkgs.libsForQt5.callPackage ../development/python-modules/mayavi {
    inherit buildPythonPackage pythonOlder fetchPypi;
    inherit (self) pyface pygments numpy vtk traitsui envisage apptools pyqt5;
  };

  mbddns = callPackage ../development/python-modules/mbddns { };

  mccabe = callPackage ../development/python-modules/mccabe { };

  mcstatus = callPackage ../development/python-modules/mcstatus { };

  md-toc = callPackage ../development/python-modules/md-toc { };

  md2gemini = callPackage ../development/python-modules/md2gemini { };

  mdformat = callPackage ../development/python-modules/mdformat { };

  mdit-py-plugins = callPackage ../development/python-modules/mdit-py-plugins { };

  mdurl = callPackage ../development/python-modules/mdurl { };

  MDP = callPackage ../development/python-modules/mdp { };

  measurement = callPackage ../development/python-modules/measurement { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  mechanicalsoup = callPackage ../development/python-modules/mechanicalsoup { };

  mechanize = callPackage ../development/python-modules/mechanize { };

  mediafile = callPackage ../development/python-modules/mediafile { };

  meinheld = callPackage ../development/python-modules/meinheld { };

  meld3 = callPackage ../development/python-modules/meld3 { };

  memcached = callPackage ../development/python-modules/memcached { };

  memory-allocator = callPackage ../development/python-modules/memory-allocator { };

  memory_profiler = callPackage ../development/python-modules/memory_profiler { };

  mercantile = callPackage ../development/python-modules/mercantile { };

  mercurial = toPythonModule (pkgs.mercurial.override {
    python3Packages = self;
  });

  mergedeep = callPackage ../development/python-modules/mergedeep { };

  merkletools = callPackage ../development/python-modules/merkletools { };

  meross-iot = callPackage ../development/python-modules/meross-iot { };

  mesa = callPackage ../development/python-modules/mesa { };

  meshio = callPackage ../development/python-modules/meshio { };

  meshlabxml = callPackage ../development/python-modules/meshlabxml { };

  meshtastic = callPackage ../development/python-modules/meshtastic { };

  meson = toPythonModule ((pkgs.meson.override { python3 = python; }).overrideAttrs
    (oldAttrs: { # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    }));

  mesonpep517 = callPackage ../development/python-modules/mesonpep517 { };

  metakernel = callPackage ../development/python-modules/metakernel { };

  metar = callPackage ../development/python-modules/metar { };

  meteoalertapi = callPackage ../development/python-modules/meteoalertapi { };

  mezzanine = callPackage ../development/python-modules/mezzanine { };

  micawber = callPackage ../development/python-modules/micawber { };

  midiutil = callPackage ../development/python-modules/midiutil { };

  mido = callPackage ../development/python-modules/mido { };

  migen = callPackage ../development/python-modules/migen { };

  milc = callPackage ../development/python-modules/milc { };

  milksnake = callPackage ../development/python-modules/milksnake { };

  mill-local = callPackage ../development/python-modules/mill-local { };

  millheater = callPackage ../development/python-modules/millheater { };

  minexr = callPackage ../development/python-modules/minexr { };

  miniaudio = callPackage ../development/python-modules/miniaudio { };

  minidb = callPackage ../development/python-modules/minidb { };

  minidump = callPackage ../development/python-modules/minidump { };

  minikerberos = callPackage ../development/python-modules/minikerberos { };

  minimock = callPackage ../development/python-modules/minimock { };

  mininet-python = (toPythonModule (pkgs.mininet.override {
    python3 = python;
  })).py;

  minio = callPackage ../development/python-modules/minio { };

  miniupnpc = callPackage ../development/python-modules/miniupnpc { };

  misaka = callPackage ../development/python-modules/misaka { };

  mistletoe = callPackage ../development/python-modules/mistletoe { };

  inherit (import ../development/python-modules/mistune self)
    mistune
    mistune_0_8
    mistune_2_0
  ;

  mitmproxy = callPackage ../development/python-modules/mitmproxy { };

  mitogen = callPackage ../development/python-modules/mitogen { };

  mixpanel = callPackage ../development/python-modules/mixpanel { };

  mizani = callPackage ../development/python-modules/mizani { };

  mkdocs = callPackage ../development/python-modules/mkdocs { };

  mkl-service = callPackage ../development/python-modules/mkl-service { };

  ml-collections = callPackage ../development/python-modules/ml-collections { };

  mlflow = callPackage ../development/python-modules/mlflow { };

  mlrose = callPackage ../development/python-modules/mlrose { };

  mlxtend = callPackage ../development/python-modules/mlxtend { };

  mlt = toPythonModule (pkgs.mlt.override {
    python3 = python;
    enablePython = true;
  });

  mmh3 = callPackage ../development/python-modules/mmh3 { };

  mmpython = callPackage ../development/python-modules/mmpython { };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  mne-python = callPackage ../development/python-modules/mne-python { };

  mnist = callPackage ../development/python-modules/mnist { };

  mocket = callPackage ../development/python-modules/mocket { };

  mock = callPackage ../development/python-modules/mock { };

  mockito = callPackage ../development/python-modules/mockito { };

  mock-open = callPackage ../development/python-modules/mock-open { };

  mock-services = callPackage ../development/python-modules/mock-services { };

  mockupdb = callPackage ../development/python-modules/mockupdb { };

  modeled = callPackage ../development/python-modules/modeled { };

  moderngl = callPackage ../development/python-modules/moderngl { };

  moderngl-window = callPackage ../development/python-modules/moderngl_window { };

  modestmaps = callPackage ../development/python-modules/modestmaps { };

  mohawk = callPackage ../development/python-modules/mohawk { };

  mongomock = callPackage ../development/python-modules/mongomock { };

  mongodict = callPackage ../development/python-modules/mongodict { };

  mongoengine = callPackage ../development/python-modules/mongoengine { };

  monkeyhex = callPackage ../development/python-modules/monkeyhex { };

  monosat = (pkgs.monosat.python {
    inherit buildPythonPackage;
    inherit (self) cython;
  });

  monotonic = callPackage ../development/python-modules/monotonic { };

  monty = callPackage ../development/python-modules/monty { };

  moonraker-api = callPackage ../development/python-modules/moonraker-api { };

  more-itertools = callPackage ../development/python-modules/more-itertools { };

  moretools = callPackage ../development/python-modules/moretools { };

  morphys = callPackage ../development/python-modules/morphys { };

  mortgage = callPackage ../development/python-modules/mortgage { };

  motionblinds = callPackage ../development/python-modules/motionblinds { };

  motioneye-client = callPackage ../development/python-modules/motioneye-client { };

  moto = callPackage ../development/python-modules/moto { };

  motor = callPackage ../development/python-modules/motor { };

  mouseinfo = callPackage ../development/python-modules/mouseinfo { };

  moviepy = callPackage ../development/python-modules/moviepy { };

  mox3 = callPackage ../development/python-modules/mox3 { };

  mox = callPackage ../development/python-modules/mox { };

  mpd2 = callPackage ../development/python-modules/mpd2 { };

  mpi4py = callPackage ../development/python-modules/mpi4py { };

  mpldatacursor = callPackage ../development/python-modules/mpldatacursor { };

  mplfinance = callPackage ../development/python-modules/mplfinance { };

  mplleaflet = callPackage ../development/python-modules/mplleaflet { };

  mpmath = callPackage ../development/python-modules/mpmath { };

  mpv = callPackage ../development/python-modules/mpv {
    inherit (pkgs) mpv;
  };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mrkd = callPackage ../development/python-modules/mrkd { };

  ms-active-directory = callPackage ../development/python-modules/ms-active-directory { };

  ms-cv = callPackage ../development/python-modules/ms-cv { };

  msal = callPackage ../development/python-modules/msal { };

  msal-extensions = callPackage ../development/python-modules/msal-extensions { };

  msgpack = callPackage ../development/python-modules/msgpack { };

  msgpack-numpy = callPackage ../development/python-modules/msgpack-numpy { };

  msldap = callPackage ../development/python-modules/msldap { };

  msoffcrypto-tool = callPackage ../development/python-modules/msoffcrypto-tool { };

  mss = callPackage ../development/python-modules/mss { };

  msrestazure = callPackage ../development/python-modules/msrestazure { };

  msrest = callPackage ../development/python-modules/msrest { };

  mt-940 = callPackage ../development/python-modules/mt-940 { };

  mullvad-api = callPackage ../development/python-modules/mullvad-api { };

  mulpyplexer = callPackage ../development/python-modules/mulpyplexer { };

  multidict = callPackage ../development/python-modules/multidict { };

  multi_key_dict = callPackage ../development/python-modules/multi_key_dict { };

  multimethod = callPackage ../development/python-modules/multimethod { };

  multipledispatch = callPackage ../development/python-modules/multipledispatch { };

  multiprocess = callPackage ../development/python-modules/multiprocess { };

  multiset = callPackage ../development/python-modules/multiset { };

  multitasking = callPackage ../development/python-modules/multitasking { };

  munch = callPackage ../development/python-modules/munch { };

  munkres = callPackage ../development/python-modules/munkres { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  musicbrainzngs = callPackage ../development/python-modules/musicbrainzngs { };

  mutag = callPackage ../development/python-modules/mutag { };

  mutagen = callPackage ../development/python-modules/mutagen { };

  mutatormath = callPackage ../development/python-modules/mutatormath { };

  mutesync = callPackage ../development/python-modules/mutesync { };

  mutf8 = callPackage ../development/python-modules/mutf8 { };

  mutmut = callPackage ../development/python-modules/mutmut { };

  mujson = callPackage ../development/python-modules/mujson { };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwdblib = callPackage ../development/python-modules/mwdblib { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

  mwparserfromhell = callPackage ../development/python-modules/mwparserfromhell { };

  mxnet = callPackage ../development/python-modules/mxnet { };

  myfitnesspal = callPackage ../development/python-modules/myfitnesspal { };

  mygpoclient = callPackage ../development/python-modules/mygpoclient { };

  myhome = callPackage ../development/python-modules/myhome { };

  myjwt = callPackage ../development/python-modules/myjwt { };

  mypy = callPackage ../development/python-modules/mypy { };

  mypy-boto3-builder = callPackage ../development/python-modules/mypy-boto3-builder { };

  mypy-boto3-s3 = callPackage ../development/python-modules/mypy-boto3-s3 { };

  mypy-extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  mysqlclient = callPackage ../development/python-modules/mysqlclient { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  nad-receiver = callPackage ../development/python-modules/nad-receiver { };

  nagiosplugin = callPackage ../development/python-modules/nagiosplugin { };

  namedlist = callPackage ../development/python-modules/namedlist { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  names = callPackage ../development/python-modules/names { };

  nampa = callPackage ../development/python-modules/nampa { };

  nanoleaf = callPackage ../development/python-modules/nanoleaf { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python {
    inherit (pkgs) nanomsg;
  };

  nanotime = callPackage ../development/python-modules/nanotime { };

  napari = callPackage ../development/python-modules/napari {
    inherit (pkgs.libsForQt5) mkDerivationWith wrapQtAppsHook;
  };

  napari-console = callPackage ../development/python-modules/napari-console { };

  napari-plugin-engine = callPackage ../development/python-modules/napari-plugin-engine { };

  napari-svg = callPackage ../development/python-modules/napari-svg { };

  nassl = callPackage ../development/python-modules/nassl { };

  nats-py = callPackage ../development/python-modules/nats-py { };

  nats-python = callPackage ../development/python-modules/nats-python { };

  natsort = callPackage ../development/python-modules/natsort { };

  naturalsort = callPackage ../development/python-modules/naturalsort { };

  nbclassic = callPackage ../development/python-modules/nbclassic { };

  nbclient = callPackage ../development/python-modules/nbclient { };

  nbconflux = callPackage ../development/python-modules/nbconflux { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbdime = callPackage ../development/python-modules/nbdime { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbsmoke = callPackage ../development/python-modules/nbsmoke { };

  nbsphinx = callPackage ../development/python-modules/nbsphinx { };

  nbval = callPackage ../development/python-modules/nbval { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  ncclient = callPackage ../development/python-modules/ncclient { };

  nclib = callPackage ../development/python-modules/nclib { };

  ndg-httpsclient = callPackage ../development/python-modules/ndg-httpsclient { };

  ndjson = callPackage ../development/python-modules/ndjson { };

  ndms2-client = callPackage ../development/python-modules/ndms2-client { };

  ndspy = callPackage ../development/python-modules/ndspy { };

  ndtypes = callPackage ../development/python-modules/ndtypes { };

  nengo = callPackage ../development/python-modules/nengo { };

  neo = callPackage ../development/python-modules/neo { };

  neo4j-driver = callPackage ../development/python-modules/neo4j-driver { };

  nessclient = callPackage ../development/python-modules/nessclient { };

  nest-asyncio = callPackage ../development/python-modules/nest-asyncio { };

  nestedtext = callPackage ../development/python-modules/nestedtext { };

  netaddr = callPackage ../development/python-modules/netaddr { };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  netdata = callPackage ../development/python-modules/netdata { };

  netdisco = callPackage ../development/python-modules/netdisco { };

  netifaces = callPackage ../development/python-modules/netifaces { };

  nettigo-air-monitor = callPackage ../development/python-modules/nettigo-air-monitor { };

  networkx = callPackage ../development/python-modules/networkx { };

  neuron-mpi = pkgs.neuron-mpi.override { inherit python; };

  neuron = pkgs.neuron.override { inherit python; };

  neuronpy = callPackage ../development/python-modules/neuronpy { };

  nevow = callPackage ../development/python-modules/nevow { };

  nexia = callPackage ../development/python-modules/nexia { };

  nextcloudmonitor = callPackage ../development/python-modules/nextcloudmonitor { };

  nghttp2 = (toPythonModule (pkgs.nghttp2.override {
    inherit (self) python cython setuptools;
    inherit (pkgs) ncurses;
    enablePython = true;
  })).python;

  nibabel = callPackage ../development/python-modules/nibabel { };

  nidaqmx = callPackage ../development/python-modules/nidaqmx { };

  Nikola = callPackage ../development/python-modules/Nikola { };

  niko-home-control = callPackage ../development/python-modules/niko-home-control { };

  nilearn = callPackage ../development/python-modules/nilearn { };

  niluclient = callPackage ../development/python-modules/niluclient { };

  nimfa = callPackage ../development/python-modules/nimfa { };

  nine = callPackage ../development/python-modules/nine { };

  nipy = callPackage ../development/python-modules/nipy { };

  nipype = callPackage ../development/python-modules/nipype {
    inherit (pkgs) which;
  };

  nitime = callPackage ../development/python-modules/nitime { };

  nitpick = callPackage ../applications/version-management/nitpick { };

  nitransforms = callPackage ../development/python-modules/nitransforms { };

  nix-kernel = callPackage ../development/python-modules/nix-kernel {
    inherit (pkgs) nix;
  };

  nixpkgs = callPackage ../development/python-modules/nixpkgs { };

  nixpkgs-pytools = callPackage ../development/python-modules/nixpkgs-pytools { };

  nix-prefetch-github = callPackage ../development/python-modules/nix-prefetch-github { };

  nkdfu = callPackage ../development/python-modules/nkdfu { };

  nltk = callPackage ../development/python-modules/nltk { };

  nmapthon2 = callPackage ../development/python-modules/nmapthon2 { };

  amaranth-boards = callPackage ../development/python-modules/amaranth-boards { };

  amaranth = callPackage ../development/python-modules/amaranth { };

  amaranth-soc = callPackage ../development/python-modules/amaranth-soc { };

  nocasedict = callPackage ../development/python-modules/nocasedict { };

  nocaselist = callPackage ../development/python-modules/nocaselist { };

  nodeenv = callPackage ../development/python-modules/nodeenv { };

  nodepy-runtime = callPackage ../development/python-modules/nodepy-runtime { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  noise = callPackage ../development/python-modules/noise { };

  noiseprotocol = callPackage ../development/python-modules/noiseprotocol { };

  normality = callPackage ../development/python-modules/normality { };

  nose2 = callPackage ../development/python-modules/nose2 { };

  nose = callPackage ../development/python-modules/nose { };

  nose-cov = callPackage ../development/python-modules/nose-cov { };

  nose-cover3 = callPackage ../development/python-modules/nose-cover3 { };

  nose-cprof = callPackage ../development/python-modules/nose-cprof { };

  nose-exclude = callPackage ../development/python-modules/nose-exclude { };

  nose-timer = callPackage ../development/python-modules/nose-timer { };

  nosejs = callPackage ../development/python-modules/nosejs { };

  nose-pattern-exclude = callPackage ../development/python-modules/nose-pattern-exclude { };

  nose_progressive = callPackage ../development/python-modules/nose_progressive { };

  nose-randomly = callPackage ../development/python-modules/nose-randomly { };

  nose_warnings_filters = callPackage ../development/python-modules/nose_warnings_filters { };

  nosexcover = callPackage ../development/python-modules/nosexcover { };

  notebook = callPackage ../development/python-modules/notebook { };

  notedown = callPackage ../development/python-modules/notedown { };

  notifications-python-client = callPackage ../development/python-modules/notifications-python-client { };

  notify-py = callPackage ../development/python-modules/notify-py { };

  notify2 = callPackage ../development/python-modules/notify2 { };

  notmuch = callPackage ../development/python-modules/notmuch {
    inherit (pkgs) notmuch;
  };

  nototools = callPackage ../data/fonts/noto-fonts/tools.nix { };

  notus-scanner = callPackage ../development/python-modules/notus-scanner { };

  nplusone = callPackage ../development/python-modules/nplusone { };

  npyscreen = callPackage ../development/python-modules/npyscreen { };

  nsapi = callPackage ../development/python-modules/nsapi { };

  ntfy-webpush = callPackage ../tools/misc/ntfy-webpush { };

  ntc-templates = callPackage ../development/python-modules/ntc-templates { };

  ntlm-auth = callPackage ../development/python-modules/ntlm-auth { };

  ntplib = callPackage ../development/python-modules/ntplib { };

  Nuitka = callPackage ../development/python-modules/nuitka { };

  nulltype = callPackage ../development/python-modules/nulltype { };

  num2words = callPackage ../development/python-modules/num2words { };

  numba = callPackage ../development/python-modules/numba { };

  numcodecs = callPackage ../development/python-modules/numcodecs { };

  numericalunits = callPackage ../development/python-modules/numericalunits { };

  numexpr = callPackage ../development/python-modules/numexpr { };

  numpydoc = callPackage ../development/python-modules/numpydoc { };

  numpy = callPackage ../development/python-modules/numpy { };

  numpy-stl = callPackage ../development/python-modules/numpy-stl { };

  nunavut = callPackage ../development/python-modules/nunavut { };

  nvchecker = callPackage ../development/python-modules/nvchecker { };

  python-nvd3 = callPackage ../development/python-modules/python-nvd3 { };

  nwdiag = callPackage ../development/python-modules/nwdiag { };

  oath = callPackage ../development/python-modules/oath { };

  oauth2 = callPackage ../development/python-modules/oauth2 { };

  oauth2client = callPackage ../development/python-modules/oauth2client { };

  oauth = callPackage ../development/python-modules/oauth { };

  oauthenticator = callPackage ../development/python-modules/oauthenticator { };

  oauthlib = callPackage ../development/python-modules/oauthlib { };

  obfsproxy = callPackage ../development/python-modules/obfsproxy { };

  objax = callPackage ../development/python-modules/objax { };

  objgraph = callPackage ../development/python-modules/objgraph {
    # requires both the graphviz package and python package
    graphvizPkgs = pkgs.graphviz;
  };

  obspy = callPackage ../development/python-modules/obspy { };

  oci = callPackage ../development/python-modules/oci { };

  ocrmypdf = callPackage ../development/python-modules/ocrmypdf { };

  od = callPackage ../development/python-modules/od { };

  odfpy = callPackage ../development/python-modules/odfpy { };

  offtrac = callPackage ../development/python-modules/offtrac { };

  ofxclient = callPackage ../development/python-modules/ofxclient { };

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = callPackage ../development/python-modules/ofxparse { };

  ofxtools = callPackage ../development/python-modules/ofxtools { };

  oemthermostat = callPackage ../development/python-modules/oemthermostat { };

  olefile = callPackage ../development/python-modules/olefile { };

  oletools = callPackage ../development/python-modules/oletools { };

  omegaconf = callPackage ../development/python-modules/omegaconf { };

  omnikinverter = callPackage ../development/python-modules/omnikinverter { };

  omnilogic = callPackage ../development/python-modules/omnilogic { };

  ondilo = callPackage ../development/python-modules/ondilo { };

  onetimepass = callPackage ../development/python-modules/onetimepass { };

  onkyo-eiscp = callPackage ../development/python-modules/onkyo-eiscp { };

  online-judge-api-client = callPackage ../development/python-modules/online-judge-api-client { };

  online-judge-tools = callPackage ../development/python-modules/online-judge-tools { };

  onlykey-solo-python = callPackage ../development/python-modules/onlykey-solo-python { };

  onnx = callPackage ../development/python-modules/onnx { };

  oocsi = callPackage ../development/python-modules/oocsi { };

  open-garage = callPackage ../development/python-modules/open-garage { };

  open-meteo = callPackage ../development/python-modules/open-meteo { };

  openant = callPackage ../development/python-modules/openant { };

  openapi-schema-validator = callPackage ../development/python-modules/openapi-schema-validator { };

  openapi-spec-validator = callPackage ../development/python-modules/openapi-spec-validator { };

  openbabel-bindings = callPackage ../development/python-modules/openbabel-bindings {
      openbabel = (callPackage ../development/libraries/openbabel { python = self.python; });
  };

  opencv3 = toPythonModule (pkgs.opencv3.override {
    enablePython = true;
    pythonPackages = self;
  });

  opencv4 = toPythonModule (pkgs.opencv4.override {
    enablePython = true;
    pythonPackages = self;
  });

  openerz-api = callPackage ../development/python-modules/openerz-api { };

  openhomedevice = callPackage ../development/python-modules/openhomedevice { };

  openidc-client = callPackage ../development/python-modules/openidc-client { };

  openpyxl = callPackage ../development/python-modules/openpyxl { };

  openrazer = callPackage ../development/python-modules/openrazer/pylib.nix { };

  openrazer-daemon = callPackage ../development/python-modules/openrazer/daemon.nix { };

  openrouteservice = callPackage ../development/python-modules/openrouteservice { };

  opensensemap-api = callPackage ../development/python-modules/opensensemap-api { };

  openshift = callPackage ../development/python-modules/openshift { };

  opensimplex = callPackage ../development/python-modules/opensimplex { };

  openstacksdk = callPackage ../development/python-modules/openstacksdk { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  opentracing = callPackage ../development/python-modules/opentracing { };

  openvino = toPythonModule (pkgs.openvino.override {
    inherit (self) python;
    enablePython = true;
  });

  openwebifpy = callPackage ../development/python-modules/openwebifpy { };

  openwrt-luci-rpc = callPackage ../development/python-modules/openwrt-luci-rpc { };

  openwrt-ubus-rpc = callPackage ../development/python-modules/openwrt-ubus-rpc { };

  opsdroid_get_image_size = callPackage ../development/python-modules/opsdroid_get_image_size { };

  opt-einsum = callPackage ../development/python-modules/opt-einsum { };

  optax = callPackage ../development/python-modules/optax { };

  optuna = callPackage ../development/python-modules/optuna { };

  opuslib = callPackage ../development/python-modules/opuslib { };

  ordereddict = callPackage ../development/python-modules/ordereddict { };

  orderedmultidict = callPackage ../development/python-modules/orderedmultidict { };

  ordered-set = callPackage ../development/python-modules/ordered-set { };

  orderedset = callPackage ../development/python-modules/orderedset { };

  orjson = callPackage ../development/python-modules/orjson { };

  orm = callPackage ../development/python-modules/orm { };

  ormar = callPackage ../development/python-modules/ormar { };

  ortools = (toPythonModule (pkgs.or-tools.override { inherit (self) python; })).python;

  orvibo = callPackage ../development/python-modules/orvibo { };

  os-service-types = callPackage ../development/python-modules/os-service-types { };

  osc = callPackage ../development/python-modules/osc { };

  osc-lib = callPackage ../development/python-modules/osc-lib { };

  oscrypto = callPackage ../development/python-modules/oscrypto { };

  oset = callPackage ../development/python-modules/oset { };

  osmnx = callPackage ../development/python-modules/osmnx { };

  osmpythontools = callPackage ../development/python-modules/osmpythontools { };

  oslo-concurrency = callPackage ../development/python-modules/oslo-concurrency { };

  oslo-config = callPackage ../development/python-modules/oslo-config { };

  oslo-context = callPackage ../development/python-modules/oslo-context { };

  oslo-db = callPackage ../development/python-modules/oslo-db { };

  oslo-i18n = callPackage ../development/python-modules/oslo-i18n { };

  oslo-log = callPackage ../development/python-modules/oslo-log { };

  oslo-serialization = callPackage ../development/python-modules/oslo-serialization { };

  oslo-utils = callPackage ../development/python-modules/oslo-utils { };

  oslotest = callPackage ../development/python-modules/oslotest { };

  ospd = callPackage ../development/python-modules/ospd { };

  osqp = callPackage ../development/python-modules/osqp { };

  outcome = callPackage ../development/python-modules/outcome { };

  ovh = callPackage ../development/python-modules/ovh { };

  ovoenergy = callPackage ../development/python-modules/ovoenergy { };

  owslib = callPackage ../development/python-modules/owslib { };

  oyaml = callPackage ../development/python-modules/oyaml { };

  p1monitor = callPackage ../development/python-modules/p1monitor { };

  packageurl-python = callPackage ../development/python-modules/packageurl-python { };

  packaging = callPackage ../development/python-modules/packaging { };

  packbits = callPackage ../development/python-modules/packbits { };

  packet-python = callPackage ../development/python-modules/packet-python { };

  pafy = callPackage ../development/python-modules/pafy { };

  pagelabels = callPackage ../development/python-modules/pagelabels { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt { };

  palace = callPackage ../development/python-modules/palace { };

  palettable = callPackage ../development/python-modules/palettable { };

  pamela = callPackage ../development/python-modules/pamela { };

  pamqp = callPackage ../development/python-modules/pamqp { };

  panacotta = callPackage ../development/python-modules/panacotta { };

  pandas = callPackage ../development/python-modules/pandas { };

  pandas-datareader = callPackage ../development/python-modules/pandas-datareader { };

  pandoc-attributes = callPackage ../development/python-modules/pandoc-attributes { };

  pandocfilters = callPackage ../development/python-modules/pandocfilters { };

  panel = callPackage ../development/python-modules/panel { };

  panflute = callPackage ../development/python-modules/panflute { };

  papermill = callPackage ../development/python-modules/papermill { };

  openpaperwork-core = callPackage ../applications/office/paperwork/openpaperwork-core.nix { };
  openpaperwork-gtk = callPackage ../applications/office/paperwork/openpaperwork-gtk.nix { };
  paperwork-backend = callPackage ../applications/office/paperwork/paperwork-backend.nix { };
  paperwork-shell = callPackage ../applications/office/paperwork/paperwork-shell.nix { };

  papis = callPackage ../development/python-modules/papis { };

  papis-python-rofi = callPackage ../development/python-modules/papis-python-rofi { };

  param = callPackage ../development/python-modules/param { };

  parameter-expansion-patched = callPackage ../development/python-modules/parameter-expansion-patched { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  paramiko = callPackage ../development/python-modules/paramiko { };

  paramz = callPackage ../development/python-modules/paramz { };

  parfive = callPackage ../development/python-modules/parfive { };

  parquet = callPackage ../development/python-modules/parquet { };

  parse = callPackage ../development/python-modules/parse { };

  parsedatetime = callPackage ../development/python-modules/parsedatetime { };

  parsedmarc = callPackage ../development/python-modules/parsedmarc { };

  parsel = callPackage ../development/python-modules/parsel { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  parsimonious = callPackage ../development/python-modules/parsimonious { };

  parsley = callPackage ../development/python-modules/parsley { };

  parso = callPackage ../development/python-modules/parso { };

  parsy = callPackage ../development/python-modules/parsy { };

  partd = callPackage ../development/python-modules/partd { };

  parts = callPackage ../development/python-modules/parts { };

  parver = callPackage ../development/python-modules/parver { };
  arpeggio = callPackage ../development/python-modules/arpeggio { };

  passlib = callPackage ../development/python-modules/passlib { };

  paste = callPackage ../development/python-modules/paste { };

  pastedeploy = callPackage ../development/python-modules/pastedeploy { };

  pastel = callPackage ../development/python-modules/pastel { };

  pastescript = callPackage ../development/python-modules/pastescript { };

  patator = callPackage ../development/python-modules/patator { };

  patch = callPackage ../development/python-modules/patch { };

  patch-ng = callPackage ../development/python-modules/patch-ng { };

  path-and-address = callPackage ../development/python-modules/path-and-address { };

  pathlib2 = callPackage ../development/python-modules/pathlib2 { };

  pathlib = callPackage ../development/python-modules/pathlib { };

  pathos = callPackage ../development/python-modules/pathos { };

  pathpy = callPackage ../development/python-modules/path.py { };

  pathspec = callPackage ../development/python-modules/pathspec { };

  pathtools = callPackage ../development/python-modules/pathtools { };

  pathvalidate = callPackage ../development/python-modules/pathvalidate { };

  pathy = callPackage ../development/python-modules/pathy { };

  patiencediff = callPackage ../development/python-modules/patiencediff { };

  patool = callPackage ../development/python-modules/patool { };

  patsy = callPackage ../development/python-modules/patsy { };

  patrowl4py = callPackage ../development/python-modules/patrowl4py { };

  paver = callPackage ../development/python-modules/paver { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbkdf2 = callPackage ../development/python-modules/pbkdf2 { };

  pbr = callPackage ../development/python-modules/pbr { };

  pc-ble-driver-py = toPythonModule (callPackage ../development/python-modules/pc-ble-driver-py { });

  pcodedmp = callPackage ../development/python-modules/pcodedmp { };

  pcpp = callPackage ../development/python-modules/pcpp { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfkit = callPackage ../development/python-modules/pdfkit { };

  pdfminer = callPackage ../development/python-modules/pdfminer_six { };

  pdfposter = callPackage ../development/python-modules/pdfposter { };

  pdfrw = callPackage ../development/python-modules/pdfrw { };

  pdftotext = callPackage ../development/python-modules/pdftotext { };

  pdfx = callPackage ../development/python-modules/pdfx { };

  pdm-pep517 = callPackage ../development/python-modules/pdm-pep517 { };

  pdoc3 = callPackage ../development/python-modules/pdoc3 { };

  pebble = callPackage ../development/python-modules/pebble { };

  pecan = callPackage ../development/python-modules/pecan { };

  peewee = callPackage ../development/python-modules/peewee { };

  pefile = callPackage ../development/python-modules/pefile { };

  pelican = callPackage ../development/python-modules/pelican {
    inherit (pkgs) glibcLocales git;
  };

  pendulum = callPackage ../development/python-modules/pendulum { };

  pep257 = callPackage ../development/python-modules/pep257 { };

  pep440 = callPackage ../development/python-modules/pep440 { };

  pep517 = callPackage ../development/python-modules/pep517 { };

  pep8 = callPackage ../development/python-modules/pep8 { };

  pep8-naming = callPackage ../development/python-modules/pep8-naming { };

  peppercorn = callPackage ../development/python-modules/peppercorn { };

  percol = callPackage ../development/python-modules/percol { };

  perfplot = callPackage ../development/python-modules/perfplot { };

  periodictable = callPackage ../development/python-modules/periodictable { };

  persim = callPackage ../development/python-modules/persim { };

  persistent = callPackage ../development/python-modules/persistent { };

  persisting-theory = callPackage ../development/python-modules/persisting-theory { };

  pescea = callPackage ../development/python-modules/pescea { };

  pex = callPackage ../development/python-modules/pex { };

  pexif = callPackage ../development/python-modules/pexif { };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pg8000 = callPackage ../development/python-modules/pg8000 { };

  pgcli = callPackage ../development/tools/database/pgcli { };

  pglast = callPackage ../development/python-modules/pglast { };

  pgpdump = callPackage ../development/python-modules/pgpdump { };

  pgpy = callPackage ../development/python-modules/pgpy { };

  pgsanity = callPackage ../development/python-modules/pgsanity { };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  phe = callPackage ../development/python-modules/phe { };

  phik = callPackage ../development/python-modules/phik { };

  phone-modem = callPackage ../development/python-modules/phone-modem { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  micloud = callPackage ../development/python-modules/micloud { };

  netmap = callPackage ../development/python-modules/netmap { };

  openai = callPackage ../development/python-modules/openai { };

  openapi-core = callPackage ../development/python-modules/openapi-core { };

  pandas-stubs = callPackage ../development/python-modules/pandas-stubs { };

  parameterizedtestcase = callPackage ../development/python-modules/parameterizedtestcase { };

  pdunehd = callPackage ../development/python-modules/pdunehd { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  phpserialize = callPackage ../development/python-modules/phpserialize { };

  phx-class-registry = callPackage ../development/python-modules/phx-class-registry { };

  piccata = callPackage ../development/python-modules/piccata { };

  pickleshare = callPackage ../development/python-modules/pickleshare { };

  picos = callPackage ../development/python-modules/picos { };

  pid = callPackage ../development/python-modules/pid { };

  piep = callPackage ../development/python-modules/piep { };

  piexif = callPackage ../development/python-modules/piexif { };

  pijuice = callPackage ../development/python-modules/pijuice { };

  pika = callPackage ../development/python-modules/pika { };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  pikepdf = callPackage ../development/python-modules/pikepdf { };

  pilkit = callPackage ../development/python-modules/pilkit { };

  pillowfight = callPackage ../development/python-modules/pillowfight { };

  pillow = callPackage ../development/python-modules/pillow {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11 libxcb;
  };

  pillow-simd = callPackage ../development/python-modules/pillow-simd {
      inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
      inherit (pkgs.xorg) libX11;
  };

  pims = callPackage ../development/python-modules/pims { };

  pinboard = callPackage ../development/python-modules/pinboard { };

  pint = callPackage ../development/python-modules/pint { };

  pip = callPackage ../development/python-modules/pip { };

  pipdate = callPackage ../development/python-modules/pipdate { };

  pip-tools = callPackage ../development/python-modules/pip-tools { };

  pipx = callPackage ../development/python-modules/pipx { };

  pivy = callPackage ../development/python-modules/pivy {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) soqt;
  };

  pixelmatch = callPackage ../development/python-modules/pixelmatch { };

  pkce = callPackage ../development/python-modules/pkce { };

  pkgconfig = callPackage ../development/python-modules/pkgconfig { };

  pkginfo = callPackage ../development/python-modules/pkginfo { };

  pkuseg = callPackage ../development/python-modules/pkuseg { };

  pmsensor = callPackage ../development/python-modules/pmsensor { };

  ppdeep = callPackage ../development/python-modules/ppdeep { };

  proxy_tools = callPackage ../development/python-modules/proxy_tools { };

  pyaehw4a1 = callPackage ../development/python-modules/pyaehw4a1 { };

  pyatag = callPackage ../development/python-modules/pyatag { };

  pyatome = callPackage ../development/python-modules/pyatome { };

  pycontrol4 = callPackage ../development/python-modules/pycontrol4 { };

  pycoolmasternet-async = callPackage ../development/python-modules/pycoolmasternet-async { };

  pyfireservicerota = callPackage ../development/python-modules/pyfireservicerota { };

  pyflexit = callPackage ../development/python-modules/pyflexit { };

  pyflick = callPackage ../development/python-modules/pyflick { };

  pyfreedompro = callPackage ../development/python-modules/pyfreedompro { };

  pygti = callPackage ../development/python-modules/pygti { };

  pyheos = callPackage ../development/python-modules/pyheos { };

  pyhiveapi = callPackage ../development/python-modules/pyhiveapi { };

  pyhumps = callPackage ../development/python-modules/pyhumps { };

  pyisy = callPackage ../development/python-modules/pyisy { };

  pykrakenapi = callPackage ../development/python-modules/pykrakenapi { };

  pynndescent = callPackage ../development/python-modules/pynndescent { };

  pynobo = callPackage ../development/python-modules/pynobo { };

  pynuki = callPackage ../development/python-modules/pynuki { };

  pynut2 = callPackage ../development/python-modules/pynut2 { };

  pynws = callPackage ../development/python-modules/pynws { };

  pynx584 = callPackage ../development/python-modules/pynx584 { };

  pypoint = callPackage ../development/python-modules/pypoint { };

  pypoolstation = callPackage ../development/python-modules/pypoolstation { };

  pyrfxtrx = callPackage ../development/python-modules/pyrfxtrx { };

  pyrogram = callPackage ../development/python-modules/pyrogram { };

  pysbd = callPackage ../development/python-modules/pysbd { };

  pyshark = callPackage ../development/python-modules/pyshark { };

  pysiaalarm = callPackage ../development/python-modules/pysiaalarm { };

  pyskyqhub = callPackage ../development/python-modules/pyskyqhub { };

  pyskyqremote = callPackage ../development/python-modules/pyskyqremote { };

  pysolcast = callPackage ../development/python-modules/pysolcast { };

  pysyncthru = callPackage ../development/python-modules/pysyncthru { };

  python-codon-tables = callPackage ../development/python-modules/python-codon-tables { };

  python-crfsuite = callPackage ../development/python-modules/python-crfsuite { };

  python-csxcad = callPackage ../development/python-modules/python-csxcad { };

  python-ecobee-api = callPackage ../development/python-modules/python-ecobee-api { };

  python-glanceclient = callPackage ../development/python-modules/python-glanceclient { };

  python-google-nest = callPackage ../development/python-modules/python-google-nest { };

  python-heatclient = callPackage ../development/python-modules/python-heatclient { };

  python-ipmi = callPackage ../development/python-modules/python-ipmi { };

  python-ironicclient = callPackage ../development/python-modules/python-ironicclient { };

  python-izone = callPackage ../development/python-modules/python-izone { };

  python-juicenet = callPackage ../development/python-modules/python-juicenet { };

  python-kasa = callPackage ../development/python-modules/python-kasa { };

  python-keycloak = callPackage ../development/python-modules/python-keycloak { };

  python-keystoneclient = callPackage ../development/python-modules/python-keystoneclient { };

  python-lsp-black = callPackage ../development/python-modules/python-lsp-black { };

  python-openems = callPackage ../development/python-modules/python-openems { };

  python-openzwave-mqtt = callPackage ../development/python-modules/python-openzwave-mqtt { };

  python-owasp-zap-v2-4 = callPackage ../development/python-modules/python-owasp-zap-v2-4 { };

  python-songpal = callPackage ../development/python-modules/python-songpal { };

  python-swiftclient = callPackage ../development/python-modules/python-swiftclient { };

  python-tado = callPackage ../development/python-modules/python-tado { };

  pythonfinder = callPackage ../development/python-modules/pythonfinder { };

  pyutil = callPackage ../development/python-modules/pyutil { };

  pkutils = callPackage ../development/python-modules/pkutils { };

  plac = callPackage ../development/python-modules/plac { };

  plaid-python = callPackage ../development/python-modules/plaid-python { };

  plaster = callPackage ../development/python-modules/plaster { };

  plaster-pastedeploy = callPackage ../development/python-modules/plaster-pastedeploy { };

  platformdirs = callPackage ../development/python-modules/platformdirs { };

  playsound = callPackage ../development/python-modules/playsound { };

  plexapi = callPackage ../development/python-modules/plexapi { };

  plexauth = callPackage ../development/python-modules/plexauth { };

  plexwebsocket = callPackage ../development/python-modules/plexwebsocket { };

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  plotly = callPackage ../development/python-modules/plotly { };

  pluggy = callPackage ../development/python-modules/pluggy { };

  plugincode = callPackage ../development/python-modules/plugincode { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  plugnplay = callPackage ../development/python-modules/plugnplay { };

  plugwise = callPackage ../development/python-modules/plugwise { };

  plum-py = callPackage ../development/python-modules/plum-py { };

  plumbum = callPackage ../development/python-modules/plumbum { };

  ply = callPackage ../development/python-modules/ply { };

  plyer = callPackage ../development/python-modules/plyer { };

  plyfile = callPackage ../development/python-modules/plyfile { };

  plyplus = callPackage ../development/python-modules/plyplus { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  Pmw = callPackage ../development/python-modules/Pmw { };

  pocket = callPackage ../development/python-modules/pocket { };

  podcastparser = callPackage ../development/python-modules/podcastparser { };

  podcats = callPackage ../development/python-modules/podcats { };

  poetry = callPackage ../development/python-modules/poetry { };

  poetry-core = callPackage ../development/python-modules/poetry-core { };

  poetry-semver = callPackage ../development/python-modules/poetry-semver { };

  poetry2conda = callPackage ../development/python-modules/poetry2conda { };

  poezio = callPackage ../applications/networking/instant-messengers/poezio { };

  polarizationsolver = callPackage ../development/python-modules/polarizationsolver { };

  polib = callPackage ../development/python-modules/polib { };

  policy-sentry = callPackage ../development/python-modules/policy-sentry { };

  policyuniverse = callPackage ../development/python-modules/policyuniverse { };

  polyline = callPackage ../development/python-modules/polyline { };

  pomegranate = callPackage ../development/python-modules/pomegranate { };

  pontos = callPackage ../development/python-modules/pontos { };

  pony = callPackage ../development/python-modules/pony { };

  ponywhoosh = callPackage ../development/python-modules/ponywhoosh { };

  pooch = callPackage ../development/python-modules/pooch { };

  pook = callPackage ../development/python-modules/pook { };

  poolsense = callPackage ../development/python-modules/poolsense { };

  poppler-qt5 = callPackage ../development/python-modules/poppler-qt5 {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) poppler;
  };

  portalocker = callPackage ../development/python-modules/portalocker { };

  portend = callPackage ../development/python-modules/portend { };

  portpicker = callPackage ../development/python-modules/portpicker { };

  posix_ipc = callPackage ../development/python-modules/posix_ipc { };

  poster3 = callPackage ../development/python-modules/poster3 { };

  postorius = callPackage ../servers/mail/mailman/postorius.nix { };

  pot = callPackage ../development/python-modules/pot { };

  potentials = callPackage ../development/python-modules/potentials { };

  potr = callPackage ../development/python-modules/potr { };

  power = callPackage ../development/python-modules/power { };

  powerline = callPackage ../development/python-modules/powerline { };

  powerline-mem-segment = callPackage ../development/python-modules/powerline-mem-segment { };

  pox = callPackage ../development/python-modules/pox { };

  poyo = callPackage ../development/python-modules/poyo { };

  ppft = callPackage ../development/python-modules/ppft { };

  pplpy = callPackage ../development/python-modules/pplpy { };

  pprintpp = callPackage ../development/python-modules/pprintpp { };

  pproxy = callPackage ../development/python-modules/pproxy { };

  ppscore = callPackage ../development/python-modules/ppscore { };

  pq = callPackage ../development/python-modules/pq { };

  prance = callPackage ../development/python-modules/prance { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  praw = callPackage ../development/python-modules/praw { };

  prayer-times-calculator = callPackage ../development/python-modules/prayer-times-calculator { };

  precis-i18n = callPackage ../development/python-modules/precis-i18n { };

  prefixed = callPackage ../development/python-modules/prefixed { };

  pre-commit-hooks = callPackage ../development/python-modules/pre-commit-hooks { };

  preggy = callPackage ../development/python-modules/preggy { };

  premailer = callPackage ../development/python-modules/premailer { };

  preshed = callPackage ../development/python-modules/preshed { };

  pretend = callPackage ../development/python-modules/pretend { };

  prettytable = callPackage ../development/python-modules/prettytable { };

  primecountpy = callPackage ../development/python-modules/primecountpy { };

  primer3 = callPackage ../development/python-modules/primer3 { };

  priority = callPackage ../development/python-modules/priority { };

  prison = callPackage ../development/python-modules/prison { };

  privacyidea-ldap-proxy = callPackage ../development/python-modules/privacyidea-ldap-proxy { };

  proboscis = callPackage ../development/python-modules/proboscis { };

  process-tests = callPackage ../development/python-modules/process-tests { };

  proglog = callPackage ../development/python-modules/proglog { };

  progressbar2 = callPackage ../development/python-modules/progressbar2 { };

  progressbar33 = callPackage ../development/python-modules/progressbar33 { };

  progressbar = callPackage ../development/python-modules/progressbar { };

  progress = callPackage ../development/python-modules/progress { };

  prometheus-client = callPackage ../development/python-modules/prometheus-client { };

  prometheus-flask-exporter = callPackage ../development/python-modules/prometheus-flask-exporter { };

  promise = callPackage ../development/python-modules/promise { };

  prompt-toolkit = callPackage ../development/python-modules/prompt-toolkit { };

  property-manager = callPackage ../development/python-modules/property-manager { };

  protego = callPackage ../development/python-modules/protego { };

  proto-plus = callPackage ../development/python-modules/proto-plus { };

  protobuf = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
    doCheck = !isPy3k;
    inherit (pkgs) protobuf;
  };

  protobuf3-to-dict = callPackage ../development/python-modules/protobuf3-to-dict { };

  proton-client = callPackage ../development/python-modules/proton-client { };

  protonup = callPackage ../development/python-modules/protonup { };

  protonvpn-nm-lib = callPackage ../development/python-modules/protonvpn-nm-lib { };

  prov = callPackage ../development/python-modules/prov { };

  prox-tv = callPackage ../development/python-modules/prox-tv { };

  proxmoxer = callPackage ../development/python-modules/proxmoxer { };

  proxy-py = callPackage ../development/python-modules/proxy-py { };

  psautohint = callPackage ../development/python-modules/psautohint { };

  pscript = callPackage ../development/python-modules/pscript { };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psutil = callPackage ../development/python-modules/psutil { };

  psycopg2 = callPackage ../development/python-modules/psycopg2 { };

  psycopg2cffi = callPackage ../development/python-modules/psycopg2cffi { };

  psygnal = callPackage ../development/python-modules/psygnal { };

  ptable = callPackage ../development/python-modules/ptable { };

  ptest = callPackage ../development/python-modules/ptest { };

  ptpython = callPackage ../development/python-modules/ptpython { };

  ptyprocess = callPackage ../development/python-modules/ptyprocess { };

  publicsuffix2 = callPackage ../development/python-modules/publicsuffix2 { };

  publicsuffix = callPackage ../development/python-modules/publicsuffix { };

  pubnub = callPackage ../development/python-modules/pubnub { };

  pubnubsub-handler = callPackage ../development/python-modules/pubnubsub-handler { };

  pudb = callPackage ../development/python-modules/pudb { };

  pulp = callPackage ../development/python-modules/pulp { };

  pulsectl = callPackage ../development/python-modules/pulsectl { };

  pure-cdb = callPackage ../development/python-modules/pure-cdb { };

  pure-eval = callPackage ../development/python-modules/pure-eval { };

  pure-pcapy3 = callPackage ../development/python-modules/pure-pcapy3 { };

  purepng = callPackage ../development/python-modules/purepng { };

  pure-python-adb = callPackage ../development/python-modules/pure-python-adb { };

  pure-python-adb-homeassistant = callPackage ../development/python-modules/pure-python-adb-homeassistant { };

  puremagic = callPackage ../development/python-modules/puremagic { };

  purl = callPackage ../development/python-modules/purl { };

  push-receiver = callPackage ../development/python-modules/push-receiver { };

  pushbullet = callPackage ../development/python-modules/pushbullet { };

  pushover-complete = callPackage ../development/python-modules/pushover-complete { };

  pvlib = callPackage ../development/python-modules/pvlib { };

  pvo = callPackage ../development/python-modules/pvo { };

  Pweave = callPackage ../development/python-modules/pweave { };

  pwntools = callPackage ../development/python-modules/pwntools {
    debugger = pkgs.gdb;
  };

  pxml = callPackage ../development/python-modules/pxml { };

  py-air-control = callPackage ../development/python-modules/py-air-control { };

  py-air-control-exporter = callPackage ../development/python-modules/py-air-control-exporter { };

  py-dmidecode = callPackage ../development/python-modules/py-dmidecode { };

  py-nightscout = callPackage ../development/python-modules/py-nightscout { };

  py-synologydsm-api = callPackage ../development/python-modules/py-synologydsm-api { };

  py-tes = callPackage ../development/python-modules/py-tes { };

  py-ubjson = callPackage ../development/python-modules/py-ubjson { };

  py-zabbix = callPackage ../development/python-modules/py-zabbix { };

  py17track = callPackage ../development/python-modules/py17track { };

  py2bit = callPackage ../development/python-modules/py2bit { };

  py3buddy = toPythonModule (callPackage ../development/python-modules/py3buddy { });

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { };

  py3status = callPackage ../development/python-modules/py3status { };

  py3to2 = callPackage ../development/python-modules/3to2 { };

  py4j = callPackage ../development/python-modules/py4j { };

  pyacoustid = callPackage ../development/python-modules/pyacoustid { };

  pyads = callPackage ../development/python-modules/pyads { };

  pyaes = callPackage ../development/python-modules/pyaes { };

  pyaftership = callPackage ../development/python-modules/pyaftership { };

  pyahocorasick = callPackage ../development/python-modules/pyahocorasick { };

  pyairnow = callPackage ../development/python-modules/pyairnow { };

  pyairvisual = callPackage ../development/python-modules/pyairvisual { };

  pyalgotrade = callPackage ../development/python-modules/pyalgotrade { };

  pyalmond = callPackage ../development/python-modules/pyalmond { };

  pyamg = callPackage ../development/python-modules/pyamg { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyannotate = callPackage ../development/python-modules/pyannotate { };

  pyarlo = callPackage ../development/python-modules/pyarlo { };

  pyarrow = callPackage ../development/python-modules/pyarrow {
    inherit (pkgs) arrow-cpp cmake;
  };

  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyathena = callPackage ../development/python-modules/pyathena { };

  pyatmo = callPackage ../development/python-modules/pyatmo { };

  pyatspi = callPackage ../development/python-modules/pyatspi { };

  pyatv = callPackage ../development/python-modules/pyatv { };

  pyaudio = callPackage ../development/python-modules/pyaudio { };

  pyaussiebb = callPackage ../development/python-modules/pyaussiebb { };

  pyautogui = callPackage ../development/python-modules/pyautogui { };

  pyavm = callPackage ../development/python-modules/pyavm { };

  pyaxmlparser = callPackage ../development/python-modules/pyaxmlparser { };

  pybalboa = callPackage ../development/python-modules/pybalboa { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pybids = callPackage ../development/python-modules/pybids { };

  pybigwig = callPackage ../development/python-modules/pybigwig { };

  pybind11 = callPackage ../development/python-modules/pybind11 { };

  pybindgen = callPackage ../development/python-modules/pybindgen { };

  pyblackbird = callPackage ../development/python-modules/pyblackbird { };

  pyblake2 = callPackage ../development/python-modules/pyblake2 { };

  pyblock = callPackage ../development/python-modules/pyblock { };

  pybluez = callPackage ../development/python-modules/pybluez { };

  pybotvac = callPackage ../development/python-modules/pybotvac { };

  pybrowserid = callPackage ../development/python-modules/pybrowserid { };

  pybtex = callPackage ../development/python-modules/pybtex { };

  pybtex-docutils = callPackage ../development/python-modules/pybtex-docutils { };

  pybullet = callPackage ../development/python-modules/pybullet { };

  pycairo = callPackage ../development/python-modules/pycairo {
    inherit (pkgs.buildPackages) meson;
  };

  pycallgraph = callPackage ../development/python-modules/pycallgraph { };

  py = callPackage ../development/python-modules/py { };

  pycangjie = callPackage ../development/python-modules/pycangjie { };

  pycapnp = callPackage ../development/python-modules/pycapnp { };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycares = callPackage ../development/python-modules/pycares { };

  pycarwings2 = callPackage ../development/python-modules/pycarwings2 { };

  pycategories = callPackage ../development/python-modules/pycategories { };

  pycdio = callPackage ../development/python-modules/pycdio { };

  pycec = callPackage ../development/python-modules/pycec { };

  pycfdns = callPackage ../development/python-modules/pycfdns { };

  pycflow2dot = callPackage ../development/python-modules/pycflow2dot {
    inherit (pkgs) graphviz;
  };

  pycfmodel = callPackage ../development/python-modules/pycfmodel { };

  pychannels = callPackage ../development/python-modules/pychannels { };

  pychart = callPackage ../development/python-modules/pychart { };

  pychef = callPackage ../development/python-modules/pychef { };

  PyChromecast = callPackage ../development/python-modules/pychromecast { };

  pyclimacell = callPackage ../development/python-modules/pyclimacell { };

  pyclip = callPackage ../development/python-modules/pyclip { };

  pyclipper = callPackage ../development/python-modules/pyclipper { };

  pycm = callPackage ../development/python-modules/pycm { };

  pycmarkgfm = callPackage ../development/python-modules/pycmarkgfm { };

  pycocotools = callPackage ../development/python-modules/pycocotools { };

  pycodestyle = callPackage ../development/python-modules/pycodestyle { };

  pycognito = callPackage ../development/python-modules/pycognito { };

  pycoin = callPackage ../development/python-modules/pycoin { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycomfoconnect = callPackage ../development/python-modules/pycomfoconnect { };

  pycontracts = callPackage ../development/python-modules/pycontracts { };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycountry = callPackage ../development/python-modules/pycountry { };

  pycparser = callPackage ../development/python-modules/pycparser { };

  py-canary = callPackage ../development/python-modules/py-canary { };

  py-cid = callPackage ../development/python-modules/py-cid { };

  py-cpuinfo = callPackage ../development/python-modules/py-cpuinfo { };

  pycrc = callPackage ../development/python-modules/pycrc { };

  pycritty = callPackage ../development/python-modules/pycritty { };

  pycron = callPackage ../development/python-modules/pycron { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodome-test-vectors = callPackage ../development/python-modules/pycryptodome-test-vectors { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  pyct = callPackage ../development/python-modules/pyct { };

  pycuda = callPackage ../development/python-modules/pycuda {
    cudatoolkit = pkgs.cudatoolkit;
    inherit (pkgs.stdenv) mkDerivation;
  };

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycxx = callPackage ../development/python-modules/pycxx { };

  pydaikin = callPackage ../development/python-modules/pydaikin { };

  pydal = callPackage ../development/python-modules/pydal { };

  pydanfossair = callPackage ../development/python-modules/pydanfossair { };

  pydantic = callPackage ../development/python-modules/pydantic { };

  pydash = callPackage ../development/python-modules/pydash { };

  pydbus = callPackage ../development/python-modules/pydbus { };

  pydeck = callPackage ../development/python-modules/pydeck { };

  pydeconz = callPackage ../development/python-modules/pydeconz { };

  pydelijn = callPackage ../development/python-modules/pydelijn { };

  pydenticon = callPackage ../development/python-modules/pydenticon { };

  pydes = callPackage ../development/python-modules/pydes { };

  py-desmume = callPackage ../development/python-modules/py-desmume { };

  pydevccu = callPackage ../development/python-modules/pydevccu { };

  pydexcom = callPackage ../development/python-modules/pydexcom { };

  pydicom = callPackage ../development/python-modules/pydicom { };

  pydispatcher = callPackage ../development/python-modules/pydispatcher { };

  pydmd = callPackage ../development/python-modules/pydmd { };

  pydns = callPackage ../development/python-modules/py3dns { };

  pydocstyle = callPackage ../development/python-modules/pydocstyle { };

  pydocumentdb = callPackage ../development/python-modules/pydocumentdb { };

  pydoods = callPackage ../development/python-modules/pydoods { };

  pydot = callPackage ../development/python-modules/pydot {
    inherit (pkgs) graphviz;
  };

  pydrive = callPackage ../development/python-modules/pydrive { };

  pydrive2 = callPackage ../development/python-modules/pydrive2 { };

  pydroid-ipcam = callPackage ../development/python-modules/pydroid-ipcam  { };

  pydsdl = callPackage ../development/python-modules/pydsdl { };

  pydub = callPackage ../development/python-modules/pydub { };

  pyduke-energy = callPackage ../development/python-modules/pyduke-energy { };

  pydy = callPackage ../development/python-modules/pydy { };

  pydyf = callPackage ../development/python-modules/pydyf { };

  pyebus = callPackage ../development/python-modules/pyebus { };

  pyechonest = callPackage ../development/python-modules/pyechonest { };

  pyeclib = callPackage ../development/python-modules/pyeclib { };

  pyeconet = callPackage ../development/python-modules/pyeconet { };

  pyecowitt = callPackage ../development/python-modules/pyecowitt { };

  pyedimax = callPackage ../development/python-modules/pyedimax { };

  pyee = callPackage ../development/python-modules/pyee { };

  pyefergy = callPackage ../development/python-modules/pyefergy { };

  pyeight = callPackage ../development/python-modules/pyeight { };

  pyelftools = callPackage ../development/python-modules/pyelftools { };

  pyemby = callPackage ../development/python-modules/pyemby { };

  pyemd = callPackage ../development/python-modules/pyemd { };

  pyenchant = callPackage ../development/python-modules/pyenchant {
    inherit (pkgs) enchant2;
  };

  pyenvisalink = callPackage ../development/python-modules/pyenvisalink { };

  pyephember = callPackage ../development/python-modules/pyephember { };

  pyepsg = callPackage ../development/python-modules/pyepsg { };

  pyerfa = callPackage ../development/python-modules/pyerfa { };

  pyevmasm = callPackage ../development/python-modules/pyevmasm { };

  pyevilgenius = callPackage ../development/python-modules/pyevilgenius { };

  pyexcel = callPackage ../development/python-modules/pyexcel { };

  pyexcel-io = callPackage ../development/python-modules/pyexcel-io { };

  pyexcel-ods = callPackage ../development/python-modules/pyexcel-ods { };

  pyexcel-xls = callPackage ../development/python-modules/pyexcel-xls { };

  pyext = callPackage ../development/python-modules/pyext { };

  pyezviz = callPackage ../development/python-modules/pyezviz { };

  pyface = callPackage ../development/python-modules/pyface { };

  pyfaidx = callPackage ../development/python-modules/pyfaidx { };

  pyfakefs = callPackage ../development/python-modules/pyfakefs { };

  pyfakewebcam = callPackage ../development/python-modules/pyfakewebcam { };

  pyfantom = callPackage ../development/python-modules/pyfantom { };

  pyfcm = callPackage ../development/python-modules/pyfcm { };

  pyfftw = callPackage ../development/python-modules/pyfftw { };

  pyfido = callPackage ../development/python-modules/pyfido { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyfnip = callPackage ../development/python-modules/pyfnip { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyflic = callPackage ../development/python-modules/pyflic { };

  pyflume = callPackage ../development/python-modules/pyflume { };

  pyflunearyou = callPackage ../development/python-modules/pyflunearyou { };

  pyfma = callPackage ../development/python-modules/pyfma { };

  pyfribidi = callPackage ../development/python-modules/pyfribidi { };

  pyfritzhome = callPackage ../development/python-modules/pyfritzhome { };

  pyfronius = callPackage ../development/python-modules/pyfronius { };

  pyftdi = callPackage ../development/python-modules/pyftdi { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pyftpdlib = callPackage ../development/python-modules/pyftpdlib { };

  pyfttt = callPackage ../development/python-modules/pyfttt { };

  pyfuse3 = callPackage ../development/python-modules/pyfuse3 { };

  pyfxa = callPackage ../development/python-modules/pyfxa { };

  pygal = callPackage ../development/python-modules/pygal { };

  pygame = callPackage ../development/python-modules/pygame {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  pygame_sdl2 = callPackage ../development/python-modules/pygame_sdl2 { };

  pygame-gui = callPackage ../development/python-modules/pygame-gui { };

  pygatt = callPackage ../development/python-modules/pygatt { };

  pygbm = callPackage ../development/python-modules/pygbm { };

  pygccxml = callPackage ../development/python-modules/pygccxml { };

  pygdbmi = callPackage ../development/python-modules/pygdbmi { };

  pygeoip = callPackage ../development/python-modules/pygeoip { };

  pygeos = callPackage ../development/python-modules/pygeos { };

  pygetwindow = callPackage ../development/python-modules/pygetwindow { };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  PyGithub = callPackage ../development/python-modules/pyGithub { };

  pyglet = callPackage ../development/python-modules/pyglet { };

  pygls = callPackage ../development/python-modules/pygls { };

  pygmars = callPackage ../development/python-modules/pygmars { };

  pygments-better-html = callPackage ../development/python-modules/pygments-better-html { };

  pygments = callPackage ../development/python-modules/Pygments { };

  pygments-markdown-lexer = callPackage ../development/python-modules/pygments-markdown-lexer { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygmt = callPackage ../development/python-modules/pygmt { };

  pygobject2 = callPackage ../development/python-modules/pygobject { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix {
    inherit (pkgs) meson;
  };

  pygogo = callPackage ../development/python-modules/pygogo { };

  pygpgme = callPackage ../development/python-modules/pygpgme { };

  pygraphviz = callPackage ../development/python-modules/pygraphviz {
    inherit (pkgs) graphviz;
  };

  pygreat = callPackage ../development/python-modules/pygreat { };

  pygrok = callPackage ../development/python-modules/pygrok { };

  pygtfs = callPackage ../development/python-modules/pygtfs { };

  pygtail = callPackage ../development/python-modules/pygtail { };

  pygtkspellcheck = callPackage ../development/python-modules/pygtkspellcheck { };

  pygtrie = callPackage ../development/python-modules/pygtrie { };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest { };

  pyhaversion = callPackage ../development/python-modules/pyhaversion { };

  pyhcl = callPackage ../development/python-modules/pyhcl { };

  pyhocon = callPackage ../development/python-modules/pyhocon { };

  pyhomematic = callPackage ../development/python-modules/pyhomematic { };

  pyhomepilot = callPackage ../development/python-modules/pyhomepilot { };

  pyhomeworks = callPackage ../development/python-modules/pyhomeworks { };

  pyhs100 = callPackage ../development/python-modules/pyhs100 { };

  pyi2cflash = callPackage ../development/python-modules/pyi2cflash { };

  pyialarm = callPackage ../development/python-modules/pyialarm { };

  pyicloud = callPackage ../development/python-modules/pyicloud { };

  PyICU = callPackage ../development/python-modules/pyicu { };

  pyimpfuzzy = callPackage ../development/python-modules/pyimpfuzzy {
    inherit (pkgs) ssdeep;
  };

  pyinotify = callPackage ../development/python-modules/pyinotify { };

  pyinputevent = callPackage ../development/python-modules/pyinputevent { };

  pyinsteon = callPackage ../development/python-modules/pyinsteon { };

  pyintesishome = callPackage ../development/python-modules/pyintesishome { };

  pyipma = callPackage ../development/python-modules/pyipma { };

  pyipp = callPackage ../development/python-modules/pyipp { };

  pyiqvia = callPackage ../development/python-modules/pyiqvia { };

  pyjet = callPackage ../development/python-modules/pyjet { };

  pyjks = callPackage ../development/python-modules/pyjks { };

  pyjson5 = callPackage ../development/python-modules/pyjson5 { };

  pyjwkest = callPackage ../development/python-modules/pyjwkest { };

  pyjwt = callPackage ../development/python-modules/pyjwt { };

  pykakasi = callPackage ../development/python-modules/pykakasi { };

  pykdl = callPackage ../development/python-modules/pykdl { };

  pykdtree = callPackage ../development/python-modules/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykeepass = callPackage ../development/python-modules/pykeepass { };

  pykerberos = callPackage ../development/python-modules/pykerberos { };

  pykeyatome = callPackage ../development/python-modules/pykeyatome { };

  pykira = callPackage ../development/python-modules/pykira { };

  pykka = callPackage ../development/python-modules/pykka { };

  pykmtronic = callPackage ../development/python-modules/pykmtronic { };

  pykodi = callPackage ../development/python-modules/pykodi { };

  pykoplenti = callPackage ../development/python-modules/pykoplenti { };

  pykulersky = callPackage ../development/python-modules/pykulersky { };

  pykwalify = callPackage ../development/python-modules/pykwalify { };

  pylacrosse = callPackage ../development/python-modules/pylacrosse { };

  pylama = callPackage ../development/python-modules/pylama { };

  pylast = callPackage ../development/python-modules/pylast { };

  pylatexenc = callPackage ../development/python-modules/pylatexenc { };

  pylaunches = callPackage ../development/python-modules/pylaunches { };

  PyLD = callPackage ../development/python-modules/PyLD { };

  pylev = callPackage ../development/python-modules/pylev { };

  pylgnetcast = callPackage ../development/python-modules/pylgnetcast { };

  pylibacl = callPackage ../development/python-modules/pylibacl { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibftdi = callPackage ../development/python-modules/pylibftdi {
    inherit (pkgs) libusb1;
  };

  pyliblo = callPackage ../development/python-modules/pyliblo { };

  pylibmc = callPackage ../development/python-modules/pylibmc { };

  pylink-square = callPackage ../development/python-modules/pylink-square { };

  pylint-celery = callPackage ../development/python-modules/pylint-celery { };

  pylint-django = callPackage ../development/python-modules/pylint-django { };

  pylint-flask = callPackage ../development/python-modules/pylint-flask { };

  pylint = callPackage ../development/python-modules/pylint { };

  pylint-plugin-utils = callPackage ../development/python-modules/pylint-plugin-utils { };

  pylitterbot = callPackage ../development/python-modules/pylitterbot { };

  py-lru-cache = callPackage ../development/python-modules/py-lru-cache { };

  pylru = callPackage ../development/python-modules/pylru { };

  pyls-black = callPackage ../development/python-modules/pyls-black { };

  pyls-flake8 = callPackage ../development/python-modules/pyls-flake8 { };

  pyls-isort = callPackage ../development/python-modules/pyls-isort { };

  pyls-mypy = callPackage ../development/python-modules/pyls-mypy { };

  pyls-spyder = callPackage ../development/python-modules/pyls-spyder { };

  pylsp-mypy = callPackage ../development/python-modules/pylsp-mypy { };

  PyLTI = callPackage ../development/python-modules/pylti { };

  pylutron = callPackage ../development/python-modules/pylutron { };

  pylutron-caseta = callPackage ../development/python-modules/pylutron-caseta { };

  pylyrics = callPackage ../development/python-modules/pylyrics { };

  pylxd = callPackage ../development/python-modules/pylxd { };

  pylzma = callPackage ../development/python-modules/pylzma { };

  pymacaroons = callPackage ../development/python-modules/pymacaroons { };

  pymaging = callPackage ../development/python-modules/pymaging { };

  pymaging_png = callPackage ../development/python-modules/pymaging_png { };

  pymanopt = callPackage ../development/python-modules/pymanopt { };

  pymarshal = callPackage ../development/python-modules/pymarshal { };

  pymata-express = callPackage ../development/python-modules/pymata-express { };

  pymatgen = callPackage ../development/python-modules/pymatgen { };

  pymatgen-lammps = callPackage ../development/python-modules/pymatgen-lammps { };

  pymaven-patch = callPackage ../development/python-modules/pymaven-patch { };

  pymavlink = callPackage ../development/python-modules/pymavlink { };

  pymazda = callPackage ../development/python-modules/pymazda { };

  pymbolic = callPackage ../development/python-modules/pymbolic { };

  pymc3 = callPackage ../development/python-modules/pymc3 { };

  pymdstat = callPackage ../development/python-modules/pymdstat { };

  pymdown-extensions = callPackage ../development/python-modules/pymdown-extensions { };

  pymediainfo = callPackage ../development/python-modules/pymediainfo { };

  pymediaroom = callPackage ../development/python-modules/pymediaroom { };

  pymeeus = callPackage ../development/python-modules/pymeeus { };

  pymelcloud = callPackage ../development/python-modules/pymelcloud { };

  pymemcache = callPackage ../development/python-modules/pymemcache { };

  pymemoize = callPackage ../development/python-modules/pymemoize { };

  pyment = callPackage ../development/python-modules/pyment { };

  pymetar = callPackage ../development/python-modules/pymetar { };

  pymeteireann = callPackage ../development/python-modules/pymeteireann { };

  pymeteoclimatic = callPackage ../development/python-modules/pymeteoclimatic { };

  pymetno = callPackage ../development/python-modules/pymetno { };

  pymitv = callPackage ../development/python-modules/pymitv { };

  pymfy = callPackage ../development/python-modules/pymfy { };

  pymodbus = callPackage ../development/python-modules/pymodbus { };

  pymongo = callPackage ../development/python-modules/pymongo { };

  pymorphy2 = callPackage ../development/python-modules/pymorphy2 { };

  pymorphy2-dicts-ru = callPackage ../development/python-modules/pymorphy2/dicts-ru.nix { };

  pympler = callPackage ../development/python-modules/pympler { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pymsteams = callPackage ../development/python-modules/pymsteams { };

  py-multiaddr = callPackage ../development/python-modules/py-multiaddr { };

  py-multibase = callPackage ../development/python-modules/py-multibase { };

  py-multicodec = callPackage ../development/python-modules/py-multicodec { };

  py-multihash = callPackage ../development/python-modules/py-multihash { };

  pymumble = callPackage ../development/python-modules/pymumble { };

  pymunk = callPackage ../development/python-modules/pymunk {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pymupdf = callPackage ../development/python-modules/pymupdf { };

  PyMVGLive = callPackage ../development/python-modules/pymvglive { };

  pymyq = callPackage ../development/python-modules/pymyq { };

  pymysensors = callPackage ../development/python-modules/pymysensors { };

  pymysql = callPackage ../development/python-modules/pymysql { };

  pymysqlsa = callPackage ../development/python-modules/pymysqlsa { };

  pymystem3 = callPackage ../development/python-modules/pymystem3 { };

  pynac = callPackage ../development/python-modules/pynac { };

  pynacl = callPackage ../development/python-modules/pynacl { };

  pynamecheap = callPackage ../development/python-modules/pynamecheap { };

  pynamodb = callPackage ../development/python-modules/pynamodb { };

  pynanoleaf = callPackage ../development/python-modules/pynanoleaf { };

  pync = callPackage ../development/python-modules/pync {
    inherit (pkgs) coreutils which;
  };

  pynello = callPackage ../development/python-modules/pynello { };

  pynest2d = callPackage ../development/python-modules/pynest2d { };

  pynetbox = callPackage ../development/python-modules/pynetbox { };

  pynetdicom = callPackage ../development/python-modules/pynetdicom { };

  pynina = callPackage ../development/python-modules/pynina { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pynmea2 = callPackage ../development/python-modules/pynmea2 { };

  pynput = callPackage ../development/python-modules/pynput { };

  pynrrd = callPackage ../development/python-modules/pynrrd { };

  pynvim = callPackage ../development/python-modules/pynvim { };

  pynvml = callPackage ../development/python-modules/pynvml { };

  pynzb = callPackage ../development/python-modules/pynzb { };

  pyobihai = callPackage ../development/python-modules/pyobihai { };

  pyocr = callPackage ../development/python-modules/pyocr {
    tesseract = pkgs.tesseract4;
  };

  pyoctoprintapi = callPackage ../development/python-modules/pyoctoprintapi { };

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyogg = callPackage ../development/python-modules/pyogg { };

  pyombi = callPackage ../development/python-modules/pyombi { };

  pyomo = callPackage ../development/python-modules/pyomo { };

  pyp = callPackage ../development/python-modules/pyp {
    inherit (pkgs) jq;
  };

  phonemizer = callPackage ../development/python-modules/phonemizer { };

  pyopencl = callPackage ../development/python-modules/pyopencl {
    mesa_drivers = pkgs.mesa.drivers;
  };

  pyopengl = callPackage ../development/python-modules/pyopengl { };

  pyopengl-accelerate = callPackage ../development/python-modules/pyopengl-accelerate { };

  pyopenssl = callPackage ../development/python-modules/pyopenssl { };

  pyopenuv = callPackage ../development/python-modules/pyopenuv { };

  pyopnsense = callPackage ../development/python-modules/pyopnsense { };

  pyosf = callPackage ../development/python-modules/pyosf { };

  pyosmium = callPackage ../development/python-modules/pyosmium {
    inherit (pkgs) lz4;
  };

  pyotgw = callPackage ../development/python-modules/pyotgw { };

  pyotp = callPackage ../development/python-modules/pyotp { };

  pyowm = callPackage ../development/python-modules/pyowm { };

  pypamtest = pkgs.libpam-wrapper.override {
    enablePython = true;
    inherit python;
  };

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  pyparser = callPackage ../development/python-modules/pyparser { };

  pyparsing = callPackage ../development/python-modules/pyparsing { };

  pyparted = callPackage ../development/python-modules/pyparted { };

  pypass = callPackage ../development/python-modules/pypass { };

  pypblib = callPackage ../development/python-modules/pypblib { };

  pypca = callPackage ../development/python-modules/pypca { };

  pypcap = callPackage ../development/python-modules/pypcap { };

  pypck = callPackage ../development/python-modules/pypck { };

  pypdf2 = callPackage ../development/python-modules/pypdf2 { };

  pypdf3 = callPackage ../development/python-modules/pypdf3 { };

  pypeg2 = callPackage ../development/python-modules/pypeg2 { };

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pyperf = callPackage ../development/python-modules/pyperf { };

  pyphen = callPackage ../development/python-modules/pyphen { };

  pyphotonfile = callPackage ../development/python-modules/pyphotonfile { };

  pypillowfight = callPackage ../development/python-modules/pypillowfight { };

  pypinyin = callPackage ../development/python-modules/pypinyin { };

  pypiserver = callPackage ../development/python-modules/pypiserver { };

  pyplaato  = callPackage ../development/python-modules/pyplaato { };

  pyplatec = callPackage ../development/python-modules/pyplatec { };

  pyppeteer = callPackage ../development/python-modules/pyppeteer { };

  pypresence = callPackage ../development/python-modules/pypresence { };

  pyprind = callPackage ../development/python-modules/pyprind { };

  pyprof2calltree = callPackage ../development/python-modules/pyprof2calltree { };

  pyproj = callPackage ../development/python-modules/pyproj { };

  pyprosegur = callPackage ../development/python-modules/pyprosegur { };

  pyptlib = callPackage ../development/python-modules/pyptlib { };

  pypubsub = callPackage ../development/python-modules/pypubsub { };

  pypugjs = callPackage ../development/python-modules/pypugjs { };

  pypykatz = callPackage ../development/python-modules/pypykatz { };

  pyqrcode = callPackage ../development/python-modules/pyqrcode { };

  pyqt-builder = callPackage ../development/python-modules/pyqt-builder { };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix { };

  pyqt5 = callPackage ../development/python-modules/pyqt/5.x.nix { };

  pyqt5_with_qtmultimedia = self.pyqt5.override {
    withMultimedia = true;
  };

  /*
    `pyqt5_with_qtwebkit` should not be used by python libraries in
    pkgs/development/python-modules/*. Putting this attribute in
    `propagatedBuildInputs` may cause collisions.
  */
  pyqt5_with_qtwebkit = self.pyqt5.override {
    withWebKit = true;
  };

  pyqtgraph = callPackage ../development/python-modules/pyqtgraph { };

  pyqtwebengine = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtwebengine {
    pythonPackages = self;
  };

  pyquery = callPackage ../development/python-modules/pyquery { };

  pyquaternion = callPackage ../development/python-modules/pyquaternion { };

  pyquil = callPackage ../development/python-modules/pyquil { };

  pyqvrpro = callPackage ../development/python-modules/pyqvrpro { };

  pyrabbit2 = callPackage ../development/python-modules/pyrabbit2 { };

  pyrad = callPackage ../development/python-modules/pyrad { };

  pyradios = callPackage ../development/python-modules/pyradios { };

  py-radix = callPackage ../development/python-modules/py-radix { };

  pyramid_beaker = callPackage ../development/python-modules/pyramid_beaker { };

  pyramid = callPackage ../development/python-modules/pyramid { };

  pyramid_chameleon = callPackage ../development/python-modules/pyramid_chameleon { };

  pyramid_exclog = callPackage ../development/python-modules/pyramid_exclog { };

  pyramid_hawkauth = callPackage ../development/python-modules/pyramid_hawkauth { };

  pyramid_jinja2 = callPackage ../development/python-modules/pyramid_jinja2 { };

  pyramid_mako = callPackage ../development/python-modules/pyramid_mako { };

  pyramid_multiauth = callPackage ../development/python-modules/pyramid_multiauth { };

  pyreadability = callPackage ../development/python-modules/pyreadability { };

  pyrealsense2 = toPythonModule (pkgs.librealsense.override {
    enablePython = true;
    pythonPackages = self;
  });

  pyrealsense2WithCuda = toPythonModule (pkgs.librealsenseWithCuda.override {
    enablePython = true;
    pythonPackages = self;
  });

  pyrealsense2WithoutCuda = toPythonModule (pkgs.librealsenseWithoutCuda.override {
    enablePython = true;
    pythonPackages = self;
  });

  pyrect = callPackage ../development/python-modules/pyrect { };

  pyregion = callPackage ../development/python-modules/pyregion { };

  pyres = callPackage ../development/python-modules/pyres { };

  pyrisco = callPackage ../development/python-modules/pyrisco { };

  pyrituals = callPackage ../development/python-modules/pyrituals { };

  pyRFC3339 = callPackage ../development/python-modules/pyrfc3339 { };

  pyrmvtransport = callPackage ../development/python-modules/pyrmvtransport { };

  Pyro4 = callPackage ../development/python-modules/pyro4 { };

  Pyro5 = callPackage ../development/python-modules/pyro5 { };

  pyroma = callPackage ../development/python-modules/pyroma { };

  pyro-api = callPackage ../development/python-modules/pyro-api { };

  pyro-ppl = callPackage ../development/python-modules/pyro-ppl { };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyroute2-core = callPackage ../development/python-modules/pyroute2-core { };

  pyroute2-ethtool = callPackage ../development/python-modules/pyroute2-ethtool { };

  pyroute2-ipdb = callPackage ../development/python-modules/pyroute2-ipdb { };

  pyroute2-ipset = callPackage ../development/python-modules/pyroute2-ipset { };

  pyroute2-ndb = callPackage ../development/python-modules/pyroute2-ndb { };

  pyroute2-nftables = callPackage ../development/python-modules/pyroute2-nftables { };

  pyroute2-nslink = callPackage ../development/python-modules/pyroute2-nslink { };

  pyroute2-protocols = callPackage ../development/python-modules/pyroute2-protocols { };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pyrsistent = callPackage ../development/python-modules/pyrsistent { };

  PyRSS2Gen = callPackage ../development/python-modules/pyrss2gen { };

  pyrtlsdr = callPackage ../development/python-modules/pyrtlsdr { };

  pyruckus = callPackage ../development/python-modules/pyruckus { };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = callPackage ../development/python-modules/pysaml2 {
    inherit (pkgs) xmlsec;
  };

  pysatochip = callPackage ../development/python-modules/pysatochip { };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscard = callPackage ../development/python-modules/pyscard {
    inherit (pkgs.darwin.apple_sdk.frameworks) PCSC;
  };

  pyscf = callPackage ../development/python-modules/pyscf { };

  pyschedule = callPackage ../development/python-modules/pyschedule { };

  pyscreenshot = callPackage ../development/python-modules/pyscreenshot { };

  pyscreeze = callPackage ../development/python-modules/pyscreeze { };

  py_scrypt = callPackage ../development/python-modules/py_scrypt { };

  pyscrypt = callPackage ../development/python-modules/pyscrypt { };

  pyscss = callPackage ../development/python-modules/pyscss { };

  pysdcp = callPackage ../development/python-modules/pysdcp { };

  pysdl2 = callPackage ../development/python-modules/pysdl2 { };

  pysearpc = toPythonModule (pkgs.libsearpc.override {
    python3 = self.python;
  });

  pysecuritas = callPackage ../development/python-modules/pysecuritas { };

  pysendfile = callPackage ../development/python-modules/pysendfile { };

  pysensors = callPackage ../development/python-modules/pysensors { };

  pyserial-asyncio = callPackage ../development/python-modules/pyserial-asyncio { };

  pyserial = callPackage ../development/python-modules/pyserial { };

  pysftp = callPackage ../development/python-modules/pysftp { };

  pysha3 = callPackage ../development/python-modules/pysha3 { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pyside2-tools = toPythonModule (callPackage ../development/python-modules/pyside2-tools {
    inherit (pkgs) cmake qt5;
  });

  pyside2 = toPythonModule (callPackage ../development/python-modules/pyside2 {
    inherit (pkgs) cmake ninja qt5;
  });

  pyside = callPackage ../development/python-modules/pyside {
    inherit (pkgs) mesa;
  };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix {
    inherit (pkgs) libxml2 libxslt;
  };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pysigset = callPackage ../development/python-modules/pysigset { };

  pysimplegui = callPackage ../development/python-modules/pysimplegui { };

  pysingleton = callPackage ../development/python-modules/pysingleton { };

  pyslurm = callPackage ../development/python-modules/pyslurm {
    inherit (pkgs) slurm;
  };

  pysma = callPackage ../development/python-modules/pysma { };

  pysmappee = callPackage ../development/python-modules/pysmappee { };

  pysmart = callPackage ../development/python-modules/pysmart { };

  pysmartapp = callPackage ../development/python-modules/pysmartapp { };

  pysmartthings = callPackage ../development/python-modules/pysmartthings { };

  pysmb = callPackage ../development/python-modules/pysmb { };

  pysmbc = callPackage ../development/python-modules/pysmbc { };

  pysmf = callPackage ../development/python-modules/pysmf { };

  pysmi = callPackage ../development/python-modules/pysmi { };

  pysml = callPackage ../development/python-modules/pysml { };

  pysmt = callPackage ../development/python-modules/pysmt { };

  pysnmp = callPackage ../development/python-modules/pysnmp { };

  pysnooper = callPackage ../development/python-modules/pysnooper { };

  pysnow = callPackage ../development/python-modules/pysnow { };

  pysocks = callPackage ../development/python-modules/pysocks { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  pysoma = callPackage ../development/python-modules/pysoma { };

  py-sonic = callPackage ../development/python-modules/py-sonic { };

  pysonos = callPackage ../development/python-modules/pysonos { };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pyspark = callPackage ../development/python-modules/pyspark { };

  pysparse = callPackage ../development/python-modules/pysparse { };

  pyspcwebgw = callPackage ../development/python-modules/pyspcwebgw { };

  pyspf = callPackage ../development/python-modules/pyspf { };

  pyspice = callPackage ../development/python-modules/pyspice { };

  pyspiflash = callPackage ../development/python-modules/pyspiflash { };

  pyspinel = callPackage ../development/python-modules/pyspinel { };

  pyspnego = callPackage ../development/python-modules/pyspnego { };

  pyspotify = callPackage ../development/python-modules/pyspotify { };

  pysptk = callPackage ../development/python-modules/pysptk { };

  pysqlcipher3 = callPackage ../development/python-modules/pysqlcipher3 {
    inherit (pkgs) sqlcipher;
  };

  pysqueezebox = callPackage ../development/python-modules/pysqueezebox { };

  pysrim = callPackage ../development/python-modules/pysrim { };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pyssim = callPackage ../development/python-modules/pyssim { };

  pystache = callPackage ../development/python-modules/pystache { };

  pystemd = callPackage ../development/python-modules/pystemd {
    inherit (pkgs) systemd;
  };

  PyStemmer = callPackage ../development/python-modules/pystemmer { };

  pystray = callPackage ../development/python-modules/pystray { };

  py_stringmatching = callPackage ../development/python-modules/py_stringmatching { };

  pysvg-py3 = callPackage ../development/python-modules/pysvg-py3 { };

  pysvn = callPackage ../development/python-modules/pysvn {
    inherit (pkgs) bash subversion apr aprutil expat neon openssl;
  };

  pyswitchbot = callPackage ../development/python-modules/pyswitchbot { };

  pysychonaut = callPackage ../development/python-modules/pysychonaut { };

  pysyncobj = callPackage ../development/python-modules/pysyncobj { };

  pytabix = callPackage ../development/python-modules/pytabix { };

  pytado = callPackage ../development/python-modules/pytado { };

  pytaglib = callPackage ../development/python-modules/pytaglib { };

  pytankerkoenig = callPackage ../development/python-modules/pytankerkoenig { };

  pytap2 = callPackage ../development/python-modules/pytap2 { };

  pytautulli = callPackage ../development/python-modules/pytautulli { };

  pyte = callPackage ../development/python-modules/pyte { };

  pytenable = callPackage ../development/python-modules/pytenable { };

  pytelegrambotapi = callPackage ../development/python-modules/pyTelegramBotAPI { };

  pytesseract = callPackage ../development/python-modules/pytesseract { };

  pytest = self.pytest_6;

  pytest_6 =
    callPackage ../development/python-modules/pytest {
      # hypothesis tests require pytest that causes dependency cycle
      hypothesis = self.hypothesis.override {
        doCheck = false;
      };
    };

  pytest_6_1 = self.pytest_6.overridePythonAttrs (oldAttrs: rec {
    version = "6.1.2";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "c0a7e94a8cdbc5422a51ccdad8e6f1024795939cc89159a0ae7f0b316ad3823e";
    };

    postPatch = ''
      substituteInPlace setup.cfg \
        --replace "pluggy>=0.12,<1.0" "pluggy>=0.12,<2.0"
    '';
  });

  pytest-aio = callPackage ../development/python-modules/pytest-aio { };

  pytest-aiohttp = callPackage ../development/python-modules/pytest-aiohttp { };

  pytest-annotate = callPackage ../development/python-modules/pytest-annotate { };

  pytest-ansible = callPackage ../development/python-modules/pytest-ansible { };

  pytest-arraydiff = callPackage ../development/python-modules/pytest-arraydiff { };

  pytest-astropy = callPackage ../development/python-modules/pytest-astropy { };

  pytest-astropy-header = callPackage ../development/python-modules/pytest-astropy-header { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytest-bdd = callPackage ../development/python-modules/pytest-bdd { };

  pytest-benchmark = callPackage ../development/python-modules/pytest-benchmark { };

  pytest-black = callPackage ../development/python-modules/pytest-black { };

  pytest-cache = self.pytestcache; # added 2021-01-04
  pytestcache = callPackage ../development/python-modules/pytestcache { };

  pytest-cases = callPackage ../development/python-modules/pytest-cases{ };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-celery = callPackage ../development/python-modules/pytest-celery { };

  pytest-check = callPackage ../development/python-modules/pytest-check { };

  pytest-cid = callPackage ../development/python-modules/pytest-cid { };

  pytest-click = callPackage ../development/python-modules/pytest-click { };

  pytest-console-scripts = callPackage ../development/python-modules/pytest-console-scripts { };

  pytest-cov = callPackage ../development/python-modules/pytest-cov { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datadir = callPackage ../development/python-modules/pytest-datadir { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-doctestplus = callPackage ../development/python-modules/pytest-doctestplus { };

  pytest-dotenv = callPackage ../development/python-modules/pytest-dotenv { };

  pytest-env = callPackage ../development/python-modules/pytest-env { };

  pytest-error-for-skips = callPackage ../development/python-modules/pytest-error-for-skips { };

  pytest-expect = callPackage ../development/python-modules/pytest-expect { };

  pytest-factoryboy = callPackage ../development/python-modules/pytest-factoryboy { };

  pytest-filter-subpackage = callPackage ../development/python-modules/pytest-filter-subpackage { };

  pytest-fixture-config = callPackage ../development/python-modules/pytest-fixture-config { };

  pytest-flake8 = callPackage ../development/python-modules/pytest-flake8 { };

  pytest-flakes = callPackage ../development/python-modules/pytest-flakes { };

  pytest-flask = callPackage ../development/python-modules/pytest-flask { };

  pytest-forked = callPackage ../development/python-modules/pytest-forked { };

  pytest-freezegun = callPackage ../development/python-modules/pytest-freezegun { };

  pytest-helpers-namespace = callPackage ../development/python-modules/pytest-helpers-namespace { };

  pytest-html = callPackage ../development/python-modules/pytest-html { };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-httpserver = callPackage ../development/python-modules/pytest-httpserver { };

  pytest-httpx = callPackage ../development/python-modules/pytest-httpx { };

  pytest-instafail = callPackage ../development/python-modules/pytest-instafail { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-json-report = callPackage ../development/python-modules/pytest-json-report { };

  pytest-lazy-fixture = callPackage ../development/python-modules/pytest-lazy-fixture { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-logdog = callPackage ../development/python-modules/pytest-logdog{ };

  pytest-metadata = callPackage ../development/python-modules/pytest-metadata { };

  pytest-mock = callPackage ../development/python-modules/pytest-mock { };

  pytest-mockservers = callPackage ../development/python-modules/pytest-mockservers { };

  pytest-mpl = callPackage ../development/python-modules/pytest-mpl { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-mypy-plugins = callPackage ../development/python-modules/pytest-mypy-plugins { };

  pytest-openfiles = callPackage ../development/python-modules/pytest-openfiles { };

  pytest-order = callPackage ../development/python-modules/pytest-order { };

  pytest-ordering = callPackage ../development/python-modules/pytest-ordering { };

  pytest-pep257 = callPackage ../development/python-modules/pytest-pep257 { };

  pytest-pylint = callPackage ../development/python-modules/pytest-pylint { };

  pytest-pythonpath = callPackage ../development/python-modules/pytest-pythonpath { };

  pytest-qt = callPackage ../development/python-modules/pytest-qt { };

  pytest-quickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-raises = callPackage ../development/python-modules/pytest-raises { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-raisin = callPackage ../development/python-modules/pytest-raisin { };

  pytest-randomly = callPackage ../development/python-modules/pytest-randomly { };

  pytest-random-order = callPackage ../development/python-modules/pytest-random-order { };

  pytest-regressions = callPackage ../development/python-modules/pytest-regressions { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-remotedata = callPackage ../development/python-modules/pytest-remotedata { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytest-resource-path = callPackage ../development/python-modules/pytest-resource-path { };

  pytest-runner = callPackage ../development/python-modules/pytest-runner { };

  pytest-sanic = callPackage ../development/python-modules/pytest-sanic {
    sanic = self.sanic.override { doCheck = false; };
  };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-services = callPackage ../development/python-modules/pytest-services { };

  pytest-snapshot = callPackage ../development/python-modules/pytest-snapshot { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  python-status = callPackage ../development/python-modules/python-status { };

  python-string-utils = callPackage ../development/python-modules/python-string-utils { };

  pytest-socket = callPackage ../development/python-modules/pytest-socket { };

  pytest-subprocess = callPackage ../development/python-modules/pytest-subprocess { };

  pytest-subtesthack = callPackage ../development/python-modules/pytest-subtesthack { };

  pytest-subtests = callPackage ../development/python-modules/pytest-subtests { };

  pytest-sugar = callPackage ../development/python-modules/pytest-sugar { };

  pytest-testmon = callPackage ../development/python-modules/pytest-testmon { };

  pytest-timeout = callPackage ../development/python-modules/pytest-timeout { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  pytest-tornasync = callPackage ../development/python-modules/pytest-tornasync { };

  pytest-trio = callPackage ../development/python-modules/pytest-trio { };

  pytest-twisted = callPackage ../development/python-modules/pytest-twisted { };

  pytest-vcr = callPackage ../development/python-modules/pytest-vcr { };

  pytest-virtualenv = callPackage ../development/python-modules/pytest-virtualenv { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytest-watch = callPackage ../development/python-modules/pytest-watch { };

  pytest-xdist = callPackage ../development/python-modules/pytest-xdist { };

  pytest-xprocess = callPackage ../development/python-modules/pytest-xprocess { };

  pytest-xvfb = callPackage ../development/python-modules/pytest-xvfb { };

  python3-application = callPackage ../development/python-modules/python3-application { };

  python3-eventlib = callPackage ../development/python-modules/python3-eventlib { };

  python3-gnutls = callPackage ../development/python-modules/python3-gnutls { };

  python3-openid = callPackage ../development/python-modules/python3-openid { };

  python-awair = callPackage ../development/python-modules/python-awair { };

  python3-saml = callPackage ../development/python-modules/python3-saml { };

  python-axolotl = callPackage ../development/python-modules/python-axolotl { };

  python-axolotl-curve25519 = callPackage ../development/python-modules/python-axolotl-curve25519 { };

  python-baseconv = callPackage ../development/python-modules/python-baseconv { };

  python-benedict = callPackage ../development/python-modules/python-benedict { };

  python-bidi = callPackage ../development/python-modules/python-bidi { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-box = callPackage ../development/python-modules/python-box { };

  python-cinderclient = callPackage ../development/python-modules/python-cinderclient { };

  python-constraint = callPackage ../development/python-modules/python-constraint { };

  python-crontab = callPackage ../development/python-modules/python-crontab { };

  python-ctags3 = callPackage ../development/python-modules/python-ctags3 { };

  python-daemon = callPackage ../development/python-modules/python-daemon { };

  python-datemath = callPackage ../development/python-modules/python-datemath { };

  python-dateutil = callPackage ../development/python-modules/dateutil { };

  python-dbusmock = callPackage ../development/python-modules/python-dbusmock { };

  pythondialog = callPackage ../development/python-modules/pythondialog { };

  python-didl-lite = callPackage ../development/python-modules/python-didl-lite { };

  python-docx = callPackage ../development/python-modules/python-docx { };

  python-doi = callPackage ../development/python-modules/python-doi { };

  python-dotenv = callPackage ../development/python-modules/python-dotenv { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  python-fsutil = callPackage ../development/python-modules/python-fsutil { };

  pythonefl = callPackage ../development/python-modules/python-efl { };

  pythonegardia = callPackage ../development/python-modules/pythonegardia { };

  python-engineio = callPackage ../development/python-modules/python-engineio { };

  python-etcd = callPackage ../development/python-modules/python-etcd { };

  python-ethtool = callPackage ../development/python-modules/python-ethtool { };

  python_fedora = callPackage ../development/python-modules/python_fedora { };

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  python-forecastio = callPackage ../development/python-modules/python-forecastio { };

  python-frontmatter = callPackage ../development/python-modules/python-frontmatter { };

  python-gammu = callPackage ../development/python-modules/python-gammu { };

  python-gitlab = callPackage ../development/python-modules/python-gitlab { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg { };

  python-gvm = callPackage ../development/python-modules/python-gvm { };

  python-hglib = callPackage ../development/python-modules/python-hglib { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-hpilo = callPackage ../development/python-modules/python-hpilo { };

  python-http-client = callPackage ../development/python-modules/python-http-client { };

  python-i18n = callPackage ../development/python-modules/python-i18n { };

  pythonix = callPackage ../development/python-modules/pythonix {
    nix = pkgs.nixVersions.nix_2_3;
    meson = pkgs.meson.override { python3 = self.python; };
  };

  python-jenkins = callPackage ../development/python-modules/python-jenkins { };

  python-jose = callPackage ../development/python-modules/python-jose { };

  python-json-logger = callPackage ../development/python-modules/python-json-logger { };

  python-jsonrpc-server = callPackage ../development/python-modules/python-jsonrpc-server { };

  python_keyczar = callPackage ../development/python-modules/python_keyczar { };

  python-language-server = callPackage ../development/python-modules/python-language-server { };

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

  python-Levenshtein = callPackage ../development/python-modules/python-levenshtein { };

  python-linux-procfs = callPackage ../development/python-modules/python-linux-procfs { };

  python-logstash = callPackage ../development/python-modules/python-logstash { };

  python-louvain = callPackage ../development/python-modules/python-louvain { };

  python-lsp-jsonrpc = callPackage ../development/python-modules/python-lsp-jsonrpc { };

  python-lsp-server = callPackage ../development/python-modules/python-lsp-server { };

  python-ly = callPackage ../development/python-modules/python-ly { };

  python-lzf = callPackage ../development/python-modules/python-lzf { };

  python-lzo = callPackage ../development/python-modules/python-lzo {
    inherit (pkgs) lzo;
  };

  python_magic = callPackage ../development/python-modules/python-magic { };

  python-manilaclient = callPackage ../development/python-modules/python-manilaclient { };

  python-mapnik = let
    boost = pkgs.boost175.override {
      enablePython = true;
      inherit python;
    };
  in callPackage ../development/python-modules/python-mapnik {
    inherit (pkgs) pkg-config cairo harfbuzz icu libjpeg libpng libtiff libwebp proj zlib;
    inherit boost;
    mapnik = pkgs.mapnik.override {
      inherit python boost;
    };
  };

  python-markdown-math = callPackage ../development/python-modules/python-markdown-math { };

  python-miio = callPackage ../development/python-modules/python-miio { };

  python-mimeparse = callPackage ../development/python-modules/python-mimeparse { };

  python-mnist = callPackage ../development/python-modules/python-mnist { };

  python-mpv-jsonipc = callPackage ../development/python-modules/python-mpv-jsonipc { };

  python-multipart = callPackage ../development/python-modules/python-multipart { };

  python-mystrom = callPackage ../development/python-modules/python-mystrom { };

  python-nest = callPackage ../development/python-modules/python-nest { };

  pythonnet = callPackage
    ../development/python-modules/pythonnet {
      # Using `mono > 5`, tests are failing..
      mono = pkgs.mono5;
    };

  python-nmap = callPackage ../development/python-modules/python-nmap { };

  python-nomad = callPackage ../development/python-modules/python-nomad { };

  python-novaclient = callPackage ../development/python-modules/python-novaclient { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  pythonocc-core = toPythonModule (callPackage ../development/python-modules/pythonocc-core {
    inherit (pkgs.xorg) libX11;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  });

  python-olm = callPackage ../development/python-modules/python-olm { };

  python-opendata-transport = callPackage ../development/python-modules/python-opendata-transport { };

  python-openstackclient = callPackage ../development/python-modules/python-openstackclient { };

  python_openzwave = callPackage ../development/python-modules/python_openzwave { };

  python-osc = callPackage ../development/python-modules/python-osc { };

  python-packer = callPackage ../development/python-modules/python-packer { };

  python-pam = callPackage ../development/python-modules/python-pam {
    inherit (pkgs) pam;
  };

  python-periphery = callPackage ../development/python-modules/python-periphery { };

  python-picnic-api = callPackage ../development/python-modules/python-picnic-api { };

  python-pidfile = callPackage ../development/python-modules/python-pidfile { };

  python-pipedrive = callPackage ../development/python-modules/python-pipedrive { };

  python-pkcs11 = callPackage ../development/python-modules/python-pkcs11 { };

  python-prctl = callPackage ../development/python-modules/python-prctl { };

  python-ptrace = callPackage ../development/python-modules/python-ptrace { };

  python-pushover = callPackage ../development/python-modules/pushover { };

  python-rapidjson = callPackage ../development/python-modules/python-rapidjson { };

  python-redis-lock = callPackage ../development/python-modules/python-redis-lock { };

  python-registry = callPackage ../development/python-modules/python-registry { };

  python-rtmidi = callPackage ../development/python-modules/python-rtmidi { };

  python-sat = callPackage ../development/python-modules/python-sat { };

  python-simple-hipchat = callPackage ../development/python-modules/python-simple-hipchat { };

  python-slugify = callPackage ../development/python-modules/python-slugify { };

  python-smarttub = callPackage ../development/python-modules/python-smarttub { };

  python-snap7 = callPackage ../development/python-modules/python-snap7 {
    inherit (pkgs) snap7;
  };

  python-snappy = callPackage ../development/python-modules/python-snappy {
    inherit (pkgs) snappy;
  };

  python-socketio = callPackage ../development/python-modules/python-socketio { };

  python-socks = callPackage ../development/python-modules/python-socks { };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-telegram-bot = callPackage ../development/python-modules/python-telegram-bot { };

  python-toolbox = callPackage ../development/python-modules/python-toolbox { };

  python-twitch-client = callPackage ../development/python-modules/python-twitch-client { };

  python-twitter = callPackage ../development/python-modules/python-twitter { };

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  python-uinput = callPackage ../development/python-modules/python-uinput { };

  python-unshare = callPackage ../development/python-modules/python-unshare { };

  python-utils = callPackage ../development/python-modules/python-utils { };

  python-vagrant = callPackage ../development/python-modules/python-vagrant { };

  python-velbus = callPackage ../development/python-modules/python-velbus { };

  python-vipaccess = callPackage ../development/python-modules/python-vipaccess { };

  python-vlc = callPackage ../development/python-modules/python-vlc { };

  python-whois = callPackage ../development/python-modules/python-whois { };

  python-wifi = callPackage ../development/python-modules/python-wifi { };

  python-wink = callPackage ../development/python-modules/python-wink { };

  python-xmp-toolkit = callPackage ../development/python-modules/python-xmp-toolkit { };

  pythran = callPackage ../development/python-modules/pythran {
    inherit (pkgs.llvmPackages) openmp;
  };

  pyeverlights = callPackage ../development/python-modules/pyeverlights { };

  pytibber = callPackage ../development/python-modules/pytibber { };

  pytile = callPackage ../development/python-modules/pytile { };

  pytimeparse = callPackage ../development/python-modules/pytimeparse { };

  pytm = callPackage ../development/python-modules/pytm { };

  pytmx = callPackage ../development/python-modules/pytmx { };

  pytoml = callPackage ../development/python-modules/pytoml { };

  pytomlpp = callPackage ../development/python-modules/pytomlpp { };

  pytools = callPackage ../development/python-modules/pytools { };

  pytorch = callPackage ../development/python-modules/pytorch {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  pytorch-bin = callPackage ../development/python-modules/pytorch/bin.nix { };

  pytorch-lightning = callPackage ../development/python-modules/pytorch-lightning { };

  pytorch-metric-learning = callPackage ../development/python-modules/pytorch-metric-learning { };

  pytorchWithCuda = self.pytorch.override {
    cudaSupport = true;
  };

  pytorchWithoutCuda = self.pytorch.override {
    cudaSupport = false;
  };

  pytraccar = callPackage ../development/python-modules/pytraccar { };

  pytradfri = callPackage ../development/python-modules/pytradfri { };

  pytrafikverket = callPackage ../development/python-modules/pytrafikverket { };

  pytransportnsw = callPackage ../development/python-modules/pytransportnsw { };

  pytransportnswv2 = callPackage ../development/python-modules/pytransportnswv2 { };

  pytrends = callPackage ../development/python-modules/pytrends { };

  pytricia = callPackage ../development/python-modules/pytricia { };

  pytube = callPackage ../development/python-modules/pytube { };

  pytun = callPackage ../development/python-modules/pytun { };

  pyturbojpeg = callPackage ../development/python-modules/pyturbojpeg { };

  pytweening = callPackage ../development/python-modules/pytweening { };

  pytwitchapi = callPackage ../development/python-modules/pytwitchapi { };

  pytz = callPackage ../development/python-modules/pytz { };

  pytz-deprecation-shim = callPackage ../development/python-modules/pytz-deprecation-shim { };

  pytzdata = callPackage ../development/python-modules/pytzdata { };

  pyu2f = callPackage ../development/python-modules/pyu2f { };

  pyuavcan = callPackage
    ../development/python-modules/pyuavcan { # this version pinpoint to anold version is necessary due to a regression
      nunavut = self.nunavut.overridePythonAttrs (old: rec {
        version = "0.2.3";
        src = old.src.override {
          inherit version;
          sha256 = "0x8a9h4mc2r2yz49s9arsbs4bn3h25mvmg4zbgksm9hcyi9536x5";
        };
      });
    };

  pyudev = callPackage ../development/python-modules/pyudev {
    inherit (pkgs) systemd;
  };

  pyunbound = callPackage ../tools/networking/unbound/python.nix { };

  pyunifi = callPackage ../development/python-modules/pyunifi { };

  pyupdate = callPackage ../development/python-modules/pyupdate { };

  pyupgrade = callPackage ../development/python-modules/pyupgrade { };

  pyuptimerobot = callPackage ../development/python-modules/pyuptimerobot { };

  pyusb = callPackage ../development/python-modules/pyusb {
    inherit (pkgs) libusb1;
  };

  pyuseragents = callPackage ../development/python-modules/pyuseragents { };

  pyutilib = callPackage ../development/python-modules/pyutilib { };

  pyuv = callPackage ../development/python-modules/pyuv { };

  py-vapid = callPackage ../development/python-modules/py-vapid { };

  pyvcd = callPackage ../development/python-modules/pyvcd { };

  pyvcf = callPackage ../development/python-modules/pyvcf { };

  pyvera = callPackage ../development/python-modules/pyvera { };

  pyverilog = callPackage ../development/python-modules/pyverilog { };

  pyversasense = callPackage ../development/python-modules/pyversasense { };

  pyvesync = callPackage ../development/python-modules/pyvesync { };

  pyvex = callPackage ../development/python-modules/pyvex { };

  pyvicare = callPackage ../development/python-modules/pyvicare { };

  pyvis = callPackage ../development/python-modules/pyvis { };

  pyvisa = callPackage ../development/python-modules/pyvisa { };

  pyvisa-py = callPackage ../development/python-modules/pyvisa-py { };

  pyviz-comms = callPackage ../development/python-modules/pyviz-comms { };

  pyvizio = callPackage ../development/python-modules/pyvizio { };

  pyvips = callPackage ../development/python-modules/pyvips {
    inherit (pkgs) vips glib;
  };

  pyvlx = callPackage ../development/python-modules/pyvlx { };

  pyvmomi = callPackage ../development/python-modules/pyvmomi { };

  pyvolumio = callPackage ../development/python-modules/pyvolumio { };

  pyvoro = callPackage ../development/python-modules/pyvoro { };

  pywal = callPackage ../development/python-modules/pywal { };

  pywatchman = callPackage ../development/python-modules/pywatchman { };

  pywavelets = callPackage ../development/python-modules/pywavelets { };

  pywayland = callPackage ../development/python-modules/pywayland { };

  pywbem = callPackage ../development/python-modules/pywbem {
    inherit (pkgs) libxml2;
  };

  pyweatherflowrest = callPackage ../development/python-modules/pyweatherflowrest { };

  pywebpush = callPackage ../development/python-modules/pywebpush { };

  pywebview = callPackage ../development/python-modules/pywebview { };

  pywemo = callPackage ../development/python-modules/pywemo { };

  pywick = callPackage ../development/python-modules/pywick { };

  pywilight = callPackage ../development/python-modules/pywilight { };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pywizlight = callPackage ../development/python-modules/pywizlight { };

  pywlroots = callPackage ../development/python-modules/pywlroots { };

  pyxattr = callPackage ../development/python-modules/pyxattr { };

  pyworld = callPackage ../development/python-modules/pyworld { };

  pyx = callPackage ../development/python-modules/pyx { };

  pyxb = callPackage ../development/python-modules/pyxb { };

  pyxbe = callPackage ../development/python-modules/pyxbe { };

  pyxdg = callPackage ../development/python-modules/pyxdg { };

  pyxeoma = callPackage ../development/python-modules/pyxeoma { };

  pyxiaomigateway = callPackage ../development/python-modules/pyxiaomigateway { };

  pyxl3 = callPackage ../development/python-modules/pyxl3 { };

  pyxnat = callPackage ../development/python-modules/pyxnat { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  pyyaml-env-tag = callPackage ../development/python-modules/pyyaml-env-tag { };

  pyzerproc = callPackage ../development/python-modules/pyzerproc { };

  pyzmq = callPackage ../development/python-modules/pyzmq { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  qcelemental = callPackage ../development/python-modules/qcelemental { };

  qcengine = callPackage ../development/python-modules/qcengine { };

  qcs-api-client = callPackage ../development/python-modules/qcs-api-client { };

  qdarkstyle = callPackage ../development/python-modules/qdarkstyle { };

  qdldl = callPackage ../development/python-modules/qdldl { };

  qds_sdk = callPackage ../development/python-modules/qds_sdk { };

  qiling = callPackage ../development/python-modules/qiling { };

  qimage2ndarray = callPackage ../development/python-modules/qimage2ndarray { };

  qiskit = callPackage ../development/python-modules/qiskit { };

  qiskit-aer = callPackage ../development/python-modules/qiskit-aer { };

  qiskit-aqua = callPackage ../development/python-modules/qiskit-aqua { };

  qiskit-finance = callPackage ../development/python-modules/qiskit-finance { };

  qiskit-ibmq-provider = callPackage ../development/python-modules/qiskit-ibmq-provider { };

  qiskit-ignis = callPackage ../development/python-modules/qiskit-ignis { };

  qiskit-machine-learning = callPackage ../development/python-modules/qiskit-machine-learning { };

  qiskit-nature = callPackage ../development/python-modules/qiskit-nature { };

  qiskit-optimization = callPackage ../development/python-modules/qiskit-optimization { };

  qiskit-terra = callPackage ../development/python-modules/qiskit-terra { };

  qnap-qsw = callPackage ../development/python-modules/qnap-qsw{ };

  qrcode = callPackage ../development/python-modules/qrcode { };

  qreactor = callPackage ../development/python-modules/qreactor { };

  qscintilla-qt4 = callPackage ../development/python-modules/qscintilla-qt4 { };

  qscintilla-qt5 = pkgs.libsForQt5.callPackage ../development/python-modules/qscintilla-qt5 {
    pythonPackages = self;
  };

  qscintilla = self.qscintilla-qt5;

  qt5reactor = callPackage ../development/python-modules/qt5reactor { };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  qualysclient = callPackage ../development/python-modules/qualysclient { };

  quamash = callPackage ../development/python-modules/quamash { };

  quandl = callPackage ../development/python-modules/quandl { };

  # TODO: rename this
  Quandl = callPackage ../development/python-modules/quandl { }; # alias for an older package which did not support Python 3

  quantities = callPackage ../development/python-modules/quantities { };

  quantum-gateway = callPackage ../development/python-modules/quantum-gateway { };

  querystring_parser = callPackage ../development/python-modules/querystring-parser { };

  questionary = callPackage ../development/python-modules/questionary { };

  queuelib = callPackage ../development/python-modules/queuelib { };

  qutip = callPackage ../development/python-modules/qutip { };

  qmk-dotty-dict = callPackage ../development/python-modules/qmk-dotty-dict { };

  r2pipe = callPackage ../development/python-modules/r2pipe { };

  rabbitpy = callPackage ../development/python-modules/rabbitpy { };

  rachiopy = callPackage ../development/python-modules/rachiopy { };

  radicale_infcloud = callPackage ../development/python-modules/radicale_infcloud { };

  radio_beam = callPackage ../development/python-modules/radio_beam { };

  radiotherm = callPackage ../development/python-modules/radiotherm { };

  radish-bdd = callPackage ../development/python-modules/radish-bdd { };

  rainbowstream = callPackage ../development/python-modules/rainbowstream { };

  ramlfications = callPackage ../development/python-modules/ramlfications { };

  random2 = callPackage ../development/python-modules/random2 { };

  rangehttpserver = callPackage ../development/python-modules/rangehttpserver { };

  rapidfuzz = callPackage ../development/python-modules/rapidfuzz { };

  rarfile = callPackage ../development/python-modules/rarfile {
    inherit (pkgs) libarchive;
  };

  rasterio = callPackage ../development/python-modules/rasterio { };

  ratelim = callPackage ../development/python-modules/ratelim { };

  ratelimit = callPackage ../development/python-modules/ratelimit { };

  ratelimiter = callPackage ../development/python-modules/ratelimiter { };

  raven = callPackage ../development/python-modules/raven { };

  rawkit = callPackage ../development/python-modules/rawkit { };

  rbtools = callPackage ../development/python-modules/rbtools { };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  rdkit = callPackage ../development/python-modules/rdkit { };

  re-assert = callPackage ../development/python-modules/re-assert { };

  readchar = callPackage ../development/python-modules/readchar { };

  readlike = callPackage ../development/python-modules/readlike { };

  readme = callPackage ../development/python-modules/readme { };

  readme_renderer = callPackage ../development/python-modules/readme_renderer { };

  readthedocs-sphinx-ext = callPackage ../development/python-modules/readthedocs-sphinx-ext { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  recaptcha_client = callPackage ../development/python-modules/recaptcha_client { };

  recoll = toPythonModule (pkgs.recoll.override {
    python3Packages = self;
  });

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  redbaron = callPackage ../development/python-modules/redbaron { };

  redis = callPackage ../development/python-modules/redis { };

  rednose = callPackage ../development/python-modules/rednose { };

  reedsolo = callPackage ../development/python-modules/reedsolo { };

  reflink = callPackage ../development/python-modules/reflink { };

  regenmaschine = callPackage ../development/python-modules/regenmaschine { };

  regex = callPackage ../development/python-modules/regex { };

  regional = callPackage ../development/python-modules/regional { };

  reikna = callPackage ../development/python-modules/reikna { };

  related = callPackage ../development/python-modules/related { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  remarshal = callPackage ../development/python-modules/remarshal { };

  renault-api = callPackage ../development/python-modules/renault-api { };

  rencode = callPackage ../development/python-modules/rencode { };

  reolink = callPackage ../development/python-modules/reolink { };

  reparser = callPackage ../development/python-modules/reparser { };

  repocheck = callPackage ../development/python-modules/repocheck { };

  reportlab = callPackage ../development/python-modules/reportlab { };

  repoze_lru = callPackage ../development/python-modules/repoze_lru { };

  repoze_sphinx_autointerface = callPackage ../development/python-modules/repoze_sphinx_autointerface { };

  repoze_who = callPackage ../development/python-modules/repoze_who { };

  reproject = callPackage ../development/python-modules/reproject { };

  requests-aws4auth = callPackage ../development/python-modules/requests-aws4auth { };

  requests-cache = callPackage ../development/python-modules/requests-cache { };

  requests-hawk = callPackage ../development/python-modules/requests-hawk { };

  requests = callPackage ../development/python-modules/requests { };

  requests_download = callPackage ../development/python-modules/requests_download { };

  requestsexceptions = callPackage ../development/python-modules/requestsexceptions { };

  requests-file = callPackage ../development/python-modules/requests-file { };

  requests-futures = callPackage ../development/python-modules/requests-futures { };

  requests-http-signature = callPackage ../development/python-modules/requests-http-signature { };

  requests-kerberos = callPackage ../development/python-modules/requests-kerberos { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  requests_ntlm = callPackage ../development/python-modules/requests_ntlm { };

  requests_oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-pkcs12 = callPackage ../development/python-modules/requests-pkcs12 { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };

  requests-unixsocket = callPackage ../development/python-modules/requests-unixsocket { };

  requirements-detector = callPackage ../development/python-modules/requirements-detector { };

  requirements-parser = callPackage ../development/python-modules/requirements-parser { };

  resampy = callPackage ../development/python-modules/resampy { };

  resolvelib = callPackage ../development/python-modules/resolvelib { };

  responses = callPackage ../development/python-modules/responses { };

  respx = callPackage ../development/python-modules/respx { };

  restfly = callPackage ../development/python-modules/restfly { };

  restrictedpython = callPackage ../development/python-modules/restrictedpython { };

  restructuredtext_lint = callPackage ../development/python-modules/restructuredtext_lint { };

  restview = callPackage ../development/python-modules/restview { };

  rethinkdb = callPackage ../development/python-modules/rethinkdb { };

  retry = callPackage ../development/python-modules/retry { };

  retry_decorator = callPackage ../development/python-modules/retry_decorator { };

  retrying = callPackage ../development/python-modules/retrying { };

  retworkx = callPackage ../development/python-modules/retworkx { };

  rfc3339 = callPackage ../development/python-modules/rfc3339 { };

  rfc3339-validator = callPackage ../development/python-modules/rfc3339-validator { };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  rfc3987 = callPackage ../development/python-modules/rfc3987 { };

  rfc6555 = callPackage ../development/python-modules/rfc6555 { };

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  rfcat = callPackage ../development/python-modules/rfcat { };

  rflink = callPackage ../development/python-modules/rflink { };

  rich = callPackage ../development/python-modules/rich { };

  rig = callPackage ../development/python-modules/rig { };

  ring-doorbell = callPackage ../development/python-modules/ring-doorbell { };

  riprova = callPackage ../development/python-modules/riprova { };

  ripser = callPackage ../development/python-modules/ripser { };

  rising = callPackage ../development/python-modules/rising { };

  ritassist = callPackage ../development/python-modules/ritassist { };

  rivet = toPythonModule (pkgs.rivet.override {
    python3 = python;
  });

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  rki-covid-parser = callPackage ../development/python-modules/rki-covid-parser { };

  rl-coach = callPackage ../development/python-modules/rl-coach { };

  rlp = callPackage ../development/python-modules/rlp { };

  rnc2rng = callPackage ../development/python-modules/rnc2rng { };

  rnginline = callPackage ../development/python-modules/rnginline { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  robot-detection = callPackage ../development/python-modules/robot-detection { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-databaselibrary = callPackage ../development/python-modules/robotframework-databaselibrary { };

  robotframework-requests = callPackage ../development/python-modules/robotframework-requests { };

  robotframework-selenium2library = callPackage ../development/python-modules/robotframework-selenium2library { };

  robotframework-seleniumlibrary = callPackage ../development/python-modules/robotframework-seleniumlibrary { };

  robotframework-sshlibrary = callPackage ../development/python-modules/robotframework-sshlibrary { };

  robotframework-tools = callPackage ../development/python-modules/robotframework-tools { };

  robotstatuschecker = callPackage ../development/python-modules/robotstatuschecker { };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  rocket-errbot = callPackage ../development/python-modules/rocket-errbot { };

  roku = callPackage ../development/python-modules/roku { };

  rokuecp = callPackage ../development/python-modules/rokuecp { };

  rollbar = callPackage ../development/python-modules/rollbar { };

  roman = callPackage ../development/python-modules/roman { };

  roombapy = callPackage ../development/python-modules/roombapy { };

  roonapi = callPackage ../development/python-modules/roonapi { };

  ronin = callPackage ../development/python-modules/ronin { };

  rope = callPackage ../development/python-modules/rope { };

  ropgadget = callPackage ../development/python-modules/ropgadget { };

  ropper = callPackage ../development/python-modules/ropper { };

  routes = callPackage ../development/python-modules/routes { };

  rpcq = callPackage ../development/python-modules/rpcq { };

  rpdb = callPackage ../development/python-modules/rpdb { };

  rpi-bad-power = callPackage ../development/python-modules/rpi-bad-power { };

  rply = callPackage ../development/python-modules/rply { };

  rpm = toPythonModule (pkgs.rpm.override {
    inherit python;
  });

  rpmfile = callPackage ../development/python-modules/rpmfile { };

  rpmfluff = callPackage ../development/python-modules/rpmfluff { };

  rpy2 = callPackage ../development/python-modules/rpy2 { };

  rpyc = callPackage ../development/python-modules/rpyc { };

  rq = callPackage ../development/python-modules/rq { };

  rsa = callPackage ../development/python-modules/rsa { };

  rst2ansi = callPackage ../development/python-modules/rst2ansi { };

  rstcheck = callPackage ../development/python-modules/rstcheck { };

  rtmidi-python = callPackage ../development/python-modules/rtmidi-python { };

  rtoml = callPackage ../development/python-modules/rtoml { };

  Rtree = callPackage ../development/python-modules/Rtree {
    inherit (pkgs) libspatialindex;
  };

  rtslib = callPackage ../development/python-modules/rtslib { };

  rtsp-to-webrtc = callPackage ../development/python-modules/rtsp-to-webrtc { };

  ruamel-base = callPackage ../development/python-modules/ruamel-base { };

  ruamel-yaml = callPackage ../development/python-modules/ruamel-yaml { };

  ruamel-yaml-clib = callPackage ../development/python-modules/ruamel-yaml-clib { };

  rubymarshal = callPackage ../development/python-modules/rubymarshal { };

  ruffus = callPackage ../development/python-modules/ruffus { };

  runway-python = callPackage ../development/python-modules/runway-python { };

  ruyaml = callPackage ../development/python-modules/ruyaml { };

  rx = callPackage ../development/python-modules/rx { };

  rxv = callPackage ../development/python-modules/rxv { };

  rzpipe = callPackage ../development/python-modules/rzpipe { };

  s2clientprotocol = callPackage ../development/python-modules/s2clientprotocol { };

  s3fs = callPackage ../development/python-modules/s3fs { };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  sabyenc3 = callPackage ../development/python-modules/sabyenc3 { };

  sabyenc = callPackage ../development/python-modules/sabyenc { };

  sacn = callPackage ../development/python-modules/sacn { };

  sacremoses = callPackage ../development/python-modules/sacremoses { };

  safe = callPackage ../development/python-modules/safe { };

  safety = callPackage ../development/python-modules/safety { };

  sagemaker = callPackage ../development/python-modules/sagemaker { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  sane = callPackage ../development/python-modules/sane {
    inherit (pkgs) sane-backends;
  };

  saneyaml = callPackage ../development/python-modules/saneyaml { };

  sampledata = callPackage ../development/python-modules/sampledata { };

  samplerate = callPackage ../development/python-modules/samplerate { };

  samsungctl = callPackage ../development/python-modules/samsungctl { };

  samsungtvws = callPackage ../development/python-modules/samsungtvws { };

  sanic = callPackage ../development/python-modules/sanic {
    # Don't pass any `sanic` to avoid dependency loops.  `sanic-testing`
    # has special logic to disable tests when this is the case.
    sanic-testing = self.sanic-testing.override { sanic = null; };
  };

  sanic-auth = callPackage ../development/python-modules/sanic-auth { };

  sanic-routing = callPackage ../development/python-modules/sanic-routing { };

  sanic-testing = callPackage ../development/python-modules/sanic-testing { };

  sapi-python-client = callPackage ../development/python-modules/sapi-python-client { };

  sarif-om = callPackage ../development/python-modules/sarif-om { };

  sarge = callPackage ../development/python-modules/sarge { };

  sasmodels = callPackage ../development/python-modules/sasmodels { };

  scales = callPackage ../development/python-modules/scales { };

  scancode-toolkit = callPackage ../development/python-modules/scancode-toolkit { };

  scapy = callPackage ../development/python-modules/scapy { };

  schedule = callPackage ../development/python-modules/schedule { };

  schema = callPackage ../development/python-modules/schema { };

  schema-salad = callPackage ../development/python-modules/schema-salad { };

  schiene = callPackage ../development/python-modules/schiene { };

  scikit-bio = callPackage ../development/python-modules/scikit-bio { };

  scikit-build = callPackage ../development/python-modules/scikit-build { };

  scikit-fmm = callPackage ../development/python-modules/scikit-fmm { };

  scikit-fuzzy = callPackage ../development/python-modules/scikit-fuzzy { };

  scikit-hep-testdata = callPackage ../development/python-modules/scikit-hep-testdata { };

  scikitimage = callPackage ../development/python-modules/scikit-image { };

  scikit-learn = callPackage ../development/python-modules/scikit-learn {
    inherit (pkgs) gfortran glibcLocales;
  };

  scikit-learn-extra = callPackage ../development/python-modules/scikit-learn-extra { };

  scikit-optimize = callPackage ../development/python-modules/scikit-optimize { };

  scikits-odes = callPackage ../development/python-modules/scikits-odes { };

  scikit-tda = callPackage ../development/python-modules/scikit-tda { };

  scipy = callPackage ../development/python-modules/scipy { };

  scmrepo = callPackage ../development/python-modules/scmrepo { };

  scour = callPackage ../development/python-modules/scour { };

  scp = callPackage ../development/python-modules/scp { };

  scramp = callPackage ../development/python-modules/scramp { };

  scrapy = callPackage ../development/python-modules/scrapy { };

  scrapy-deltafetch = callPackage ../development/python-modules/scrapy-deltafetch { };

  scrapy-fake-useragent = callPackage ../development/python-modules/scrapy-fake-useragent { };

  scrapy-splash = callPackage ../development/python-modules/scrapy-splash { };

  screeninfo = callPackage ../development/python-modules/screeninfo { };

  screenlogicpy = callPackage ../development/python-modules/screenlogicpy { };

  scripttest = callPackage ../development/python-modules/scripttest { };

  scikit-survival = callPackage ../development/python-modules/scikit-survival { };

  scs = callPackage ../development/python-modules/scs { };

  sdnotify = callPackage ../development/python-modules/sdnotify { };

  seaborn = callPackage ../development/python-modules/seaborn { };

  seabreeze = callPackage ../development/python-modules/seabreeze { };

  seaserv = toPythonModule (pkgs.seafile-server.override {
    python3 = self.python;
  });

  seatconnect = callPackage ../development/python-modules/seatconnect { };

  seccomp = callPackage ../development/python-modules/seccomp { };

  secp256k1 = callPackage ../development/python-modules/secp256k1 {
    inherit (pkgs) secp256k1;
  };

  secretstorage = callPackage ../development/python-modules/secretstorage { };

  secure = callPackage ../development/python-modules/secure { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  segments = callPackage ../development/python-modules/segments { };

  selectors2 = callPackage ../development/python-modules/selectors2 { };

  selenium = callPackage ../development/python-modules/selenium { };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  semver = callPackage ../development/python-modules/semver { };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sendgrid = callPackage ../development/python-modules/sendgrid { };

  sense-energy = callPackage ../development/python-modules/sense-energy { };

  sentencepiece = callPackage ../development/python-modules/sentencepiece {
    inherit (pkgs) sentencepiece;
  };

  sentinel = callPackage ../development/python-modules/sentinel { };

  sentinels = callPackage ../development/python-modules/sentinels { };

  sentry-sdk = callPackage ../development/python-modules/sentry-sdk { };

  sepaxml = callPackage ../development/python-modules/sepaxml { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  seqeval = callPackage ../development/python-modules/seqeval { };

  sequoia = disabledIf isPyPy (toPythonModule (pkgs.sequoia.override {
    pythonPackages = self;
    pythonSupport = true;
  }));

  serpent = callPackage ../development/python-modules/serpent { };

  serpy = callPackage ../development/python-modules/serpy { };

  serverlessrepo = callPackage ../development/python-modules/serverlessrepo { };

  service-identity = callPackage ../development/python-modules/service_identity { };

  setproctitle = callPackage ../development/python-modules/setproctitle { };

  setupmeta = callPackage ../development/python-modules/setupmeta { };

  setuptools-declarative-requirements = callPackage ../development/python-modules/setuptools-declarative-requirements { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  setuptools-lint = callPackage ../development/python-modules/setuptools-lint { };

  setuptools-rust = callPackage ../development/python-modules/setuptools-rust { };

  setuptools-scm = callPackage ../development/python-modules/setuptools-scm { };

  setuptools-scm-git-archive = callPackage ../development/python-modules/setuptools-scm-git-archive { };

  setuptoolsTrial = callPackage ../development/python-modules/setuptoolstrial { };

  sexpdata = callPackage ../development/python-modules/sexpdata { };

  sfepy = callPackage ../development/python-modules/sfepy { };

  sgmllib3k = callPackage ../development/python-modules/sgmllib3k { };

  shamir-mnemonic = callPackage ../development/python-modules/shamir-mnemonic { };

  shap = callPackage ../development/python-modules/shap { };

  shapely = callPackage ../development/python-modules/shapely { };

  sharedmem = callPackage ../development/python-modules/sharedmem { };

  sharkiqpy = callPackage ../development/python-modules/sharkiqpy { };

  sh = callPackage ../development/python-modules/sh { };

  shellescape = callPackage ../development/python-modules/shellescape { };

  shellingham = callPackage ../development/python-modules/shellingham { };

  shiboken2 = toPythonModule (callPackage ../development/python-modules/shiboken2 {
    inherit (pkgs) cmake llvmPackages qt5;
  });

  shippai = callPackage ../development/python-modules/shippai { };

  shodan = callPackage ../development/python-modules/shodan { };

  shortuuid = callPackage ../development/python-modules/shortuuid { };

  shouldbe = callPackage ../development/python-modules/shouldbe { };

  should-dsl = callPackage ../development/python-modules/should-dsl { };

  showit = callPackage ../development/python-modules/showit { };

  shtab = callPackage ../development/python-modules/shtab { };

  shutilwhich = callPackage ../development/python-modules/shutilwhich { };

  sievelib = callPackage ../development/python-modules/sievelib { };

  signedjson = callPackage ../development/python-modules/signedjson { };

  sigrok = callPackage ../development/python-modules/sigrok { };

  sigtools = callPackage ../development/python-modules/sigtools { };

  simanneal = callPackage ../development/python-modules/simanneal { };

  simber = callPackage ../development/python-modules/simber { };

  simpleaudio = callPackage ../development/python-modules/simpleaudio { };

  simplebayes = callPackage ../development/python-modules/simplebayes { };

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  simplefix = callPackage ../development/python-modules/simplefix { };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  simplehound = callPackage ../development/python-modules/simplehound { };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simplekml = callPackage ../development/python-modules/simplekml { };

  simplenote = callPackage ../development/python-modules/simplenote { };

  simple-di = callPackage ../development/python-modules/simple-di { };

  simple-rest-client = callPackage ../development/python-modules/simple-rest-client { };

  simple-salesforce = callPackage ../development/python-modules/simple-salesforce { };

  simple-websocket-server = callPackage ../development/python-modules/simple-websocket-server { };

  simplisafe-python = callPackage ../development/python-modules/simplisafe-python { };

  simpy = callPackage ../development/python-modules/simpy { };

  signify = callPackage ../development/python-modules/signify { };

  siosocks = callPackage ../development/python-modules/siosocks { };

  sip = callPackage ../development/python-modules/sip { };

  sip_4 = callPackage ../development/python-modules/sip/4.x.nix { };

  six = callPackage ../development/python-modules/six { };

  skein = callPackage ../development/python-modules/skein {
    jre = pkgs.jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  skidl = callPackage ../development/python-modules/skidl { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  skodaconnect = callPackage ../development/python-modules/skodaconnect { };

  skorch = callPackage ../development/python-modules/skorch { };

  skybellpy = callPackage ../development/python-modules/skybellpy { };

  skytemple-dtef = callPackage ../development/python-modules/skytemple-dtef { };

  skytemple-eventserver = callPackage ../development/python-modules/skytemple-eventserver { };

  skytemple-files = callPackage ../development/python-modules/skytemple-files { };

  skytemple-icons = callPackage ../development/python-modules/skytemple-icons { };

  skytemple-rust = callPackage ../development/python-modules/skytemple-rust { };

  skytemple-ssb-debugger = callPackage ../development/python-modules/skytemple-ssb-debugger { };

  slack-sdk = callPackage ../development/python-modules/slack-sdk { };

  slackclient = callPackage ../development/python-modules/slackclient { };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

  sleepyq = callPackage ../development/python-modules/sleepyq { };

  slicedimage = callPackage ../development/python-modules/slicedimage { };

  slicer = callPackage ../development/python-modules/slicer { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  slither-analyzer = callPackage ../development/python-modules/slither-analyzer { };

  slixmpp = callPackage ../development/python-modules/slixmpp {
    inherit (pkgs) gnupg;
  };

  slob = callPackage ../development/python-modules/slob { };

  slowapi = callPackage ../development/python-modules/slowapi { };

  slugid = callPackage ../development/python-modules/slugid { };

  sly = callPackage ../development/python-modules/sly { };

  smart-meter-texas = callPackage ../development/python-modules/smart-meter-texas { };

  smart-open = callPackage ../development/python-modules/smart-open { };

  smarthab = callPackage ../development/python-modules/smarthab { };

  smartypants = callPackage ../development/python-modules/smartypants { };

  smbprotocol = callPackage ../development/python-modules/smbprotocol { };

  smbus-cffi = callPackage ../development/python-modules/smbus-cffi { };

  smbus2 = callPackage ../development/python-modules/smbus2 { };

  smdebug-rulesconfig = callPackage ../development/python-modules/smdebug-rulesconfig { };

  smhi-pkg = callPackage ../development/python-modules/smhi-pkg { };

  smmap = callPackage ../development/python-modules/smmap { };

  smpplib = callPackage ../development/python-modules/smpplib { };

  snack = toPythonModule (pkgs.newt.override {
    inherit (self) python;
  });

  snakebite = callPackage ../development/python-modules/snakebite { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  snapcast = callPackage ../development/python-modules/snapcast { };

  snapshottest = callPackage ../development/python-modules/snapshottest { };

  sniffio = callPackage ../development/python-modules/sniffio { };

  snitun = callPackage ../development/python-modules/snitun { };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  snowflake-connector-python = callPackage ../development/python-modules/snowflake-connector-python { };

  snowflake-sqlalchemy = callPackage ../development/python-modules/snowflake-sqlalchemy { };

  snscrape = callPackage ../development/python-modules/snscrape { };

  snuggs = callPackage ../development/python-modules/snuggs { };

  soapysdr = toPythonModule (pkgs.soapysdr.override {
    python = self.python;
    usePython = true;
  });

  soapysdr-with-plugins = toPythonModule (pkgs.soapysdr-with-plugins.override {
    python = self.python;
    usePython = true;
  });

  socketio-client = callPackage ../development/python-modules/socketio-client { };

  socialscan = callPackage ../development/python-modules/socialscan { };

  socid-extractor =  callPackage ../development/python-modules/socid-extractor { };

  sockjs = callPackage ../development/python-modules/sockjs { };

  sockjs-tornado = callPackage ../development/python-modules/sockjs-tornado { };

  socksipy-branch = callPackage ../development/python-modules/socksipy-branch { };

  soco = callPackage ../development/python-modules/soco { };

  softlayer = callPackage ../development/python-modules/softlayer { };

  solaredge = callPackage ../development/python-modules/solaredge { };

  solax = callPackage ../development/python-modules/solax { };

  solc-select = callPackage ../development/python-modules/solc-select { };

  solo-python = disabledIf (!pythonAtLeast "3.6") (callPackage ../development/python-modules/solo-python { });

  somajo = callPackage ../development/python-modules/somajo { };

  somecomfort = callPackage ../development/python-modules/somecomfort { };

  somfy-mylink-synergy = callPackage ../development/python-modules/somfy-mylink-synergy { };

  sonarr = callPackage ../development/python-modules/sonarr { };

  sopel = callPackage ../development/python-modules/sopel { };

  sorl_thumbnail = callPackage ../development/python-modules/sorl_thumbnail { };

  sortedcollections = callPackage ../development/python-modules/sortedcollections { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  sounddevice = callPackage ../development/python-modules/sounddevice { };

  soundfile = callPackage ../development/python-modules/soundfile { };

  soupsieve = callPackage ../development/python-modules/soupsieve { };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy-alignments = callPackage ../development/python-modules/spacy-alignments { };

  spacy-legacy = callPackage ../development/python-modules/spacy/legacy.nix { };

  spacy-loggers = callPackage ../development/python-modules/spacy-loggers { };

  spacy_models = callPackage ../development/python-modules/spacy/models.nix { };

  spacy-pkuseg = callPackage ../development/python-modules/spacy-pkuseg { };

  spacy-transformers = callPackage ../development/python-modules/spacy-transformers { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  spark_parser = callPackage ../development/python-modules/spark_parser { };

  sparklines = callPackage ../development/python-modules/sparklines { };

  SPARQLWrapper = callPackage ../development/python-modules/sparqlwrapper { };

  sparse = callPackage ../development/python-modules/sparse { };

  spdx-tools = callPackage ../development/python-modules/spdx-tools { };

  speaklater = callPackage ../development/python-modules/speaklater { };

  speaklater3 = callPackage ../development/python-modules/speaklater3 { };

  spectral-cube = callPackage ../development/python-modules/spectral-cube { };

  speedtest-cli = callPackage ../development/python-modules/speedtest-cli { };

  spglib = callPackage ../development/python-modules/spglib { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  spiderpy = callPackage ../development/python-modules/spiderpy { };

  spinners = callPackage ../development/python-modules/spinners { };

  sphinxcontrib-actdiag = callPackage ../development/python-modules/sphinxcontrib-actdiag { };

  sphinxcontrib-applehelp = callPackage ../development/python-modules/sphinxcontrib-applehelp { };

  sphinxcontrib-autoapi = callPackage ../development/python-modules/sphinxcontrib-autoapi { };

  sphinxcontrib-bayesnet = callPackage ../development/python-modules/sphinxcontrib-bayesnet { };

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex { };

  sphinxcontrib-blockdiag = callPackage ../development/python-modules/sphinxcontrib-blockdiag { };

  sphinxcontrib-devhelp = callPackage ../development/python-modules/sphinxcontrib-devhelp { };

  sphinxcontrib-excel-table = callPackage ../development/python-modules/sphinxcontrib-excel-table { };

  sphinxcontrib-fulltoc = callPackage ../development/python-modules/sphinxcontrib-fulltoc { };

  sphinxcontrib-htmlhelp = callPackage ../development/python-modules/sphinxcontrib-htmlhelp { };

  sphinxcontrib_httpdomain = callPackage ../development/python-modules/sphinxcontrib_httpdomain { };

  sphinxcontrib-jsmath = callPackage ../development/python-modules/sphinxcontrib-jsmath { };

  sphinxcontrib-katex = callPackage ../development/python-modules/sphinxcontrib-katex { };

  sphinxcontrib-nwdiag = callPackage ../development/python-modules/sphinxcontrib-nwdiag { };

  sphinxcontrib_newsfeed = callPackage ../development/python-modules/sphinxcontrib_newsfeed { };

  sphinxcontrib-openapi = callPackage ../development/python-modules/sphinxcontrib-openapi { };

  sphinxcontrib-plantuml = callPackage ../development/python-modules/sphinxcontrib-plantuml {
    inherit (pkgs) plantuml;
  };

  sphinxcontrib-qthelp = callPackage ../development/python-modules/sphinxcontrib-qthelp { };

  sphinxcontrib-serializinghtml = callPackage ../development/python-modules/sphinxcontrib-serializinghtml { };

  sphinxcontrib-seqdiag = callPackage ../development/python-modules/sphinxcontrib-seqdiag { };

  sphinxcontrib-spelling = callPackage ../development/python-modules/sphinxcontrib-spelling { };

  sphinxcontrib-tikz = callPackage ../development/python-modules/sphinxcontrib-tikz {
    texLive = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small standalone pgfplots; };
  };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  sphinx = callPackage ../development/python-modules/sphinx { };

  sphinx-argparse = callPackage ../development/python-modules/sphinx-argparse { };

  sphinx-autobuild = callPackage ../development/python-modules/sphinx-autobuild { };

  sphinx-copybutton = callPackage ../development/python-modules/sphinx-copybutton { };

  sphinx-inline-tabs = callPackage ../development/python-modules/sphinx-inline-tabs { };

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  sphinx-markdown-parser = callPackage ../development/python-modules/sphinx-markdown-parser { };

  sphinx-material = callPackage ../development/python-modules/sphinx-material { };

  sphinx-navtree = callPackage ../development/python-modules/sphinx-navtree { };

  sphinx_pypi_upload = callPackage ../development/python-modules/sphinx_pypi_upload { };

  sphinx_rtd_theme = callPackage ../development/python-modules/sphinx_rtd_theme { };

  sphinx-serve = callPackage ../development/python-modules/sphinx-serve { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinxext-opengraph = callPackage ../development/python-modules/sphinxext-opengraph { };

  spidev = callPackage ../development/python-modules/spidev { };

  splinter = callPackage ../development/python-modules/splinter { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  spur = callPackage ../development/python-modules/spur { };

  spyder = callPackage ../development/python-modules/spyder { };

  spyder-kernels = callPackage ../development/python-modules/spyder-kernels { };

  spyse-python = callPackage ../development/python-modules/spyse-python { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy-citext = callPackage ../development/python-modules/sqlalchemy-citext { };

  sqlalchemy-continuum = callPackage ../development/python-modules/sqlalchemy-continuum { };

  sqlalchemy-i18n = callPackage ../development/python-modules/sqlalchemy-i18n { };

  SQLAlchemy-ImageAttach = callPackage ../development/python-modules/sqlalchemy-imageattach { };

  sqlalchemy-jsonfield = callPackage ../development/python-modules/sqlalchemy-jsonfield { };

  sqlalchemy-migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  sqlalchemy-mixins = callPackage ../development/python-modules/sqlalchemy-mixins { };

  sqlalchemy-utils = callPackage ../development/python-modules/sqlalchemy-utils { };

  sqlitedict = callPackage ../development/python-modules/sqlitedict { };

  sqlite-fts4 = callPackage ../development/python-modules/sqlite-fts4 { };

  sqlite-utils = callPackage ../development/python-modules/sqlite-utils { };

  sqlmap = callPackage ../development/python-modules/sqlmap { };

  sqlobject = callPackage ../development/python-modules/sqlobject { };

  sqlparse = callPackage ../development/python-modules/sqlparse { };

  sqlsoup = callPackage ../development/python-modules/sqlsoup { };

  srp = callPackage ../development/python-modules/srp { };

  srpenergy = callPackage ../development/python-modules/srpenergy { };

  srptools = callPackage ../development/python-modules/srptools { };

  srsly = callPackage ../development/python-modules/srsly { };

  srvlookup = callPackage ../development/python-modules/srvlookup { };

  ssdeep = callPackage ../development/python-modules/ssdeep {
    inherit (pkgs) ssdeep;
  };

  ssdp = callPackage ../development/python-modules/ssdp { };

  sseclient = callPackage ../development/python-modules/sseclient { };

  sseclient-py = callPackage ../development/python-modules/sseclient-py { };

  sshpubkeys = callPackage ../development/python-modules/sshpubkeys { };

  sshtunnel = callPackage ../development/python-modules/sshtunnel { };

  sslib = callPackage ../development/python-modules/sslib { };

  sslyze = callPackage ../development/python-modules/sslyze { };

  stack-data = callPackage ../development/python-modules/stack-data { };

  stanza = callPackage ../development/python-modules/stanza { };

  starlette = callPackage ../development/python-modules/starlette {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices;
  };

  starkbank-ecdsa = callPackage ../development/python-modules/starkbank-ecdsa { };

  starline = callPackage ../development/python-modules/starline { };

  stashy = callPackage ../development/python-modules/stashy { };

  staticjinja = callPackage ../development/python-modules/staticjinja { };

  statistics = callPackage ../development/python-modules/statistics { };

  statmake = callPackage ../development/python-modules/statmake { };

  statsd = callPackage ../development/python-modules/statsd { };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  stdiomask = callPackage ../development/python-modules/stdiomask { };

  stdlib-list = callPackage ../development/python-modules/stdlib-list { };

  stem = callPackage ../development/python-modules/stem { };

  stestr = callPackage ../development/python-modules/stestr { };

  stevedore = callPackage ../development/python-modules/stevedore { };

  stickytape = callPackage ../development/python-modules/stickytape { };

  stm32loader = callPackage ../development/python-modules/stm32loader { };

  stone = callPackage ../development/python-modules/stone { };

  stopit = callPackage ../development/python-modules/stopit { };

  strategies = callPackage ../development/python-modules/strategies { };

  stravalib = callPackage ../development/python-modules/stravalib { };

  streaming-form-data = callPackage ../development/python-modules/streaming-form-data { };

  streamlabswater = callPackage ../development/python-modules/streamlabswater { };

  streamz = callPackage ../development/python-modules/streamz { };

  strict-rfc3339 = callPackage ../development/python-modules/strict-rfc3339 { };

  strictyaml = callPackage ../development/python-modules/strictyaml { };

  stringcase = callPackage ../development/python-modules/stringcase { };

  stripe = callPackage ../development/python-modules/stripe { };

  striprtf = callPackage ../development/python-modules/striprtf { };

  structlog = callPackage ../development/python-modules/structlog { };

  stumpy = callPackage ../development/python-modules/stumpy { };

  stups-cli-support = callPackage ../development/python-modules/stups-cli-support { };

  stups-fullstop = callPackage ../development/python-modules/stups-fullstop { };

  stups-pierone = callPackage ../development/python-modules/stups-pierone { };

  stups-tokens = callPackage ../development/python-modules/stups-tokens { };

  stups-zign = callPackage ../development/python-modules/stups-zign { };

  stytra = callPackage ../development/python-modules/stytra { };

  subarulink = callPackage ../development/python-modules/subarulink { };

  subdownloader = callPackage ../development/python-modules/subdownloader { };

  subliminal = callPackage ../development/python-modules/subliminal { };

  subprocess-tee = callPackage ../development/python-modules/subprocess-tee { };

  subunit = callPackage ../development/python-modules/subunit {
    inherit (pkgs) subunit cppunit check;
  };

  subunit2sql = callPackage ../development/python-modules/subunit2sql { };

  subzerod = callPackage ../development/python-modules/subzerod { };

  suds-jurko = callPackage ../development/python-modules/suds-jurko { };

  sumo = callPackage ../development/python-modules/sumo { };

  sumtypes = callPackage ../development/python-modules/sumtypes { };

  sunpy = callPackage ../development/python-modules/sunpy { };

  sunwatcher = callPackage ../development/python-modules/sunwatcher { };

  supervise_api = callPackage ../development/python-modules/supervise_api { };

  supervisor = callPackage ../development/python-modules/supervisor { };

  superqt = callPackage ../development/python-modules/superqt { };

  sure = callPackage ../development/python-modules/sure { };

  surepy = callPackage ../development/python-modules/surepy { };

  surt = callPackage ../development/python-modules/surt { };

  survey = callPackage ../development/python-modules/survey { };

  suseapi = callPackage ../development/python-modules/suseapi { };

  svdtools = callPackage ../development/python-modules/svdtools { };

  svg2tikz = callPackage ../development/python-modules/svg2tikz { };

  svglib = callPackage ../development/python-modules/svglib { };

  svg-path = callPackage ../development/python-modules/svg-path { };

  svgwrite = callPackage ../development/python-modules/svgwrite { };

  swagger-spec-validator = callPackage ../development/python-modules/swagger-spec-validator { };

  swagger-ui-bundle = callPackage ../development/python-modules/swagger-ui-bundle { };

  swift = callPackage ../development/python-modules/swift { };

  swisshydrodata = callPackage ../development/python-modules/swisshydrodata { };

  swspotify = callPackage ../development/python-modules/swspotify { };

  sybil = callPackage ../development/python-modules/sybil { };

  symengine = callPackage ../development/python-modules/symengine {
    inherit (pkgs) symengine;
  };

  sympy = callPackage ../development/python-modules/sympy { };

  syncer = callPackage ../development/python-modules/syncer { };

  synergy = callPackage ../development/python-modules/synergy { };

  synologydsm-api = callPackage ../development/python-modules/synologydsm-api { };

  syslog-rfc5424-formatter = callPackage ../development/python-modules/syslog-rfc5424-formatter { };

  systembridge = callPackage ../development/python-modules/systembridge { };

  systemd = callPackage ../development/python-modules/systemd {
    inherit (pkgs) systemd;
  };

  sysv_ipc = callPackage ../development/python-modules/sysv_ipc { };

  tableaudocumentapi = callPackage ../development/python-modules/tableaudocumentapi { };

  tables = callPackage ../development/python-modules/tables {
    hdf5 = pkgs.hdf5_1_10;
  };

  tablib = callPackage ../development/python-modules/tablib { };

  tabulate = callPackage ../development/python-modules/tabulate { };

  tabview = callPackage ../development/python-modules/tabview { };

  tadasets = callPackage ../development/python-modules/tadasets { };

  tag-expressions = callPackage ../development/python-modules/tag-expressions { };

  tago = callPackage ../development/python-modules/tago { };

  tahoma-api = callPackage ../development/python-modules/tahoma-api { };

  tailer = callPackage ../development/python-modules/tailer { };

  tailscale = callPackage ../development/python-modules/tailscale { };

  tappy = callPackage ../development/python-modules/tappy { };

  tasklib = callPackage ../development/python-modules/tasklib { };

  taskw = callPackage ../development/python-modules/taskw { };

  tatsu = callPackage ../development/python-modules/tatsu { };

  tblib = callPackage ../development/python-modules/tblib { };

  tbm-utils = callPackage ../development/python-modules/tbm-utils { };

  telegram = callPackage ../development/python-modules/telegram { };

  telethon = callPackage ../development/python-modules/telethon {
    inherit (pkgs) openssl;
  };

  telethon-session-sqlalchemy = callPackage ../development/python-modules/telethon-session-sqlalchemy { };

  teletype = callPackage ../development/python-modules/teletype { };

  telfhash = callPackage ../development/python-modules/telfhash { };

  tempest = callPackage ../development/python-modules/tempest { };

  tempita = callPackage ../development/python-modules/tempita { };

  tempora = callPackage ../development/python-modules/tempora { };

  tenacity = callPackage ../development/python-modules/tenacity { };

  tensorboard-data-server = callPackage ../development/python-modules/tensorboard-data-server { };

  tensorboard-plugin-profile = callPackage ../development/python-modules/tensorboard-plugin-profile { };

  tensorboard-plugin-wit = callPackage ../development/python-modules/tensorboard-plugin-wit { };

  tensorboardx = callPackage ../development/python-modules/tensorboardx { };

  tensorflow-bin = callPackage ../development/python-modules/tensorflow/bin.nix {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudatoolkit = tensorflow_compat_cudatoolkit;
    cudnn = tensorflow_compat_cudnn;
  };

  tensorflow-build = callPackage ../development/python-modules/tensorflow {
    inherit (pkgs.darwin) cctools;
    cudaSupport = pkgs.config.cudaSupport or false;
    cudatoolkit = tensorflow_compat_cudatoolkit;
    cudnn = tensorflow_compat_cudnn;
    nccl = tensorflow_compat_nccl;
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation Security;
    flatbuffers-core = pkgs.flatbuffers;
    flatbuffers-python = self.flatbuffers;
    protobuf-core = pkgs.protobuf;
    protobuf-python = self.protobuf;
    lmdb-core = pkgs.lmdb;
  };

  tensorflow-datasets = callPackage ../development/python-modules/tensorflow-datasets { };

  tensorflow-estimator = callPackage ../development/python-modules/tensorflow-estimator { };

  tensorflow-metadata = callPackage ../development/python-modules/tensorflow-metadata { };

  tensorflow-probability = callPackage ../development/python-modules/tensorflow-probability { };

  tensorflow = self.tensorflow-build;

  tensorflow-tensorboard = callPackage ../development/python-modules/tensorflow-tensorboard { };

  tensorflowWithCuda = self.tensorflow.override {
    cudaSupport = true;
  };

  tensorflowWithoutCuda = self.tensorflow.override {
    cudaSupport = false;
  };

  tensorly = callPackage ../development/python-modules/tensorly { };

  tellduslive = callPackage ../development/python-modules/tellduslive { };

  termcolor = callPackage ../development/python-modules/termcolor { };

  terminado = callPackage ../development/python-modules/terminado { };

  terminaltables = callPackage ../development/python-modules/terminaltables { };

  termplotlib = callPackage ../development/python-modules/termplotlib { };

  termstyle = callPackage ../development/python-modules/termstyle { };

  tern = callPackage ../development/python-modules/tern { };

  tesla-wall-connector = callPackage ../development/python-modules/tesla-wall-connector { };

  teslajsonpy = callPackage ../development/python-modules/teslajsonpy { };

  tess = callPackage ../development/python-modules/tess { };

  tesserocr = callPackage ../development/python-modules/tesserocr { };

  testfixtures = callPackage ../development/python-modules/testfixtures { };

  textfsm = callPackage ../development/python-modules/textfsm { };

  testing-common-database = callPackage ../development/python-modules/testing-common-database { };

  testing-postgresql = callPackage ../development/python-modules/testing-postgresql { };

  testpath = callPackage ../development/python-modules/testpath { };

  testrepository = callPackage ../development/python-modules/testrepository { };

  testresources = callPackage ../development/python-modules/testresources { };

  testscenarios = callPackage ../development/python-modules/testscenarios { };

  testtools = callPackage ../development/python-modules/testtools { };

  test-tube = callPackage ../development/python-modules/test-tube { };

  textdistance = callPackage ../development/python-modules/textdistance { };

  textacy = callPackage ../development/python-modules/textacy { };

  texttable = callPackage ../development/python-modules/texttable { };

  text-unidecode = callPackage ../development/python-modules/text-unidecode { };

  textwrap3 = callPackage ../development/python-modules/textwrap3 { };

  tflearn = callPackage ../development/python-modules/tflearn { };

  tgcrypto = callPackage ../development/python-modules/tgcrypto { };

  Theano = callPackage ../development/python-modules/Theano rec {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudnnSupport = cudaSupport;
  };

  TheanoWithCuda = self.Theano.override {
    cudaSupport = true;
    cudnnSupport = true;
  };

  TheanoWithoutCuda = self.Theano.override {
    cudaSupport = false;
    cudnnSupport = false;
  };

  thespian = callPackage ../development/python-modules/thespian { };

  thinc = callPackage ../development/python-modules/thinc {
    inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate CoreFoundation CoreGraphics CoreVideo;
  };

  threadloop = callPackage ../development/python-modules/threadloop { };

  threadpool = callPackage ../development/python-modules/threadpool { };

  threadpoolctl = callPackage ../development/python-modules/threadpoolctl { };

  three-merge = callPackage ../development/python-modules/three-merge { };

  thrift = callPackage ../development/python-modules/thrift { };

  thriftpy2 = callPackage ../development/python-modules/thriftpy2 { };

  thumborPexif = callPackage ../development/python-modules/thumborpexif { };

  tkinter = let
    py = python.override { x11Support=true; };
  in callPackage ../development/python-modules/tkinter { py = py; };

  tidylib = callPackage ../development/python-modules/pytidylib { };

  tifffile = callPackage ../development/python-modules/tifffile { };

  tika = callPackage ../development/python-modules/tika { };

  tiledb = callPackage ../development/python-modules/tiledb {
    inherit (pkgs) tiledb;
  };

  tilequant = callPackage ../development/python-modules/tilequant { };

  tilestache = callPackage ../development/python-modules/tilestache { };

  timeago = callPackage ../development/python-modules/timeago { };

  timecop = callPackage ../development/python-modules/timecop { };

  timelib = callPackage ../development/python-modules/timelib { };

  time-machine = callPackage ../development/python-modules/time-machine { };

  timeout-decorator = callPackage ../development/python-modules/timeout-decorator { };

  timetagger = callPackage ../development/python-modules/timetagger { };

  timezonefinder = callPackage ../development/python-modules/timezonefinder { };

  tinycss2 = callPackage ../development/python-modules/tinycss2 { };

  tinycss = callPackage ../development/python-modules/tinycss { };

  tinydb = callPackage ../development/python-modules/tinydb { };

  tinyobjloader-py = callPackage ../development/python-modules/tinyobjloader-py { };

  tissue = callPackage ../development/python-modules/tissue { };

  titlecase = callPackage ../development/python-modules/titlecase { };

  tld = callPackage ../development/python-modules/tld { };

  tldextract = callPackage ../development/python-modules/tldextract { };

  tlsh = callPackage ../development/python-modules/tlsh { };

  tlslite-ng = callPackage ../development/python-modules/tlslite-ng { };

  tls-parser = callPackage ../development/python-modules/tls-parser { };

  tmb = callPackage ../development/python-modules/tmb { };

  todoist = callPackage ../development/python-modules/todoist { };

  toggl-cli = callPackage ../development/python-modules/toggl-cli { };

  token-bucket = callPackage ../development/python-modules/token-bucket { };

  tokenizers = toPythonModule (callPackage ../development/python-modules/tokenizers { });

  tokenize-rt = toPythonModule (callPackage ../development/python-modules/tokenize-rt { });

  tokenlib = callPackage ../development/python-modules/tokenlib { };

  tololib = callPackage ../development/python-modules/tololib { };

  toml = callPackage ../development/python-modules/toml { };

  tomli = callPackage ../development/python-modules/tomli { };

  tomli-w = callPackage ../development/python-modules/tomli-w { };

  tomlkit = callPackage ../development/python-modules/tomlkit { };

  toolz = callPackage ../development/python-modules/toolz { };

  toonapi = callPackage ../development/python-modules/toonapi { };

  toposort = callPackage ../development/python-modules/toposort { };

  torchaudio-bin = callPackage ../development/python-modules/torchaudio/bin.nix { };

  torchgpipe = callPackage ../development/python-modules/torchgpipe { };

  torchinfo = callPackage ../development/python-modules/torchinfo { };

  torchvision = callPackage ../development/python-modules/torchvision { };

  torchvision-bin = callPackage ../development/python-modules/torchvision/bin.nix { };

  tornado = callPackage ../development/python-modules/tornado { };

  # Used by circus and grab-site, 2020-08-29
  tornado_4 = callPackage ../development/python-modules/tornado/4.nix { };

  # Used by streamlit, graphite_beacon, 2021-01-29
  tornado_5 = callPackage ../development/python-modules/tornado/5.nix { };

  torrequest = callPackage ../development/python-modules/torrequest { };

  total-connect-client = callPackage ../development/python-modules/total-connect-client { };

  towncrier = callPackage ../development/python-modules/towncrier {
    inherit (pkgs) git;
  };

  tox = callPackage ../development/python-modules/tox { };

  tpm2-pytss = callPackage ../development/python-modules/tpm2-pytss { };

  tqdm = callPackage ../development/python-modules/tqdm { };

  traceback2 = callPackage ../development/python-modules/traceback2 { };

  tracing = callPackage ../development/python-modules/tracing { };

  trackpy = callPackage ../development/python-modules/trackpy { };

  traitlets = callPackage ../development/python-modules/traitlets { };

  traits = callPackage ../development/python-modules/traits { };

  traitsui = callPackage ../development/python-modules/traitsui { };

  traittypes = callPackage ../development/python-modules/traittypes { };

  transaction = callPackage ../development/python-modules/transaction { };

  transformers = callPackage ../development/python-modules/transformers { };

  transforms3d = callPackage ../development/python-modules/transforms3d { };

  transip = callPackage ../development/python-modules/transip { };

  transitions = callPackage ../development/python-modules/transitions { };

  translatepy = callPackage ../development/python-modules/translatepy { };

  translationstring = callPackage ../development/python-modules/translationstring { };

  transmission-rpc = callPackage ../development/python-modules/transmission-rpc { };

  transmissionrpc = callPackage ../development/python-modules/transmissionrpc { };

  treeo = callPackage ../development/python-modules/treeo { };

  treex = callPackage ../development/python-modules/treex { };

  treq = callPackage ../development/python-modules/treq { };

  trezor_agent = callPackage ../development/python-modules/trezor_agent { };

  trezor = callPackage ../development/python-modules/trezor { };

  trimesh = callPackage ../development/python-modules/trimesh { };

  trio = callPackage ../development/python-modules/trio { };

  trio-asyncio = callPackage ../development/python-modules/trio-asyncio { };

  trueskill = callPackage ../development/python-modules/trueskill { };

  trustme = callPackage ../development/python-modules/trustme { };

  trytond = callPackage ../development/python-modules/trytond { };

  ttls = callPackage ../development/python-modules/ttls { };

  ttp = callPackage ../development/python-modules/ttp { };

  tubes = callPackage ../development/python-modules/tubes { };

  tunigo = callPackage ../development/python-modules/tunigo { };

  tubeup = callPackage ../development/python-modules/tubeup { };

  tumpa = callPackage ../development/python-modules/tumpa {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  tuya-iot-py-sdk = callPackage ../development/python-modules/tuya-iot-py-sdk { };

  tuyaha = callPackage ../development/python-modules/tuyaha { };

  tvdb_api = callPackage ../development/python-modules/tvdb_api { };

  tweedledum = callPackage ../development/python-modules/tweedledum { };

  tweepy = callPackage ../development/python-modules/tweepy { };

  twentemilieu = callPackage ../development/python-modules/twentemilieu { };

  twiggy = callPackage ../development/python-modules/twiggy { };

  twilio = callPackage ../development/python-modules/twilio { };

  twill = callPackage ../development/python-modules/twill { };

  twine = callPackage ../development/python-modules/twine { };

  twinkly-client = callPackage ../development/python-modules/twinkly-client { };

  twisted = callPackage ../development/python-modules/twisted { };

  twitch-python = callPackage ../development/python-modules/twitch-python { };

  twitter = callPackage ../development/python-modules/twitter { };

  twitter-common-collections = callPackage ../development/python-modules/twitter-common-collections { };

  twitter-common-confluence = callPackage ../development/python-modules/twitter-common-confluence { };

  twitter-common-dirutil = callPackage ../development/python-modules/twitter-common-dirutil { };

  twitter-common-lang = callPackage ../development/python-modules/twitter-common-lang { };

  twitter-common-log = callPackage ../development/python-modules/twitter-common-log { };

  twitter-common-options = callPackage ../development/python-modules/twitter-common-options { };

  twitterapi = callPackage ../development/python-modules/twitterapi { };

  twofish = callPackage ../development/python-modules/twofish { };

  txaio = callPackage ../development/python-modules/txaio { };

  txamqp = callPackage ../development/python-modules/txamqp { };

  txdbus = callPackage ../development/python-modules/txdbus { };

  txgithub = callPackage ../development/python-modules/txgithub { };

  txredisapi = callPackage ../development/python-modules/txredisapi { };

  txrequests = callPackage ../development/python-modules/txrequests { };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  txzmq = callPackage ../development/python-modules/txzmq { };

  typecode = callPackage ../development/python-modules/typecode { };

  typecode-libmagic = callPackage ../development/python-modules/typecode/libmagic.nix {
    inherit (pkgs) file zlib;
  };

  typed-ast = callPackage ../development/python-modules/typed-ast { };

  typed-settings = callPackage ../development/python-modules/typed-settings { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  typer = callPackage ../development/python-modules/typer { };

  types-decorator = callPackage ../development/python-modules/types-decorator { };

  types-freezegun = callPackage ../development/python-modules/types-freezegun { };

  types-futures = callPackage ../development/python-modules/types-futures { };

  types-protobuf = callPackage ../development/python-modules/types-protobuf { };

  types-pytz = callPackage ../development/python-modules/types-pytz { };

  types-requests = callPackage ../development/python-modules/types-requests { };

  types-setuptools = callPackage ../development/python-modules/types-setuptools { };

  types-tabulate = callPackage ../development/python-modules/types-tabulate { };

  types-toml = callPackage ../development/python-modules/types-toml { };

  types-typed-ast = callPackage ../development/python-modules/types-typed-ast { };

  types-urllib3 = callPackage ../development/python-modules/types-urllib3 { };

  typesentry = callPackage ../development/python-modules/typesentry { };

  typesystem = callPackage ../development/python-modules/typesystem { };

  typical = callPackage ../development/python-modules/typical { };

  typing = null;

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typing-inspect = callPackage ../development/python-modules/typing-inspect { };

  typogrify = callPackage ../development/python-modules/typogrify { };

  tzdata = callPackage ../development/python-modules/tzdata { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  uamqp = callPackage ../development/python-modules/uamqp {
    inherit (pkgs.darwin.apple_sdk.frameworks) CFNetwork CoreFoundation Security;
  };

  ua-parser = callPackage ../development/python-modules/ua-parser { };

  uarray = callPackage ../development/python-modules/uarray { };

  uc-micro-py = callPackage ../development/python-modules/uc-micro-py { };

  udatetime = callPackage ../development/python-modules/udatetime { };

  ueberzug = callPackage ../development/python-modules/ueberzug {
    inherit (pkgs.xorg) libX11 libXext;
  };

  ufo2ft = callPackage ../development/python-modules/ufo2ft { };

  ufoLib2 = callPackage ../development/python-modules/ufoLib2 { };

  ufonormalizer = callPackage ../development/python-modules/ufonormalizer { };

  ufoprocessor = callPackage ../development/python-modules/ufoprocessor { };

  ueagle = callPackage ../development/python-modules/ueagle { };

  ujson = callPackage ../development/python-modules/ujson { };

  ukkonen = callPackage ../development/python-modules/ukkonen { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  umalqurra = callPackage ../development/python-modules/umalqurra { };

  umap-learn = callPackage ../development/python-modules/umap-learn { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  unasync = callPackage ../development/python-modules/unasync { };

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  uncompyle6 = callPackage ../development/python-modules/uncompyle6 { };

  unicodecsv = callPackage ../development/python-modules/unicodecsv { };

  unicodedata2 = callPackage ../development/python-modules/unicodedata2 { };

  unicode-slugify = callPackage ../development/python-modules/unicode-slugify { };

  unicorn = callPackage ../development/python-modules/unicorn {
    unicorn-emu = pkgs.unicorn;
  };

  unidecode = callPackage ../development/python-modules/unidecode { };

  unidic-lite = callPackage ../development/python-modules/unidic-lite { };

  unidiff = callPackage ../development/python-modules/unidiff { };

  unifi = callPackage ../development/python-modules/unifi { };

  unify = callPackage ../development/python-modules/unify { };

  unifiled = callPackage ../development/python-modules/unifiled { };

  units = callPackage ../development/python-modules/units { };

  unittest2 = callPackage ../development/python-modules/unittest2 { };

  unittest-data-provider = callPackage ../development/python-modules/unittest-data-provider { };

  unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

  unpaddedbase64 = callPackage ../development/python-modules/unpaddedbase64 { };

  unrardll = callPackage ../development/python-modules/unrardll { };

  unrpa = callPackage ../development/python-modules/unrpa { };

  untangle = callPackage ../development/python-modules/untangle { };

  untokenize = callPackage ../development/python-modules/untokenize { };

  uonet-request-signer-hebe = callPackage ../development/python-modules/uonet-request-signer-hebe { };

  upass = callPackage ../development/python-modules/upass { };

  upb-lib = callPackage ../development/python-modules/upb-lib { };

  upcloud-api = callPackage ../development/python-modules/upcloud-api { };

  update_checker = callPackage ../development/python-modules/update_checker { };

  update-copyright = callPackage ../development/python-modules/update-copyright { };

  update-dotdee = callPackage ../development/python-modules/update-dotdee { };

  upnpy = callPackage ../development/python-modules/upnpy { };

  uproot = callPackage ../development/python-modules/uproot { };

  uproot3 = callPackage ../development/python-modules/uproot3 { };

  uproot3-methods = callPackage ../development/python-modules/uproot3-methods { };

  uptime = callPackage ../development/python-modules/uptime { };

  uptime-kuma-monitor = callPackage ../development/python-modules/uptime-kuma-monitor { };

  uranium = callPackage ../development/python-modules/uranium { };

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uritools = callPackage ../development/python-modules/uritools { };

  url-normalize = callPackage ../development/python-modules/url-normalize { };

  urlextract = callPackage ../development/python-modules/urlextract { };

  urlgrabber = callPackage ../development/python-modules/urlgrabber { };

  urllib3 = callPackage ../development/python-modules/urllib3 { };

  urlpy = callPackage ../development/python-modules/urlpy { };

  urwid = callPackage ../development/python-modules/urwid { };

  urwidtrees = callPackage ../development/python-modules/urwidtrees { };

  urwid-readline = callPackage ../development/python-modules/urwid-readline { };

  usbtmc = callPackage ../development/python-modules/usbtmc { };

  us = callPackage ../development/python-modules/us { };

  user-agents = callPackage ../development/python-modules/user-agents { };

  userpath = callPackage ../development/python-modules/userpath { };

  ush = callPackage ../development/python-modules/ush { };

  utils = callPackage ../development/python-modules/utils { };

  uuid = callPackage ../development/python-modules/uuid { };

  uvcclient = callPackage ../development/python-modules/uvcclient { };

  uvicorn = callPackage ../development/python-modules/uvicorn { };

  uvloop = callPackage ../development/python-modules/uvloop {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  };

  validate-email = callPackage ../development/python-modules/validate-email { };

  validators = callPackage ../development/python-modules/validators { };

  validictory = callPackage ../development/python-modules/validictory { };

  variants = callPackage ../development/python-modules/variants { };

  varint = callPackage ../development/python-modules/varint { };

  vcrpy = callPackage ../development/python-modules/vcrpy { };

  vcver = callPackage ../development/python-modules/vcver { };

  vcversioner = callPackage ../development/python-modules/vcversioner { };

  vdf = callPackage ../development/python-modules/vdf { };

  vdirsyncer = callPackage ../development/python-modules/vdirsyncer { };

  vehicle = callPackage ../development/python-modules/vehicle { };

  vega = callPackage ../development/python-modules/vega { };

  vega_datasets = callPackage ../development/python-modules/vega_datasets { };

  venstarcolortouch = callPackage ../development/python-modules/venstarcolortouch { };

  venusian = callPackage ../development/python-modules/venusian { };

  velbus-aio = callPackage ../development/python-modules/velbus-aio { };

  verboselogs = callPackage ../development/python-modules/verboselogs { };

  versioneer = callPackage ../development/python-modules/versioneer { };

  versionfinder = callPackage ../development/python-modules/versionfinder { };

  versiontag = callPackage ../development/python-modules/versiontag { };

  versiontools = callPackage ../development/python-modules/versiontools { };

  vertica-python = callPackage ../development/python-modules/vertica-python { };

  veryprettytable = callPackage ../development/python-modules/veryprettytable { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  ViennaRNA = toPythonModule pkgs.ViennaRNA;

  viewstate = callPackage ../development/python-modules/viewstate { };

  vilfo-api-client = callPackage ../development/python-modules/vilfo-api-client { };

  vincenty = callPackage ../development/python-modules/vincenty { };

  vine = callPackage ../development/python-modules/vine { };

  virtkey = callPackage ../development/python-modules/virtkey { };

  virtual-display = callPackage ../development/python-modules/virtual-display { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  virtualenv-clone = callPackage ../development/python-modules/virtualenv-clone { };

  virtualenvwrapper = callPackage ../development/python-modules/virtualenvwrapper { };

  visitor = callPackage ../development/python-modules/visitor { };

  vispy = callPackage ../development/python-modules/vispy { };

  vivisect = callPackage ../development/python-modules/vivisect { };

  viv-utils = callPackage ../development/python-modules/viv-utils { };

  vmprof = callPackage ../development/python-modules/vmprof { };

  vncdo = callPackage ../development/python-modules/vncdo { };

  vobject = callPackage ../development/python-modules/vobject { };

  volkszaehler = callPackage ../development/python-modules/volkszaehler { };

  voluptuous = callPackage ../development/python-modules/voluptuous { };

  voluptuous-serialize = callPackage ../development/python-modules/voluptuous-serialize { };

  vowpalwabbit = callPackage ../development/python-modules/vowpalwabbit { };

  vpk = callPackage ../development/python-modules/vpk { };

  vsts = callPackage ../development/python-modules/vsts { };

  vsts-cd-manager = callPackage ../development/python-modules/vsts-cd-manager { };

  vsure = callPackage ../development/python-modules/vsure { };

  vt-py = callPackage ../development/python-modules/vt-py { };

  vtk = toPythonModule (pkgs.vtk.override {
    pythonInterpreter = python;
    enablePython = true;
  });

  vulcan-api = callPackage ../development/python-modules/vulcan-api { };

  vultr = callPackage ../development/python-modules/vultr { };

  vulture = callPackage ../development/python-modules/vulture { };

  vxi11 = callPackage ../development/python-modules/vxi11 { };

  vyper = callPackage ../development/compilers/vyper { };

  w3lib = callPackage ../development/python-modules/w3lib { };

  wadllib = callPackage ../development/python-modules/wadllib { };

  waitress = callPackage ../development/python-modules/waitress { };

  waitress-django = callPackage ../development/python-modules/waitress-django { };

  wakeonlan = callPackage ../development/python-modules/wakeonlan { };

  wallbox = callPackage ../development/python-modules/wallbox { };

  Wand = callPackage ../development/python-modules/Wand { };

  wandb = callPackage ../development/python-modules/wandb { };

  warcio = callPackage ../development/python-modules/warcio { };

  warlock = callPackage ../development/python-modules/warlock { };

  warrant = callPackage ../development/python-modules/warrant { };

  warrant-lite = callPackage ../development/python-modules/warrant-lite { };

  waqiasync = callPackage ../development/python-modules/waqiasync { };

  wasabi = callPackage ../development/python-modules/wasabi { };

  wasm = callPackage ../development/python-modules/wasm { };

  wasmerPackages = pkgs.recurseIntoAttrs (callPackage ../development/python-modules/wasmer { });
  inherit (self.wasmerPackages) wasmer wasmer-compiler-cranelift wasmer-compiler-llvm wasmer-compiler-singlepass;

  watchdog = callPackage ../development/python-modules/watchdog {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };

  watchgod = callPackage ../development/python-modules/watchgod { };

  waterfurnace = callPackage ../development/python-modules/waterfurnace { };

  watermark = callPackage ../development/python-modules/watermark { };

  wavedrom = callPackage ../development/python-modules/wavedrom { };

  wavefile = callPackage ../development/python-modules/wavefile { };

  wavinsentio = callPackage ../development/python-modules/wavinsentio { };

  wazeroutecalculator = callPackage ../development/python-modules/wazeroutecalculator { };

  wcmatch = callPackage ../development/python-modules/wcmatch { };

  wcwidth = callPackage ../development/python-modules/wcwidth { };

  weasyprint = callPackage ../development/python-modules/weasyprint { };

  webargs = callPackage ../development/python-modules/webargs { };

  webapp2 = callPackage ../development/python-modules/webapp2 { };

  webassets = callPackage ../development/python-modules/webassets { };

  web = callPackage ../development/python-modules/web { };

  web-cache = callPackage ../development/python-modules/web-cache { };

  webcolors = callPackage ../development/python-modules/webcolors { };

  webdavclient3 = callPackage ../development/python-modules/webdavclient3 { };

  webencodings = callPackage ../development/python-modules/webencodings { };

  webexteamssdk = callPackage ../development/python-modules/webexteamssdk { };

  webhelpers = callPackage ../development/python-modules/webhelpers { };

  webob = callPackage ../development/python-modules/webob { };

  weboob = callPackage ../development/python-modules/weboob { };

  webrtcvad = callPackage ../development/python-modules/webrtcvad { };

  websocket-client = callPackage ../development/python-modules/websocket-client { };

  websockets = callPackage ../development/python-modules/websockets { };

  websockify = callPackage ../development/python-modules/websockify { };

  webssh = callPackage ../development/python-modules/webssh { };

  webtest = callPackage ../development/python-modules/webtest { };

  webtest-aiohttp = callPackage ../development/python-modules/webtest-aiohttp { };

  webthing = callPackage ../development/python-modules/webthing { };

  weconnect = callPackage ../development/python-modules/weconnect { };

  weconnect-mqtt = callPackage ../development/python-modules/weconnect-mqtt { };

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  west = callPackage ../development/python-modules/west { };

  wfuzz = callPackage ../development/python-modules/wfuzz { };

  wget = callPackage ../development/python-modules/wget { };

  wheel = callPackage ../development/python-modules/wheel { };

  wheel-filename = callPackage ../development/python-modules/wheel-filename { };

  wheel-inspect = callPackage ../development/python-modules/wheel-inspect { };

  whichcraft = callPackage ../development/python-modules/whichcraft { };

  whirlpool-sixth-sense = callPackage ../development/python-modules/whirlpool-sixth-sense { };

  whisper = callPackage ../development/python-modules/whisper { };

  whitenoise = callPackage ../development/python-modules/whitenoise { };

  whodap = callPackage ../development/python-modules/whodap { };

  whois = callPackage ../development/python-modules/whois { };

  whoosh = callPackage ../development/python-modules/whoosh { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  wiffi = callPackage ../development/python-modules/wiffi { };

  willow = callPackage ../development/python-modules/willow { };

  winacl = callPackage ../development/python-modules/winacl { };

  winsspi = callPackage ../development/python-modules/winsspi { };

  wled = callPackage ../development/python-modules/wled { };

  woob = callPackage ../development/python-modules/woob { };

  woodblock = callPackage ../development/python-modules/woodblock { };

  word2vec = callPackage ../development/python-modules/word2vec { };

  wordcloud = callPackage ../development/python-modules/wordcloud { };

  wordfreq = callPackage ../development/python-modules/wordfreq { };

  worldengine = callPackage ../development/python-modules/worldengine { };

  wrapio = callPackage ../development/python-modules/wrapio { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  wrf-python = callPackage ../development/python-modules/wrf-python { };

  ws4py = callPackage ../development/python-modules/ws4py { };

  wsgi-intercept = callPackage ../development/python-modules/wsgi-intercept { };

  wsgiprox = callPackage ../development/python-modules/wsgiprox { };

  wsgiproxy2 = callPackage ../development/python-modules/wsgiproxy2 { };

  wsgitools = callPackage ../development/python-modules/wsgitools { };

  WSME = callPackage ../development/python-modules/WSME { };

  wsnsimpy = callPackage ../development/python-modules/wsnsimpy { };

  wsproto = callPackage ../development/python-modules/wsproto { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  wtf-peewee = callPackage ../development/python-modules/wtf-peewee { };

  wurlitzer = callPackage ../development/python-modules/wurlitzer { };

  wxPython_4_0 = callPackage ../development/python-modules/wxPython/4.0.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox Carbon Cocoa CoreFoundation IOKit OpenGL;
    wxGTK = pkgs.wxGTK30.override {
      withGtk2 = false;
      withWebKit = true;
    };
  };

  wxPython_4_1 = callPackage ../development/python-modules/wxPython/4.1.nix {
    wxGTK = pkgs.wxGTK31.override {
      withGtk2 = false;
      withWebKit = true;
    };
  };

  x11_hash = callPackage ../development/python-modules/x11_hash { };

  x256 = callPackage ../development/python-modules/x256 { };

  xapian = callPackage ../development/python-modules/xapian {
    inherit (pkgs) xapian;
  };

  xapp = callPackage ../development/python-modules/xapp {
    inherit (pkgs) gtk3 gobject-introspection polkit;
    inherit (pkgs.cinnamon) xapps;
  };

  xarray = callPackage ../development/python-modules/xarray { };

  xattr = callPackage ../development/python-modules/xattr { };

  xbox-webapi = callPackage ../development/python-modules/xbox-webapi { };

  xboxapi = callPackage ../development/python-modules/xboxapi { };

  xcffib = callPackage ../development/python-modules/xcffib { };

  xdg = callPackage ../development/python-modules/xdg { };

  xdis = callPackage ../development/python-modules/xdis { };

  xdot = callPackage ../development/python-modules/xdot {
    inherit (pkgs) graphviz;
  };

  xgboost = callPackage ../development/python-modules/xgboost {
    inherit (pkgs) xgboost;
  };

  xhtml2pdf = callPackage ../development/python-modules/xhtml2pdf { };

  xkbcommon = callPackage ../development/python-modules/xkbcommon { };

  xkcdpass = callPackage ../development/python-modules/xkcdpass { };

  xknx = callPackage ../development/python-modules/xknx { };

  xlib = callPackage ../development/python-modules/xlib { };

  xlrd = callPackage ../development/python-modules/xlrd { };

  xlsx2csv = callPackage ../development/python-modules/xlsx2csv { };

  XlsxWriter = callPackage ../development/python-modules/XlsxWriter { };

  xlwt = callPackage ../development/python-modules/xlwt { };

  xmind = callPackage ../development/python-modules/xmind { };

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmldiff = callPackage ../development/python-modules/xmldiff { };

  xmljson = callPackage ../development/python-modules/xmljson { };

  xmlschema = callPackage ../development/python-modules/xmlschema { };

  xmlsec = callPackage ../development/python-modules/xmlsec {
    inherit (pkgs) libxslt libxml2 libtool pkg-config xmlsec;
  };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xml-marshaller = callPackage ../development/python-modules/xml-marshaller { };

  xmodem = callPackage ../development/python-modules/xmodem { };

  xnd = callPackage ../development/python-modules/xnd { };

  xpath-expressions = callPackage ../development/python-modules/xpath-expressions { };

  xpybutil = callPackage ../development/python-modules/xpybutil { };

  xstatic-bootbox = callPackage ../development/python-modules/xstatic-bootbox { };

  xstatic-bootstrap = callPackage ../development/python-modules/xstatic-bootstrap { };

  xstatic = callPackage ../development/python-modules/xstatic { };

  xstatic-jquery = callPackage ../development/python-modules/xstatic-jquery { };

  xstatic-jquery-file-upload = callPackage ../development/python-modules/xstatic-jquery-file-upload { };

  xstatic-jquery-ui = callPackage ../development/python-modules/xstatic-jquery-ui { };

  xstatic-pygments = callPackage ../development/python-modules/xstatic-pygments { };

  xtensor-python = callPackage ../development/python-modules/xtensor-python { };

  xvfbwrapper = callPackage ../development/python-modules/xvfbwrapper {
    inherit (pkgs.xorg) xorgserver;
  };

  xxh = callPackage ../tools/networking/xxh { };

  xxhash = callPackage ../development/python-modules/xxhash { };

  yahooweather = callPackage ../development/python-modules/yahooweather { };

  yalesmartalarmclient = callPackage ../development/python-modules/yalesmartalarmclient { };

  yalexs = callPackage ../development/python-modules/yalexs { };

  yamale = callPackage ../development/python-modules/yamale { };

  yamlfix = callPackage ../development/python-modules/yamlfix { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yamlloader = callPackage ../development/python-modules/yamlloader { };

  yamlordereddictloader = callPackage ../development/python-modules/yamlordereddictloader { };

  yanc = callPackage ../development/python-modules/yanc { };

  yangson = callPackage ../development/python-modules/yangson { };

  yapf = callPackage ../development/python-modules/yapf { };

  yappi = callPackage ../development/python-modules/yappi { };

  Yapsy = callPackage ../development/python-modules/yapsy { };

  yara-python = callPackage ../development/python-modules/yara-python { };

  yarg = callPackage ../development/python-modules/yarg { };

  yarl = callPackage ../development/python-modules/yarl { };

  yaspin = callPackage ../development/python-modules/yaspin { };

  yaswfp = callPackage ../development/python-modules/yaswfp { };

  yattag = callPackage ../development/python-modules/yattag { };

  yacs = callPackage ../development/python-modules/yacs { };

  ydiff = callPackage ../development/python-modules/ydiff { };

  yeelight = callPackage ../development/python-modules/yeelight { };

  yfinance = callPackage ../development/python-modules/yfinance { };

  yoda = toPythonModule (pkgs.yoda.override { inherit python; });

  youless-api = callPackage ../development/python-modules/youless-api { };

  youtube-dl = callPackage ../tools/misc/youtube-dl { };

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
    phantomjsSupport = false;
  };

  yt-dlp = callPackage ../tools/misc/yt-dlp { };

  yt-dlp-light = callPackage ../tools/misc/yt-dlp {
    ffmpegSupport = false;
    phantomjsSupport = false;
  };

  youtube-search = callPackage ../development/python-modules/youtube-search { };

  youtube-search-python = callPackage ../development/python-modules/youtube-search-python { };

  youtube-transcript-api = callPackage ../development/python-modules/youtube-transcript-api { };

  yowsup = callPackage ../development/python-modules/yowsup { };

  yq = callPackage ../development/python-modules/yq {
    inherit (pkgs) jq;
  };

  ytmusicapi = callPackage ../development/python-modules/ytmusicapi { };

  yubico-client = callPackage ../development/python-modules/yubico-client { };

  z3c-checkversions = callPackage ../development/python-modules/z3c-checkversions { };

  z3 = (toPythonModule (pkgs.z3.override {
    inherit python;
  })).python;

  zake = callPackage ../development/python-modules/zake { };

  zarr = callPackage ../development/python-modules/zarr { };

  zc-buildout = callPackage ../development/python-modules/buildout { };

  zc_lockfile = callPackage ../development/python-modules/zc_lockfile { };

  zconfig = callPackage ../development/python-modules/zconfig { };

  zcs = callPackage ../development/python-modules/zcs { };

  zdaemon = callPackage ../development/python-modules/zdaemon { };

  zeek = toPythonModule (pkgs.zeek.override {
    python3 = python;
  }).py;

  zeep = callPackage ../development/python-modules/zeep { };

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override {
    python3 = python;
  })).py;

  zeroc-ice = callPackage ../development/python-modules/zeroc-ice { };

  zeroconf = callPackage ../development/python-modules/zeroconf { };

  zerorpc = callPackage ../development/python-modules/zerorpc { };

  zetup = callPackage ../development/python-modules/zetup { };

  zeversolarlocal = callPackage ../development/python-modules/zeversolarlocal { };

  zfec = callPackage ../development/python-modules/zfec { };

  zha-quirks = callPackage ../development/python-modules/zha-quirks { };

  zict = callPackage ../development/python-modules/zict { };

  zigpy = callPackage ../development/python-modules/zigpy { };

  zigpy-cc = callPackage ../development/python-modules/zigpy-cc { };

  zigpy-deconz = callPackage ../development/python-modules/zigpy-deconz { };

  zigpy-xbee = callPackage ../development/python-modules/zigpy-xbee { };

  zigpy-zigate = callPackage ../development/python-modules/zigpy-zigate { };

  zigpy-znp = callPackage ../development/python-modules/zigpy-znp { };

  zimports = callPackage ../development/python-modules/zimports { };

  zipfile36 = callPackage ../development/python-modules/zipfile36 { };

  zipp = callPackage ../development/python-modules/zipp { };

  zipstream = callPackage ../development/python-modules/zipstream { };

  zipstream-new = callPackage ../development/python-modules/zipstream-new { };

  zm-py = callPackage ../development/python-modules/zm-py { };

  zodb = callPackage ../development/python-modules/zodb { };

  zodbpickle = callPackage ../development/python-modules/zodbpickle { };

  zope_broken = callPackage ../development/python-modules/zope_broken { };

  zope_component = callPackage ../development/python-modules/zope_component { };

  zope_configuration = callPackage ../development/python-modules/zope_configuration { };

  zope_contenttype = callPackage ../development/python-modules/zope_contenttype { };

  zope_copy = callPackage ../development/python-modules/zope_copy { };

  zope-deferredimport = callPackage ../development/python-modules/zope-deferredimport { };

  zope_deprecation = callPackage ../development/python-modules/zope_deprecation { };

  zope_dottedname = callPackage ../development/python-modules/zope_dottedname { };

  zope_event = callPackage ../development/python-modules/zope_event { };

  zope_exceptions = callPackage ../development/python-modules/zope_exceptions { };

  zope_filerepresentation = callPackage ../development/python-modules/zope_filerepresentation { };

  zope-hookable = callPackage ../development/python-modules/zope-hookable { };

  zope_i18nmessageid = callPackage ../development/python-modules/zope_i18nmessageid { };

  zope_interface = callPackage ../development/python-modules/zope_interface { };

  zope_lifecycleevent = callPackage ../development/python-modules/zope_lifecycleevent { };

  zope_location = callPackage ../development/python-modules/zope_location { };

  zope_proxy = callPackage ../development/python-modules/zope_proxy { };

  zope_schema = callPackage ../development/python-modules/zope_schema { };

  zope_size = callPackage ../development/python-modules/zope_size { };

  zope_testing = callPackage ../development/python-modules/zope_testing { };

  zope_testrunner = callPackage ../development/python-modules/zope_testrunner { };

  zopfli = callPackage ../development/python-modules/zopfli {
    inherit (pkgs) zopfli;
  };

  zstandard = callPackage ../development/python-modules/zstandard { };

  zstd = callPackage ../development/python-modules/zstd {
    inherit (pkgs) zstd;
  };

  zulip = callPackage ../development/python-modules/zulip { };

  zwave-js-server-python = callPackage ../development/python-modules/zwave-js-server-python { };

  zxcvbn = callPackage ../development/python-modules/zxcvbn { };
}
