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
}:

with pkgs.lib;

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

  fetchPypi = callPackage ../development/interpreters/python/fetchpypi.nix {};

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

  inherit (python.passthru) isPy27 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast pythonOlder;
  inherit python bootstrapped-pip buildPythonPackage buildPythonApplication;
  inherit fetchPypi;
  inherit hasPythonModule requiredPythonModules makePythonPath disabledIf;
  inherit toPythonModule toPythonApplication;
  inherit buildSetupcfg;

  inherit (callPackage ../development/interpreters/python/hooks { })
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

  # helpers

  wrapPython = callPackage ../development/interpreters/python/wrap-python.nix {inherit python; inherit (pkgs) makeSetupHook makeWrapper; };

  # Dont take pythonPackages from "global" pkgs scope to avoid mixing python versions
  pythonPackages = self;

  # specials

  recursivePthLoader = callPackage ../development/python-modules/recursive-pth-loader { };

  setuptools = if isPy27 then
    callPackage ../development/python-modules/setuptools/44.0.nix { }
  else
    callPackage ../development/python-modules/setuptools { };

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

  adal = callPackage ../development/python-modules/adal { };

  adb-homeassistant = callPackage ../development/python-modules/adb-homeassistant { };

  adb-shell = callPackage ../development/python-modules/adb-shell { };

  addic7ed-cli = callPackage ../development/python-modules/addic7ed-cli { };

  adguardhome= callPackage ../development/python-modules/adguardhome { };

  aenum = callPackage ../development/python-modules/aenum { };

  afdko = callPackage ../development/python-modules/afdko { };

  affine = callPackage ../development/python-modules/affine { };

  affinity = callPackage ../development/python-modules/affinity { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiocontextvars = callPackage ../development/python-modules/aiocontextvars { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aioesphomeapi = callPackage ../development/python-modules/aioesphomeapi { };

  aioeventlet = callPackage ../development/python-modules/aioeventlet { };

  aioextensions = callPackage ../development/python-modules/aioextensions { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aioftp = callPackage ../development/python-modules/aioftp { };

  aioh2 = callPackage ../development/python-modules/aioh2 { };

  aioharmony = callPackage ../development/python-modules/aioharmony { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp-cors { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aiohttp-socks = callPackage ../development/python-modules/aiohttp-socks { };

  aiohttp-swagger = callPackage ../development/python-modules/aiohttp-swagger { };

  aiohue = callPackage ../development/python-modules/aiohue { };

  aioimaplib = callPackage ../development/python-modules/aioimaplib { };

  aiojobs = callPackage ../development/python-modules/aiojobs { };

  aiokafka = callPackage ../development/python-modules/aiokafka { };

  aiolifx = callPackage ../development/python-modules/aiolifx { };

  aiolifx-effects = callPackage ../development/python-modules/aiolifx-effects { };

  aiomysql = callPackage ../development/python-modules/aiomysql { };

  aionotify = callPackage ../development/python-modules/aionotify { };

  aioprocessing = callPackage ../development/python-modules/aioprocessing { };

  aioredis = callPackage ../development/python-modules/aioredis { };

  aioresponses = callPackage ../development/python-modules/aioresponses { };

  aiorpcx = callPackage ../development/python-modules/aiorpcx { };

  aiorun = callPackage ../development/python-modules/aiorun { };

  aiosmtpd = callPackage ../development/python-modules/aiosmtpd { };

  aiosqlite = callPackage ../development/python-modules/aiosqlite { };

  aiounifi = callPackage ../development/python-modules/aiounifi { };

  aiounittest = callPackage ../development/python-modules/aiounittest { };

  aiozeroconf = callPackage ../development/python-modules/aiozeroconf { };

  ajpy = callPackage ../development/python-modules/ajpy { };

  alabaster = callPackage ../development/python-modules/alabaster { };

  alarmdecoder = callPackage ../development/python-modules/alarmdecoder { };

  alembic = callPackage ../development/python-modules/alembic { };

  alerta = callPackage ../development/python-modules/alerta { };

  alerta-server = callPackage ../development/python-modules/alerta-server { };

  algebraic-data-types = callPackage ../development/python-modules/algebraic-data-types { };

  allpairspy = callPackage ../development/python-modules/allpairspy { };

  alot = callPackage ../development/python-modules/alot { };

  altair = callPackage ../development/python-modules/altair { };

  amazon_kclpy = callPackage ../development/python-modules/amazon_kclpy { };

  amply = callPackage ../development/python-modules/amply { };

  amqp = callPackage ../development/python-modules/amqp { };

  amqplib = callPackage ../development/python-modules/amqplib { };

  androidtv = callPackage ../development/python-modules/androidtv { };

  androguard = callPackage ../development/python-modules/androguard { };

  aniso8601 = callPackage ../development/python-modules/aniso8601 { };

  annexremote = callPackage ../development/python-modules/annexremote { };

  annoy = callPackage ../development/python-modules/annoy { };

  anonip = callPackage ../development/python-modules/anonip { };

  ansi2html = callPackage ../development/python-modules/ansi2html { };

  ansible = callPackage ../development/python-modules/ansible { };

  ansible-kernel = callPackage ../development/python-modules/ansible-kernel { };

  ansible-lint = callPackage ../development/python-modules/ansible-lint { };

  ansible-runner = callPackage ../development/python-modules/ansible-runner { };

  ansi = callPackage ../development/python-modules/ansi { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  ansicolors = callPackage ../development/python-modules/ansicolors { };

  ansiconv = callPackage ../development/python-modules/ansiconv { };

  ansiwrap = callPackage ../development/python-modules/ansiwrap { };

  antlr4-python2-runtime = callPackage ../development/python-modules/antlr4-python2-runtime { antlr4 = pkgs.antlr4; };

  antlr4-python3-runtime = callPackage ../development/python-modules/antlr4-python3-runtime { antlr4 = pkgs.antlr4; };

  anyio = callPackage ../development/python-modules/anyio { };

  anyjson = callPackage ../development/python-modules/anyjson { };

  anytree = callPackage ../development/python-modules/anytree { inherit (pkgs) graphviz; };

  apache-airflow = callPackage ../development/python-modules/apache-airflow { };

  apipkg = callPackage ../development/python-modules/apipkg { };

  apispec = callPackage ../development/python-modules/apispec { };

  aplpy = callPackage ../development/python-modules/aplpy { };

  appdirs = callPackage ../development/python-modules/appdirs { };

  appleseed = disabledIf isPy3k (toPythonModule (pkgs.appleseed.override { inherit (self) python; }));

  application = callPackage ../development/python-modules/application { };

  applicationinsights = callPackage ../development/python-modules/applicationinsights { };

  appnope = callPackage ../development/python-modules/appnope { };

  apprise = callPackage ../development/python-modules/apprise { };

  approvaltests = callPackage ../development/python-modules/approvaltests { };

  apptools = callPackage ../development/python-modules/apptools { };

  APScheduler = callPackage ../development/python-modules/APScheduler { };

  apsw = callPackage ../development/python-modules/apsw { };

  arabic-reshaper = callPackage ../development/python-modules/arabic-reshaper { };

  area = callPackage ../development/python-modules/area { };

  arelle = callPackage ../development/python-modules/arelle { gui = true; };

  arelle-headless = callPackage ../development/python-modules/arelle { gui = false; };

  aresponses = callPackage ../development/python-modules/aresponses { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  argh = callPackage ../development/python-modules/argh { };

  argon2_cffi = callPackage ../development/python-modules/argon2_cffi { };

  args = callPackage ../development/python-modules/args { };

  aria2p = callPackage ../development/python-modules/aria2p { inherit (pkgs) aria2; };

  arrayqueues = callPackage ../development/python-modules/arrayqueues { };

  arrow = callPackage ../development/python-modules/arrow { };

  arviz = callPackage ../development/python-modules/arviz { };

  arxiv2bib = callPackage ../development/python-modules/arxiv2bib { };

  asana = callPackage ../development/python-modules/asana { };

  asciimatics = callPackage ../development/python-modules/asciimatics { };

  asciitree = callPackage ../development/python-modules/asciitree { };

  asdf = callPackage ../development/python-modules/asdf { };

  ase = if isPy27 then
    callPackage ../development/python-modules/ase/3.17.nix { }
  else
    callPackage ../development/python-modules/ase { };

  asgi-csrf = callPackage ../development/python-modules/asgi-csrf { };

  asgiref = callPackage ../development/python-modules/asgiref { };

  asn1ate = callPackage ../development/python-modules/asn1ate { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  aspy-yaml = callPackage ../development/python-modules/aspy.yaml { };

  astor = callPackage ../development/python-modules/astor { };

  astral = callPackage ../development/python-modules/astral { };

  astroid = if isPy3k then
    callPackage ../development/python-modules/astroid { }
  else
    callPackage ../development/python-modules/astroid/1.6.nix { };

  astropy = callPackage ../development/python-modules/astropy { };

  astropy-healpix = callPackage ../development/python-modules/astropy-healpix { };

  astropy-helpers = callPackage ../development/python-modules/astropy-helpers { };

  astroquery = callPackage ../development/python-modules/astroquery { };

  asttokens = callPackage ../development/python-modules/asttokens { };

  astunparse = callPackage ../development/python-modules/astunparse { };

  async_generator = callPackage ../development/python-modules/async_generator { };

  asyncio-throttle = callPackage ../development/python-modules/asyncio-throttle { };

  asyncpg = callPackage ../development/python-modules/asyncpg { };

  asyncssh = callPackage ../development/python-modules/asyncssh { };

  async_stagger = callPackage ../development/python-modules/async_stagger { };

  asynctest = callPackage ../development/python-modules/asynctest { };

  async-timeout = callPackage ../development/python-modules/async_timeout { };

  async-upnp-client = callPackage ../development/python-modules/async-upnp-client { };

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

  audiotools = callPackage ../development/python-modules/audiotools { };

  augeas = callPackage ../development/python-modules/augeas { inherit (pkgs) augeas; };

  auth0-python = callPackage ../development/python-modules/auth0-python { };

  authheaders = callPackage ../development/python-modules/authheaders { };

  authlib = callPackage ../development/python-modules/authlib { };

  authres = callPackage ../development/python-modules/authres { };

  autobahn = callPackage ../development/python-modules/autobahn { };

  autograd = callPackage ../development/python-modules/autograd { };

  autologging = callPackage ../development/python-modules/autologging { };

  automat = callPackage ../development/python-modules/automat { };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  avahi = toPythonModule (pkgs.avahi.override {
    inherit python;
    withPython = true;
  });

  av = callPackage ../development/python-modules/av { inherit (pkgs) pkgconfig; };

  avro3k = callPackage ../development/python-modules/avro3k { };

  avro = callPackage ../development/python-modules/avro { };

  avro-python3 = callPackage ../development/python-modules/avro-python3 { };

  awesome-slugify = callPackage ../development/python-modules/awesome-slugify { };

  awkward0 = callPackage ../development/python-modules/awkward0 { };
  awkward = callPackage ../development/python-modules/awkward { };

  aws-adfs = callPackage ../development/python-modules/aws-adfs { };

  aws-lambda-builders = callPackage ../development/python-modules/aws-lambda-builders { };

  aws-sam-translator = callPackage ../development/python-modules/aws-sam-translator { };

  aws-xray-sdk = callPackage ../development/python-modules/aws-xray-sdk { };

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

  azure-mgmt-hanaonazure = callPackage ../development/python-modules/azure-mgmt-hanaonazure { };

  azure-mgmt-hdinsight = callPackage ../development/python-modules/azure-mgmt-hdinsight { };

  azure-mgmt-imagebuilder = callPackage ../development/python-modules/azure-mgmt-imagebuilder { };

  azure-mgmt-iotcentral = callPackage ../development/python-modules/azure-mgmt-iotcentral { };

  azure-mgmt-iothub = callPackage ../development/python-modules/azure-mgmt-iothub { };

  azure-mgmt-iothubprovisioningservices =
    callPackage ../development/python-modules/azure-mgmt-iothubprovisioningservices { };

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

  azure-synapse-spark = callPackage ../development/python-modules/azure-synapse-spark { };

  b2sdk = callPackage ../development/python-modules/b2sdk { };

  Babel = callPackage ../development/python-modules/Babel { };

  babelfish = callPackage ../development/python-modules/babelfish { };

  babelgladeextractor = callPackage ../development/python-modules/babelgladeextractor { };

  backcall = callPackage ../development/python-modules/backcall { };

  backoff = callPackage ../development/python-modules/backoff { };

  backports_abc = callPackage ../development/python-modules/backports_abc { };

  backports_csv = callPackage ../development/python-modules/backports_csv { };

  backports_functools_lru_cache = callPackage ../development/python-modules/backports_functools_lru_cache { };

  backports_lzma = callPackage ../development/python-modules/backports_lzma { };

  backports_os = callPackage ../development/python-modules/backports_os { };

  backports_shutil_get_terminal_size = callPackage ../development/python-modules/backports_shutil_get_terminal_size { };

  backports-shutil-which = callPackage ../development/python-modules/backports-shutil-which { };

  backports_ssl_match_hostname =
    if !(pythonOlder "3.5") then null else callPackage ../development/python-modules/backports_ssl_match_hostname { };

  backports_tempfile = callPackage ../development/python-modules/backports_tempfile { };

  backports_unittest-mock = callPackage ../development/python-modules/backports_unittest-mock { };

  backports_weakref = callPackage ../development/python-modules/backports_weakref { };

  bacpypes = callPackage ../development/python-modules/bacpypes { };

  bandit = callPackage ../development/python-modules/bandit { };

  bap = callPackage ../development/python-modules/bap { bap = pkgs.ocaml-ng.ocamlPackages_4_07.bap; };

  baron = callPackage ../development/python-modules/baron { };

  base58 = callPackage ../development/python-modules/base58 { };

  baselines = callPackage ../development/python-modules/baselines { };

  basemap = callPackage ../development/python-modules/basemap { };

  bash_kernel = callPackage ../development/python-modules/bash_kernel { inherit (pkgs) bash; };

  bashlex = callPackage ../development/python-modules/bashlex { };

  basiciw = callPackage ../development/python-modules/basiciw { inherit (pkgs) gcc wirelesstools; };

  batchgenerators = callPackage ../development/python-modules/batchgenerators { };

  batchspawner = callPackage ../development/python-modules/batchspawner { };

  batinfo = callPackage ../development/python-modules/batinfo { };

  bayesian-optimization = callPackage ../development/python-modules/bayesian-optimization { };

  bayespy = callPackage ../development/python-modules/bayespy { };

  bcdoc = callPackage ../development/python-modules/bcdoc { };

  bcrypt = if pythonOlder "3.6" then
    callPackage ../development/python-modules/bcrypt/3_1.nix { }
  else
    callPackage ../development/python-modules/bcrypt { };

  beaker = callPackage ../development/python-modules/beaker { };

  beancount = callPackage ../development/python-modules/beancount { };

  beancount_docverif = callPackage ../development/python-modules/beancount_docverif { };

  beanstalkc = callPackage ../development/python-modules/beanstalkc { };

  beautifulsoup4 = callPackage ../development/python-modules/beautifulsoup4 { };

  bedup = callPackage ../development/python-modules/bedup { };

  behave = callPackage ../development/python-modules/behave { };

  bellows = callPackage ../development/python-modules/bellows { };

  bespon = callPackage ../development/python-modules/bespon { };

  betacode = callPackage ../development/python-modules/betacode { };

  betamax = callPackage ../development/python-modules/betamax { };

  betamax-matchers = callPackage ../development/python-modules/betamax-matchers { };

  betamax-serializers = callPackage ../development/python-modules/betamax-serializers { };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  bidict = callPackage ../development/python-modules/bidict { };

  bids-validator = callPackage ../development/python-modules/bids-validator { };

  billiard = callPackage ../development/python-modules/billiard { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  binwalk = callPackage ../development/python-modules/binwalk {
    pyqtgraph = null;
    matplotlib = null;
  };

  binwalk-full = appendToName "full" (self.binwalk.override {
    pyqtgraph = self.pyqtgraph;
    matplotlib = self.matplotlib;
  });

  biopython = callPackage ../development/python-modules/biopython { };

  biplist = callPackage ../development/python-modules/biplist { };

  bip_utils = callPackage ../development/python-modules/bip_utils { };

  bitarray = callPackage ../development/python-modules/bitarray { };

  bitbucket_api = callPackage ../development/python-modules/bitbucket-api { };

  bitbucket-cli = callPackage ../development/python-modules/bitbucket-cli { };

  bitcoinlib = callPackage ../development/python-modules/bitcoinlib { };

  bitcoin-price-api = callPackage ../development/python-modules/bitcoin-price-api { };

  bitmath = callPackage ../development/python-modules/bitmath { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  bitstruct = callPackage ../development/python-modules/bitstruct { };

  bjoern = callPackage ../development/python-modules/bjoern { };

  bkcharts = callPackage ../development/python-modules/bkcharts { };

  black = callPackage ../development/python-modules/black { };

  black-macchiato = callPackage ../development/python-modules/black-macchiato { };

  bleach = callPackage ../development/python-modules/bleach { };

  bleak = callPackage ../development/python-modules/bleak { };

  blessed = callPackage ../development/python-modules/blessed { };

  blessings = callPackage ../development/python-modules/blessings { };

  blinker = callPackage ../development/python-modules/blinker { };

  BlinkStick = callPackage ../development/python-modules/blinkstick { };

  blis = callPackage ../development/python-modules/blis { };

  blist = callPackage ../development/python-modules/blist { };

  blivet = callPackage ../development/python-modules/blivet { };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

  blockdiagcontrib-cisco = throw "blockdiagcontrib-cisco is not compatible with blockdiag 2.0.0 and has been removed."; # Added 2020-11-29

  block-io = callPackage ../development/python-modules/block-io { };

  bluepy = callPackage ../development/python-modules/bluepy { };

  bme680 = callPackage ../development/python-modules/bme680 { };

  bokeh = callPackage ../development/python-modules/bokeh { };

  boltons = callPackage ../development/python-modules/boltons { };

  boltztrap2 = callPackage ../development/python-modules/boltztrap2 { };

  booleanoperations = callPackage ../development/python-modules/booleanoperations { };

  boolean-py = callPackage ../development/python-modules/boolean-py { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (pkgs.boost.override {
    inherit (self) python numpy;
    enablePython = true;
  });

  boto3 = callPackage ../development/python-modules/boto3 { };

  boto = callPackage ../development/python-modules/boto { };

  botocore = callPackage ../development/python-modules/botocore { };

  bottle = callPackage ../development/python-modules/bottle { };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  box2d = callPackage ../development/python-modules/box2d { };

  bpython = callPackage ../development/python-modules/bpython { };

  braintree = callPackage ../development/python-modules/braintree { };

  branca = callPackage ../development/python-modules/branca { };

  bravado-core = callPackage ../development/python-modules/bravado-core { };

  bravia-tv = callPackage ../development/python-modules/bravia-tv { };

  breathe = callPackage ../development/python-modules/breathe { };

  breezy = callPackage ../development/python-modules/breezy { };

  broadlink = callPackage ../development/python-modules/broadlink { };

  brother = callPackage ../development/python-modules/brother { };

  brotli = callPackage ../development/python-modules/brotli { };

  brotlipy = callPackage ../development/python-modules/brotlipy { };

  browser-cookie3 = callPackage ../development/python-modules/browser-cookie3 { };

  browsermob-proxy = disabledIf isPy3k (callPackage ../development/python-modules/browsermob-proxy { });

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  bsdiff4 = callPackage ../development/python-modules/bsdiff4 { };

  btchip = callPackage ../development/python-modules/btchip { };

  bt_proximity = callPackage ../development/python-modules/bt-proximity { };

  BTrees = callPackage ../development/python-modules/btrees { };

  btrfs = callPackage ../development/python-modules/btrfs { };

  bugseverywhere = throw "bugseverywhere has been removed: Abandoned by upstream."; # Added 2019-11-27

  bugsnag = callPackage ../development/python-modules/bugsnag { };

  bugwarrior = callPackage ../development/python-modules/bugwarrior { };

  bugz = callPackage ../development/python-modules/bugz { };

  bugzilla = callPackage ../development/python-modules/bugzilla { };

  buildbot = callPackage ../development/python-modules/buildbot { };

  buildbot-ui = self.buildbot.withPlugins (with self.buildbot-plugins; [ www ]);

  buildbot-full = self.buildbot.withPlugins
    (with self.buildbot-plugins; [ www console-view waterfall-view grid-view wsgi-dashboards ]);

  buildbot-pkg = callPackage ../development/python-modules/buildbot/pkg.nix { };

  buildbot-plugins = pkgs.recurseIntoAttrs (callPackage ../development/python-modules/buildbot/plugins.nix { });

  buildbot-worker = callPackage ../development/python-modules/buildbot/worker.nix { };

  build = callPackage ../development/python-modules/build { };

  bumps = callPackage ../development/python-modules/bumps { };

  bunch = callPackage ../development/python-modules/bunch { };

  bx-python = callPackage ../development/python-modules/bx-python { inherit (pkgs) zlib; };

  bwapy = callPackage ../development/python-modules/bwapy { };

  bytecode = callPackage ../development/python-modules/bytecode { };

  bz2file = callPackage ../development/python-modules/bz2file { };

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cached-property = callPackage ../development/python-modules/cached-property { };

  cachelib = callPackage ../development/python-modules/cachelib { };

  cachetools = let
    cachetools' = callPackage ../development/python-modules/cachetools { };
    cachetools_2 = cachetools'.overridePythonAttrs (oldAttrs: rec {
      version = "3.1.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "16m69l6n6y1r1y7cklm92rr7v69ldig2n3lbl3j323w5jz7d78lf";
      };
    });
  in if isPy3k then cachetools' else cachetools_2;

  cachy = callPackage ../development/python-modules/cachy { };

  cadquery = callPackage ../development/python-modules/cadquery { };

  caffe = toPythonModule (pkgs.caffe.override {
    pythonSupport = true;
    inherit (self) python numpy boost;
  });

  cairocffi = if isPy3k then
    callPackage ../development/python-modules/cairocffi { }
  else
    callPackage ../development/python-modules/cairocffi/0_9.nix { };

  cairosvg = if isPy3k then
    callPackage ../development/python-modules/cairosvg { }
  else
    callPackage ../development/python-modules/cairosvg/1_x.nix { };

  caldav = callPackage ../development/python-modules/caldav { };

  can = callPackage ../development/python-modules/can { };

  canmatrix = callPackage ../development/python-modules/canmatrix { };

  canonicaljson = callPackage ../development/python-modules/canonicaljson { };

  canopen = callPackage ../development/python-modules/canopen { };

  capstone = callPackage ../development/python-modules/capstone { inherit (pkgs) capstone; };

  capturer = callPackage ../development/python-modules/capturer { };

  carbon = callPackage ../development/python-modules/carbon { };

  carrot = callPackage ../development/python-modules/carrot { };

  cartopy = callPackage ../development/python-modules/cartopy { };

  casbin = callPackage ../development/python-modules/casbin { };

  case = callPackage ../development/python-modules/case { };

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  casttube = callPackage ../development/python-modules/casttube { };

  catalogue = callPackage ../development/python-modules/catalogue { };

  cbeams = callPackage ../misc/cbeams { };

  cbor2 = callPackage ../development/python-modules/cbor2 { };

  cbor = callPackage ../development/python-modules/cbor { };

  cccolutils = callPackage ../development/python-modules/cccolutils { };

  cchardet = callPackage ../development/python-modules/cchardet { };

  CDDB = callPackage ../development/python-modules/cddb { };

  cdecimal = callPackage ../development/python-modules/cdecimal { };

  celery = callPackage ../development/python-modules/celery { };

  cement = callPackage ../development/python-modules/cement { };

  cerberus = callPackage ../development/python-modules/cerberus { };

  certbot = callPackage ../development/python-modules/certbot { };

  certbot-dns-cloudflare = callPackage ../development/python-modules/certbot-dns-cloudflare { };

  certbot-dns-rfc2136 = callPackage ../development/python-modules/certbot-dns-rfc2136 { };

  certbot-dns-route53 = callPackage ../development/python-modules/certbot-dns-route53 { };

  certifi = callPackage ../development/python-modules/certifi { };

  certipy = callPackage ../development/python-modules/certipy { };

  cffi = callPackage ../development/python-modules/cffi { };

  cfgv = callPackage ../development/python-modules/cfgv { };

  cfn-flip = callPackage ../development/python-modules/cfn-flip { };

  cfn-lint = callPackage ../development/python-modules/cfn-lint { };

  cftime = callPackage ../development/python-modules/cftime { };

  cgen = callPackage ../development/python-modules/cgen { };

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils { };

  chai = callPackage ../development/python-modules/chai { };

  chainer = callPackage ../development/python-modules/chainer { cudaSupport = pkgs.config.cudaSupport or false; };

  chainmap = callPackage ../development/python-modules/chainmap { };

  chalice = callPackage ../development/python-modules/chalice { };

  chameleon = callPackage ../development/python-modules/chameleon { };

  channels = callPackage ../development/python-modules/channels { };

  channels-redis = callPackage ../development/python-modules/channels-redis { };

  characteristic = callPackage ../development/python-modules/characteristic { };

  chardet = callPackage ../development/python-modules/chardet { };

  chart-studio = callPackage ../development/python-modules/chart-studio { };

  check-manifest = callPackage ../development/python-modules/check-manifest { };

  cheetah3 = callPackage ../development/python-modules/cheetah3 { };

  cheetah = callPackage ../development/python-modules/cheetah { };

  cheroot = callPackage ../development/python-modules/cheroot { };

  cherrypy = if isPy3k then
    callPackage ../development/python-modules/cherrypy { }
  else
    callPackage ../development/python-modules/cherrypy/17.nix { };

  chevron = callPackage ../development/python-modules/chevron { };

  ci-info = callPackage ../development/python-modules/ci-info { };

  ci-py = callPackage ../development/python-modules/ci-py { };

  cirq = callPackage ../development/python-modules/cirq { };

  ciscomobilityexpress = callPackage ../development/python-modules/ciscomobilityexpress { };

  ciso8601 = callPackage ../development/python-modules/ciso8601 { };

  citeproc-py = callPackage ../development/python-modules/citeproc-py { };

  cjson = callPackage ../development/python-modules/cjson { };

  ckcc-protocol = callPackage ../development/python-modules/ckcc-protocol { };

  class-registry = callPackage ../development/python-modules/class-registry { };

  cld2-cffi = callPackage ../development/python-modules/cld2-cffi { };

  cleo = callPackage ../development/python-modules/cleo { };

  clf = callPackage ../development/python-modules/clf { };

  cliapp = callPackage ../development/python-modules/cliapp { };

  click = callPackage ../development/python-modules/click { };

  clickclick = callPackage ../development/python-modules/clickclick { };

  click-completion = callPackage ../development/python-modules/click-completion { };

  click-datetime = callPackage ../development/python-modules/click-datetime { };

  click-default-group = callPackage ../development/python-modules/click-default-group { };

  click-didyoumean = callPackage ../development/python-modules/click-didyoumean { };

  click-help-colors = callPackage ../development/python-modules/click-help-colors { };

  click-log = callPackage ../development/python-modules/click-log { };

  click-plugins = callPackage ../development/python-modules/click-plugins { };

  click-repl = callPackage ../development/python-modules/click-repl { };

  click-threading = callPackage ../development/python-modules/click-threading { };

  clickhouse-cityhash = callPackage ../development/python-modules/clickhouse-cityhash {};

  clickhouse-driver = callPackage ../development/python-modules/clickhouse-driver {};

  cliff = callPackage ../development/python-modules/cliff { };

  clifford = callPackage ../development/python-modules/clifford { };

  cligj = callPackage ../development/python-modules/cligj { };

  cli-helpers = callPackage ../development/python-modules/cli-helpers { };

  clikit = callPackage ../development/python-modules/clikit { };

  clint = callPackage ../development/python-modules/clint { };

  clintermission = callPackage ../development/python-modules/clintermission { };

  clize = callPackage ../development/python-modules/clize { };

  clldutils = callPackage ../development/python-modules/clldutils { };

  closure-linter = callPackage ../development/python-modules/closure-linter { };

  cloudflare = callPackage ../development/python-modules/cloudflare { };

  cloudpickle = callPackage ../development/python-modules/cloudpickle { };

  clustershell = callPackage ../development/python-modules/clustershell { };

  cma = callPackage ../development/python-modules/cma { };

  cmarkgfm = callPackage ../development/python-modules/cmarkgfm { };

  cmd2 = callPackage ../development/python-modules/cmd2 { };

  cmdline = callPackage ../development/python-modules/cmdline { };

  cmdtest = callPackage ../development/python-modules/cmdtest { };

  cntk = callPackage ../development/python-modules/cntk { };

  cnvkit = callPackage ../development/python-modules/cnvkit { };

  coapthon3 = callPackage ../development/python-modules/coapthon3 { };

  coconut = callPackage ../development/python-modules/coconut { };

  cocotb = callPackage ../development/python-modules/cocotb { };

  codecov = callPackage ../development/python-modules/codecov { };

  codespell = callPackage ../development/python-modules/codespell { };

  cogapp = callPackage ../development/python-modules/cogapp { };

  coilmq = callPackage ../development/python-modules/coilmq { };

  coinmarketcap = callPackage ../development/python-modules/coinmarketcap { };

  ColanderAlchemy = callPackage ../development/python-modules/colanderalchemy { };

  colander = callPackage ../development/python-modules/colander { };

  colorama = callPackage ../development/python-modules/colorama { };

  colorcet = callPackage ../development/python-modules/colorcet { };

  colorclass = callPackage ../development/python-modules/colorclass { };

  colored = callPackage ../development/python-modules/colored { };

  coloredlogs = callPackage ../development/python-modules/coloredlogs { };

  colorful = callPackage ../development/python-modules/colorful { };

  colorlog = callPackage ../development/python-modules/colorlog { };

  colorlover = callPackage ../development/python-modules/colorlover { };

  colormath = callPackage ../development/python-modules/colormath { };

  colorspacious = callPackage ../development/python-modules/colorspacious { };

  colour = callPackage ../development/python-modules/colour { };

  CommonMark = callPackage ../development/python-modules/commonmark { };

  compiledb = callPackage ../development/python-modules/compiledb { };

  conda = callPackage ../development/python-modules/conda { };

  ConfigArgParse = callPackage ../development/python-modules/configargparse { };

  configobj = callPackage ../development/python-modules/configobj { };

  configparser = if pythonOlder "3.6" then
    callPackage ../development/python-modules/configparser/4.nix { }
  else
    callPackage ../development/python-modules/configparser { };

  configshell = callPackage ../development/python-modules/configshell { };

  confluent-kafka = callPackage ../development/python-modules/confluent-kafka { };

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

  cot = callPackage ../development/python-modules/cot { };

  covCore = callPackage ../development/python-modules/cov-core { };

  coverage = callPackage ../development/python-modules/coverage { };

  coveralls = callPackage ../development/python-modules/coveralls { };

  cozy = callPackage ../development/python-modules/cozy { };

  cppheaderparser = callPackage ../development/python-modules/cppheaderparser { };

  cppy = callPackage ../development/python-modules/cppy { };

  cpyparsing = callPackage ../development/python-modules/cpyparsing { };

  cram = callPackage ../development/python-modules/cram { };

  crashtest = callPackage ../development/python-modules/crashtest { };

  crate = callPackage ../development/python-modules/crate { };

  crayons = callPackage ../development/python-modules/crayons { };

  crc16 = callPackage ../development/python-modules/crc16 { };

  crc32c = callPackage ../development/python-modules/crc32c { };

  crccheck = callPackage ../development/python-modules/crccheck { };

  crcmod = callPackage ../development/python-modules/crcmod { };

  credstash = callPackage ../development/python-modules/credstash { };

  croniter = callPackage ../development/python-modules/croniter { };

  cryptacular = callPackage ../development/python-modules/cryptacular { };

  cryptography = if isPy27 then
    callPackage ../development/python-modules/cryptography/3.3.nix { }
  else
    callPackage ../development/python-modules/cryptography { };

  cryptography_vectors = if isPy27 then
    callPackage ../development/python-modules/cryptography/vectors-3.3.nix { }
  else
    callPackage ../development/python-modules/cryptography/vectors.nix { };

  crytic-compile = callPackage ../development/python-modules/crytic-compile { };

  csscompressor = callPackage ../development/python-modules/csscompressor { };

  cssmin = callPackage ../development/python-modules/cssmin { };

  css-parser = callPackage ../development/python-modules/css-parser { };

  cssselect2 = callPackage ../development/python-modules/cssselect2 { };

  cssselect = callPackage ../development/python-modules/cssselect { };

  cssutils = callPackage ../development/python-modules/cssutils { };

  csvs-to-sqlite = callPackage ../development/python-modules/csvs-to-sqlite { };

  csvw = callPackage ../development/python-modules/csvw { };

  cucumber-tag-expressions = callPackage ../development/python-modules/cucumber-tag-expressions { };

  cufflinks = callPackage ../development/python-modules/cufflinks { };

  cupy = callPackage ../development/python-modules/cupy {
    cudatoolkit = pkgs.cudatoolkit_10_0;
    cudnn = pkgs.cudnn_cudatoolkit_10_0;
    nccl = pkgs.nccl_cudatoolkit_10;
  };

  curio = callPackage ../development/python-modules/curio { };

  curtsies = callPackage ../development/python-modules/curtsies { };

  curve25519-donna = callPackage ../development/python-modules/curve25519-donna { };

  cvxopt = callPackage ../development/python-modules/cvxopt { };

  cvxpy = callPackage ../development/python-modules/cvxpy { };

  cx_Freeze = callPackage ../development/python-modules/cx_freeze { };

  cx_oracle = callPackage ../development/python-modules/cx_oracle { };

  cycler = callPackage ../development/python-modules/cycler { };

  cymem = callPackage ../development/python-modules/cymem { };

  cypari2 = callPackage ../development/python-modules/cypari2 { };

  cysignals = callPackage ../development/python-modules/cysignals { };

  cython = callPackage ../development/python-modules/Cython { };

  cytoolz = callPackage ../development/python-modules/cytoolz { };

  d2to1 = callPackage ../development/python-modules/d2to1 { };

  daemonize = callPackage ../development/python-modules/daemonize { };

  daemonocle = callPackage ../development/python-modules/daemonocle { };

  daphne = callPackage ../development/python-modules/daphne { };

  darcsver = callPackage ../development/python-modules/darcsver { };

  dash = callPackage ../development/python-modules/dash { };

  dash-core-components = callPackage ../development/python-modules/dash-core-components { };

  dash-html-components = callPackage ../development/python-modules/dash-html-components { };

  dash-renderer = callPackage ../development/python-modules/dash-renderer { };

  dash-table = callPackage ../development/python-modules/dash-table { };

  dask = callPackage ../development/python-modules/dask { };

  dask-gateway = callPackage ../development/python-modules/dask-gateway { };

  dask-gateway-server = callPackage ../development/python-modules/dask-gateway-server { inherit (pkgs) go; };

  dask-glm = callPackage ../development/python-modules/dask-glm { };

  dask-image = callPackage ../development/python-modules/dask-image { };

  dask-jobqueue = callPackage ../development/python-modules/dask-jobqueue { };

  dask-ml = callPackage ../development/python-modules/dask-ml { };

  dask-mpi = callPackage ../development/python-modules/dask-mpi { };

  dask-xgboost = callPackage ../development/python-modules/dask-xgboost { };

  databases = callPackage ../development/python-modules/databases { };

  databricks-cli = callPackage ../development/python-modules/databricks-cli { };

  databricks-connect = callPackage ../development/python-modules/databricks-connect { inherit (pkgs) jdk; };

  dataclasses = callPackage ../development/python-modules/dataclasses { };

  dataclasses-json = callPackage ../development/python-modules/dataclasses-json { };

  datadiff = callPackage ../development/python-modules/datadiff { };

  datadog = callPackage ../development/python-modules/datadog { };

  datamodeldict = callPackage ../development/python-modules/datamodeldict { };

  datasets = callPackage ../development/python-modules/datasets { };

  datasette = callPackage ../development/python-modules/datasette { };

  datashader = callPackage ../development/python-modules/datashader { };

  datashape = callPackage ../development/python-modules/datashape { };

  datatable = callPackage ../development/python-modules/datatable {
    inherit (pkgs.llvmPackages) libcxx;
  };

  dateparser = callPackage ../development/python-modules/dateparser { };

  datrie = callPackage ../development/python-modules/datrie { };

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  dbus-next = callPackage ../development/python-modules/dbus-next { };

  dbus-python = callPackage ../development/python-modules/dbus { inherit (pkgs) dbus pkgconfig; };

  dcmstack = callPackage ../development/python-modules/dcmstack { };

  ddt = callPackage ../development/python-modules/ddt { };

  deap = callPackage ../development/python-modules/deap { };

  debian = callPackage ../development/python-modules/debian { };

  debts = callPackage ../development/python-modules/debts { };

  debugpy = callPackage ../development/python-modules/debugpy { };

  decorator = callPackage ../development/python-modules/decorator { };

  deepdiff = callPackage ../development/python-modules/deepdiff { };

  deepmerge = callPackage ../development/python-modules/deepmerge { };

  deeptoolsintervals = callPackage ../development/python-modules/deeptoolsintervals { };

  defcon = callPackage ../development/python-modules/defcon { };

  deform = callPackage ../development/python-modules/deform { };

  defusedxml = callPackage ../development/python-modules/defusedxml { };

  delegator-py = callPackage ../development/python-modules/delegator-py { };

  deluge-client = callPackage ../development/python-modules/deluge-client { };

  demjson = callPackage ../development/python-modules/demjson { };

  dendropy = callPackage ../development/python-modules/dendropy { };

  denonavr = callPackage ../development/python-modules/denonavr { };

  dependency-injector = callPackage ../development/python-modules/dependency-injector { };

  deprecated = callPackage ../development/python-modules/deprecated { };

  deprecation = callPackage ../development/python-modules/deprecation { };

  derpconf = callPackage ../development/python-modules/derpconf { };

  descartes = callPackage ../development/python-modules/descartes { };

  deskcon = callPackage ../development/python-modules/deskcon { };

  detox = throw "detox is no longer maintained, and was broken since may 2019"; # added 2020-07-04

  devpi-common = callPackage ../development/python-modules/devpi-common { };

  dftfit = callPackage ../development/python-modules/dftfit { };

  diceware = callPackage ../development/python-modules/diceware { };

  dicom2nifti = callPackage ../development/python-modules/dicom2nifti { };

  dict2xml = callPackage ../development/python-modules/dict2xml { };

  dictionaries = callPackage ../development/python-modules/dictionaries { };

  dicttoxml = callPackage ../development/python-modules/dicttoxml { };

  diff_cover = callPackage ../development/python-modules/diff_cover { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  digital-ocean = callPackage ../development/python-modules/digitalocean { };

  digi-xbee = callPackage ../development/python-modules/digi-xbee { };

  dill = callPackage ../development/python-modules/dill { };

  diofant = callPackage ../development/python-modules/diofant { };

  dipy = callPackage ../development/python-modules/dipy { };

  discid = callPackage ../development/python-modules/discid { };

  discogs_client = callPackage ../development/python-modules/discogs_client { };

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

  # Current latest
  django_3 = callPackage ../development/python-modules/django/3.nix { };

  django-allauth = callPackage ../development/python-modules/django-allauth { };

  django-anymail = callPackage ../development/python-modules/django-anymail { };

  django_appconf = callPackage ../development/python-modules/django_appconf { };

  django-auth-ldap = callPackage ../development/python-modules/django-auth-ldap { };

  django-cache-url = callPackage ../development/python-modules/django-cache-url { };

  django_classytags = callPackage ../development/python-modules/django_classytags { };

  django-cleanup = callPackage ../development/python-modules/django-cleanup { };

  django_colorful = callPackage ../development/python-modules/django_colorful { };

  django_compat = callPackage ../development/python-modules/django-compat { };

  django_compressor = callPackage ../development/python-modules/django_compressor { };

  django-configurations = callPackage ../development/python-modules/django-configurations { };

  django_contrib_comments = callPackage ../development/python-modules/django_contrib_comments { };

  django-cors-headers = callPackage ../development/python-modules/django-cors-headers { };

  django-csp = callPackage ../development/python-modules/django-csp { };

  django-discover-runner = callPackage ../development/python-modules/django-discover-runner { };

  django-dynamic-preferences = callPackage ../development/python-modules/django-dynamic-preferences { };

  django_environ = callPackage ../development/python-modules/django_environ { };

  django_evolution = callPackage ../development/python-modules/django_evolution { };

  django_extensions = callPackage ../development/python-modules/django-extensions { };

  django-filter = callPackage ../development/python-modules/django-filter { };

  django-gravatar2 = callPackage ../development/python-modules/django-gravatar2 { };

  django_guardian = callPackage ../development/python-modules/django_guardian { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  django_hijack_admin = callPackage ../development/python-modules/django-hijack-admin { };

  django_hijack = callPackage ../development/python-modules/django-hijack
    { }; # This package may need an older version of Django. Override the package set and set e.g. `django = super.django_1_9`. See the Nixpkgs manual for examples on how to override the package set.

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-logentry-admin = callPackage ../development/python-modules/django-logentry-admin { };

  django-mailman3 = callPackage ../development/python-modules/django-mailman3 { };

  django_modelcluster = callPackage ../development/python-modules/django_modelcluster { };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  django-maintenance-mode = callPackage ../development/python-modules/django-maintenance-mode { };

  django_nose = callPackage ../development/python-modules/django_nose { };

  django-oauth-toolkit = callPackage ../development/python-modules/django-oauth-toolkit { };

  django-paintstore = callPackage ../development/python-modules/django-paintstore { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django_pipeline = callPackage ../development/python-modules/django-pipeline { };

  django_polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-postgresql-netfields = callPackage ../development/python-modules/django-postgresql-netfields { };

  django-q = callPackage ../development/python-modules/django-q { };

  djangoql = callPackage ../development/python-modules/djangoql { };

  django-ranged-response = callPackage ../development/python-modules/django-ranged-response { };

  django-raster = callPackage ../development/python-modules/django-raster { };

  django_redis = callPackage ../development/python-modules/django_redis { };

  django-rest-auth = callPackage ../development/python-modules/django-rest-auth { };

  djangorestframework = callPackage ../development/python-modules/djangorestframework { };

  djangorestframework-jwt = callPackage ../development/python-modules/djangorestframework-jwt { };

  djangorestframework-simplejwt = callPackage ../development/python-modules/djangorestframework-simplejwt { };

  django_reversion = callPackage ../development/python-modules/django_reversion { };

  django-sampledatahelper = callPackage ../development/python-modules/django-sampledatahelper { };

  django-sesame = callPackage ../development/python-modules/django-sesame { };

  django_silk = callPackage ../development/python-modules/django_silk { };

  django-simple-captcha = callPackage ../development/python-modules/django-simple-captcha { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django-storages = callPackage ../development/python-modules/django-storages { };

  django_tagging = callPackage ../development/python-modules/django_tagging { };

  django_taggit = callPackage ../development/python-modules/django_taggit { };

  django_treebeard = callPackage ../development/python-modules/django_treebeard { };

  django-versatileimagefield = callPackage ../development/python-modules/django-versatileimagefield { };

  django-webpack-loader = callPackage ../development/python-modules/django-webpack-loader { };

  django-widget-tweaks = callPackage ../development/python-modules/django-widget-tweaks { };

  dj-database-url = callPackage ../development/python-modules/dj-database-url { };

  dj-email-url = callPackage ../development/python-modules/dj-email-url { };

  djmail = callPackage ../development/python-modules/djmail { };

  dj-search-url = callPackage ../development/python-modules/dj-search-url { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  dlib = callPackage ../development/python-modules/dlib { inherit (pkgs) dlib; };

  dlx = callPackage ../development/python-modules/dlx { };

  dmenu-python = callPackage ../development/python-modules/dmenu { };

  dm-sonnet = callPackage ../development/python-modules/dm-sonnet { };

  dnslib = callPackage ../development/python-modules/dnslib { };

  dnspython = if isPy3k then
    callPackage ../development/python-modules/dnspython { }
  else
    self.dnspython_1;

  dnspython_1 = callPackage ../development/python-modules/dnspython/1.nix { };

  dns = self.dnspython; # Alias for compatibility, 2017-12-10

  doc8 = callPackage ../development/python-modules/doc8 { };

  docker = callPackage ../development/python-modules/docker { };

  dockerfile-parse = callPackage ../development/python-modules/dockerfile-parse { };

  dockerpty = callPackage ../development/python-modules/dockerpty { };

  docker_pycreds = callPackage ../development/python-modules/docker-pycreds { };

  docker-py = disabledIf isPy27 (callPackage ../development/python-modules/docker-py { });

  dockerspawner = callPackage ../development/python-modules/dockerspawner { };

  docloud = callPackage ../development/python-modules/docloud { };

  docopt = callPackage ../development/python-modules/docopt { };

  docplex = callPackage ../development/python-modules/docplex { };

  docrep = callPackage ../development/python-modules/docrep { };

  doctest-ignore-unicode = callPackage ../development/python-modules/doctest-ignore-unicode { };

  docutils = callPackage ../development/python-modules/docutils { };

  dodgy = callPackage ../development/python-modules/dodgy { };

  dogpile_cache = callPackage ../development/python-modules/dogpile.cache { };

  dogpile_core = callPackage ../development/python-modules/dogpile.core { };

  dogtail = callPackage ../development/python-modules/dogtail { };

  dominate = callPackage ../development/python-modules/dominate { };

  dopy = callPackage ../development/python-modules/dopy { };

  dot2tex = callPackage ../development/python-modules/dot2tex { inherit (pkgs) graphviz; };

  dparse = callPackage ../development/python-modules/dparse { };

  dpath = callPackage ../development/python-modules/dpath { };

  dpkt = callPackage ../development/python-modules/dpkt { };

  drf-yasg = callPackage ../development/python-modules/drf-yasg { };

  drms = callPackage ../development/python-modules/drms { };

  dropbox = callPackage ../development/python-modules/dropbox { };

  ds4drv = callPackage ../development/python-modules/ds4drv { inherit (pkgs) fetchFromGitHub bluez; };

  dtopt = callPackage ../development/python-modules/dtopt { };

  duckdb = callPackage ../development/python-modules/duckdb { duckdb = pkgs.duckdb; };

  duecredit = callPackage ../development/python-modules/duecredit { };

  dufte = callPackage ../development/python-modules/dufte { };

  dugong = callPackage ../development/python-modules/dugong { };

  dulwich = if isPy3k then
    callPackage ../development/python-modules/dulwich { }
  else
    callPackage ../development/python-modules/dulwich/0_19.nix { };

  dyn = callPackage ../development/python-modules/dyn { };

  dynd = callPackage ../development/python-modules/dynd { };

  easydict = callPackage ../development/python-modules/easydict { };

  easygui = callPackage ../development/python-modules/easygui { };

  EasyProcess = callPackage ../development/python-modules/easyprocess { };

  easysnmp = callPackage ../development/python-modules/easysnmp {
    openssl = pkgs.openssl;
    net-snmp = pkgs.net-snmp;
  };

  easy-thumbnails = callPackage ../development/python-modules/easy-thumbnails { };

  easywatch = callPackage ../development/python-modules/easywatch { };

  eccodes = toPythonModule (pkgs.eccodes.override {
    enablePython = true;
    pythonPackages = self;
  });

  ecdsa = callPackage ../development/python-modules/ecdsa { };

  ecos = callPackage ../development/python-modules/ecos { };

  ecpy = callPackage ../development/python-modules/ecpy { };

  ed25519 = callPackage ../development/python-modules/ed25519 { };

  editorconfig = callPackage ../development/python-modules/editorconfig { };

  edward = callPackage ../development/python-modules/edward { };

  effect = callPackage ../development/python-modules/effect { };

  eggdeps = callPackage ../development/python-modules/eggdeps { };

  elasticsearch = callPackage ../development/python-modules/elasticsearch { };

  elasticsearch-dsl = callPackage ../development/python-modules/elasticsearch-dsl { };

  elasticsearchdsl = self.elasticsearch-dsl; # alias

  elementpath = callPackage ../development/python-modules/elementpath { };

  eliot = callPackage ../development/python-modules/eliot { };

  emailthreads = callPackage ../development/python-modules/emailthreads { };

  email_validator = callPackage ../development/python-modules/email-validator { };

  emcee = callPackage ../development/python-modules/emcee { };

  emv = callPackage ../development/python-modules/emv { };

  emoji = callPackage ../development/python-modules/emoji { };

  enaml = callPackage ../development/python-modules/enaml { };

  enamlx = callPackage ../development/python-modules/enamlx { };

  entrance = callPackage ../development/python-modules/entrance { routerFeatures = false; };

  entrance-with-router-features = callPackage ../development/python-modules/entrance { routerFeatures = true; };

  entrypoint2 = callPackage ../development/python-modules/entrypoint2 { };

  entrypoints = callPackage ../development/python-modules/entrypoints { };

  enum34 = callPackage ../development/python-modules/enum34 { };

  enum = callPackage ../development/python-modules/enum { };

  enum-compat = callPackage ../development/python-modules/enum-compat { };

  envisage = callPackage ../development/python-modules/envisage { };

  envs = callPackage ../development/python-modules/envs { };

  enzyme = callPackage ../development/python-modules/enzyme { };

  epc = callPackage ../development/python-modules/epc { };

  ephem = callPackage ../development/python-modules/ephem { };

  eradicate = callPackage ../development/python-modules/eradicate { };

  escapism = callPackage ../development/python-modules/escapism { };

  etcd = callPackage ../development/python-modules/etcd { };

  etelemetry = callPackage ../development/python-modules/etelemetry { };

  etebase = callPackage ../development/python-modules/etebase {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  etesync = callPackage ../development/python-modules/etesync { };

  eth-hash = callPackage ../development/python-modules/eth-hash { };

  eth-typing = callPackage ../development/python-modules/eth-typing { };

  eth-utils = callPackage ../development/python-modules/eth-utils { };

  et_xmlfile = callPackage ../development/python-modules/et_xmlfile { };

  evdev = callPackage ../development/python-modules/evdev { };

  eve = callPackage ../development/python-modules/eve { };

  eventlet = callPackage ../development/python-modules/eventlet { };

  eventlib = callPackage ../development/python-modules/eventlib { };

  events = callPackage ../development/python-modules/events { };

  evernote = callPackage ../development/python-modules/evernote { };

  ewmh = callPackage ../development/python-modules/ewmh { };

  exchangelib = callPackage ../development/python-modules/exchangelib { };

  execnet = callPackage ../development/python-modules/execnet { };

  executing = callPackage ../development/python-modules/executing { };

  executor = callPackage ../development/python-modules/executor { };

  exifread = callPackage ../development/python-modules/exifread { };

  extension-helpers = callPackage ../development/python-modules/extension-helpers { };

  extras = callPackage ../development/python-modules/extras { };

  eyeD3 = callPackage ../development/python-modules/eyed3 { };

  ezdxf = callPackage ../development/python-modules/ezdxf { };

  Fabric = callPackage ../development/python-modules/Fabric { };

  fabulous = callPackage ../development/python-modules/fabulous { };

  facebook-sdk = callPackage ../development/python-modules/facebook-sdk { };

  face = callPackage ../development/python-modules/face { };

  facedancer = callPackage ../development/python-modules/facedancer { };

  face_recognition = callPackage ../development/python-modules/face_recognition { };

  face_recognition_models = callPackage ../development/python-modules/face_recognition_models { };

  factory_boy = callPackage ../development/python-modules/factory_boy { };

  fake_factory = callPackage ../development/python-modules/fake_factory { };

  faker = callPackage ../development/python-modules/faker { };

  fake-useragent = callPackage ../development/python-modules/fake-useragent { };

  falcon = callPackage ../development/python-modules/falcon { };

  fastapi = callPackage ../development/python-modules/fastapi { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  fastdtw = callPackage ../development/python-modules/fastdtw { };

  fastecdsa = callPackage ../development/python-modules/fastecdsa { };

  fasteners = callPackage ../development/python-modules/fasteners { };

  fastentrypoints = callPackage ../development/python-modules/fastentrypoints { };

  fastimport = callPackage ../development/python-modules/fastimport { };

  fastjsonschema = callPackage ../development/python-modules/fastjsonschema { };

  fastpair = callPackage ../development/python-modules/fastpair { };

  fastparquet = callPackage ../development/python-modules/fastparquet { };

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 { };

  fastprogress = callPackage ../development/python-modules/fastprogress { };

  fastrlock = callPackage ../development/python-modules/fastrlock { };

  fasttext = callPackage ../development/python-modules/fasttext { };

  faulthandler = if !isPy3k then
    callPackage ../development/python-modules/faulthandler { }
  else
    throw "faulthandler is built into ${python.executable}";

  favicon = callPackage ../development/python-modules/favicon { };

  fb-re2 = callPackage ../development/python-modules/fb-re2 { };

  fdint = callPackage ../development/python-modules/fdint { };

  feedgen = callPackage ../development/python-modules/feedgen { };

  feedgenerator = callPackage ../development/python-modules/feedgenerator { inherit (pkgs) glibcLocales; };

  feedparser = if isPy3k then
    callPackage ../development/python-modules/feedparser { }
  else
    callPackage ../development/python-modules/feedparser/5.nix { };

  fenics = callPackage ../development/libraries/science/math/fenics {
    inherit (pkgs) pkg-config;
    mpi = pkgs.openmpi;
    pytest = self.pytest_4;
  };

  ffmpeg-python = callPackage ../development/python-modules/ffmpeg-python { };

  fido2 = callPackage ../development/python-modules/fido2 { };

  filebrowser_safe = callPackage ../development/python-modules/filebrowser_safe { };

  filebytes = callPackage ../development/python-modules/filebytes { };

  filelock = callPackage ../development/python-modules/filelock { };

  filemagic = callPackage ../development/python-modules/filemagic { };

  filetype = callPackage ../development/python-modules/filetype { };

  filterpy = callPackage ../development/python-modules/filterpy { };

  finalfusion = callPackage ../development/python-modules/finalfusion { };

  fints = callPackage ../development/python-modules/fints { };

  fiona = callPackage ../development/python-modules/fiona { gdal_2 = pkgs.gdal_2; };

  fipy = callPackage ../development/python-modules/fipy { };

  fire = callPackage ../development/python-modules/fire { };

  firetv = callPackage ../development/python-modules/firetv { };

  first = callPackage ../development/python-modules/first { };

  fitbit = callPackage ../development/python-modules/fitbit { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flake8-import-order = callPackage ../development/python-modules/flake8-import-order { };

  flake8-polyfill = callPackage ../development/python-modules/flake8-polyfill { };

  flaky = callPackage ../development/python-modules/flaky { };

  flammkuchen = callPackage ../development/python-modules/flammkuchen { };

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

  flask-httpauth = callPackage ../development/python-modules/flask-httpauth { };

  flask-jwt-extended = callPackage ../development/python-modules/flask-jwt-extended { };

  flask_ldap_login = callPackage ../development/python-modules/flask-ldap-login { };

  flask-limiter = callPackage ../development/python-modules/flask-limiter { };

  flask_login = callPackage ../development/python-modules/flask-login { };

  flask_mail = callPackage ../development/python-modules/flask-mail { };

  flask_marshmallow = callPackage ../development/python-modules/flask-marshmallow { };

  flask_migrate = callPackage ../development/python-modules/flask-migrate { };

  flask-mongoengine = callPackage ../development/python-modules/flask-mongoengine { };

  flask-openid = callPackage ../development/python-modules/flask-openid { };

  flask-paginate = callPackage ../development/python-modules/flask-paginate { };

  flask_principal = callPackage ../development/python-modules/flask-principal { };

  flask-pymongo = callPackage ../development/python-modules/Flask-PyMongo { };

  flask-restful = callPackage ../development/python-modules/flask-restful { };

  flask-restplus = callPackage ../development/python-modules/flask-restplus { };

  flask-restx = callPackage ../development/python-modules/flask-restx { };

  flask-reverse-proxy-fix = callPackage ../development/python-modules/flask-reverse-proxy-fix { };

  flask_script = callPackage ../development/python-modules/flask-script { };

  flask-silk = callPackage ../development/python-modules/flask-silk { };

  flask-socketio = callPackage ../development/python-modules/flask-socketio { };

  flask-sockets = callPackage ../development/python-modules/flask-sockets { };

  flask_sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask-swagger = callPackage ../development/python-modules/flask-swagger { };

  flask-swagger-ui = callPackage ../development/python-modules/flask-swagger-ui { };

  flask_testing = callPackage ../development/python-modules/flask-testing { };

  flask-versioned = callPackage ../development/python-modules/flask-versioned { };

  flask_wtf = callPackage ../development/python-modules/flask-wtf { };

  flatbuffers = callPackage ../development/python-modules/flatbuffers {
    inherit (pkgs) flatbuffers;
  };

  flexmock = callPackage ../development/python-modules/flexmock { };

  flickrapi = callPackage ../development/python-modules/flickrapi { };

  flit = callPackage ../development/python-modules/flit { };

  flit-core = callPackage ../development/python-modules/flit-core { };

  flower = callPackage ../development/python-modules/flower { };

  flowlogs_reader = callPackage ../development/python-modules/flowlogs_reader { };

  fluent-logger = callPackage ../development/python-modules/fluent-logger { };

  flufl_bounce = callPackage ../development/python-modules/flufl/bounce.nix { };

  flufl_i18n = callPackage ../development/python-modules/flufl/i18n.nix { };

  flufl_lock = callPackage ../development/python-modules/flufl/lock.nix { };

  flup = callPackage ../development/python-modules/flup { };

  flux-led = callPackage ../development/python-modules/flux-led { };

  fn = callPackage ../development/python-modules/fn { };

  folium = callPackage ../development/python-modules/folium { };

  fontforge = disabledIf (!isPy3k) (toPythonModule (pkgs.fontforge.override {
    withPython = true;
    inherit python;
  }));

  fontmath = callPackage ../development/python-modules/fontmath { };

  fontparts = callPackage ../development/python-modules/fontparts { };

  fontpens = callPackage ../development/python-modules/fontpens { };

  fonttools = callPackage ../development/python-modules/fonttools { };

  foolscap = callPackage ../development/python-modules/foolscap { };

  forbiddenfruit = callPackage ../development/python-modules/forbiddenfruit { };

  FormEncode = callPackage ../development/python-modules/FormEncode { };

  foundationdb51 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb51; };
  foundationdb52 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb52; };
  foundationdb60 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb60; };
  foundationdb61 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb61; };

  foxdot = callPackage ../development/python-modules/foxdot { };

  fpdf = callPackage ../development/python-modules/fpdf { };

  fpylll = callPackage ../development/python-modules/fpylll { };

  freetype-py = callPackage ../development/python-modules/freetype-py { };

  freezegun = if isPy27 then
      callPackage ../development/python-modules/freezegun/0.3.nix { }
    else
      callPackage ../development/python-modules/freezegun { };

  fritzconnection = callPackage ../development/python-modules/fritzconnection { };

  frozendict = callPackage ../development/python-modules/frozendict { };

  fs = callPackage ../development/python-modules/fs { };

  fs-s3fs = callPackage ../development/python-modules/fs-s3fs { };

  fsspec = callPackage ../development/python-modules/fsspec { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  ftputil = callPackage ../development/python-modules/ftputil { };

  fudge = callPackage ../development/python-modules/fudge { };

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  functools32 = callPackage ../development/python-modules/functools32 { };

  funcy = callPackage ../development/python-modules/funcy { };

  furl = callPackage ../development/python-modules/furl { };

  fuse = callPackage ../development/python-modules/fuse-python { inherit (pkgs) fuse pkgconfig; };

  fusepy = callPackage ../development/python-modules/fusepy { };

  future = callPackage ../development/python-modules/future { };

  future-fstrings = callPackage ../development/python-modules/future-fstrings { };

  futures = callPackage ../development/python-modules/futures { };

  fuzzywuzzy = callPackage ../development/python-modules/fuzzywuzzy { };

  fx2 = callPackage ../development/python-modules/fx2 { };

  gaia = disabledIf (isPyPy || isPy3k) (toPythonModule (pkgs.gaia.override {
    pythonPackages = self;
    pythonSupport = true;
  })); # gaia isn't supported with python3 and it's not available from pypi

  galario = toPythonModule (pkgs.galario.override {
    enablePython = true;
    pythonPackages = self;
  });

  gast = callPackage ../development/python-modules/gast { };

  gateone = callPackage ../development/python-modules/gateone { };

  gcovr = callPackage ../development/python-modules/gcovr { };

  gdal = toPythonModule (pkgs.gdal.override { pythonPackages = self; });

  gdata = callPackage ../development/python-modules/gdata { };

  gdcm = disabledIf isPy27 (toPythonModule (pkgs.gdcm.override {
    inherit (self) python;
    enablePython = true;
  }));

  gdown = callPackage ../development/python-modules/gdown { };

  gdrivefs = callPackage ../development/python-modules/gdrivefs { };

  geant4 = disabledIf (!isPy3k) (toPythonModule (pkgs.geant4.override {
    enablePython = true;
    python3 = python;
  }));

  geeknote = callPackage ../development/python-modules/geeknote { };

  genanki = callPackage ../development/python-modules/genanki { };

  genpy = callPackage ../development/python-modules/genpy { };

  genshi = callPackage ../development/python-modules/genshi { };

  gensim = callPackage ../development/python-modules/gensim { };

  gentools = callPackage ../development/python-modules/gentools { };

  genzshcomp = callPackage ../development/python-modules/genzshcomp { };

  geoalchemy2 = callPackage ../development/python-modules/geoalchemy2 { };

  geographiclib = callPackage ../development/python-modules/geographiclib { };

  geoip2 = callPackage ../development/python-modules/geoip2 { };

  GeoIP = callPackage ../development/python-modules/GeoIP { };

  geojson = callPackage ../development/python-modules/geojson { };

  geopandas = callPackage ../development/python-modules/geopandas { };

  geopy = if isPy3k then
    callPackage ../development/python-modules/geopy { }
  else
    callPackage ../development/python-modules/geopy/2.nix { };

  getmac = callPackage ../development/python-modules/getmac { };

  getkey = callPackage ../development/python-modules/getkey { };

  gevent = callPackage ../development/python-modules/gevent { };

  geventhttpclient = callPackage ../development/python-modules/geventhttpclient { };

  gevent-socketio = callPackage ../development/python-modules/gevent-socketio { };

  gevent-websocket = callPackage ../development/python-modules/gevent-websocket { };

  gflags = callPackage ../development/python-modules/gflags { };

  ghdiff = callPackage ../development/python-modules/ghdiff { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  gin-config = callPackage ../development/python-modules/gin-config { };

  gipc = callPackage ../development/python-modules/gipc { };

  git-annex-adapter =
    callPackage ../development/python-modules/git-annex-adapter { inherit (pkgs.gitAndTools) git-annex; };

  gitdb2 = throw "gitdb2 has been deprecated, use gitdb instead."; # added 2020-03-14

  gitdb = callPackage ../development/python-modules/gitdb { };

  github3_py = callPackage ../development/python-modules/github3_py { };

  github-webhook = callPackage ../development/python-modules/github-webhook { };

  GitPython = callPackage ../development/python-modules/GitPython { };

  git-revise = callPackage ../development/python-modules/git-revise { };

  git-sweep = callPackage ../development/python-modules/git-sweep { };

  glances = throw "glances has moved to pkgs.glances"; # added 2020-20-28

  glasgow = callPackage ../development/python-modules/glasgow { };

  glob2 = callPackage ../development/python-modules/glob2 { };

  globre = callPackage ../development/python-modules/globre { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  glom = callPackage ../development/python-modules/glom { };

  glymur = callPackage ../development/python-modules/glymur { };

  gmpy2 = callPackage ../development/python-modules/gmpy2 { };

  gmpy = callPackage ../development/python-modules/gmpy { };

  gmusicapi = callPackage ../development/python-modules/gmusicapi { };

  gntp = callPackage ../development/python-modules/gntp { };

  gnureadline = callPackage ../development/python-modules/gnureadline { };

  gnutls = callPackage ../development/python-modules/gnutls { };

  goobook = callPackage ../development/python-modules/goobook { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  google_api_core = callPackage ../development/python-modules/google_api_core { };

  google_api_python_client =
    let google_api_python_client = callPackage ../development/python-modules/google-api-python-client { };
    in if isPy3k then
      google_api_python_client
    else # Python 2.7 support was deprecated but is still needed by weboob and duplicity
      google_api_python_client.overridePythonAttrs (old: rec {
        version = "1.7.6";
        src = old.src.override {
          inherit version;
          sha256 = "14w5sdrp0bk9n0r2lmpqmrbf2zclpfq6q7giyahnskkfzdkb165z";
        };
      });

  googleapis_common_protos = callPackage ../development/python-modules/googleapis_common_protos { };

  google_apputils = callPackage ../development/python-modules/google_apputils { };

  google_auth = callPackage ../development/python-modules/google_auth { };

  google-auth-httplib2 = callPackage ../development/python-modules/google-auth-httplib2 { };

  google-auth-oauthlib = callPackage ../development/python-modules/google-auth-oauthlib { };

  google-cloud-access-context-manager = callPackage ../development/python-modules/google-cloud-access-context-manager { };

  google_cloud_asset = callPackage ../development/python-modules/google_cloud_asset { };

  google_cloud_automl = callPackage ../development/python-modules/google_cloud_automl { };

  google_cloud_bigquery = callPackage ../development/python-modules/google_cloud_bigquery { };

  google_cloud_bigquery_datatransfer = callPackage ../development/python-modules/google_cloud_bigquery_datatransfer { };

  google_cloud_bigtable = callPackage ../development/python-modules/google_cloud_bigtable { };

  google_cloud_container = callPackage ../development/python-modules/google_cloud_container { };

  google_cloud_core = callPackage ../development/python-modules/google_cloud_core { };

  google_cloud_dataproc = callPackage ../development/python-modules/google_cloud_dataproc { };

  google_cloud_datastore = callPackage ../development/python-modules/google_cloud_datastore { };

  google_cloud_dlp = callPackage ../development/python-modules/google_cloud_dlp { };

  google_cloud_dns = callPackage ../development/python-modules/google_cloud_dns { };

  google_cloud_error_reporting = callPackage ../development/python-modules/google_cloud_error_reporting { };

  google_cloud_firestore = callPackage ../development/python-modules/google_cloud_firestore { };

  google-cloud-iam = callPackage ../development/python-modules/google-cloud-iam { };

  google_cloud_iot = callPackage ../development/python-modules/google_cloud_iot { };

  google_cloud_kms = callPackage ../development/python-modules/google_cloud_kms { };

  google_cloud_language = callPackage ../development/python-modules/google_cloud_language { };

  google_cloud_logging = callPackage ../development/python-modules/google_cloud_logging { };

  google_cloud_monitoring = callPackage ../development/python-modules/google_cloud_monitoring { };

  google-cloud-org-policy = callPackage ../development/python-modules/google-cloud-org-policy { };

  google_cloud_pubsub = callPackage ../development/python-modules/google_cloud_pubsub { };

  google_cloud_redis = callPackage ../development/python-modules/google_cloud_redis { };

  google_cloud_resource_manager = callPackage ../development/python-modules/google_cloud_resource_manager { };

  google_cloud_runtimeconfig = callPackage ../development/python-modules/google_cloud_runtimeconfig { };

  google_cloud_secret_manager = callPackage ../development/python-modules/google_cloud_secret_manager { };

  google_cloud_securitycenter = callPackage ../development/python-modules/google_cloud_securitycenter { };

  google_cloud_spanner = callPackage ../development/python-modules/google_cloud_spanner { };

  google_cloud_speech = callPackage ../development/python-modules/google_cloud_speech { };

  google_cloud_storage = callPackage ../development/python-modules/google_cloud_storage { };

  google_cloud_tasks = callPackage ../development/python-modules/google_cloud_tasks { };

  google_cloud_testutils = callPackage ../development/python-modules/google_cloud_testutils { };

  google_cloud_texttospeech = callPackage ../development/python-modules/google_cloud_texttospeech { };

  google_cloud_trace = callPackage ../development/python-modules/google_cloud_trace { };

  google_cloud_translate = callPackage ../development/python-modules/google_cloud_translate { };

  google_cloud_videointelligence = callPackage ../development/python-modules/google_cloud_videointelligence { };

  google_cloud_vision = callPackage ../development/python-modules/google_cloud_vision { };

  google_cloud_websecurityscanner = callPackage ../development/python-modules/google_cloud_websecurityscanner { };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-crc32c = callPackage ../development/python-modules/google-crc32c {
    inherit (pkgs) crc32c;
  };

  google-i18n-address = callPackage ../development/python-modules/google-i18n-address { };

  googlemaps = callPackage ../development/python-modules/googlemaps { };

  google-music = callPackage ../development/python-modules/google-music { };

  google-music-proto = callPackage ../development/python-modules/google-music-proto { };

  google-music-utils = callPackage ../development/python-modules/google-music-utils { };

  google-pasta = callPackage ../development/python-modules/google-pasta { };

  google_resumable_media = callPackage ../development/python-modules/google_resumable_media { };

  googletrans = callPackage ../development/python-modules/googletrans { };

  gorilla = callPackage ../development/python-modules/gorilla { };

  gpapi = callPackage ../development/python-modules/gpapi { };
  gplaycli = callPackage ../development/python-modules/gplaycli { };

  gpgme = toPythonModule (pkgs.gpgme.override {
    pythonSupport = true;
    inherit python;
  });

  gphoto2 = callPackage ../development/python-modules/gphoto2 { inherit (pkgs) pkgconfig; };

  gprof2dot = callPackage ../development/python-modules/gprof2dot { inherit (pkgs) graphviz; };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  gpxpy = callPackage ../development/python-modules/gpxpy { };

  gpy = callPackage ../development/python-modules/gpy { };

  gpyopt = callPackage ../development/python-modules/gpyopt { };

  gradient_sdk = callPackage ../development/python-modules/gradient_sdk { };

  gradient_statsd = callPackage ../development/python-modules/gradient_statsd { };

  grammalecte = callPackage ../development/python-modules/grammalecte { };

  grandalf = callPackage ../development/python-modules/grandalf { };

  graphite_api = callPackage ../development/python-modules/graphite-api { };

  graphite_beacon = callPackage ../development/python-modules/graphite_beacon { };

  graphite-web = callPackage ../development/python-modules/graphite-web { };

  graph_nets = callPackage ../development/python-modules/graph_nets { };

  graphql-core = callPackage ../development/python-modules/graphql-core { };

  graphql-server-core = callPackage ../development/python-modules/graphql-server-core { };

  graph-tool = callPackage ../development/python-modules/graph-tool/2.x.x.nix { inherit (pkgs) pkg-config; };

  graphviz = callPackage ../development/python-modules/graphviz { inherit (pkgs) graphviz; };

  grappelli_safe = callPackage ../development/python-modules/grappelli_safe { };

  graspologic = callPackage ../development/python-modules/graspologic { };

  greatfet = callPackage ../development/python-modules/greatfet { };

  green = callPackage ../development/python-modules/green { };

  greenlet = callPackage ../development/python-modules/greenlet { };

  grequests = callPackage ../development/python-modules/grequests { };

  grib-api = disabledIf (!isPy27) (toPythonModule (pkgs.grib-api.override {
    enablePython = true;
    pythonPackages = self;
  }));

  grip = callPackage ../development/python-modules/grip { };

  grpc_google_iam_v1 = callPackage ../development/python-modules/grpc_google_iam_v1 { };

  grpcio = callPackage ../development/python-modules/grpcio { };

  grpcio-gcp = callPackage ../development/python-modules/grpcio-gcp { };

  grpcio-tools = callPackage ../development/python-modules/grpcio-tools { };

  gsd = if isPy27 then
    callPackage ../development/python-modules/gsd/1.7.nix { }
  else
    callPackage ../development/python-modules/gsd { };

  gspread = callPackage ../development/python-modules/gspread { };

  gssapi = callPackage ../development/python-modules/gssapi { inherit (pkgs) darwin krb5Full; };

  gst-python = callPackage ../development/python-modules/gst-python {
    inherit (pkgs) meson pkgconfig;
    gst-plugins-base = pkgs.gst_all_1.gst-plugins-base;
  };

  gtimelog = callPackage ../development/python-modules/gtimelog { };

  gtts = callPackage ../development/python-modules/gtts { };

  gtts-token = callPackage ../development/python-modules/gtts-token { };

  guessit = callPackage ../development/python-modules/guessit { };

  guestfs = callPackage ../development/python-modules/guestfs { };

  gumath = callPackage ../development/python-modules/gumath { };

  gunicorn = if isPy27 then
    callPackage ../development/python-modules/gunicorn/19.nix { }
  else
    callPackage ../development/python-modules/gunicorn { };

  gurobipy = if stdenv.hostPlatform.system == "x86_64-darwin" then
    callPackage ../development/python-modules/gurobipy/darwin.nix { inherit (pkgs.darwin) cctools insert_dylib; }
  else if stdenv.hostPlatform.system == "x86_64-linux" then
    callPackage ../development/python-modules/gurobipy/linux.nix { }
  else
    throw "gurobipy not yet supported on ${stdenv.hostPlatform.system}";

  guzzle_sphinx_theme = callPackage ../development/python-modules/guzzle_sphinx_theme { };

  gwyddion = disabledIf isPy3k (toPythonModule (pkgs.gwyddion.override {
    pythonSupport = true;
    pythonPackages = self;
  }));

  gym = callPackage ../development/python-modules/gym { };

  gyp = callPackage ../development/python-modules/gyp { };

  h11 = callPackage ../development/python-modules/h11 { };

  h2 = callPackage ../development/python-modules/h2 { };

  h3 = callPackage ../development/python-modules/h3 { inherit (pkgs) h3; };

  h5netcdf = callPackage ../development/python-modules/h5netcdf { };

  h5py = callPackage ../development/python-modules/h5py { hdf5 = pkgs.hdf5; };

  h5py-mpi = self.h5py.override { hdf5 = pkgs.hdf5-mpi; };

  habanero = callPackage ../development/python-modules/habanero { };

  ha-ffmpeg = callPackage ../development/python-modules/ha-ffmpeg { };

  handout = callPackage ../development/python-modules/handout { };

  HAP-python = callPackage ../development/python-modules/HAP-python { };

  hass-nabucasa = callPackage ../development/python-modules/hass-nabucasa { };

  hawkauthlib = callPackage ../development/python-modules/hawkauthlib { };

  hbmqtt = callPackage ../development/python-modules/hbmqtt { };

  hcloud = callPackage ../development/python-modules/hcloud { };

  hcs_utils = callPackage ../development/python-modules/hcs_utils { };

  hdbscan = callPackage ../development/python-modules/hdbscan { };

  hdlparse = callPackage ../development/python-modules/hdlparse { };

  hdmedians = callPackage ../development/python-modules/hdmedians { };

  heapdict = callPackage ../development/python-modules/heapdict { };

  helpdev = callPackage ../development/python-modules/helpdev { };

  helper = callPackage ../development/python-modules/helper { };

  hepmc3 = toPythonModule (pkgs.hepmc3.override { inherit python; });

  hetzner = callPackage ../development/python-modules/hetzner { };

  heudiconv = callPackage ../development/python-modules/heudiconv { };

  hg-evolve = callPackage ../development/python-modules/hg-evolve { };

  hg-git = callPackage ../development/python-modules/hg-git { };

  hglib = callPackage ../development/python-modules/hglib { };

  hgsvn = callPackage ../development/python-modules/hgsvn { };

  hickle = callPackage ../development/python-modules/hickle { };

  hidapi = callPackage ../development/python-modules/hidapi { inherit (pkgs) udev libusb1; };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  hiredis = callPackage ../development/python-modules/hiredis { };

  hiro = callPackage ../development/python-modules/hiro { };

  hiyapyco = callPackage ../development/python-modules/hiyapyco { };

  hjson = callPackage ../development/python-modules/hjson { };

  hkdf = callPackage ../development/python-modules/hkdf { };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hocr-tools = callPackage ../development/python-modules/hocr-tools { };

  holidays = callPackage ../development/python-modules/holidays { };

  holoviews = callPackage ../development/python-modules/holoviews { };

  homeassistant-pyozw = callPackage ../development/python-modules/homeassistant-pyozw { };

  hoomd-blue = toPythonModule (callPackage ../development/python-modules/hoomd-blue { inherit python; });

  hopcroftkarp = callPackage ../development/python-modules/hopcroftkarp { };

  howdoi = callPackage ../development/python-modules/howdoi { };

  hpack = callPackage ../development/python-modules/hpack { };

  hsaudiotag3k = callPackage ../development/python-modules/hsaudiotag3k { };

  hsaudiotag = callPackage ../development/python-modules/hsaudiotag { };

  hstspreload = callPackage ../development/python-modules/hstspreload { };

  html2text = if isPy3k then
    callPackage ../development/python-modules/html2text { }
  else
    callPackage ../development/python-modules/html2text/2018.nix { };

  html5lib = callPackage ../development/python-modules/html5lib { };

  html5-parser = callPackage ../development/python-modules/html5-parser { inherit (pkgs) pkgconfig; };

  htmllaundry = callPackage ../development/python-modules/htmllaundry { };

  htmlmin = callPackage ../development/python-modules/htmlmin { };

  html-sanitizer = callPackage ../development/python-modules/html-sanitizer { };

  htmltreediff = callPackage ../development/python-modules/htmltreediff { };

  HTSeq = callPackage ../development/python-modules/HTSeq { };

  httmock = callPackage ../development/python-modules/httmock { };

  httpauth = callPackage ../development/python-modules/httpauth { };

  httpbin = callPackage ../development/python-modules/httpbin { };

  httpcore = callPackage ../development/python-modules/httpcore { };

  http-ece = callPackage ../development/python-modules/http-ece { };

  httplib2 = callPackage ../development/python-modules/httplib2 { };

  http-parser = callPackage ../development/python-modules/http-parser { };

  httpretty = if isPy3k then
    callPackage ../development/python-modules/httpretty { }
  else
    callPackage ../development/python-modules/httpretty/0.nix { };

  httpserver = callPackage ../development/python-modules/httpserver { };

  httpsig = callPackage ../development/python-modules/httpsig { };

  http_signature = callPackage ../development/python-modules/http_signature { };

  httptools = callPackage ../development/python-modules/httptools { };

  httpx = callPackage ../development/python-modules/httpx { };

  huey = callPackage ../development/python-modules/huey { };

  hug = callPackage ../development/python-modules/hug { };

  humanfriendly = callPackage ../development/python-modules/humanfriendly { };

  humanize = callPackage ../development/python-modules/humanize { };

  hupper = callPackage ../development/python-modules/hupper { };

  hvac = callPackage ../development/python-modules/hvac { };

  hvplot = callPackage ../development/python-modules/hvplot { };

  hwi = callPackage ../development/python-modules/hwi { };

  hydra = callPackage ../development/python-modules/hydra { };

  hydra-check = callPackage ../development/python-modules/hydra-check { };

  hypchat = callPackage ../development/python-modules/hypchat { };

  hyperframe = callPackage ../development/python-modules/hyperframe { };

  hyperkitty = callPackage ../servers/mail/mailman/hyperkitty.nix { };

  hyperlink = callPackage ../development/python-modules/hyperlink { };

  hyperopt = callPackage ../development/python-modules/hyperopt { };

  hypothesis_4 = callPackage ../development/python-modules/hypothesis/2.nix
    { }; # File name is called 2.nix because this one will need to remain for Python 2.

  hypothesis-auto = callPackage ../development/python-modules/hypothesis-auto { };

  hypothesis = if isPy3k then callPackage ../development/python-modules/hypothesis { } else self.hypothesis_4;

  hyppo = callPackage ../development/python-modules/hyppo { };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  i3-py = callPackage ../development/python-modules/i3-py { };

  iapws = callPackage ../development/python-modules/iapws { };

  ibis = callPackage ../development/python-modules/ibis { };

  ibis-framework = callPackage ../development/python-modules/ibis-framework { };

  icalendar = callPackage ../development/python-modules/icalendar { };

  icecream = callPackage ../development/python-modules/icecream { };

  ics = callPackage ../development/python-modules/ics { };

  identify = callPackage ../development/python-modules/identify { };

  idna = callPackage ../development/python-modules/idna { };

  idna-ssl = callPackage ../development/python-modules/idna-ssl { };

  ifaddr = callPackage ../development/python-modules/ifaddr { };

  ifconfig-parser = callPackage ../development/python-modules/ifconfig-parser { };

  ifcopenshell = callPackage ../development/python-modules/ifcopenshell { };

  ignite = callPackage ../development/python-modules/ignite { };

  ihatemoney = callPackage ../development/python-modules/ihatemoney { };

  ijson = callPackage ../development/python-modules/ijson { };

  imagecodecs-lite = disabledIf (!isPy3k) (callPackage ../development/python-modules/imagecodecs-lite { });

  imagecorruptions = callPackage ../development/python-modules/imagecorruptions { };

  imageio = callPackage ../development/python-modules/imageio { };

  imageio-ffmpeg = callPackage ../development/python-modules/imageio-ffmpeg { };

  image-match = callPackage ../development/python-modules/image-match { };

  imagesize = callPackage ../development/python-modules/imagesize { };

  imantics = callPackage ../development/python-modules/imantics { };

  IMAPClient = callPackage ../development/python-modules/imapclient { };

  imaplib2 = callPackage ../development/python-modules/imaplib2 { };

  imbalanced-learn = if isPy27 then
    callPackage ../development/python-modules/imbalanced-learn/0.4.nix { }
  else
    callPackage ../development/python-modules/imbalanced-learn { };

  imdbpy = callPackage ../development/python-modules/imdbpy { };

  img2pdf = callPackage ../development/python-modules/img2pdf { };

  imgaug = callPackage ../development/python-modules/imgaug { };

  imgsize = callPackage ../development/python-modules/imgsize { };

  immutables = callPackage ../development/python-modules/immutables { };

  impacket = callPackage ../development/python-modules/impacket { };

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata { };

  importlib-resources = callPackage ../development/python-modules/importlib-resources { };

  importmagic = callPackage ../development/python-modules/importmagic { };

  imread =
    callPackage ../development/python-modules/imread { inherit (pkgs) pkgconfig libjpeg libpng libtiff libwebp; };

  imutils = callPackage ../development/python-modules/imutils { };

  incremental = callPackage ../development/python-modules/incremental { };

  inflect = callPackage ../development/python-modules/inflect { };

  inflection = callPackage ../development/python-modules/inflection { };

  influxdb = callPackage ../development/python-modules/influxdb { };

  influxdb-client = callPackage ../development/python-modules/influxdb-client { };

  influxgraph = callPackage ../development/python-modules/influxgraph { };

  infoqscraper = callPackage ../development/python-modules/infoqscraper { };

  inform = callPackage ../development/python-modules/inform { };

  iniconfig = callPackage ../development/python-modules/iniconfig { };

  inifile = callPackage ../development/python-modules/inifile { };

  iniparse = callPackage ../development/python-modules/iniparse { };

  inotify-simple = callPackage ../development/python-modules/inotify-simple { };

  inquirer = callPackage ../development/python-modules/inquirer { };

  intake = callPackage ../development/python-modules/intake { };

  intelhex = callPackage ../development/python-modules/intelhex { };

  internetarchive = callPackage ../development/python-modules/internetarchive { };

  interruptingcow = callPackage ../development/python-modules/interruptingcow { };

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  intreehooks = callPackage ../development/python-modules/intreehooks { };

  invoke = callPackage ../development/python-modules/invoke { };

  iocapture = callPackage ../development/python-modules/iocapture { };

  iowait = callPackage ../development/python-modules/iowait { };

  ipaddr = callPackage ../development/python-modules/ipaddr { };

  ipaddress = callPackage ../development/python-modules/ipaddress { };

  ipdb = callPackage ../development/python-modules/ipdb { };

  ipdbplugin = callPackage ../development/python-modules/ipdbplugin { };

  ipfsapi = callPackage ../development/python-modules/ipfsapi { };

  iptools = callPackage ../development/python-modules/iptools { };

  ipy = callPackage ../development/python-modules/IPy { };

  ipydatawidgets = callPackage ../development/python-modules/ipydatawidgets { };

  ipykernel = if pythonOlder "3.4" then
    callPackage ../development/python-modules/ipykernel/4.nix { }
  else
    callPackage ../development/python-modules/ipykernel { };

  ipympl = callPackage ../development/python-modules/ipympl { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  ipython_genutils = callPackage ../development/python-modules/ipython_genutils { };

  ipython = if isPy27 then
    callPackage ../development/python-modules/ipython/5.nix { }
  else if isPy36 then
    callPackage ../development/python-modules/ipython/7.16.nix { }
  else
    callPackage ../development/python-modules/ipython { };

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

  iso-639 = callPackage ../development/python-modules/iso-639 { };

  iso8601 = callPackage ../development/python-modules/iso8601 { };

  isodate = callPackage ../development/python-modules/isodate { };

  isort = if isPy3k then
    callPackage ../development/python-modules/isort { }
  else
    callPackage ../development/python-modules/isort/4.nix {
  };

  isoweek = callPackage ../development/python-modules/isoweek { };

  itanium_demangler = callPackage ../development/python-modules/itanium_demangler { };

  itemadapter = callPackage ../development/python-modules/itemadapter { };

  itemloaders = callPackage ../development/python-modules/itemloaders { };

  iterm2 = callPackage ../development/python-modules/iterm2 { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous { };

  itypes = callPackage ../development/python-modules/itypes { };

  j2cli = callPackage ../development/python-modules/j2cli { };

  jabberbot = callPackage ../development/python-modules/jabberbot { };

  janus = callPackage ../development/python-modules/janus { };

  jaraco_classes = callPackage ../development/python-modules/jaraco_classes { };

  jaraco_collections = callPackage ../development/python-modules/jaraco_collections { };

  jaraco_functools = if pythonOlder "3.6" then
    callPackage ../development/python-modules/jaraco_functools/2.nix { }
  else
    callPackage ../development/python-modules/jaraco_functools { };

  jaraco_itertools = callPackage ../development/python-modules/jaraco_itertools { };

  jaraco_logging = callPackage ../development/python-modules/jaraco_logging { };

  jaraco_stream = if pythonOlder "3.6" then
    callPackage ../development/python-modules/jaraco_stream/2.nix { }
  else
    callPackage ../development/python-modules/jaraco_stream { };

  jaraco_text = callPackage ../development/python-modules/jaraco_text { };

  javaobj-py3 = callPackage ../development/python-modules/javaobj-py3 { };

  javaproperties = callPackage ../development/python-modules/javaproperties { };

  JayDeBeApi = callPackage ../development/python-modules/JayDeBeApi { };

  jc = callPackage ../development/python-modules/jc { };

  jdatetime = callPackage ../development/python-modules/jdatetime { };

  jdcal = callPackage ../development/python-modules/jdcal { };

  jedi = callPackage ../development/python-modules/jedi { };

  jeepney = callPackage ../development/python-modules/jeepney { };

  jellyfin-apiclient-python = callPackage ../development/python-modules/jellyfin-apiclient-python { };

  jellyfish = callPackage ../development/python-modules/jellyfish { };

  jenkinsapi = callPackage ../development/python-modules/jenkinsapi { };

  jenkins-job-builder = callPackage ../development/python-modules/jenkins-job-builder { };

  jieba = callPackage ../development/python-modules/jieba { };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2_pluralize = callPackage ../development/python-modules/jinja2_pluralize { };

  jinja2_time = callPackage ../development/python-modules/jinja2_time { };

  jira = callPackage ../development/python-modules/jira { };

  jmespath = callPackage ../development/python-modules/jmespath { };

  joblib = callPackage ../development/python-modules/joblib { };

  josepy = callPackage ../development/python-modules/josepy { };

  journalwatch = callPackage ../tools/system/journalwatch { inherit (self) systemd pytest; };

  jpylyzer = callPackage ../development/python-modules/jpylyzer { };

  JPype1 = callPackage ../development/python-modules/JPype1 { };

  jq = callPackage ../development/python-modules/jq { inherit (pkgs) jq; };

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier { };

  jsmin = callPackage ../development/python-modules/jsmin { };

  jsondate = callPackage ../development/python-modules/jsondate { };

  jsondiff = callPackage ../development/python-modules/jsondiff { };

  jsonlines = callPackage ../development/python-modules/jsonlines { };

  jsonmerge = callPackage ../development/python-modules/jsonmerge { };

  json-merge-patch = callPackage ../development/python-modules/json-merge-patch { };

  jsonnet = buildPythonPackage { inherit (pkgs.jsonnet) name src; };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpath = callPackage ../development/python-modules/jsonpath { };

  jsonpath_rw = callPackage ../development/python-modules/jsonpath_rw { };

  jsonpickle = callPackage ../development/python-modules/jsonpickle { };

  jsonpointer = callPackage ../development/python-modules/jsonpointer { };

  jsonref = callPackage ../development/python-modules/jsonref { };

  jsonrpc-async = callPackage ../development/python-modules/jsonrpc-async { };

  jsonrpc-base = callPackage ../development/python-modules/jsonrpc-base { };

  jsonrpclib = callPackage ../development/python-modules/jsonrpclib { };

  jsonrpclib-pelix = callPackage ../development/python-modules/jsonrpclib-pelix { };

  jsonrpc-websocket = callPackage ../development/python-modules/jsonrpc-websocket { };

  jsonschema = callPackage ../development/python-modules/jsonschema { };

  jsonstreams = callPackage ../development/python-modules/jsonstreams { };

  jsonwatch = callPackage ../development/python-modules/jsonwatch { };

  jug = callPackage ../development/python-modules/jug { };

  junitparser = callPackage ../development/python-modules/junitparser { };

  junit-xml = callPackage ../development/python-modules/junit-xml { };

  junos-eznc = callPackage ../development/python-modules/junos-eznc { };

  jupyter = callPackage ../development/python-modules/jupyter { };

  jupyter-c-kernel = callPackage ../development/python-modules/jupyter-c-kernel { };

  jupyter_client = if isPy3k then
    callPackage ../development/python-modules/jupyter_client { }
  else
    callPackage ../development/python-modules/jupyter_client/5.nix { };

  jupyter_console = if pythonOlder "3.5" then
    callPackage ../development/python-modules/jupyter_console/5.nix { }
  else
    callPackage ../development/python-modules/jupyter_console { };

  jupyter_core = callPackage ../development/python-modules/jupyter_core { };

  jupyterhub = callPackage ../development/python-modules/jupyterhub { };

  jupyterhub-ldapauthenticator = callPackage ../development/python-modules/jupyterhub-ldapauthenticator { };

  jupyterhub-systemdspawner =
    callPackage ../development/python-modules/jupyterhub-systemdspawner { inherit (pkgs) bash; };

  jupyterhub-tmpauthenticator = callPackage ../development/python-modules/jupyterhub-tmpauthenticator { };

  jupyterlab = callPackage ../development/python-modules/jupyterlab { };

  jupyterlab-git = callPackage ../development/python-modules/jupyterlab-git { };

  jupyterlab_launcher = callPackage ../development/python-modules/jupyterlab_launcher { };

  jupyterlab-pygments = callPackage ../development/python-modules/jupyterlab-pygments { };

  jupyterlab_server = callPackage ../development/python-modules/jupyterlab_server { };

  jupyter-repo2docker = callPackage ../development/python-modules/jupyter-repo2docker { pkgs-docker = pkgs.docker; };

  jupyter-sphinx = callPackage ../development/python-modules/jupyter-sphinx { };

  jupyter-telemetry = callPackage ../development/python-modules/jupyter-telemetry { };

  jupytext = callPackage ../development/python-modules/jupytext { };

  jwcrypto = callPackage ../development/python-modules/jwcrypto { };

  k5test = callPackage ../development/python-modules/k5test { inherit (pkgs) krb5Full findutils which; };

  kaa-base = callPackage ../development/python-modules/kaa-base { };

  kaa-metadata = callPackage ../development/python-modules/kaa-metadata { };

  kafka-python = callPackage ../development/python-modules/kafka-python { };

  kaggle = callPackage ../development/python-modules/kaggle { };

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  Kajiki = callPackage ../development/python-modules/kajiki { };

  kaptan = callPackage ../development/python-modules/kaptan { };

  kazoo = callPackage ../development/python-modules/kazoo { };

  kconfiglib = callPackage ../development/python-modules/kconfiglib { };

  keep = callPackage ../development/python-modules/keep { };

  keepalive = callPackage ../development/python-modules/keepalive { };

  keepkey_agent = callPackage ../development/python-modules/keepkey_agent { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  keras-applications = callPackage ../development/python-modules/keras-applications { };

  Keras = callPackage ../development/python-modules/keras { };

  keras-preprocessing = callPackage ../development/python-modules/keras-preprocessing { };

  kerberos = callPackage ../development/python-modules/kerberos { inherit (pkgs) kerberos; };

  keyring = if isPy3k then
    callPackage ../development/python-modules/keyring { }
  else
    callPackage ../development/python-modules/keyring/2.nix { };

  keyrings-alt = callPackage ../development/python-modules/keyrings-alt { };

  keyutils = callPackage ../development/python-modules/keyutils { inherit (pkgs) keyutils; };

  kicad = disabledIf isPy27 (toPythonModule (pkgs.kicad.override { python3 = python; }).src);

  kinparse = callPackage ../development/python-modules/kinparse { };

  kitchen = callPackage ../development/python-modules/kitchen { };

  kiwisolver = if isPy3k then
    callPackage ../development/python-modules/kiwisolver { }
  else
    callPackage ../development/python-modules/kiwisolver/1_1.nix { };

  klaus = callPackage ../development/python-modules/klaus { };

  klein = callPackage ../development/python-modules/klein { };

  kmapper = callPackage ../development/python-modules/kmapper { };

  kmsxx = toPythonModule ((callPackage ../development/libraries/kmsxx {
    inherit (pkgs.kmsxx) stdenv;
    inherit (pkgs) pkgconfig;
    withPython = true;
  }).overrideAttrs (oldAttrs: { name = "${python.libPrefix}-${pkgs.kmsxx.name}"; }));

  knack = callPackage ../development/python-modules/knack { };

  koji = callPackage ../development/python-modules/koji { };

  kombu = callPackage ../development/python-modules/kombu { };

  konfig = callPackage ../development/python-modules/konfig { };

  korean-lunar-calendar = callPackage ../development/python-modules/korean-lunar-calendar { };

  kubernetes = callPackage ../development/python-modules/kubernetes { };

  labelbox = callPackage ../development/python-modules/labelbox { };

  lammps-cython = callPackage ../development/python-modules/lammps-cython { mpi = pkgs.openmpi; };

  langcodes = callPackage ../development/python-modules/langcodes { };

  langdetect = callPackage ../development/python-modules/langdetect { };

  larch = callPackage ../development/python-modules/larch { };

  lark-parser = callPackage ../development/python-modules/lark-parser { };

  Lasagne = callPackage ../development/python-modules/lasagne { };

  latexcodec = callPackage ../development/python-modules/latexcodec { };

  launchpadlib = callPackage ../development/python-modules/launchpadlib { };

  lazr_config = callPackage ../development/python-modules/lazr/config.nix { };

  lazr_delegates = callPackage ../development/python-modules/lazr/delegates.nix { };

  lazr-restfulclient = callPackage ../development/python-modules/lazr-restfulclient { };

  lazr-uri = callPackage ../development/python-modules/lazr-uri { };

  lazy = callPackage ../development/python-modules/lazy { };

  lazy_import = callPackage ../development/python-modules/lazy_import { };

  lazy-object-proxy = callPackage ../development/python-modules/lazy-object-proxy { };

  ldap3 = callPackage ../development/python-modules/ldap3 { };

  ldap = callPackage ../development/python-modules/ldap { inherit (pkgs) openldap cyrus_sasl; };

  ldappool = callPackage ../development/python-modules/ldappool { };

  ldaptor = callPackage ../development/python-modules/ldaptor { };

  leather = callPackage ../development/python-modules/leather { };

  le = callPackage ../development/python-modules/le { };

  ledger_agent = callPackage ../development/python-modules/ledger_agent { };

  ledgerblue = callPackage ../development/python-modules/ledgerblue { };

  ledgerwallet = callPackage ../development/python-modules/ledgerwallet {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  lektor = callPackage ../development/python-modules/lektor { };

  leveldb = callPackage ../development/python-modules/leveldb { };

  lexid = callPackage ../development/python-modules/lexid { };

  libagent = callPackage ../development/python-modules/libagent { };

  pa-ringbuffer = callPackage ../development/python-modules/pa-ringbuffer { };

  libais = callPackage ../development/python-modules/libais { };

  libarchive-c = callPackage ../development/python-modules/libarchive-c { inherit (pkgs) libarchive; };

  libarcus = callPackage ../development/python-modules/libarcus { inherit (pkgs) protobuf; };

  libasyncns = callPackage ../development/python-modules/libasyncns { inherit (pkgs) libasyncns pkgconfig; };

  libcloud = if isPy27 then
    callPackage ../development/python-modules/libcloud/2.nix { }
  else
    callPackage ../development/python-modules/libcloud { };

  libcst = callPackage ../development/python-modules/libcst { };

  libevdev = callPackage ../development/python-modules/libevdev { };

  libfdt = toPythonModule (pkgs.dtc.override {
    inherit python;
    pythonSupport = true;
  });

  libgpiod = disabledIf (!isPy3k) (toPythonModule (pkgs.libgpiod.override {
    enablePython = true;
    python3 = python;
  }));

  libgpuarray = callPackage ../development/python-modules/libgpuarray {
    clblas = pkgs.clblas.override { boost = self.boost; };
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
  };

  libiio = (toPythonModule (pkgs.libiio.override { inherit python; })).python;

  libkeepass = callPackage ../development/python-modules/libkeepass { };

  liblarch = callPackage ../development/python-modules/liblarch { };

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

  libnacl = callPackage ../development/python-modules/libnacl { inherit (pkgs) libsodium; };

  libnl-python = disabledIf isPy3k (toPythonModule (pkgs.libnl.override {
    pythonSupport = true;
    inherit python;
  })).py;

  libplist = disabledIf isPy3k (toPythonModule (pkgs.libplist.override {
    enablePython = true;
    inherit python;
  })).py;

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

  libsass = (callPackage ../development/python-modules/libsass { inherit (pkgs) libsass; });

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

  libtorrent-rasterbar = if isPy27 then
    (toPythonModule (pkgs.libtorrent-rasterbar-1_2_x.override { inherit python; })).python
  else
    (toPythonModule (pkgs.libtorrent-rasterbar.override { inherit python; })).python;

  libusb1 = callPackage ../development/python-modules/libusb1 { inherit (pkgs) libusb1; };

  libversion = callPackage ../development/python-modules/libversion { inherit (pkgs) libversion pkgconfig; };

  libvirt = if isPy3k then
    (callPackage ../development/python-modules/libvirt { inherit (pkgs) libvirt pkgconfig; })
  else
    (callPackage ../development/python-modules/libvirt/5.9.0.nix {
      inherit (pkgs) pkgconfig;
      libvirt = pkgs.libvirt_5_9_0;
    });

  libxml2 = (toPythonModule (pkgs.libxml2.override {
    pythonSupport = true;
    inherit python;
  })).py;

  libxslt = (toPythonModule (pkgs.libxslt.override {
    pythonSupport = true;
    inherit python;
    inherit (self) libxml2;
  })).py;

  license-expression = callPackage ../development/python-modules/license-expression { };

  lightblue = callPackage ../development/python-modules/lightblue { };

  lightgbm = callPackage ../development/python-modules/lightgbm { };

  lightning = callPackage ../development/python-modules/lightning { };

  lightparam = callPackage ../development/python-modules/lightparam { };

  limitlessled = callPackage ../development/python-modules/limitlessled { };

  limits = callPackage ../development/python-modules/limits { };

  limnoria = callPackage ../development/python-modules/limnoria { };

  linecache2 = callPackage ../development/python-modules/linecache2 { };

  line_profiler = callPackage ../development/python-modules/line_profiler { };

  linode-api = callPackage ../development/python-modules/linode-api { };

  linode = callPackage ../development/python-modules/linode { };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  lirc = disabledIf isPy27 (toPythonModule (pkgs.lirc.override { python3 = python; }));

  littleutils = callPackage ../development/python-modules/littleutils { };

  livelossplot = callPackage ../development/python-modules/livelossplot { };

  livereload = callPackage ../development/python-modules/livereload { };

  livestreamer = callPackage ../development/python-modules/livestreamer { };

  livestreamer-curses = callPackage ../development/python-modules/livestreamer-curses { };

  llfuse = callPackage ../development/python-modules/llfuse {
    inherit (pkgs) fuse pkgconfig;
  }; # use "real" fuse and pkgconfig, not the python modules

  llvmlite = callPackage ../development/python-modules/llvmlite {
    llvm = pkgs.llvm_9;
  }; # llvmlite always requires a specific version of llvm.

  lmdb = callPackage ../development/python-modules/lmdb { };

  lml = callPackage ../development/python-modules/lml { };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  localzone = callPackage ../development/python-modules/localzone { };

  locket = callPackage ../development/python-modules/locket { };

  lockfile = callPackage ../development/python-modules/lockfile { };

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

  lpod = callPackage ../development/python-modules/lpod { };

  lsi = callPackage ../development/python-modules/lsi { };

  ludios_wpull = callPackage ../development/python-modules/ludios_wpull { };

  luftdaten = callPackage ../development/python-modules/luftdaten { };

  lxc = callPackage ../development/python-modules/lxc { };

  lxml = callPackage ../development/python-modules/lxml { inherit (pkgs) libxml2 libxslt zlib; };

  lyricwikia = callPackage ../development/python-modules/lyricwikia { };

  lz4 = self.python-lz4; # alias 2018-12-05

  lzstring = callPackage ../development/python-modules/lzstring { };

  m2crypto = callPackage ../development/python-modules/m2crypto { };

  m2r = callPackage ../development/python-modules/m2r { };

  m3u8 = callPackage ../development/python-modules/m3u8 { };

  mac_alias = callPackage ../development/python-modules/mac_alias { };

  macfsevents = callPackage ../development/python-modules/macfsevents {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;
  };

  macropy = callPackage ../development/python-modules/macropy { };

  maestral = callPackage ../development/python-modules/maestral {

    # https://github.com/SamSchott/maestral/issues/250#issuecomment-739510048
    survey = self.survey.overridePythonAttrs (old: rec {
      version = "2.2.1";
      src = old.src.override {
        inherit version;
        sha256 = "sha256-7ubWkqk1vyaJDLMOuKwUx2Bjziyi3HqpaQq4pKp4Z+0=";
      };
    });
    watchdog = self.watchdog.overridePythonAttrs (old: rec {
      version = "0.10.3";
      src = old.src.override {
        inherit version;
        sha256 = "4214e1379d128b0588021880ccaf40317ee156d4603ac388b9adcf29165e0c04";
      };
    });
  };

  magic = callPackage ../development/python-modules/magic { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  magic-wormhole-mailbox-server = callPackage ../development/python-modules/magic-wormhole-mailbox-server { };

  magic-wormhole-transit-relay = callPackage ../development/python-modules/magic-wormhole-transit-relay { };

  mahotas = callPackage ../development/python-modules/mahotas { };

  mailcap-fix = callPackage ../development/python-modules/mailcap-fix { };

  mailchimp = callPackage ../development/python-modules/mailchimp { };

  mailman = callPackage ../servers/mail/mailman { };

  mailmanclient = callPackage ../development/python-modules/mailmanclient { };

  mailman-hyperkitty = callPackage ../development/python-modules/mailman-hyperkitty { };

  mailman-web = callPackage ../servers/mail/mailman/web.nix { };

  rtmixer = callPackage ../development/python-modules/rtmixer { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  Mako = callPackage ../development/python-modules/Mako { };

  managesieve = callPackage ../development/python-modules/managesieve { };

  manhole = callPackage ../development/python-modules/manhole { };

  manifestparser = callPackage ../development/python-modules/marionette-harness/manifestparser.nix { };

  manuel = callPackage ../development/python-modules/manuel { };

  mapbox = callPackage ../development/python-modules/mapbox { };

  mapsplotlib = callPackage ../development/python-modules/mapsplotlib { };

  marionette_driver = callPackage ../development/python-modules/marionette-harness/marionette_driver.nix { };

  marionette-harness = callPackage ../development/python-modules/marionette-harness { };

  marisa = callPackage ../development/python-modules/marisa { marisa = pkgs.marisa; };

  marisa-trie = callPackage ../development/python-modules/marisa-trie { };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  markdown = if isPy3k then
    callPackage ../development/python-modules/markdown { }
  else
    callPackage ../development/python-modules/markdown/3_1.nix { };

  markdown-it-py = callPackage ../development/python-modules/markdown-it-py { };

  markdown-macros = callPackage ../development/python-modules/markdown-macros { };

  markdownsuperscript = callPackage ../development/python-modules/markdownsuperscript { };

  markerlib = callPackage ../development/python-modules/markerlib { };

  markupsafe = callPackage ../development/python-modules/markupsafe { };

  Markups = callPackage ../development/python-modules/Markups { };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-enum = callPackage ../development/python-modules/marshmallow-enum { };

  marshmallow-polyfield = callPackage ../development/python-modules/marshmallow-polyfield { };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  mask-rcnn = callPackage ../development/python-modules/mask-rcnn { };

  matchpy = callPackage ../development/python-modules/matchpy { };

  mathlibtools = callPackage ../development/python-modules/mathlibtools { };

  matplotlib = let
    path = if isPy3k then
      ../development/python-modules/matplotlib/default.nix
    else
      ../development/python-modules/matplotlib/2.nix;
  in callPackage path {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
    inherit (pkgs) pkgconfig;
  };

  matrix-client = callPackage ../development/python-modules/matrix-client { };

  matrix-nio = callPackage ../development/python-modules/matrix-nio { };

  mautrix = callPackage ../development/python-modules/mautrix { };

  mautrix-appservice = self.mautrix; # alias 2019-12-28

  maxminddb = callPackage ../development/python-modules/maxminddb { };

  maya = callPackage ../development/python-modules/maya { };

  mayavi = pkgs.libsForQt5.callPackage ../development/python-modules/mayavi {
    inherit buildPythonPackage isPy27 fetchPypi;
    inherit (self) pyface pygments numpy vtk traitsui envisage apptools pyqt5;
  };

  mccabe = callPackage ../development/python-modules/mccabe { };

  MDP = callPackage ../development/python-modules/mdp { };

  measurement = callPackage ../development/python-modules/measurement { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  MechanicalSoup = callPackage ../development/python-modules/MechanicalSoup { };

  mechanize = callPackage ../development/python-modules/mechanize { };

  meinheld = callPackage ../development/python-modules/meinheld { };

  meld3 = callPackage ../development/python-modules/meld3 { };

  meliae = callPackage ../development/python-modules/meliae { };

  memcached = callPackage ../development/python-modules/memcached { };

  memory_profiler = callPackage ../development/python-modules/memory_profiler { };

  mercurial = disabledIf (!isPy3k) (toPythonModule (pkgs.mercurial.override { python3Packages = self; }));

  mergedeep = callPackage ../development/python-modules/mergedeep { };

  merkletools = callPackage ../development/python-modules/merkletools { };

  mesa = callPackage ../development/python-modules/mesa { };

  meshlabxml = callPackage ../development/python-modules/meshlabxml { };

  meson = disabledIf (pythonOlder "3.5") (toPythonModule ((pkgs.meson.override { python3 = python; }).overrideAttrs
    (oldAttrs: { # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    })));

  mesonpep517 = callPackage ../development/python-modules/mesonpep517 { };

  metaphone = callPackage ../development/python-modules/metaphone { };

  mezzanine = callPackage ../development/python-modules/mezzanine { };

  micawber = callPackage ../development/python-modules/micawber { };

  midiutil = callPackage ../development/python-modules/midiutil { };

  mido = callPackage ../development/python-modules/mido { };

  milc = callPackage ../development/python-modules/milc { };

  milksnake = callPackage ../development/python-modules/milksnake { };

  minidb = callPackage ../development/python-modules/minidb { };

  minimock = callPackage ../development/python-modules/minimock { };

  mininet-python = (toPythonModule (pkgs.mininet.override { inherit python; })).py;

  minio = callPackage ../development/python-modules/minio { };

  miniupnpc = callPackage ../development/python-modules/miniupnpc { };

  misaka = callPackage ../development/python-modules/misaka { };

  mistletoe = callPackage ../development/python-modules/mistletoe { };

  mistune = callPackage ../development/python-modules/mistune { };

  mitmproxy = callPackage ../development/python-modules/mitmproxy { };

  mixpanel = callPackage ../development/python-modules/mixpanel { };

  mkl-service = callPackage ../development/python-modules/mkl-service { };

  mlflow = callPackage ../development/python-modules/mlflow { };

  mlrose = callPackage ../development/python-modules/mlrose { };

  mlxtend = callPackage ../development/python-modules/mlxtend { };

  mmh3 = callPackage ../development/python-modules/mmh3 { };

  mmpython = callPackage ../development/python-modules/mmpython { };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  mne-python = callPackage ../development/python-modules/mne-python { };

  mnist = callPackage ../development/python-modules/mnist { };

  mocket = callPackage ../development/python-modules/mocket { };

  mock = if pythonOlder "3.6" then
    callPackage ../development/python-modules/mock/2.nix { }
  else
    callPackage ../development/python-modules/mock { };

  mockito = callPackage ../development/python-modules/mockito { };

  mock-open = callPackage ../development/python-modules/mock-open { };

  modeled = callPackage ../development/python-modules/modeled { };

  moderngl = callPackage ../development/python-modules/moderngl { };

  moderngl-window = callPackage ../development/python-modules/moderngl_window { };

  modestmaps = callPackage ../development/python-modules/modestmaps { };

  mohawk = callPackage ../development/python-modules/mohawk { };

  moinmoin = callPackage ../development/python-modules/moinmoin
    { }; # Needed here because moinmoin is loaded as a Python library.

  mongodict = callPackage ../development/python-modules/mongodict { };

  mongoengine = callPackage ../development/python-modules/mongoengine { };

  monkeyhex = callPackage ../development/python-modules/monkeyhex { };

  monosat = disabledIf (!isPy3k) (pkgs.monosat.python {
    inherit buildPythonPackage;
    inherit (self) cython;
  });

  monotonic = callPackage ../development/python-modules/monotonic { };

  monty = callPackage ../development/python-modules/monty { };

  more-itertools = if isPy27 then
    callPackage ../development/python-modules/more-itertools/2.7.nix { }
  else
    callPackage ../development/python-modules/more-itertools { };

  moretools = callPackage ../development/python-modules/moretools { };

  morphys = callPackage ../development/python-modules/morphys { };

  mortgage = callPackage ../development/python-modules/mortgage { };

  moto = callPackage ../development/python-modules/moto { };

  moviepy = callPackage ../development/python-modules/moviepy { };

  mox3 = callPackage ../development/python-modules/mox3 { };

  mox = callPackage ../development/python-modules/mox { };

  mozcrash = callPackage ../development/python-modules/marionette-harness/mozcrash.nix { };

  mozdevice = callPackage ../development/python-modules/marionette-harness/mozdevice.nix { };

  mozfile = callPackage ../development/python-modules/marionette-harness/mozfile.nix { };

  mozhttpd = callPackage ../development/python-modules/marionette-harness/mozhttpd.nix { };

  mozinfo = callPackage ../development/python-modules/marionette-harness/mozinfo.nix { };

  mozlog = callPackage ../development/python-modules/marionette-harness/mozlog.nix { };

  moznetwork = callPackage ../development/python-modules/marionette-harness/moznetwork.nix { };

  mozprocess = callPackage ../development/python-modules/marionette-harness/mozprocess.nix { };

  mozprofile = callPackage ../development/python-modules/marionette-harness/mozprofile.nix { };

  mozrunner = callPackage ../development/python-modules/marionette-harness/mozrunner.nix { };

  mozsvc = callPackage ../development/python-modules/mozsvc { };

  mozterm = callPackage ../development/python-modules/mozterm { };

  moztest = callPackage ../development/python-modules/marionette-harness/moztest.nix { };

  mozversion = callPackage ../development/python-modules/marionette-harness/mozversion.nix { };

  mpd2 = callPackage ../development/python-modules/mpd2 { };

  mpd = callPackage ../development/python-modules/mpd { };

  mpi4py = callPackage ../development/python-modules/mpi4py { mpi = pkgs.openmpi; };

  mplleaflet = callPackage ../development/python-modules/mplleaflet { };

  mpmath = callPackage ../development/python-modules/mpmath { };

  mpv = callPackage ../development/python-modules/mpv { mpv = pkgs.mpv; };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mrbob = callPackage ../development/python-modules/mrbob { };

  msal = callPackage ../development/python-modules/msal { };

  msal-extensions = callPackage ../development/python-modules/msal-extensions { };

  msgpack = callPackage ../development/python-modules/msgpack { };

  msgpack-numpy = callPackage ../development/python-modules/msgpack-numpy { };

  mss = callPackage ../development/python-modules/mss { };

  msrestazure = callPackage ../development/python-modules/msrestazure { };

  msrest = callPackage ../development/python-modules/msrest { };

  msrplib = callPackage ../development/python-modules/msrplib { };

  mt-940 = callPackage ../development/python-modules/mt-940 { };

  multidict = callPackage ../development/python-modules/multidict { };

  multi_key_dict = callPackage ../development/python-modules/multi_key_dict { };

  multipledispatch = callPackage ../development/python-modules/multipledispatch { };

  multiprocess = callPackage ../development/python-modules/multiprocess { };

  multiset = callPackage ../development/python-modules/multiset { };

  multitasking = callPackage ../development/python-modules/multitasking { };

  munch = callPackage ../development/python-modules/munch { };

  munkres = callPackage ../development/python-modules/munkres { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  musicbrainzngs = callPackage ../development/python-modules/musicbrainzngs { };

  mutag = callPackage ../development/python-modules/mutag { };

  mutagen = if isPy27 then
    callPackage ../development/python-modules/mutagen/1.43.nix { }
  else
    callPackage ../development/python-modules/mutagen { };

  mutatormath = callPackage ../development/python-modules/mutatormath { };

  muttils = callPackage ../development/python-modules/muttils { };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwlib = callPackage ../development/python-modules/mwlib { };

  mwlib-ext = callPackage ../development/python-modules/mwlib-ext { };

  mwlib-rl = callPackage ../development/python-modules/mwlib-rl { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

  mwparserfromhell = callPackage ../development/python-modules/mwparserfromhell { };

  mxnet = callPackage ../development/python-modules/mxnet { };

  myfitnesspal = callPackage ../development/python-modules/myfitnesspal { };

  mygpoclient = callPackage ../development/python-modules/mygpoclient { };

  mypy = callPackage ../development/python-modules/mypy { };

  mypy-extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  mysqlclient = callPackage ../development/python-modules/mysqlclient { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  nagiosplugin = callPackage ../development/python-modules/nagiosplugin { };

  namebench = callPackage ../development/python-modules/namebench { };

  namedlist = callPackage ../development/python-modules/namedlist { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  names = callPackage ../development/python-modules/names { };

  nanoleaf = callPackage ../development/python-modules/nanoleaf { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python { inherit (pkgs) nanomsg; };

  nanotime = callPackage ../development/python-modules/nanotime { };

  nassl = callPackage ../development/python-modules/nassl { };

  natsort = callPackage ../development/python-modules/natsort { };

  naturalsort = callPackage ../development/python-modules/naturalsort { };

  nbclient = callPackage ../development/python-modules/nbclient { };

  nbconflux = callPackage ../development/python-modules/nbconflux { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbdime = callPackage ../development/python-modules/nbdime { };

  nbformat = if isPy3k then
    callPackage ../development/python-modules/nbformat { }
  else
    callPackage ../development/python-modules/nbformat/2.nix { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbsmoke = callPackage ../development/python-modules/nbsmoke { };

  nbsphinx = callPackage ../development/python-modules/nbsphinx { };

  nbval = callPackage ../development/python-modules/nbval { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  ncclient = callPackage ../development/python-modules/ncclient { };

  ndg-httpsclient = callPackage ../development/python-modules/ndg-httpsclient { };

  ndjson = callPackage ../development/python-modules/ndjson { };

  ndtypes = callPackage ../development/python-modules/ndtypes { };

  neo = callPackage ../development/python-modules/neo { };

  nest-asyncio = callPackage ../development/python-modules/nest-asyncio { };

  nestedtext = callPackage ../development/python-modules/nestedtext { };

  netaddr = callPackage ../development/python-modules/netaddr { };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  netdisco = callPackage ../development/python-modules/netdisco { };

  netifaces = callPackage ../development/python-modules/netifaces { };

  networkx = if isPy3k then
    callPackage ../development/python-modules/networkx { }
  else
    callPackage ../development/python-modules/networkx/2.2.nix { };

  neuron-mpi = pkgs.neuron-mpi.override { inherit python; };

  neuron = pkgs.neuron.override { inherit python; };

  neuronpy = callPackage ../development/python-modules/neuronpy { };

  nevow = callPackage ../development/python-modules/nevow { };

  nghttp2 = (toPythonModule (pkgs.nghttp2.override {
    inherit (self) python cython setuptools;
    inherit (pkgs) ncurses;
    enablePython = true;
  })).python;

  nibabel = callPackage ../development/python-modules/nibabel { };

  nidaqmx = callPackage ../development/python-modules/nidaqmx { };

  Nikola = callPackage ../development/python-modules/Nikola { };

  nilearn = callPackage ../development/python-modules/nilearn { };

  nimfa = callPackage ../development/python-modules/nimfa { };

  nine = callPackage ../development/python-modules/nine { };

  nipy = callPackage ../development/python-modules/nipy { };

  nipype = callPackage ../development/python-modules/nipype { inherit (pkgs) which; };

  nitime = callPackage ../development/python-modules/nitime { };

  nitpick = callPackage ../applications/version-management/nitpick { };

  nix-kernel = callPackage ../development/python-modules/nix-kernel { inherit (pkgs) nix; };

  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4
    { }; # This is used for NixOps to make sure we won't break it with the next major version of nixpart.

  nixpart = callPackage ../tools/filesystems/nixpart { };

  nixpkgs = callPackage ../development/python-modules/nixpkgs { };

  nixpkgs-pytools = callPackage ../development/python-modules/nixpkgs-pytools { };

  nix-prefetch-github = callPackage ../development/python-modules/nix-prefetch-github { };

  nltk = callPackage ../development/python-modules/nltk { };

  nmigen-boards = callPackage ../development/python-modules/nmigen-boards { };

  nmigen = callPackage ../development/python-modules/nmigen { };

  nmigen-soc = callPackage ../development/python-modules/nmigen-soc { };

  nocasedict = callPackage ../development/python-modules/nocasedict { };

  nocaselist = callPackage ../development/python-modules/nocaselist { };

  nodeenv = callPackage ../development/python-modules/nodeenv { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  noise = callPackage ../development/python-modules/noise { };

  nose2 = callPackage ../development/python-modules/nose2 { };

  nose = callPackage ../development/python-modules/nose { };

  nose-cov = callPackage ../development/python-modules/nose-cov { };

  nose-cover3 = callPackage ../development/python-modules/nose-cover3 { };

  nose-cprof = callPackage ../development/python-modules/nose-cprof { };

  nose-exclude = callPackage ../development/python-modules/nose-exclude { };

  nose-focus = callPackage ../development/python-modules/nose-focus { };

  nose-timer = callPackage ../development/python-modules/nose-timer { };

  nosejs = callPackage ../development/python-modules/nosejs { };

  nose-of-yeti = callPackage ../development/python-modules/nose-of-yeti { };

  nose-pattern-exclude = callPackage ../development/python-modules/nose-pattern-exclude { };

  nose_progressive = callPackage ../development/python-modules/nose_progressive { };

  nose-randomly = callPackage ../development/python-modules/nose-randomly { };

  nose_warnings_filters = callPackage ../development/python-modules/nose_warnings_filters { };

  nosexcover = callPackage ../development/python-modules/nosexcover { };

  notebook = if isPy3k then
    callPackage ../development/python-modules/notebook { }
  else
    callPackage ../development/python-modules/notebook/2.nix { };

  notedown = callPackage ../development/python-modules/notedown { };

  notify2 = callPackage ../development/python-modules/notify2 { };

  notify = callPackage ../development/python-modules/notify { };

  notify-py = callPackage ../development/python-modules/notify-py { };

  notmuch = callPackage ../development/python-modules/notmuch { inherit (pkgs) notmuch; };
  notmuch2 = callPackage ../development/python-modules/notmuch/2.nix { inherit (pkgs) notmuch; };

  nototools = callPackage ../data/fonts/noto-fonts/tools.nix { };

  nplusone = callPackage ../development/python-modules/nplusone { };

  ntc-templates = callPackage ../development/python-modules/ntc-templates { };

  ntlm-auth = callPackage ../development/python-modules/ntlm-auth { };

  ntplib = callPackage ../development/python-modules/ntplib { };

  Nuitka = callPackage ../development/python-modules/nuitka { };

  num2words = callPackage ../development/python-modules/num2words { };

  numba = callPackage ../development/python-modules/numba { };

  numcodecs = callPackage ../development/python-modules/numcodecs { inherit (pkgs) gcc8; };

  numericalunits = callPackage ../development/python-modules/numericalunits { };

  numexpr = callPackage ../development/python-modules/numexpr { };

  numpydoc = callPackage ../development/python-modules/numpydoc { };

  numpy = if pythonOlder "3.5" then
    callPackage ../development/python-modules/numpy/1.16.nix { }
  else
    callPackage ../development/python-modules/numpy { };

  numpy-stl = callPackage ../development/python-modules/numpy-stl { };

  numtraits = callPackage ../development/python-modules/numtraits { };

  nunavut = callPackage ../development/python-modules/nunavut { };

  nvchecker = callPackage ../development/python-modules/nvchecker { };

  nwdiag = callPackage ../development/python-modules/nwdiag { };

  nxt-python = callPackage ../development/python-modules/nxt-python { };

  oath = callPackage ../development/python-modules/oath { };

  oauth2 = callPackage ../development/python-modules/oauth2 { };

  oauth2client = callPackage ../development/python-modules/oauth2client { };

  oauth = callPackage ../development/python-modules/oauth { };

  oauthenticator = callPackage ../development/python-modules/oauthenticator { };

  oauthlib = if isPy27 then
    callPackage ../development/python-modules/oauthlib/3.1.nix { }
  else
    callPackage ../development/python-modules/oauthlib { };

  obfsproxy = callPackage ../development/python-modules/obfsproxy { };

  objgraph = callPackage ../development/python-modules/objgraph { graphvizPkg = pkgs.graphviz; };

  od = callPackage ../development/python-modules/od { };

  odfpy = callPackage ../development/python-modules/odfpy { };

  offtrac = callPackage ../development/python-modules/offtrac { };

  ofxclient = callPackage ../development/python-modules/ofxclient { };

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = callPackage ../development/python-modules/ofxparse { };

  ofxtools = callPackage ../development/python-modules/ofxtools { };

  olefile = callPackage ../development/python-modules/olefile { };

  omegaconf = callPackage ../development/python-modules/omegaconf { };

  onkyo-eiscp = callPackage ../development/python-modules/onkyo-eiscp { };

  onnx = callPackage ../development/python-modules/onnx { };

  openant = callPackage ../development/python-modules/openant { };

  openapi-spec-validator = callPackage ../development/python-modules/openapi-spec-validator { };

  opencv3 = toPythonModule (pkgs.opencv3.override {
    enablePython = true;
    pythonPackages = self;
  });

  opencv4 = toPythonModule (pkgs.opencv4.override {
    enablePython = true;
    pythonPackages = self;
  });

  opencv = disabledIf isPy3k (toPythonModule (pkgs.opencv.override {
    enablePython = true;
    pythonPackages = self;
  }));

  openidc-client = callPackage ../development/python-modules/openidc-client { };

  openpyxl = if pythonAtLeast "3.6" then
    callPackage ../development/python-modules/openpyxl { }
  else
    callPackage ../development/python-modules/openpyxl/2.nix { };

  openrazer = callPackage ../development/python-modules/openrazer/pylib.nix { };

  openrazer-daemon = callPackage ../development/python-modules/openrazer/daemon.nix { };

  openrouteservice = callPackage ../development/python-modules/openrouteservice/default.nix { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  opentracing = callPackage ../development/python-modules/opentracing { };

  openwebifpy = callPackage ../development/python-modules/openwebifpy { };

  openwrt-luci-rpc = disabledIf (!isPy3k) (callPackage ../development/python-modules/openwrt-luci-rpc { });

  opt-einsum = if isPy27 then
    callPackage ../development/python-modules/opt-einsum/2.nix { }
  else
    callPackage ../development/python-modules/opt-einsum { };

  optuna = callPackage ../development/python-modules/optuna { };

  opuslib = callPackage ../development/python-modules/opuslib { };

  ordereddict = callPackage ../development/python-modules/ordereddict { };

  orderedmultidict = callPackage ../development/python-modules/orderedmultidict { };

  ordered-set = callPackage ../development/python-modules/ordered-set { };

  orderedset = callPackage ../development/python-modules/orderedset { };

  orm = callPackage ../development/python-modules/orm { };

  ortools = (toPythonModule (pkgs.or-tools.override { inherit (self) python; })).python;

  osc = callPackage ../development/python-modules/osc { };

  oscrypto = callPackage ../development/python-modules/oscrypto { };

  oset = callPackage ../development/python-modules/oset { };

  osmnx = callPackage ../development/python-modules/osmnx { };

  osmpythontools = callPackage ../development/python-modules/osmpythontools { };

  osqp = callPackage ../development/python-modules/osqp { };

  outcome = callPackage ../development/python-modules/outcome { };

  ovh = callPackage ../development/python-modules/ovh { };

  ovito = toPythonModule (pkgs.libsForQt5.callPackage ../development/python-modules/ovito { inherit python; });

  owslib = callPackage ../development/python-modules/owslib { };

  oyaml = callPackage ../development/python-modules/oyaml { };

  packaging = if isPy3k
    then callPackage ../development/python-modules/packaging { }
    else callPackage ../development/python-modules/packaging/2.nix { };

  packet-python = callPackage ../development/python-modules/packet-python { };

  pafy = callPackage ../development/python-modules/pafy { };

  pagelabels = callPackage ../development/python-modules/pagelabels { };

  pagerduty = callPackage ../development/python-modules/pagerduty { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt { };

  palettable = callPackage ../development/python-modules/palettable { };

  # Alias. Added 2020-09-07.
  pam = self.python-pam;

  pamela = callPackage ../development/python-modules/pamela { };

  pamqp = callPackage ../development/python-modules/pamqp { };

  pandas = if isPy3k then
    callPackage ../development/python-modules/pandas { }
  else
    callPackage ../development/python-modules/pandas/2.nix { };

  pandas-datareader = callPackage ../development/python-modules/pandas-datareader { };

  pandoc-attributes = callPackage ../development/python-modules/pandoc-attributes { };

  pandocfilters = callPackage ../development/python-modules/pandocfilters { };

  panel = callPackage ../development/python-modules/panel { };

  papermill = callPackage ../development/python-modules/papermill { };

  paperspace = callPackage ../development/python-modules/paperspace { };

  openpaperwork-core = callPackage ../applications/office/paperwork/openpaperwork-core.nix { };
  openpaperwork-gtk = callPackage ../applications/office/paperwork/openpaperwork-gtk.nix { };
  paperwork-backend = callPackage ../applications/office/paperwork/paperwork-backend.nix { };
  paperwork-shell = callPackage ../applications/office/paperwork/paperwork-shell.nix { };

  papis = callPackage ../development/python-modules/papis { };

  papis-python-rofi = callPackage ../development/python-modules/papis-python-rofi { };

  param = callPackage ../development/python-modules/param { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  paramiko = callPackage ../development/python-modules/paramiko { };

  paramz = callPackage ../development/python-modules/paramz { };

  parfive = callPackage ../development/python-modules/parfive { };

  parse = callPackage ../development/python-modules/parse { };

  parsedatetime = callPackage ../development/python-modules/parsedatetime { };

  parsel = callPackage ../development/python-modules/parsel { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  parsimonious = callPackage ../development/python-modules/parsimonious { };

  parsley = callPackage ../development/python-modules/parsley { };

  parso = callPackage ../development/python-modules/parso { };

  parsy = callPackage ../development/python-modules/parsy { };

  partd = callPackage ../development/python-modules/partd { };

  parver = callPackage ../development/python-modules/parver { };
  arpeggio = callPackage ../development/python-modules/arpeggio { };

  passlib = callPackage ../development/python-modules/passlib { };

  paste = callPackage ../development/python-modules/paste { };

  PasteDeploy = callPackage ../development/python-modules/pastedeploy { };

  pastel = callPackage ../development/python-modules/pastel { };

  pasteScript = callPackage ../development/python-modules/pastescript { };

  patator = callPackage ../development/python-modules/patator { };

  patch = callPackage ../development/python-modules/patch { };

  patch-ng = callPackage ../development/python-modules/patch-ng { };

  path-and-address = callPackage ../development/python-modules/path-and-address { };

  pathlib2 = callPackage ../development/python-modules/pathlib2 { };

  pathlib = callPackage ../development/python-modules/pathlib { };

  pathos = callPackage ../development/python-modules/pathos { };

  pathpy = if isPy3k then
    callPackage ../development/python-modules/path.py { }
  else
    callPackage ../development/python-modules/path.py/2.nix { };

  pathspec = callPackage ../development/python-modules/pathspec { };

  pathtools = callPackage ../development/python-modules/pathtools { };

  patiencediff = callPackage ../development/python-modules/patiencediff { };

  patool = callPackage ../development/python-modules/patool { };

  patsy = callPackage ../development/python-modules/patsy { };

  paver = callPackage ../development/python-modules/paver { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbkdf2 = callPackage ../development/python-modules/pbkdf2 { };

  pbr = callPackage ../development/python-modules/pbr { };

  pc-ble-driver-py = toPythonModule (callPackage ../development/python-modules/pc-ble-driver-py { });

  pcpp = callPackage ../development/python-modules/pcpp { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfkit = callPackage ../development/python-modules/pdfkit { };

  pdfminer = callPackage ../development/python-modules/pdfminer_six { };

  pdfposter = callPackage ../development/python-modules/pdfposter { };

  pdfrw = callPackage ../development/python-modules/pdfrw { };

  pdftotext = callPackage ../development/python-modules/pdftotext { };

  pdfx = callPackage ../development/python-modules/pdfx { };

  pdoc3 = callPackage ../development/python-modules/pdoc3 { };

  pecan = callPackage ../development/python-modules/pecan { };

  peewee = callPackage ../development/python-modules/peewee { };

  pefile = callPackage ../development/python-modules/pefile { };

  pelican = callPackage ../development/python-modules/pelican { inherit (pkgs) glibcLocales git; };

  pendulum = callPackage ../development/python-modules/pendulum { };

  pep257 = callPackage ../development/python-modules/pep257 { };

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

  pex = callPackage ../development/python-modules/pex { };

  pexif = callPackage ../development/python-modules/pexif { };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pg8000 = callPackage ../development/python-modules/pg8000 { };
  pg8000_1_12 = callPackage ../development/python-modules/pg8000/1_12.nix { };

  pgcli = callPackage ../development/tools/database/pgcli { };

  pglast = callPackage ../development/python-modules/pglast { };

  pgpdump = callPackage ../development/python-modules/pgpdump { };

  pgpy = callPackage ../development/python-modules/pgpy { };

  pgsanity = callPackage ../development/python-modules/pgsanity { };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  phe = callPackage ../development/python-modules/phe { };

  phik = callPackage ../development/python-modules/phik { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  phpserialize = callPackage ../development/python-modules/phpserialize { };

  phx-class-registry = callPackage ../development/python-modules/phx-class-registry { };

  piccata = callPackage ../development/python-modules/piccata { };

  pickleshare = callPackage ../development/python-modules/pickleshare { };

  picos = callPackage ../development/python-modules/picos { };

  pid = callPackage ../development/python-modules/pid { };

  piep = callPackage ../development/python-modules/piep { };

  piexif = callPackage ../development/python-modules/piexif { };

  pika = callPackage ../development/python-modules/pika { };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  pikepdf = callPackage ../development/python-modules/pikepdf { };

  pilkit = callPackage ../development/python-modules/pilkit { };

  pillowfight = callPackage ../development/python-modules/pillowfight { };

  pillow = if isPy27 then
    callPackage ../development/python-modules/pillow/6.nix {
      inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
      inherit (pkgs.xorg) libX11;
    }
  else
    callPackage ../development/python-modules/pillow {
      inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
      inherit (pkgs.xorg) libX11;
    };

  pims = callPackage ../development/python-modules/pims { };

  pinboard = callPackage ../development/python-modules/pinboard { };

  pint = callPackage ../development/python-modules/pint { };

  pip = callPackage ../development/python-modules/pip { };

  pipdate = callPackage ../development/python-modules/pipdate { };

  pip-tools = callPackage ../development/python-modules/pip-tools {
    git = pkgs.gitMinimal;
    glibcLocales = pkgs.glibcLocales;
  };

  pipx = callPackage ../development/python-modules/pipx { };

  pivy = callPackage ../development/python-modules/pivy {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) soqt;
  };

  pkgconfig = callPackage ../development/python-modules/pkgconfig { inherit (pkgs) pkgconfig; };

  pkginfo = callPackage ../development/python-modules/pkginfo { };

  pkuseg = callPackage ../development/python-modules/pkuseg { };

  pysbd = callPackage ../development/python-modules/pysbd { };

  python-csxcad = callPackage ../development/python-modules/python-csxcad { };

  python-openems = callPackage ../development/python-modules/python-openems { };

  pkutils = callPackage ../development/python-modules/pkutils { };

  plac = callPackage ../development/python-modules/plac { };

  plaid-python = callPackage ../development/python-modules/plaid-python { };

  plaster = callPackage ../development/python-modules/plaster { };

  plaster-pastedeploy = callPackage ../development/python-modules/plaster-pastedeploy { };

  playsound = callPackage ../development/python-modules/playsound { };

  plexapi = callPackage ../development/python-modules/plexapi { };

  plexauth = callPackage ../development/python-modules/plexauth { };

  plexwebsocket = callPackage ../development/python-modules/plexwebsocket { };

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  plotly = callPackage ../development/python-modules/plotly { };

  pluggy = callPackage ../development/python-modules/pluggy { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  plumbum = callPackage ../development/python-modules/plumbum { };

  ply = callPackage ../development/python-modules/ply { };

  plyfile = callPackage ../development/python-modules/plyfile { };

  plyplus = callPackage ../development/python-modules/plyplus { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  Pmw = callPackage ../development/python-modules/Pmw { };

  pocket = callPackage ../development/python-modules/pocket { };

  podcastparser = callPackage ../development/python-modules/podcastparser { };

  podcats = callPackage ../development/python-modules/podcats { };

  poetry = callPackage ../development/python-modules/poetry { };

  poetry-core = callPackage ../development/python-modules/poetry-core { };

  poezio = callPackage ../applications/networking/instant-messengers/poezio { inherit (pkgs) pkgconfig; };

  polib = callPackage ../development/python-modules/polib { };

  polyline = callPackage ../development/python-modules/polyline { };

  pomegranate = callPackage ../development/python-modules/pomegranate { };

  pony = callPackage ../development/python-modules/pony { };

  ponywhoosh = callPackage ../development/python-modules/ponywhoosh { };

  pooch = callPackage ../development/python-modules/pooch { };

  poppler-qt5 = callPackage ../development/python-modules/poppler-qt5 {
    inherit (pkgs.qt5) qtbase;
    inherit (pkgs.libsForQt5) poppler;
    inherit (pkgs) pkgconfig;
  };

  portalocker = callPackage ../development/python-modules/portalocker { };

  portend = callPackage ../development/python-modules/portend { };

  portpicker = callPackage ../development/python-modules/portpicker { };

  posix_ipc = callPackage ../development/python-modules/posix_ipc { };

  poster3 = callPackage ../development/python-modules/poster3 { };

  postorius = disabledIf (!isPy3k) (callPackage ../servers/mail/mailman/postorius.nix { });

  potr = callPackage ../development/python-modules/potr { };

  power = callPackage ../development/python-modules/power { };

  powerline = callPackage ../development/python-modules/powerline { };

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

  praw = if isPy3k then
    callPackage ../development/python-modules/praw { }
  else
    callPackage ../development/python-modules/praw/6.3.nix { };

  precis-i18n = callPackage ../development/python-modules/precis-i18n { };

  pre-commit = callPackage ../development/python-modules/pre-commit { };

  pre-commit-hooks = callPackage ../development/python-modules/pre-commit-hooks { };

  preggy = callPackage ../development/python-modules/preggy { };

  premailer = callPackage ../development/python-modules/premailer { };

  preshed = callPackage ../development/python-modules/preshed { };

  pretend = callPackage ../development/python-modules/pretend { };

  prettytable = if isPy3k then
    callPackage ../development/python-modules/prettytable { }
  else
    callPackage ../development/python-modules/prettytable/1.nix { };

  priority = callPackage ../development/python-modules/priority { };

  prison = callPackage ../development/python-modules/prison { };

  privacyidea = callPackage ../development/python-modules/privacyidea { };
  privacyidea-ldap-proxy = callPackage ../development/python-modules/privacyidea/ldap-proxy.nix { };

  proboscis = callPackage ../development/python-modules/proboscis { };

  process-tests = callPackage ../development/python-modules/process-tests { };

  proglog = callPackage ../development/python-modules/proglog { };

  progressbar231 = callPackage ../development/python-modules/progressbar231 { };

  progressbar2 = callPackage ../development/python-modules/progressbar2 { };

  progressbar33 = callPackage ../development/python-modules/progressbar33 { };

  progressbar = callPackage ../development/python-modules/progressbar { };

  progress = callPackage ../development/python-modules/progress { };

  prometheus_client = callPackage ../development/python-modules/prometheus_client { };

  promise = callPackage ../development/python-modules/promise { };

  prompt_toolkit = let
    filename = if isPy3k then
      ../development/python-modules/prompt_toolkit
    else
      ../development/python-modules/prompt_toolkit/1.nix;
  in callPackage filename { };

  property-manager = callPackage ../development/python-modules/property-manager { };

  protego = callPackage ../development/python-modules/protego { };

  proto-plus = callPackage ../development/python-modules/proto-plus { };

  protobuf = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    doCheck =
      !isPy3k; # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
    protobuf = pkgs.protobuf;
  };

  prov = callPackage ../development/python-modules/prov { };

  prox-tv = callPackage ../development/python-modules/prox-tv { };

  psautohint = callPackage ../development/python-modules/psautohint { };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psutil = callPackage ../development/python-modules/psutil { };

  psycopg2 = callPackage ../development/python-modules/psycopg2 { };

  psycopg2cffi = callPackage ../development/python-modules/psycopg2cffi { };

  ptable = callPackage ../development/python-modules/ptable { };

  ptest = callPackage ../development/python-modules/ptest { };

  ptpython = callPackage ../development/python-modules/ptpython { prompt_toolkit = self.prompt_toolkit; };

  ptyprocess = callPackage ../development/python-modules/ptyprocess { };

  publicsuffix2 = callPackage ../development/python-modules/publicsuffix2 { };

  publicsuffix = callPackage ../development/python-modules/publicsuffix { };

  pudb = callPackage ../development/python-modules/pudb { };

  pulp = callPackage ../development/python-modules/pulp { };

  pulsectl = callPackage ../development/python-modules/pulsectl { };

  pure-eval = callPackage ../development/python-modules/pure-eval { };

  pure-pcapy3 = callPackage ../development/python-modules/pure-pcapy3 { };

  purepng = callPackage ../development/python-modules/purepng { };

  pure-python-adb = callPackage ../development/python-modules/pure-python-adb { };

  pure-python-adb-homeassistant = callPackage ../development/python-modules/pure-python-adb-homeassistant { };

  purl = callPackage ../development/python-modules/purl { };

  pushbullet = callPackage ../development/python-modules/pushbullet { };

  pushover-complete = callPackage ../development/python-modules/pushover-complete { };

  pvlib = callPackage ../development/python-modules/pvlib { };

  Pweave = callPackage ../development/python-modules/pweave { };

  pwntools = callPackage ../development/python-modules/pwntools { debugger = pkgs.gdb; };

  pxml = callPackage ../development/python-modules/pxml { };

  py-air-control = callPackage ../development/python-modules/py-air-control { };

  py-air-control-exporter = callPackage ../development/python-modules/py-air-control-exporter { };

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

  pyairvisual = callPackage ../development/python-modules/pyairvisual { };

  pyalgotrade = callPackage ../development/python-modules/pyalgotrade { };

  pyamf = callPackage ../development/python-modules/pyamf { };

  pyamg = callPackage ../development/python-modules/pyamg { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyannotate = callPackage ../development/python-modules/pyannotate { };

  pyarrow = callPackage ../development/python-modules/pyarrow { inherit (pkgs) arrow-cpp cmake pkgconfig; };

  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyatmo = callPackage ../development/python-modules/pyatmo { };

  pyatspi = callPackage ../development/python-modules/pyatspi { inherit (pkgs) pkgconfig; };

  pyatv = callPackage ../development/python-modules/pyatv { };

  pyaudio = callPackage ../development/python-modules/pyaudio { };

  pyavm = callPackage ../development/python-modules/pyavm { };

  pyaxmlparser = callPackage ../development/python-modules/pyaxmlparser { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pybids = callPackage ../development/python-modules/pybids { };

  pybigwig = callPackage ../development/python-modules/pybigwig { };

  pybind11 = callPackage ../development/python-modules/pybind11 { };

  pybindgen = callPackage ../development/python-modules/pybindgen { };

  pyblake2 = callPackage ../development/python-modules/pyblake2 { };

  pyblock = callPackage ../development/python-modules/pyblock { };

  pyblosxom = callPackage ../development/python-modules/pyblosxom { };

  pybluez = callPackage ../development/python-modules/pybluez { };

  pybotvac = callPackage ../development/python-modules/pybotvac { };

  pybrowserid = callPackage ../development/python-modules/pybrowserid { };

  pybtex = callPackage ../development/python-modules/pybtex { };

  pybtex-docutils = callPackage ../development/python-modules/pybtex-docutils { };

  pybullet = callPackage ../development/python-modules/pybullet { };

  pycairo = callPackage ../development/python-modules/pycairo { inherit (pkgs) meson pkg-config; };

  pycallgraph = callPackage ../development/python-modules/pycallgraph { };

  py = callPackage ../development/python-modules/py { };

  pycangjie = disabledIf (!isPy3k) (callPackage ../development/python-modules/pycangjie { inherit (pkgs) pkgconfig; });

  pycapnp = callPackage ../development/python-modules/pycapnp { };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycarddav = callPackage ../development/python-modules/pycarddav { };

  pycares = callPackage ../development/python-modules/pycares { };

  pycassa = callPackage ../development/python-modules/pycassa { };

  pycategories = callPackage ../development/python-modules/pycategories { };

  pycdio = callPackage ../development/python-modules/pycdio { };

  pychart = callPackage ../development/python-modules/pychart { };

  pychef = callPackage ../development/python-modules/pychef { };

  PyChromecast = callPackage ../development/python-modules/pychromecast { };

  pyclipper = callPackage ../development/python-modules/pyclipper { };

  pycm = callPackage ../development/python-modules/pycm { };

  pycmarkgfm = callPackage ../development/python-modules/pycmarkgfm { };

  pycodestyle = callPackage ../development/python-modules/pycodestyle { };

  pycognito = callPackage ../development/python-modules/pycognito { };

  pycoin = callPackage ../development/python-modules/pycoin { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycontracts = callPackage ../development/python-modules/pycontracts { };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycountry = callPackage ../development/python-modules/pycountry { };

  pycparser = callPackage ../development/python-modules/pycparser { };

  py-cpuinfo = callPackage ../development/python-modules/py-cpuinfo { };

  pycrc = callPackage ../development/python-modules/pycrc { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  pycryptopp = callPackage ../development/python-modules/pycryptopp { };

  pyct = callPackage ../development/python-modules/pyct { };

  pycuda = callPackage ../development/python-modules/pycuda {
    cudatoolkit = pkgs.cudatoolkit;
    inherit (pkgs.stdenv) mkDerivation;
  };

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl2 = callPackage ../development/python-modules/pycurl2 { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycxx = callPackage ../development/python-modules/pycxx { };

  pydantic = callPackage ../development/python-modules/pydantic { };

  pydbus = callPackage ../development/python-modules/pydbus { };

  pydenticon = callPackage ../development/python-modules/pydenticon { };

  pydicom = callPackage ../development/python-modules/pydicom { };

  pydispatcher = callPackage ../development/python-modules/pydispatcher { };

  pydns = let
    py3 = callPackage ../development/python-modules/py3dns { };
    py2 = callPackage ../development/python-modules/pydns { };
  in if isPy3k then py3 else py2;

  pydocstyle = if isPy27 then
    callPackage ../development/python-modules/pydocstyle/2.nix { }
  else
    callPackage ../development/python-modules/pydocstyle { };

  pydocumentdb = callPackage ../development/python-modules/pydocumentdb { };

  pydot = callPackage ../development/python-modules/pydot { inherit (pkgs) graphviz; };

  pydotplus = callPackage ../development/python-modules/pydotplus { };

  pydrive = callPackage ../development/python-modules/pydrive { };

  pydsdl = callPackage ../development/python-modules/pydsdl { };

  pydub = callPackage ../development/python-modules/pydub { };

  pydy = callPackage ../development/python-modules/pydy { };

  pyechonest = callPackage ../development/python-modules/pyechonest { };

  pyee = callPackage ../development/python-modules/pyee { };

  pyelftools = callPackage ../development/python-modules/pyelftools { };

  pyemd = callPackage ../development/python-modules/pyemd { };

  pyenchant = callPackage ../development/python-modules/pyenchant { enchant2 = pkgs.enchant2; };

  pyepsg = callPackage ../development/python-modules/pyepsg { };

  pyexcel = callPackage ../development/python-modules/pyexcel { };

  pyexcelerator = callPackage ../development/python-modules/pyexcelerator { };

  pyexcel-io = callPackage ../development/python-modules/pyexcel-io { };

  pyexcel-ods = callPackage ../development/python-modules/pyexcel-ods { };

  pyexcel-xls = callPackage ../development/python-modules/pyexcel-xls { };

  pyexiv2 = disabledIf isPy3k (toPythonModule (callPackage ../development/python-modules/pyexiv2 { }));

  pyext = callPackage ../development/python-modules/pyext { };

  pyface = callPackage ../development/python-modules/pyface { };

  pyfaidx = callPackage ../development/python-modules/pyfaidx { };

  pyfakefs = callPackage ../development/python-modules/pyfakefs { };

  pyfantom = callPackage ../development/python-modules/pyfantom { };

  pyfcm = callPackage ../development/python-modules/pyfcm { };

  pyfftw = callPackage ../development/python-modules/pyfftw { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyfma = callPackage ../development/python-modules/pyfma { };

  pyfribidi = callPackage ../development/python-modules/pyfribidi { };

  pyfritzhome = callPackage ../development/python-modules/pyfritzhome { };

  pyftdi = callPackage ../development/python-modules/pyftdi { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pyftpdlib = callPackage ../development/python-modules/pyftpdlib { };

  pyfttt = callPackage ../development/python-modules/pyfttt { };

  pyfuse3 = callPackage ../development/python-modules/pyfuse3 { };

  pyfxa = callPackage ../development/python-modules/pyfxa { };

  pygal = callPackage ../development/python-modules/pygal { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygame_sdl2 = callPackage ../development/python-modules/pygame_sdl2 { };

  pygbm = callPackage ../development/python-modules/pygbm { };

  pygccxml = callPackage ../development/python-modules/pygccxml { };

  pygdbmi = callPackage ../development/python-modules/pygdbmi { };

  pygeoip = callPackage ../development/python-modules/pygeoip { };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  PyGithub = callPackage ../development/python-modules/pyGithub { };

  pyglet = callPackage ../development/python-modules/pyglet { };

  pygls = callPackage ../development/python-modules/pygls { };

  pygments-better-html = callPackage ../development/python-modules/pygments-better-html { };

  pygments = if isPy3k then
    callPackage ../development/python-modules/Pygments { }
  else
    callPackage ../development/python-modules/Pygments/2_5.nix { };

  pygments-markdown-lexer = callPackage ../development/python-modules/pygments-markdown-lexer { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygmt = callPackage ../development/python-modules/pygmt { };

  pygobject2 = callPackage ../development/python-modules/pygobject { inherit (pkgs) pkgconfig; };

  pygobject3 = if isPy3k then
    callPackage ../development/python-modules/pygobject/3.nix { inherit (pkgs) meson pkgconfig; }
  else
    callPackage ../development/python-modules/pygobject/3.36.nix { inherit (pkgs) meson pkgconfig; };

  pygogo = callPackage ../development/python-modules/pygogo { };

  pygpgme = callPackage ../development/python-modules/pygpgme { };

  pygraphviz = callPackage ../development/python-modules/pygraphviz {
    inherit (pkgs) graphviz pkgconfig;
  }; # not the python package

  pygreat = callPackage ../development/python-modules/pygreat { };

  pygrok = callPackage ../development/python-modules/pygrok { };

  pygtail = callPackage ../development/python-modules/pygtail { };

  pygtk = callPackage ../development/python-modules/pygtk {
    inherit (pkgs) pkgconfig;
    libglade = null;
  };

  pyGtkGlade = self.pygtk.override { libglade = pkgs.gnome2.libglade; };

  pygtksourceview = callPackage ../development/python-modules/pygtksourceview { inherit (pkgs) pkgconfig; };

  pygtrie = callPackage ../development/python-modules/pygtrie { };

  pyhamcrest = if isPy3k then
    callPackage ../development/python-modules/pyhamcrest { }
  else
    callPackage ../development/python-modules/pyhamcrest/1.nix { };

  pyhaversion = callPackage ../development/python-modules/pyhaversion { };

  pyhcl = callPackage ../development/python-modules/pyhcl { };

  pyhocon = callPackage ../development/python-modules/pyhocon { };

  pyhomematic = callPackage ../development/python-modules/pyhomematic { };

  pyhs100 = callPackage ../development/python-modules/pyhs100 { };

  pyicloud = callPackage ../development/python-modules/pyicloud { };

  PyICU = callPackage ../development/python-modules/pyicu { };

  pyinotify = callPackage ../development/python-modules/pyinotify { };

  pyinputevent = callPackage ../development/python-modules/pyinputevent { };

  pyipp = callPackage ../development/python-modules/pyipp { };

  pyjet = callPackage ../development/python-modules/pyjet { };

  pyjks = callPackage ../development/python-modules/pyjks { };

  pyjson5 = callPackage ../development/python-modules/pyjson5 { };

  pyjwkest = callPackage ../development/python-modules/pyjwkest { };

  pyjwt = callPackage ../development/python-modules/pyjwt { };

  pykdl = callPackage ../development/python-modules/pykdl { };

  pykdtree = callPackage ../development/python-modules/pykdtree { inherit (pkgs.llvmPackages) openmp; };

  pykeepass = callPackage ../development/python-modules/pykeepass { };

  pykerberos = callPackage ../development/python-modules/pykerberos { };

  pykickstart = callPackage ../development/python-modules/pykickstart { };

  pykka = callPackage ../development/python-modules/pykka { };

  pykwalify = callPackage ../development/python-modules/pykwalify { };

  pylama = callPackage ../development/python-modules/pylama { };

  pylast = callPackage ../development/python-modules/pylast { };

  pylatexenc = callPackage ../development/python-modules/pylatexenc { };

  PyLD = callPackage ../development/python-modules/PyLD { };

  pylev = callPackage ../development/python-modules/pylev { };

  pylibacl = if isPy3k then
    callPackage ../development/python-modules/pylibacl { }
  else
    callPackage ../development/python-modules/pylibacl/0.5.nix { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibftdi = callPackage ../development/python-modules/pylibftdi { inherit (pkgs) libusb1; };

  pylibgen = throw "pylibgen is unmaintained upstreamed, and removed from nixpkgs"; # added 2020-06-20

  pyliblo = callPackage ../development/python-modules/pyliblo { };

  pylibmc = callPackage ../development/python-modules/pylibmc { };

  pylint-celery = callPackage ../development/python-modules/pylint-celery { };

  pylint-django = callPackage ../development/python-modules/pylint-django { };

  pylint-flask = callPackage ../development/python-modules/pylint-flask { };

  pylint = if isPy3k then
    callPackage ../development/python-modules/pylint { }
  else
    callPackage ../development/python-modules/pylint/1.9.nix { };

  pylint-plugin-utils = callPackage ../development/python-modules/pylint-plugin-utils { };

  py-lru-cache = callPackage ../development/python-modules/py-lru-cache { };

  pylru = callPackage ../development/python-modules/pylru { };

  pyls-black = callPackage ../development/python-modules/pyls-black { };

  pyls-isort = callPackage ../development/python-modules/pyls-isort { };

  pyls-mypy = callPackage ../development/python-modules/pyls-mypy { };

  PyLTI = callPackage ../development/python-modules/pylti { };

  pymacaroons = callPackage ../development/python-modules/pymacaroons { };

  pymaging = callPackage ../development/python-modules/pymaging { };

  pymaging_png = callPackage ../development/python-modules/pymaging_png { };

  pymatgen = callPackage ../development/python-modules/pymatgen { };

  pymatgen-lammps = callPackage ../development/python-modules/pymatgen-lammps { };

  pymavlink = callPackage ../development/python-modules/pymavlink { };

  pymbolic = callPackage ../development/python-modules/pymbolic { };

  pymc3 = callPackage ../development/python-modules/pymc3 { };

  pymediainfo = callPackage ../development/python-modules/pymediainfo { };

  pymeeus = callPackage ../development/python-modules/pymeeus { };

  pymemoize = callPackage ../development/python-modules/pymemoize { };

  pyment = callPackage ../development/python-modules/pyment { };

  pymetar = callPackage ../development/python-modules/pymetar { };

  pymetno = callPackage ../development/python-modules/pymetno { };

  pymongo = callPackage ../development/python-modules/pymongo { };

  pympler = callPackage ../development/python-modules/pympler { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pymssql = throw "pymssql has been abandoned upstream."; # added 2020-05-04

  py-multibase = callPackage ../development/python-modules/py-multibase { };

  py-multihash = callPackage ../development/python-modules/py-multihash { };

  pymumble = callPackage ../development/python-modules/pymumble { };

  pymupdf = callPackage ../development/python-modules/pymupdf { };

  PyMVGLive = callPackage ../development/python-modules/pymvglive { };

  pymysql = callPackage ../development/python-modules/pymysql { };

  pymysqlsa = callPackage ../development/python-modules/pymysqlsa { };

  pymystem3 = callPackage ../development/python-modules/pymystem3 { };

  pynac = callPackage ../development/python-modules/pynac { };

  pynacl = callPackage ../development/python-modules/pynacl { };

  pynamecheap = callPackage ../development/python-modules/pynamecheap { };

  pynamodb = callPackage ../development/python-modules/pynamodb { };

  pynanoleaf = callPackage ../development/python-modules/pynanoleaf { };

  pync = callPackage ../development/python-modules/pync { };

  pynest2d = callPackage ../development/python-modules/pynest2d { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pynmea2 = callPackage ../development/python-modules/pynmea2 { };

  pynput = callPackage ../development/python-modules/pynput { };

  pynrrd = callPackage ../development/python-modules/pynrrd { };

  pynvim = callPackage ../development/python-modules/pynvim { };

  pynvml = callPackage ../development/python-modules/pynvml { };

  pynzb = callPackage ../development/python-modules/pynzb { };

  pyobjc = if stdenv.isDarwin then
    callPackage ../development/python-modules/pyobjc { }
  else
    throw "pyobjc can only be built on Mac OS";

  pyocr = callPackage ../development/python-modules/pyocr {
    tesseract = pkgs.tesseract4;
  };

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyogg = callPackage ../development/python-modules/pyogg { };

  pyomo = callPackage ../development/python-modules/pyomo { };

  phonemizer = callPackage ../development/python-modules/phonemizer { };

  pyopencl = callPackage ../development/python-modules/pyopencl { };

  pyopengl = callPackage ../development/python-modules/pyopengl { };

  pyopenssl = callPackage ../development/python-modules/pyopenssl { };

  pyosf = callPackage ../development/python-modules/pyosf { };

  pyosmium = callPackage ../development/python-modules/pyosmium { };

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

  pypcap = callPackage ../development/python-modules/pypcap { };

  pypdf2 = callPackage ../development/python-modules/pypdf2 { };

  pyPdf = callPackage ../development/python-modules/pypdf { };

  pypeg2 = callPackage ../development/python-modules/pypeg2 { };

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pyperf = callPackage ../development/python-modules/pyperf { };

  pyphen = callPackage ../development/python-modules/pyphen { };

  pyphotonfile = callPackage ../development/python-modules/pyphotonfile { };

  pypillowfight = callPackage ../development/python-modules/pypillowfight { };

  pyplatec = callPackage ../development/python-modules/pyplatec { };

  pypoppler = callPackage ../development/python-modules/pypoppler { };

  pyppeteer = callPackage ../development/python-modules/pyppeteer { };

  pyprind = callPackage ../development/python-modules/pyprind { };

  pyprof2calltree = callPackage ../development/python-modules/pyprof2calltree { };

  pyproj = callPackage ../development/python-modules/pyproj { };

  pyptlib = callPackage ../development/python-modules/pyptlib { };

  pypubsub = callPackage ../development/python-modules/pypubsub { };

  pypugjs = callPackage ../development/python-modules/pypugjs { };

  pyqrcode = callPackage ../development/python-modules/pyqrcode { };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix { inherit (pkgs) pkgconfig; };

  pyqt5 = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt/5.x.nix { pythonPackages = self; };

  pyqt5_with_qtmultimedia = self.pyqt5.override { withMultimedia = true; };

  /*
    `pyqt5_with_qtwebkit` should not be used by python libraries in
    pkgs/development/python-modules/*. Putting this attribute in
    `propagatedBuildInputs` may cause collisions.
  */
  pyqt5_with_qtwebkit = self.pyqt5.override { withWebKit = true; };

  pyqtgraph = callPackage ../development/python-modules/pyqtgraph { };

  pyqtwebengine = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtwebengine { pythonPackages = self; };

  pyquery = callPackage ../development/python-modules/pyquery { };

  pyrabbit2 = callPackage ../development/python-modules/pyrabbit2 { };

  pyrad = callPackage ../development/python-modules/pyrad { };

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

  pyregion = callPackage ../development/python-modules/pyregion { };

  pyreport = callPackage ../development/python-modules/pyreport { };

  pyres = callPackage ../development/python-modules/pyres { };

  pyRFC3339 = callPackage ../development/python-modules/pyrfc3339 { };

  PyRMVtransport = callPackage ../development/python-modules/PyRMVtransport { };

  Pyro4 = callPackage ../development/python-modules/pyro4 { };

  Pyro5 = callPackage ../development/python-modules/pyro5 { };

  pyroma = callPackage ../development/python-modules/pyroma { };

  pyro-api = callPackage ../development/python-modules/pyro-api { };

  pyro-ppl = callPackage ../development/python-modules/pyro-ppl { };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pyrsistent = callPackage ../development/python-modules/pyrsistent { };

  PyRSS2Gen = callPackage ../development/python-modules/pyrss2gen { };

  pyrtlsdr = callPackage ../development/python-modules/pyrtlsdr { };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = callPackage ../development/python-modules/pysaml2 { inherit (pkgs) xmlsec; };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscard = callPackage ../development/python-modules/pyscard { inherit (pkgs.darwin.apple_sdk.frameworks) PCSC; };

  pyschedule = callPackage ../development/python-modules/pyschedule { };

  pyscreenshot = callPackage ../development/python-modules/pyscreenshot { };

  py_scrypt = callPackage ../development/python-modules/py_scrypt { };

  pyscrypt = callPackage ../development/python-modules/pyscrypt { };

  pyscss = callPackage ../development/python-modules/pyscss { };

  pysdl2 = callPackage ../development/python-modules/pysdl2 { };

  pysendfile = callPackage ../development/python-modules/pysendfile { };

  pysensors = callPackage ../development/python-modules/pysensors { };

  pyserial-asyncio = callPackage ../development/python-modules/pyserial-asyncio { };

  pyserial = callPackage ../development/python-modules/pyserial { };

  pysftp = callPackage ../development/python-modules/pysftp { };

  pysha3 = callPackage ../development/python-modules/pysha3 { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pyside2-tools =
    toPythonModule (callPackage ../development/python-modules/pyside2-tools { inherit (pkgs) cmake qt5; });

  pyside2 = toPythonModule (callPackage ../development/python-modules/pyside2 { inherit (pkgs) cmake ninja qt5; });

  pyside = callPackage ../development/python-modules/pyside { inherit (pkgs) mesa; };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix { inherit (pkgs) libxml2 libxslt; };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pysigset = callPackage ../development/python-modules/pysigset { };

  pysingleton = callPackage ../development/python-modules/pysingleton { };

  pyslurm = callPackage ../development/python-modules/pyslurm { slurm = pkgs.slurm; };

  pysmb = callPackage ../development/python-modules/pysmb { };

  pysmbc = callPackage ../development/python-modules/pysmbc { inherit (pkgs) pkgconfig; };

  pysmf = callPackage ../development/python-modules/pysmf { };

  pysmi = callPackage ../development/python-modules/pysmi { };

  pysnmp = callPackage ../development/python-modules/pysnmp { };

  pysnooper = callPackage ../development/python-modules/pysnooper { };

  pysnow = callPackage ../development/python-modules/pysnow { };

  pysocks = callPackage ../development/python-modules/pysocks { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  py-sonic = callPackage ../development/python-modules/py-sonic { };

  pysonos = callPackage ../development/python-modules/pysonos { };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pyspark = callPackage ../development/python-modules/pyspark { };

  pysparse = callPackage ../development/python-modules/pysparse { };

  pyspf = callPackage ../development/python-modules/pyspf { };

  pyspice = callPackage ../development/python-modules/pyspice { };

  pyspinel = callPackage ../development/python-modules/pyspinel { };

  pyspotify = callPackage ../development/python-modules/pyspotify { };

  pyspread = callPackage ../development/python-modules/pyspread { };

  pysptk = callPackage ../development/python-modules/pysptk { };

  pysqlite = callPackage ../development/python-modules/pysqlite { };

  pysqueezebox = callPackage ../development/python-modules/pysqueezebox { };

  pysrim = callPackage ../development/python-modules/pysrim { };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pyssim = callPackage ../development/python-modules/pyssim { };

  pystache = callPackage ../development/python-modules/pystache { };

  pystemd = callPackage ../development/python-modules/pystemd { systemd = pkgs.systemd; };

  PyStemmer = callPackage ../development/python-modules/pystemmer { };

  pystray = callPackage ../development/python-modules/pystray { };

  py_stringmatching = callPackage ../development/python-modules/py_stringmatching { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pysvn = callPackage ../development/python-modules/pysvn {
    inherit (pkgs) bash subversion apr aprutil expat neon openssl;
  };

  pytabix = callPackage ../development/python-modules/pytabix { };

  pytado = callPackage ../development/python-modules/pytado { };

  pytaglib = callPackage ../development/python-modules/pytaglib { };

  pyte = callPackage ../development/python-modules/pyte { };

  pytelegrambotapi = callPackage ../development/python-modules/pyTelegramBotAPI { };

  pytesseract = callPackage ../development/python-modules/pytesseract { };

  # pytest>=6 is too new for most packages
  pytest = if isPy3k then self.pytest_6 else self.pytest_4;

  pytest_4 = callPackage
    ../development/python-modules/pytest/4.nix { # hypothesis tests require pytest that causes dependency cycle
      hypothesis = self.hypothesis.override { doCheck = false; };
    };

  pytest_5 = callPackage
    ../development/python-modules/pytest/5.nix { # hypothesis tests require pytest that causes dependency cycle
      hypothesis = self.hypothesis.override { doCheck = false; };
    };

  pytest_6 =
    callPackage ../development/python-modules/pytest { # hypothesis tests require pytest that causes dependency cycle
      hypothesis = self.hypothesis.override { doCheck = false; };
    };

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

  pytestcache = callPackage ../development/python-modules/pytestcache { };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-celery = callPackage ../development/python-modules/pytest-celery { };

  pytest-check = callPackage ../development/python-modules/pytest-check { };

  pytest-click = callPackage ../development/python-modules/pytest-click { };

  pytestcov = callPackage ../development/python-modules/pytest-cov { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datadir = callPackage ../development/python-modules/pytest-datadir { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-doctestplus = callPackage ../development/python-modules/pytest-doctestplus { };

  pytest-env = callPackage ../development/python-modules/pytest-env { };

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

  pyopengl-accelerate = callPackage ../development/python-modules/pyopengl-accelerate { };

  pytest-html = callPackage ../development/python-modules/pytest-html { };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-lazy-fixture = callPackage ../development/python-modules/pytest-lazy-fixture { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-metadata = callPackage ../development/python-modules/pytest-metadata { };

  pytest-mock = if isPy3k then
    callPackage ../development/python-modules/pytest-mock { }
  else
    callPackage ../development/python-modules/pytest-mock/2.nix { };

  pytest-mpl = callPackage ../development/python-modules/pytest-mpl { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-openfiles = callPackage ../development/python-modules/pytest-openfiles { };

  pytest-ordering = callPackage ../development/python-modules/pytest-ordering { };

  pytest-pep257 = callPackage ../development/python-modules/pytest-pep257 { };

  pytestpep8 = throw "pytestpep8 was removed because it is abandoned and no longer compatible with pytest v6.0"; # added 2020-12-10

  pytest-pylint = callPackage ../development/python-modules/pytest-pylint { };

  pytest-pythonpath = callPackage ../development/python-modules/pytest-pythonpath { };

  pytest-qt = callPackage ../development/python-modules/pytest-qt { };

  pytestquickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-randomly = callPackage ../development/python-modules/pytest-randomly { };

  pytest-random-order = callPackage ../development/python-modules/pytest-random-order { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-remotedata = callPackage ../development/python-modules/pytest-remotedata { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytestrunner = callPackage ../development/python-modules/pytestrunner { };

  pytest-sanic = callPackage ../development/python-modules/pytest-sanic { };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-services = callPackage ../development/python-modules/pytest-services { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  pytest-socket = callPackage ../development/python-modules/pytest-socket { };

  pytest-subtesthack = callPackage ../development/python-modules/pytest-subtesthack { };

  pytest-subtests = callPackage ../development/python-modules/pytest-subtests { };

  pytest-sugar = callPackage ../development/python-modules/pytest-sugar { };

  pytest-testmon = callPackage ../development/python-modules/pytest-testmon { };

  pytest-timeout = callPackage ../development/python-modules/pytest-timeout { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  pytest-tornasync = callPackage ../development/python-modules/pytest-tornasync { };

  pytest-trio = callPackage ../development/python-modules/pytest-trio { };

  pytest-twisted = callPackage ../development/python-modules/pytest-twisted { };

  pytest-virtualenv = callPackage ../development/python-modules/pytest-virtualenv { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytest-watch = callPackage ../development/python-modules/pytest-watch { };

  pytest_xdist = if isPy27 then
    callPackage ../development/python-modules/pytest-xdist/1.nix { }
  else
    callPackage ../development/python-modules/pytest-xdist { };

  pytest-xprocess = callPackage ../development/python-modules/pytest-xprocess { };

  pytest-xvfb = callPackage ../development/python-modules/pytest-xvfb { };

  python2-pythondialog = callPackage ../development/python-modules/python2-pythondialog { };

  python3-openid = callPackage ../development/python-modules/python3-openid { };

  python-axolotl = callPackage ../development/python-modules/python-axolotl { };

  python-axolotl-curve25519 = callPackage ../development/python-modules/python-axolotl-curve25519 { };

  python-baseconv = callPackage ../development/python-modules/python-baseconv { };

  python-bidi = callPackage ../development/python-modules/python-bidi { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-constraint = callPackage ../development/python-modules/python-constraint { };

  python-crontab = callPackage ../development/python-modules/python-crontab { };

  python-ctags3 = callPackage ../development/python-modules/python-ctags3 { };

  python-daemon = callPackage ../development/python-modules/python-daemon { };

  python-dateutil = callPackage ../development/python-modules/dateutil { };
  # Alias that we should deprecate
  dateutil = self.python-dateutil;

  python-dbusmock = callPackage ../development/python-modules/python-dbusmock { };

  pythondialog = callPackage ../development/python-modules/pythondialog { };

  python-didl-lite = callPackage ../development/python-modules/python-didl-lite { };

  python-docx = callPackage ../development/python-modules/python-docx { };

  python-doi = callPackage ../development/python-modules/python-doi { };

  python-dotenv = callPackage ../development/python-modules/python-dotenv { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  pythonefl = callPackage ../development/python-modules/python-efl { inherit (pkgs) pkgconfig; };

  python-engineio = callPackage ../development/python-modules/python-engineio { };

  python-etcd = callPackage ../development/python-modules/python-etcd { };

  python_fedora = callPackage ../development/python-modules/python_fedora { };

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  python-forecastio = callPackage ../development/python-modules/python-forecastio { };

  python-frontmatter = callPackage ../development/python-modules/python-frontmatter { };

  python-gitlab = callPackage ../development/python-modules/python-gitlab { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-igraph = callPackage ../development/python-modules/python-igraph {
    pkgconfig = pkgs.pkgconfig;
    igraph = pkgs.igraph;
  };

  pythonIRClib = callPackage ../development/python-modules/pythonirclib { };

  pythonix = callPackage ../development/python-modules/pythonix { inherit (pkgs) meson pkgconfig; };

  python-jenkins = callPackage ../development/python-modules/python-jenkins { };

  python-jose = callPackage ../development/python-modules/python-jose { };

  python-json-logger = callPackage ../development/python-modules/python-json-logger { };

  python-jsonrpc-server = callPackage ../development/python-modules/python-jsonrpc-server { };

  python_keyczar = callPackage ../development/python-modules/python_keyczar { };

  python-language-server = callPackage ../development/python-modules/python-language-server { };

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

  python-Levenshtein = callPackage ../development/python-modules/python-levenshtein { };

  python-logstash = callPackage ../development/python-modules/python-logstash { };

  python-ly = callPackage ../development/python-modules/python-ly { };

  python-lz4 = callPackage ../development/python-modules/python-lz4 { };

  python-lzf = callPackage ../development/python-modules/python-lzf { };

  python-lzo = callPackage ../development/python-modules/python-lzo { inherit (pkgs) lzo; };

  python_magic = callPackage ../development/python-modules/python-magic { };

  pythonmagick = callPackage ../development/python-modules/pythonmagick { };

  python-mapnik = callPackage ../development/python-modules/python-mapnik { };

  python-markdown-math = callPackage ../development/python-modules/python-markdown-math { };

  python-miio = callPackage ../development/python-modules/python-miio { };

  python_mimeparse = callPackage ../development/python-modules/python_mimeparse { };

  python-mnist = callPackage ../development/python-modules/python-mnist { };

  python-mpv-jsonipc = callPackage ../development/python-modules/python-mpv-jsonipc { };

  python-multipart = callPackage ../development/python-modules/python-multipart { };

  python-nest = callPackage ../development/python-modules/python-nest { };

  pythonnet = callPackage
    ../development/python-modules/pythonnet { # `mono >= 4.6` required to prevent crashes encountered with earlier versions.
      mono = pkgs.mono4;
      inherit (pkgs) pkgconfig;
    };

  python-nomad = callPackage ../development/python-modules/python-nomad { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  pythonocc-core =
    toPythonModule (callPackage ../development/python-modules/pythonocc-core { inherit (pkgs.xorg) libX11; });

  python-olm = callPackage ../development/python-modules/python-olm { };

  python_openzwave = callPackage ../development/python-modules/python_openzwave { inherit (pkgs) pkgconfig; };

  python-otr = callPackage ../development/python-modules/python-otr { };

  python-packer = callPackage ../development/python-modules/python-packer { };

  python-pam = callPackage ../development/python-modules/python-pam {
    inherit (pkgs) pam;
  };

  python-periphery = callPackage ../development/python-modules/python-periphery { };

  python-pipedrive = callPackage ../development/python-modules/python-pipedrive { };

  python-prctl = callPackage ../development/python-modules/python-prctl { };

  python-ptrace = callPackage ../development/python-modules/python-ptrace { };

  python-pushover = callPackage ../development/python-modules/pushover { };

  python-rapidjson = callPackage ../development/python-modules/python-rapidjson { };

  python-redis-lock = callPackage ../development/python-modules/python-redis-lock { };

  python-rtmidi = callPackage ../development/python-modules/python-rtmidi { };

  python-sat = callPackage ../development/python-modules/python-sat { };

  python-simple-hipchat = callPackage ../development/python-modules/python-simple-hipchat { };
  python_simple_hipchat = self.python-simple-hipchat;

  python-slugify = callPackage ../development/python-modules/python-slugify { };

  python-snap7 = callPackage ../development/python-modules/python-snap7 {
    inherit (pkgs) snap7;
  };

  python-snappy = callPackage ../development/python-modules/python-snappy { inherit (pkgs) snappy; };

  python-socketio = callPackage ../development/python-modules/python-socketio { };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python_statsd = callPackage ../development/python-modules/python_statsd { };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-sybase = callPackage ../development/python-modules/sybase { };

  python-telegram-bot = callPackage ../development/python-modules/python-telegram-bot { };

  python-toolbox = callPackage ../development/python-modules/python-toolbox { };

  python-twitter = callPackage ../development/python-modules/python-twitter { };

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  python-uinput = callPackage ../development/python-modules/python-uinput { };

  python-unshare = callPackage ../development/python-modules/python-unshare { };

  python-utils = callPackage ../development/python-modules/python-utils { };

  python-vagrant = callPackage ../development/python-modules/python-vagrant { };

  python-vipaccess = callPackage ../development/python-modules/python-vipaccess { };

  python-vlc = callPackage ../development/python-modules/python-vlc { };

  python-wifi = callPackage ../development/python-modules/python-wifi { };

  python-xmp-toolkit = callPackage ../development/python-modules/python-xmp-toolkit { };

  pytimeparse = callPackage ../development/python-modules/pytimeparse { };

  pytmx = callPackage ../development/python-modules/pytmx { };

  pytoml = callPackage ../development/python-modules/pytoml { };

  pytools = callPackage ../development/python-modules/pytools { };

  pytorch = callPackage ../development/python-modules/pytorch { cudaSupport = pkgs.config.cudaSupport or false; };

  pytorch-bin = callPackage ../development/python-modules/pytorch/bin.nix {
    inherit (pkgs.linuxPackages) nvidia_x11;
  };

  pytorch-lightning = callPackage ../development/python-modules/pytorch-lightning { };

  pytorch-metric-learning = callPackage ../development/python-modules/pytorch-metric-learning { };

  pytorchWithCuda = self.pytorch.override { cudaSupport = true; };

  pytorchWithoutCuda = self.pytorch.override { cudaSupport = false; };

  pytrends = callPackage ../development/python-modules/pytrends { };

  pytricia = callPackage ../development/python-modules/pytricia { };

  pytun = callPackage ../development/python-modules/pytun { };

  pytz = callPackage ../development/python-modules/pytz { };

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

  pyudev = callPackage ../development/python-modules/pyudev { inherit (pkgs) systemd; };

  pyunbound = callPackage ../tools/networking/unbound/python.nix { };

  pyunifi = callPackage ../development/python-modules/pyunifi { };

  pyupdate = callPackage ../development/python-modules/pyupdate { };

  pyusb = callPackage ../development/python-modules/pyusb { libusb1 = pkgs.libusb1; };

  pyutil = callPackage ../development/python-modules/pyutil { };

  pyutilib = callPackage ../development/python-modules/pyutilib { };

  pyuv = callPackage ../development/python-modules/pyuv { };

  py-vapid = callPackage ../development/python-modules/py-vapid { };

  pyvcd = callPackage ../development/python-modules/pyvcd { };

  pyvcf = callPackage ../development/python-modules/pyvcf { };

  pyviz-comms = callPackage ../development/python-modules/pyviz-comms { };

  pyvips = callPackage ../development/python-modules/pyvips {
    inherit (pkgs) pkg-config vips glib;
  };

  pyvmomi = callPackage ../development/python-modules/pyvmomi { };

  pyvoro = callPackage ../development/python-modules/pyvoro { };

  pywal = callPackage ../development/python-modules/pywal { };

  pywatchman = callPackage ../development/python-modules/pywatchman { };

  pywavelets = callPackage ../development/python-modules/pywavelets { };

  # We need "normal" libxml2 and not the python package by the same name.
  pywbem = callPackage ../development/python-modules/pywbem { libxml2 = pkgs.libxml2; };

  PyWebDAV = callPackage ../development/python-modules/pywebdav { };

  pywebpush = callPackage ../development/python-modules/pywebpush { };

  pywebview = callPackage ../development/python-modules/pywebview { };

  pywick = callPackage ../development/python-modules/pywick { };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pyxattr = let
    pyxattr' = callPackage ../development/python-modules/pyxattr { };
    pyxattr_2 = pyxattr'.overridePythonAttrs (oldAttrs: rec {
      version = "0.6.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "b525843f6b51036198b3b87c4773a5093d6dec57d60c18a1f269dd7059aa16e3";
      };
    });
  in if isPy3k then pyxattr' else pyxattr_2;

  pyx = callPackage ../development/python-modules/pyx { };

  pyxdg = callPackage ../development/python-modules/pyxdg { };

  pyxl3 = callPackage ../development/python-modules/pyxl3 { };

  pyxml = disabledIf isPy3k (callPackage ../development/python-modules/pyxml { });

  pyxnat = callPackage ../development/python-modules/pyxnat { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  pyzmq = callPackage ../development/python-modules/pyzmq { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  qasm2image = throw "qasm2image is no longer maintained (since November 2018), and is not compatible with the latest pythonPackages.qiskit versions."; # added 2020-12-09

  qdarkstyle = callPackage ../development/python-modules/qdarkstyle { };

  qds_sdk = callPackage ../development/python-modules/qds_sdk { };

  qimage2ndarray = callPackage ../development/python-modules/qimage2ndarray { };

  qiskit-aer = callPackage ../development/python-modules/qiskit-aer { };

  qiskit-aqua = callPackage ../development/python-modules/qiskit-aqua { };

  qiskit = callPackage ../development/python-modules/qiskit { };

  qiskit-ibmq-provider = callPackage ../development/python-modules/qiskit-ibmq-provider { };

  qiskit-ignis = callPackage ../development/python-modules/qiskit-ignis { };

  qiskit-terra = callPackage ../development/python-modules/qiskit-terra { };

  qpid-python = callPackage ../development/python-modules/qpid-python { };

  qrcode = callPackage ../development/python-modules/qrcode { };

  qreactor = callPackage ../development/python-modules/qreactor { };

  qscintilla-qt4 = callPackage ../development/python-modules/qscintilla { };

  qscintilla-qt5 = pkgs.libsForQt5.callPackage ../development/python-modules/qscintilla-qt5 { pythonPackages = self; };

  qscintilla = self.qscintilla-qt4;

  qserve = callPackage ../development/python-modules/qserve { };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  quamash = callPackage ../development/python-modules/quamash { };

  quandl = callPackage ../development/python-modules/quandl { };

  Quandl =
    callPackage ../development/python-modules/quandl { }; # alias for an older package which did not support Python 3

  quantities = callPackage ../development/python-modules/quantities { };

  querystring_parser = callPackage ../development/python-modules/querystring-parser { };

  queuelib = callPackage ../development/python-modules/queuelib { };

  r2pipe = callPackage ../development/python-modules/r2pipe { };

  rabbitpy = callPackage ../development/python-modules/rabbitpy { };

  radicale_infcloud = callPackage ../development/python-modules/radicale_infcloud { };

  radio_beam = callPackage ../development/python-modules/radio_beam { };

  radish-bdd = callPackage ../development/python-modules/radish-bdd { };

  rainbowstream = callPackage ../development/python-modules/rainbowstream { };

  ramlfications = callPackage ../development/python-modules/ramlfications { };

  random2 = callPackage ../development/python-modules/random2 { };

  rarfile = callPackage ../development/python-modules/rarfile { inherit (pkgs) libarchive; };

  rasterio = callPackage ../development/python-modules/rasterio { gdal = pkgs.gdal_2; }; # gdal 3.0 not supported yet

  ratelimiter = callPackage ../development/python-modules/ratelimiter { };

  raven = callPackage ../development/python-modules/raven { };

  rawkit = callPackage ../development/python-modules/rawkit { };

  rbtools = callPackage ../development/python-modules/rbtools { };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  rdflib-jsonld = callPackage ../development/python-modules/rdflib-jsonld { };

  re-assert = callPackage ../development/python-modules/re-assert { };

  readchar = callPackage ../development/python-modules/readchar { };

  readme = callPackage ../development/python-modules/readme { };

  readme_renderer = callPackage ../development/python-modules/readme_renderer { };

  readthedocs-sphinx-ext = callPackage ../development/python-modules/readthedocs-sphinx-ext { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  recaptcha_client = callPackage ../development/python-modules/recaptcha_client { };

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  redbaron = callPackage ../development/python-modules/redbaron { };

  redis = callPackage ../development/python-modules/redis { };

  rednose = callPackage ../development/python-modules/rednose { };

  reedsolo = callPackage ../development/python-modules/reedsolo { };

  regex = callPackage ../development/python-modules/regex { };

  regional = callPackage ../development/python-modules/regional { };

  reikna = callPackage ../development/python-modules/reikna { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  remotecv = callPackage ../development/python-modules/remotecv { };

  rencode = callPackage ../development/python-modules/rencode { };

  repeated_test = callPackage ../development/python-modules/repeated_test { };

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

  requests-http-signature = callPackage ../development/python-modules/requests-http-signature { };

  requests-kerberos = callPackage ../development/python-modules/requests-kerberos { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  requests_ntlm = callPackage ../development/python-modules/requests_ntlm { };

  requests_oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };

  requests_toolbelt = self.requests-toolbelt; # Old attr, 2017-09-26

  requests-unixsocket = callPackage ../development/python-modules/requests-unixsocket { };

  requirements-detector = callPackage ../development/python-modules/requirements-detector { };

  resampy = callPackage ../development/python-modules/resampy { };

  responses = callPackage ../development/python-modules/responses { };

  restrictedpython = callPackage ../development/python-modules/restrictedpython { };

  restructuredtext_lint = callPackage ../development/python-modules/restructuredtext_lint { };

  restview = callPackage ../development/python-modules/restview { };

  rethinkdb = callPackage ../development/python-modules/rethinkdb { };

  retry = callPackage ../development/python-modules/retry { };

  retry_decorator = callPackage ../development/python-modules/retry_decorator { };

  retrying = callPackage ../development/python-modules/retrying { };

  retworkx = disabledIf (pythonOlder "3.5") (toPythonModule (callPackage ../development/python-modules/retworkx { }));

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  rfc3987 = callPackage ../development/python-modules/rfc3987 { };

  rfc6555 = callPackage ../development/python-modules/rfc6555 { };

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  rhpl = disabledIf isPy3k (callPackage ../development/python-modules/rhpl { });

  rich = callPackage ../development/python-modules/rich { };

  rig = callPackage ../development/python-modules/rig { };

  ripser = callPackage ../development/python-modules/ripser { };

  rising = callPackage ../development/python-modules/rising { };

  rivet = disabledIf (!isPy3k) (toPythonModule (pkgs.rivet.override { python3 = python; }));

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  rl-coach = callPackage ../development/python-modules/rl-coach { };

  rlp = callPackage ../development/python-modules/rlp { };

  rnc2rng = callPackage ../development/python-modules/rnc2rng { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  roboschool = callPackage ../development/python-modules/roboschool {
    inherit (pkgs) pkgconfig; # use normal pkgconfig, not the python package
    inherit (pkgs.qt5) qtbase;
  };

  robot-detection = callPackage ../development/python-modules/robot-detection { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-databaselibrary = callPackage ../development/python-modules/robotframework-databaselibrary { };

  robotframework-requests = callPackage ../development/python-modules/robotframework-requests { };

  robotframework-ride = callPackage ../development/python-modules/robotframework-ride { };

  robotframework-selenium2library = callPackage ../development/python-modules/robotframework-selenium2library { };

  robotframework-seleniumlibrary = callPackage ../development/python-modules/robotframework-seleniumlibrary { };

  robotframework-sshlibrary = callPackage ../development/python-modules/robotframework-sshlibrary { };

  robotframework-tools = callPackage ../development/python-modules/robotframework-tools { };

  robotstatuschecker = callPackage ../development/python-modules/robotstatuschecker { };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  rocket-errbot = callPackage ../development/python-modules/rocket-errbot { };

  roku = callPackage ../development/python-modules/roku { };

  roman = callPackage ../development/python-modules/roman { };

  rope = callPackage ../development/python-modules/rope { };

  ROPGadget = callPackage ../development/python-modules/ROPGadget { };

  ropper = callPackage ../development/python-modules/ropper { };

  rotate-backups = callPackage ../tools/backup/rotate-backups { };

  routes = callPackage ../development/python-modules/routes { };

  rpdb = callPackage ../development/python-modules/rpdb { };

  rpkg = callPackage ../development/python-modules/rpkg { };

  rply = callPackage ../development/python-modules/rply { };

  rpm = disabledIf (!isPy3k) (toPythonModule (pkgs.rpm.override { inherit python; }));

  rpmfluff = callPackage ../development/python-modules/rpmfluff { };

  rpy2 = if isPy3k then
    callPackage ../development/python-modules/rpy2 { }
  else
    callPackage ../development/python-modules/rpy2/2.nix { };

  rpyc = callPackage ../development/python-modules/rpyc { };

  rq = callPackage ../development/python-modules/rq { };

  rsa = if isPy3k then
    callPackage ../development/python-modules/rsa { }
  else
    callPackage ../development/python-modules/rsa/4_0.nix { };

  rtmidi-python = callPackage ../development/python-modules/rtmidi-python { };

  Rtree = callPackage ../development/python-modules/Rtree { inherit (pkgs) libspatialindex; };

  rtslib = callPackage ../development/python-modules/rtslib { };

  ruamel_base = callPackage ../development/python-modules/ruamel_base { };

  ruamel_ordereddict = callPackage ../development/python-modules/ruamel_ordereddict { };

  ruamel_yaml = callPackage ../development/python-modules/ruamel_yaml { };

  ruamel_yaml_clib = callPackage ../development/python-modules/ruamel_yaml_clib { };

  rubymarshal = callPackage ../development/python-modules/rubymarshal { };

  ruffus = callPackage ../development/python-modules/ruffus { };

  runsnakerun = callPackage ../development/python-modules/runsnakerun { };

  runway-python = callPackage ../development/python-modules/runway-python { };

  rx = callPackage ../development/python-modules/rx { };

  rxv = callPackage ../development/python-modules/rxv { };

  s2clientprotocol = callPackage ../development/python-modules/s2clientprotocol { };

  s3fs = callPackage ../development/python-modules/s3fs { };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  sabyenc3 = callPackage ../development/python-modules/sabyenc3 { };

  sabyenc = callPackage ../development/python-modules/sabyenc { };

  sacn = callPackage ../development/python-modules/sacn { };

  sacremoses = callPackage ../development/python-modules/sacremoses { };

  safe = callPackage ../development/python-modules/safe { };

  safety = callPackage ../development/python-modules/safety { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  sampledata = callPackage ../development/python-modules/sampledata { };

  samplerate = callPackage ../development/python-modules/samplerate { };

  samsungctl = callPackage ../development/python-modules/samsungctl { };

  samsungtvws = callPackage ../development/python-modules/samsungtvws { };

  sandboxlib = callPackage ../development/python-modules/sandboxlib { };

  sanic-auth = callPackage ../development/python-modules/sanic-auth { };

  sanic = callPackage ../development/python-modules/sanic { };

  sapi-python-client = callPackage ../development/python-modules/sapi-python-client { };

  sarge = callPackage ../development/python-modules/sarge { };

  sasmodels = callPackage ../development/python-modules/sasmodels { };

  scales = callPackage ../development/python-modules/scales { };

  scandir = callPackage ../development/python-modules/scandir { };

  scapy = callPackage ../development/python-modules/scapy { };

  schedule = callPackage ../development/python-modules/schedule { };

  schema = callPackage ../development/python-modules/schema { };

  scikit-bio = callPackage ../development/python-modules/scikit-bio { };

  scikit-build = callPackage ../development/python-modules/scikit-build { };

  scikit-fmm = callPackage ../development/python-modules/scikit-fmm { };

  scikit-fuzzy = callPackage ../development/python-modules/scikit-fuzzy { };

  scikitimage = callPackage ../development/python-modules/scikit-image { };

  scikitlearn = let args = { inherit (pkgs) gfortran glibcLocales; };
  in if isPy3k then
    callPackage ../development/python-modules/scikitlearn args
  else
    callPackage ../development/python-modules/scikitlearn/0.20.nix args;

  scikit-optimize = callPackage ../development/python-modules/scikit-optimize { };

  scikits-odes = callPackage ../development/python-modules/scikits-odes { };

  scikit-tda = callPackage ../development/python-modules/scikit-tda { };

  scipy_1_3 = self.scipy.overridePythonAttrs (oldAttrs: rec {
    version = "1.3.3";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "02iqb7ws7fw5fd1a83hx705pzrw1imj7z0bphjsl4bfvw254xgv4";
    };
    doCheck = false;
    disabled = !isPy3k;
  });

  scipy_1_4 = self.scipy.overridePythonAttrs (oldAttrs: rec {
    version = "1.4.1";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "0ndw7zyxd2dj37775mc75zm4fcyiipnqxclc45mkpxy8lvrvpqfy";
    };
    doCheck = false;
    disabled = !isPy3k;
  });

  scipy = let
    scipy_ = callPackage ../development/python-modules/scipy { };
    scipy_1_2 = scipy_.overridePythonAttrs (oldAttrs: rec {
      version = "1.2.2";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "a4331e0b8dab1ff75d2c67b5158a8bb9a83c799d7140094dda936d876c7cfbb1";
      };
    });
  in if pythonOlder "3.5" then scipy_1_2 else scipy_;

  scour = callPackage ../development/python-modules/scour { };

  scp = callPackage ../development/python-modules/scp { };

  scramp = callPackage ../development/python-modules/scramp { };

  scrapy = callPackage ../development/python-modules/scrapy { };

  scrapy-deltafetch = callPackage ../development/python-modules/scrapy-deltafetch { };

  scrapy-fake-useragent = callPackage ../development/python-modules/scrapy-fake-useragent { };

  scrapy-splash = callPackage ../development/python-modules/scrapy-splash { };

  screeninfo = callPackage ../development/python-modules/screeninfo { };

  scripttest = callPackage ../development/python-modules/scripttest { };

  scs = callPackage ../development/python-modules/scs { scs = pkgs.scs; };

  sdnotify = callPackage ../development/python-modules/sdnotify { };

  seaborn = if isPy3k then
    callPackage ../development/python-modules/seaborn { }
  else
    callPackage ../development/python-modules/seaborn/0.9.1.nix { };

  seabreeze = callPackage ../development/python-modules/seabreeze { };

  seccomp = callPackage ../development/python-modules/seccomp { };

  secp256k1 = callPackage ../development/python-modules/secp256k1 { inherit (pkgs) secp256k1 pkgconfig; };

  secretstorage = if isPy3k then
    callPackage ../development/python-modules/secretstorage { }
  else
    callPackage ../development/python-modules/secretstorage/2.nix { };

  secure = callPackage ../development/python-modules/secure { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  segments = callPackage ../development/python-modules/segments { };

  selectors2 = callPackage ../development/python-modules/selectors2 { };

  selectors34 = callPackage ../development/python-modules/selectors34 { };

  selenium = callPackage ../development/python-modules/selenium { };

  semantic = callPackage ../development/python-modules/semantic { };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  semver = callPackage ../development/python-modules/semver { };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sentencepiece = callPackage ../development/python-modules/sentencepiece { inherit (pkgs) sentencepiece pkgconfig; };

  sentinel = callPackage ../development/python-modules/sentinel { };

  sentry-sdk = callPackage ../development/python-modules/sentry-sdk { };

  sepaxml = callPackage ../development/python-modules/sepaxml { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  sequoia = disabledIf (isPyPy || !isPy3k) (toPythonModule (pkgs.sequoia.override {
    pythonPackages = self;
    pythonSupport = true;
  }));

  serpent = callPackage ../development/python-modules/serpent { };

  serpy = callPackage ../development/python-modules/serpy { };

  serverlessrepo = callPackage ../development/python-modules/serverlessrepo { };

  serversyncstorage = callPackage ../development/python-modules/serversyncstorage { };

  service-identity = callPackage ../development/python-modules/service_identity { };

  setproctitle = callPackage ../development/python-modules/setproctitle { };

  setuptoolsDarcs = callPackage ../development/python-modules/setuptoolsdarcs { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  setuptools-lint = callPackage ../development/python-modules/setuptools-lint { };

  setuptools-rust = callPackage ../development/python-modules/setuptools-rust { };

  setuptools_scm = callPackage ../development/python-modules/setuptools_scm { };

  setuptools-scm-git-archive = callPackage ../development/python-modules/setuptools-scm-git-archive { };

  setuptoolsTrial = callPackage ../development/python-modules/setuptoolstrial { };

  sexpdata = callPackage ../development/python-modules/sexpdata { };

  sfepy = callPackage ../development/python-modules/sfepy { };

  sgmllib3k = callPackage ../development/python-modules/sgmllib3k { };

  shamir-mnemonic = callPackage ../development/python-modules/shamir-mnemonic { };

  shap = callPackage ../development/python-modules/shap { };

  shapely = callPackage ../development/python-modules/shapely { };

  sharedmem = callPackage ../development/python-modules/sharedmem { };

  sh = callPackage ../development/python-modules/sh { };

  shellingham = callPackage ../development/python-modules/shellingham { };

  shiboken2 =
    toPythonModule (callPackage ../development/python-modules/shiboken2 { inherit (pkgs) cmake llvmPackages qt5; });

  shippai = callPackage ../development/python-modules/shippai { };

  shodan = callPackage ../development/python-modules/shodan { };

  shortuuid = callPackage ../development/python-modules/shortuuid { };

  shouldbe = callPackage ../development/python-modules/shouldbe { };

  should-dsl = callPackage ../development/python-modules/should-dsl { };

  showit = callPackage ../development/python-modules/showit { };

  shutilwhich = callPackage ../development/python-modules/shutilwhich { };

  sievelib = callPackage ../development/python-modules/sievelib { };

  signedjson = callPackage ../development/python-modules/signedjson { };

  sigtools = callPackage ../development/python-modules/sigtools { };

  simanneal = callPackage ../development/python-modules/simanneal { };

  simpleai = callPackage ../development/python-modules/simpleai { };

  simpleaudio = callPackage ../development/python-modules/simpleaudio { };

  simplebayes = callPackage ../development/python-modules/simplebayes { };

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  simplefix = callPackage ../development/python-modules/simplefix { };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simplekml = callPackage ../development/python-modules/simplekml { };

  simpleparse = callPackage ../development/python-modules/simpleparse { };

  simple-salesforce = callPackage ../development/python-modules/simple-salesforce { };

  simple-websocket-server = callPackage ../development/python-modules/simple-websocket-server { };

  simpy = callPackage ../development/python-modules/simpy { };

  singledispatch = callPackage ../development/python-modules/singledispatch { };

  sip = callPackage ../development/python-modules/sip { };

  sipsimple = callPackage ../development/python-modules/sipsimple { };

  six = callPackage ../development/python-modules/six { };

  skein = callPackage ../development/python-modules/skein {
    jre = pkgs.jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  skidl = callPackage ../development/python-modules/skidl { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  skorch = callPackage ../development/python-modules/skorch { };

  slackclient = callPackage ../development/python-modules/slackclient { };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

  slicedimage = callPackage ../development/python-modules/slicedimage { };

  slicer = callPackage ../development/python-modules/slicer { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  slimit = callPackage ../development/python-modules/slimit { };

  slither-analyzer = callPackage ../development/python-modules/slither-analyzer { };

  slixmpp = callPackage ../development/python-modules/slixmpp { inherit (pkgs) gnupg; };

  slob = callPackage ../development/python-modules/slob { };

  slowaes = callPackage ../development/python-modules/slowaes { };

  sly = callPackage ../development/python-modules/sly { };

  smartdc = callPackage ../development/python-modules/smartdc { };

  smart_open = callPackage ../development/python-modules/smart_open { };

  smartypants = callPackage ../development/python-modules/smartypants { };

  smbus-cffi = callPackage ../development/python-modules/smbus-cffi { };

  smmap2 = throw "smmap2 has been deprecated, use smmap instead."; # added 2020-03-14

  smmap = callPackage ../development/python-modules/smmap { };

  smpplib = callPackage ../development/python-modules/smpplib { };

  snack = toPythonModule (pkgs.newt.override { inherit (self) python; });

  snakebite = callPackage ../development/python-modules/snakebite { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  snapcast = callPackage ../development/python-modules/snapcast { };

  snapperGUI = callPackage ../development/python-modules/snappergui { };

  sniffio = callPackage ../development/python-modules/sniffio { };

  snitun = callPackage ../development/python-modules/snitun { };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  snowflake-connector-python = callPackage ../development/python-modules/snowflake-connector-python { };

  snowflake-sqlalchemy = callPackage ../development/python-modules/snowflake-sqlalchemy { };

  snscrape = callPackage ../development/python-modules/snscrape { };

  snug = callPackage ../development/python-modules/snug { };

  snuggs = callPackage ../development/python-modules/snuggs { };

  soapysdr = toPythonModule (pkgs.soapysdr.override {
    python = self.python;
    usePython = true;
  });

  soapysdr-with-plugins = toPythonModule (pkgs.soapysdr-with-plugins.override {
    python = self.python;
    usePython = true;
  });

  sockjs = callPackage ../development/python-modules/sockjs { };

  sockjs-tornado = callPackage ../development/python-modules/sockjs-tornado { };

  socksipy-branch = callPackage ../development/python-modules/socksipy-branch { };

  soco = callPackage ../development/python-modules/soco { };

  softlayer = callPackage ../development/python-modules/softlayer { };

  solo-python = disabledIf (!pythonAtLeast "3.6") (callPackage ../development/python-modules/solo-python { });

  somajo = callPackage ../development/python-modules/somajo { };

  sopel = callPackage ../development/python-modules/sopel { };

  sorl_thumbnail = callPackage ../development/python-modules/sorl_thumbnail { };

  sortedcollections = callPackage ../development/python-modules/sortedcollections { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  sounddevice = callPackage ../development/python-modules/sounddevice { };

  soundfile = callPackage ../development/python-modules/soundfile { };

  soupsieve = if isPy3k then
    callPackage ../development/python-modules/soupsieve { }
  else
    callPackage ../development/python-modules/soupsieve/1.nix { };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy_models = callPackage ../development/python-modules/spacy/models.nix { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  spambayes = callPackage ../development/python-modules/spambayes { };

  spark_parser = callPackage ../development/python-modules/spark_parser { };

  SPARQLWrapper = callPackage ../development/python-modules/sparqlwrapper { };

  sparse = callPackage ../development/python-modules/sparse { };

  speaklater = callPackage ../development/python-modules/speaklater { };

  spectral-cube = callPackage ../development/python-modules/spectral-cube { };

  speedtest-cli = callPackage ../development/python-modules/speedtest-cli { };

  spglib = callPackage ../development/python-modules/spglib { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  sphinxcontrib-applehelp = callPackage ../development/python-modules/sphinxcontrib-applehelp { };

  sphinxcontrib-autoapi = callPackage ../development/python-modules/sphinxcontrib-autoapi { };

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex { };

  sphinxcontrib-blockdiag = callPackage ../development/python-modules/sphinxcontrib-blockdiag { };

  sphinxcontrib-devhelp = callPackage ../development/python-modules/sphinxcontrib-devhelp { };

  sphinxcontrib-fulltoc = callPackage ../development/python-modules/sphinxcontrib-fulltoc { };

  sphinxcontrib-htmlhelp = callPackage ../development/python-modules/sphinxcontrib-htmlhelp { };

  sphinxcontrib_httpdomain = callPackage ../development/python-modules/sphinxcontrib_httpdomain { };

  sphinxcontrib-jsmath = callPackage ../development/python-modules/sphinxcontrib-jsmath { };

  sphinxcontrib-katex = callPackage ../development/python-modules/sphinxcontrib-katex { };

  sphinxcontrib_newsfeed = callPackage ../development/python-modules/sphinxcontrib_newsfeed { };

  sphinxcontrib-openapi = callPackage ../development/python-modules/sphinxcontrib-openapi { };

  sphinxcontrib_plantuml =
    callPackage ../development/python-modules/sphinxcontrib_plantuml { inherit (pkgs) plantuml; };

  sphinxcontrib-qthelp = callPackage ../development/python-modules/sphinxcontrib-qthelp { };

  sphinxcontrib-serializinghtml = callPackage ../development/python-modules/sphinxcontrib-serializinghtml { };

  sphinxcontrib-spelling = callPackage ../development/python-modules/sphinxcontrib-spelling { };

  sphinxcontrib-tikz = callPackage ../development/python-modules/sphinxcontrib-tikz {
    texLive = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small standalone pgfplots; };
  };

  sphinxcontrib-websupport = if isPy3k then
    callPackage ../development/python-modules/sphinxcontrib-websupport { }
  else
    callPackage ../development/python-modules/sphinxcontrib-websupport/1_1.nix { };

  sphinx = if isPy3k then
    callPackage ../development/python-modules/sphinx { }
  else
    callPackage ../development/python-modules/sphinx/2.nix { };

  sphinx-argparse = callPackage ../development/python-modules/sphinx-argparse { };

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  sphinx-navtree = callPackage ../development/python-modules/sphinx-navtree { };

  sphinx_pypi_upload = callPackage ../development/python-modules/sphinx_pypi_upload { };

  sphinx_rtd_theme = callPackage ../development/python-modules/sphinx_rtd_theme { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  spidev = callPackage ../development/python-modules/spidev { };

  splinter = callPackage ../development/python-modules/splinter { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  spyder = callPackage ../development/python-modules/spyder { };
  spyder_3 = callPackage ../development/python-modules/spyder/3.nix { };

  spyder-kernels = callPackage ../development/python-modules/spyder-kernels { };
  spyder-kernels_0_5 = callPackage ../development/python-modules/spyder-kernels/0.x.nix { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy-citext = callPackage ../development/python-modules/sqlalchemy-citext { };

  sqlalchemy-continuum = callPackage ../development/python-modules/sqlalchemy-continuum { };

  sqlalchemy-i18n = callPackage ../development/python-modules/sqlalchemy-i18n { };

  SQLAlchemy-ImageAttach = callPackage ../development/python-modules/sqlalchemy-imageattach { };

  sqlalchemy_migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  sqlalchemy-utils = callPackage ../development/python-modules/sqlalchemy-utils { };

  sqlite3dbm = callPackage ../development/python-modules/sqlite3dbm { };

  sqlitedict = callPackage ../development/python-modules/sqlitedict { };

  sqlite-fts4 = callPackage ../development/python-modules/sqlite-fts4 { };
  sqlite-utils = callPackage ../development/python-modules/sqlite-utils { };

  sqlmap = callPackage ../development/python-modules/sqlmap { };

  sqlobject = callPackage ../development/python-modules/sqlobject { };

  sqlparse = callPackage ../development/python-modules/sqlparse { };

  sqlsoup = callPackage ../development/python-modules/sqlsoup { };

  squaremap = callPackage ../development/python-modules/squaremap { };

  srp = callPackage ../development/python-modules/srp { };

  srptools = callPackage ../development/python-modules/srptools { };

  srsly = callPackage ../development/python-modules/srsly { };

  srvlookup = callPackage ../development/python-modules/srvlookup { };

  ssdeep = callPackage ../development/python-modules/ssdeep { };

  ssdp = callPackage ../development/python-modules/ssdp { };

  sseclient = callPackage ../development/python-modules/sseclient { };

  sseclient-py = callPackage ../development/python-modules/sseclient-py { };

  sshpubkeys = callPackage ../development/python-modules/sshpubkeys { };

  sshtunnel = callPackage ../development/python-modules/sshtunnel { };

  sslib = callPackage ../development/python-modules/sslib { };

  sslyze = callPackage ../development/python-modules/sslyze { };

  stack-data = callPackage ../development/python-modules/stack-data { };

  starlette = callPackage ../development/python-modules/starlette { };

  staticjinja = callPackage ../development/python-modules/staticjinja { };

  statistics = callPackage ../development/python-modules/statistics { };

  statsd = callPackage ../development/python-modules/statsd { };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  stem = callPackage ../development/python-modules/stem { };

  stevedore = callPackage ../development/python-modules/stevedore { };

  stm32loader = callPackage ../development/python-modules/stm32loader { };

  stompclient = callPackage ../development/python-modules/stompclient { };

  strategies = callPackage ../development/python-modules/strategies { };

  stravalib = callPackage ../development/python-modules/stravalib { };

  streamz = callPackage ../development/python-modules/streamz { };

  strict-rfc3339 = callPackage ../development/python-modules/strict-rfc3339 { };

  strictyaml = callPackage ../development/python-modules/strictyaml { };

  stringcase = callPackage ../development/python-modules/stringcase { };

  stripe = callPackage ../development/python-modules/stripe { };

  structlog = callPackage ../development/python-modules/structlog { };

  stumpy = callPackage ../development/python-modules/stumpy { };

  stups-cli-support = callPackage ../development/python-modules/stups-cli-support { };

  stups-fullstop = callPackage ../development/python-modules/stups-fullstop { };

  stups-pierone = callPackage ../development/python-modules/stups-pierone { };

  stups-tokens = callPackage ../development/python-modules/stups-tokens { };

  stups-zign = callPackage ../development/python-modules/stups-zign { };

  stytra = callPackage ../development/python-modules/stytra { };

  subdownloader = callPackage ../development/python-modules/subdownloader { };

  subliminal = callPackage ../development/python-modules/subliminal { };

  subprocess32 = callPackage ../development/python-modules/subprocess32 { };

  subunit = callPackage ../development/python-modules/subunit { inherit (pkgs) subunit pkg-config cppunit check; };

  suds = callPackage ../development/python-modules/suds { };

  suds-jurko = callPackage ../development/python-modules/suds-jurko { };

  sumo = callPackage ../development/python-modules/sumo { };

  sumtypes = callPackage ../development/python-modules/sumtypes { };

  sunpy = callPackage ../development/python-modules/sunpy { };

  supervise_api = callPackage ../development/python-modules/supervise_api { };

  supervisor = callPackage ../development/python-modules/supervisor { };

  sure = callPackage ../development/python-modules/sure { };

  survey = callPackage ../development/python-modules/survey { };

  suseapi = callPackage ../development/python-modules/suseapi { };

  svg2tikz = callPackage ../development/python-modules/svg2tikz { };

  svglib = callPackage ../development/python-modules/svglib { };

  svg-path = callPackage ../development/python-modules/svg-path { };

  svgwrite = callPackage ../development/python-modules/svgwrite { };

  swagger-spec-validator = callPackage ../development/python-modules/swagger-spec-validator { };

  swagger-ui-bundle = callPackage ../development/python-modules/swagger-ui-bundle { };

  swspotify = callPackage ../development/python-modules/swspotify { };

  sybil = callPackage ../development/python-modules/sybil { };

  symengine = callPackage ../development/python-modules/symengine { symengine = pkgs.symengine; };

  sympy = if isPy3k then
    callPackage ../development/python-modules/sympy { }
  else
    callPackage ../development/python-modules/sympy/1_5.nix { };

  systemd = callPackage ../development/python-modules/systemd { inherit (pkgs) pkgconfig systemd; };

  sysv_ipc = callPackage ../development/python-modules/sysv_ipc { };

  tableaudocumentapi = callPackage ../development/python-modules/tableaudocumentapi { };

  tables = if isPy3k then
    callPackage ../development/python-modules/tables { hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; }; }
  else
    callPackage ../development/python-modules/tables/3.5.nix { hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; }; };

  tablib = callPackage ../development/python-modules/tablib { };

  tabulate = callPackage ../development/python-modules/tabulate { };

  tadasets = callPackage ../development/python-modules/tadasets { };

  tag-expressions = callPackage ../development/python-modules/tag-expressions { };

  tarman = callPackage ../development/python-modules/tarman { };

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

  tempita = callPackage ../development/python-modules/tempita { };

  tempora = callPackage ../development/python-modules/tempora { };

  tenacity = callPackage ../development/python-modules/tenacity { };

  tensorboardx = callPackage ../development/python-modules/tensorboardx { };

  tensorflow-bin_1 = callPackage ../development/python-modules/tensorflow/1/bin.nix {
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
    cudatoolkit = pkgs.cudatoolkit_10;
    cudnn = pkgs.cudnn_cudatoolkit_10;
  };

  tensorflow-bin_2 = callPackage ../development/python-modules/tensorflow/2/bin.nix {
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
    cudatoolkit = pkgs.cudatoolkit_10;
    cudnn = pkgs.cudnn_cudatoolkit_10;
  };

  tensorflow-bin = self.tensorflow-bin_1;

  tensorflow-build_1 = callPackage ../development/python-modules/tensorflow/1 {
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
    cudatoolkit = pkgs.cudatoolkit_10;
    cudnn = pkgs.cudnn_cudatoolkit_10;
    nccl = pkgs.nccl_cudatoolkit_10;
    openssl = pkgs.openssl_1_1;
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation Security;
    inherit (pkgs) flatbuffers;
  };

  tensorflow-build_2 = callPackage ../development/python-modules/tensorflow/2 {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudatoolkit = pkgs.cudatoolkit_11;
    cudnn = pkgs.cudnn_cudatoolkit_11;
    nccl = pkgs.nccl_cudatoolkit_11;
    openssl = pkgs.openssl_1_1;
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation Security;
    inherit (pkgs) flatbuffers;
  };

  tensorflow-build = self.tensorflow-build_1;

  tensorflow-estimator_1 = callPackage ../development/python-modules/tensorflow-estimator/1 { };

  tensorflow-estimator_2 = callPackage ../development/python-modules/tensorflow-estimator/2 { };

  tensorflow-estimator = self.tensorflow-estimator_1;

  tensorflow-probability = callPackage ../development/python-modules/tensorflow-probability { };

  tensorflow = self.tensorflow_1;
  tensorflow_1 = self.tensorflow-build_1;
  tensorflow_2 = self.tensorflow-build_2;

  tensorflow-tensorboard_1 = callPackage ../development/python-modules/tensorflow-tensorboard/1 { };

  tensorflow-tensorboard_2 = callPackage ../development/python-modules/tensorflow-tensorboard/2 { };

  tensorflow-tensorboard = self.tensorflow-tensorboard_1;

  tensorflowWithCuda = self.tensorflow.override { cudaSupport = true; };

  tensorflowWithoutCuda = self.tensorflow.override { cudaSupport = false; };

  tensorly = callPackage ../development/python-modules/tensorly { };

  termcolor = callPackage ../development/python-modules/termcolor { };

  terminado = callPackage ../development/python-modules/terminado { };

  terminaltables = callPackage ../development/python-modules/terminaltables { };

  termstyle = callPackage ../development/python-modules/termstyle { };

  tess = callPackage ../development/python-modules/tess { };

  tesserocr = callPackage ../development/python-modules/tesserocr { };

  testfixtures = callPackage ../development/python-modules/testfixtures { };

  textfsm = callPackage ../development/python-modules/textfsm { };

  testpath = callPackage ../development/python-modules/testpath { };

  testrepository = callPackage ../development/python-modules/testrepository { };

  testresources = callPackage ../development/python-modules/testresources { };

  testscenarios = callPackage ../development/python-modules/testscenarios { };

  testtools = callPackage ../development/python-modules/testtools { };

  test-tube = callPackage ../development/python-modules/test-tube { };

  textacy = callPackage ../development/python-modules/textacy { };

  texttable = callPackage ../development/python-modules/texttable { };

  text-unidecode = callPackage ../development/python-modules/text-unidecode { };

  textwrap3 = callPackage ../development/python-modules/textwrap3 { };

  tflearn = callPackage ../development/python-modules/tflearn { };

  Theano = callPackage ../development/python-modules/Theano rec {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    inherit (pkgs.linuxPackages) nvidia_x11;
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

  thinc = callPackage ../development/python-modules/thinc { };

  threadpool = callPackage ../development/python-modules/threadpool { };

  threadpoolctl = callPackage ../development/python-modules/threadpoolctl { };

  thrift = callPackage ../development/python-modules/thrift { };

  thumbor = callPackage ../development/python-modules/thumbor { };

  thumborPexif = callPackage ../development/python-modules/thumborpexif { };

  tkinter = let
    py = python.override{x11Support=true;};
  in callPackage ../development/python-modules/tkinter { py = py; };

  tidylib = callPackage ../development/python-modules/pytidylib { };

  tifffile = callPackage ../development/python-modules/tifffile { };

  tiledb = callPackage ../development/python-modules/tiledb { inherit (pkgs) tiledb; };

  tilestache = callPackage ../development/python-modules/tilestache { };

  timelib = callPackage ../development/python-modules/timelib { };

  timeout-decorator = callPackage ../development/python-modules/timeout-decorator { };

  timezonefinder = callPackage ../development/python-modules/timezonefinder { };

  tinycss2 = callPackage ../development/python-modules/tinycss2 { };

  tinycss = callPackage ../development/python-modules/tinycss { };

  tinydb = callPackage ../development/python-modules/tinydb { };

  tinyobjloader-py = callPackage ../development/python-modules/tinyobjloader-py { };

  tiros = callPackage ../development/python-modules/tiros { };

  tissue = callPackage ../development/python-modules/tissue { };

  titlecase = callPackage ../development/python-modules/titlecase { };

  tld = callPackage ../development/python-modules/tld { };

  tldextract = callPackage ../development/python-modules/tldextract { };

  tlsh = callPackage ../development/python-modules/tlsh { };

  tlslite-ng = callPackage ../development/python-modules/tlslite-ng { };

  tls-parser = callPackage ../development/python-modules/tls-parser { };

  tmdb3 = callPackage ../development/python-modules/tmdb3 { };

  todoist = callPackage ../development/python-modules/todoist { };

  toggl-cli = callPackage ../development/python-modules/toggl-cli { };

  tokenizers = disabledIf (!isPy3k) (toPythonModule (callPackage ../development/python-modules/tokenizers { }));

  tokenlib = callPackage ../development/python-modules/tokenlib { };

  tokenserver = callPackage ../development/python-modules/tokenserver { };

  toml = callPackage ../development/python-modules/toml { };

  tomlkit = callPackage ../development/python-modules/tomlkit { };

  toolz = if isPy3k then
    callPackage ../development/python-modules/toolz { }
  else
    callPackage ../development/python-modules/toolz/2.nix { };

  toposort = callPackage ../development/python-modules/toposort { };

  topydo = throw "python3Packages.topydo was moved to topydo"; # 2017-09-22

  torchgpipe = callPackage ../development/python-modules/torchgpipe { };

  torchvision = callPackage ../development/python-modules/torchvision { };

  tornado = if isPy3k then
    callPackage ../development/python-modules/tornado { }
  else
    callPackage ../development/python-modules/tornado/5.nix { };

  # Used by circus and grab-site, 2020-08-29
  tornado_4 = callPackage ../development/python-modules/tornado/4.nix { };

  # Used by luigi, 2020-08-29
  tornado_5 = callPackage ../development/python-modules/tornado/5.nix { };

  towncrier = callPackage ../development/python-modules/towncrier { inherit (pkgs) git; };

  tox = callPackage ../development/python-modules/tox { };

  tqdm = callPackage ../development/python-modules/tqdm { };

  traceback2 = callPackage ../development/python-modules/traceback2 { };

  tracing = callPackage ../development/python-modules/tracing { };

  trackpy = callPackage ../development/python-modules/trackpy { };

  traitlets = if pythonOlder "3.7" then
    callPackage ../development/python-modules/traitlets/4.nix { }
  else
    callPackage ../development/python-modules/traitlets { };

  traits = callPackage ../development/python-modules/traits { };

  traitsui = callPackage ../development/python-modules/traitsui { };

  traittypes = callPackage ../development/python-modules/traittypes { };

  transaction = callPackage ../development/python-modules/transaction { };

  transformers = callPackage ../development/python-modules/transformers { };

  transforms3d = callPackage ../development/python-modules/transforms3d { };

  transip = callPackage ../development/python-modules/transip { };

  transitions = callPackage ../development/python-modules/transitions { };

  translationstring = callPackage ../development/python-modules/translationstring { };

  transmissionrpc = callPackage ../development/python-modules/transmissionrpc { };

  treq = callPackage ../development/python-modules/treq { };

  trezor_agent = callPackage ../development/python-modules/trezor_agent { };

  trezor = callPackage ../development/python-modules/trezor { };

  trimesh = callPackage ../development/python-modules/trimesh { };

  trio = callPackage ../development/python-modules/trio { };

  trollius = callPackage ../development/python-modules/trollius { };

  trueskill = callPackage ../development/python-modules/trueskill { };

  trustme = callPackage ../development/python-modules/trustme { };

  trytond = callPackage ../development/python-modules/trytond { };

  ttystatus = callPackage ../development/python-modules/ttystatus { };

  tunigo = callPackage ../development/python-modules/tunigo { };

  TurboCheetah = callPackage ../development/python-modules/TurboCheetah { };

  tubeup = callPackage ../development/python-modules/tubeup { };

  tvdb_api = callPackage ../development/python-modules/tvdb_api { };

  tvnamer = callPackage ../development/python-modules/tvnamer { };

  tweepy = callPackage ../development/python-modules/tweepy { };

  twiggy = callPackage ../development/python-modules/twiggy { };

  twilio = callPackage ../development/python-modules/twilio { };

  twill = callPackage ../development/python-modules/twill { };

  twine = callPackage ../development/python-modules/twine { };

  twisted = callPackage ../development/python-modules/twisted { };

  twitter = callPackage ../development/python-modules/twitter { };

  twitter-common-collections = callPackage ../development/python-modules/twitter-common-collections { };

  twitter-common-confluence = callPackage ../development/python-modules/twitter-common-confluence { };

  twitter-common-dirutil = callPackage ../development/python-modules/twitter-common-dirutil { };

  twitter-common-lang = callPackage ../development/python-modules/twitter-common-lang { };

  twitter-common-log = callPackage ../development/python-modules/twitter-common-log { };

  twitter-common-options = callPackage ../development/python-modules/twitter-common-options { };

  twofish = callPackage ../development/python-modules/twofish { };

  txaio = callPackage ../development/python-modules/txaio { };

  txamqp = callPackage ../development/python-modules/txamqp { };

  txdbus = callPackage ../development/python-modules/txdbus { };

  txgithub = callPackage ../development/python-modules/txgithub { };

  txrequests = callPackage ../development/python-modules/txrequests { };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  typed-ast = callPackage ../development/python-modules/typed-ast { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  typer = callPackage ../development/python-modules/typer { };

  typesentry = callPackage ../development/python-modules/typesentry { };

  typesystem = callPackage ../development/python-modules/typesystem { };

  typing = callPackage ../development/python-modules/typing { };

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typing-inspect = callPackage ../development/python-modules/typing-inspect { };

  typogrify = callPackage ../development/python-modules/typogrify { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  uamqp =
    callPackage ../development/python-modules/uamqp { inherit (pkgs.darwin.apple_sdk.frameworks) CFNetwork Security; };

  ua-parser = callPackage ../development/python-modules/ua-parser { };

  uarray = callPackage ../development/python-modules/uarray { };

  ueberzug = callPackage ../development/python-modules/ueberzug { inherit (pkgs.xorg) libX11 libXext; };

  ufonormalizer = callPackage ../development/python-modules/ufonormalizer { };

  ufoprocessor = callPackage ../development/python-modules/ufoprocessor { };

  ujson = if isPy27 then
    callPackage ../development/python-modules/ujson/2.nix { }
  else
    callPackage ../development/python-modules/ujson { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  umalqurra = callPackage ../development/python-modules/umalqurra { };

  umap-learn = callPackage ../development/python-modules/umap-learn { };

  umemcache = callPackage ../development/python-modules/umemcache { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  uncompyle6 = callPackage ../development/python-modules/uncompyle6 { };

  unicodecsv = callPackage ../development/python-modules/unicodecsv { };

  unicodedata2 = callPackage ../development/python-modules/unicodedata2 { };

  unicode-slugify = callPackage ../development/python-modules/unicode-slugify { };

  unicorn = callPackage ../development/python-modules/unicorn {
    unicorn-emu = pkgs.unicorn;
  };

  unidecode = callPackage ../development/python-modules/unidecode { };

  unidiff = callPackage ../development/python-modules/unidiff { };

  unifi = callPackage ../development/python-modules/unifi { };

  units = callPackage ../development/python-modules/units { };

  unittest2 = callPackage ../development/python-modules/unittest2 { };

  unittest-data-provider = callPackage ../development/python-modules/unittest-data-provider { };

  unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

  unpaddedbase64 = callPackage ../development/python-modules/unpaddedbase64 { };

  unrardll = callPackage ../development/python-modules/unrardll { };

  unrpa = callPackage ../development/python-modules/unrpa { };

  untangle = callPackage ../development/python-modules/untangle { };

  upass = callPackage ../development/python-modules/upass { };

  update_checker = callPackage ../development/python-modules/update_checker { };

  update-copyright = callPackage ../development/python-modules/update-copyright { };

  update-dotdee = callPackage ../development/python-modules/update-dotdee { };

  uproot3 = callPackage ../development/python-modules/uproot3 { };

  uproot3-methods = callPackage ../development/python-modules/uproot3-methods { };

  uptime = callPackage ../development/python-modules/uptime { };

  uranium = callPackage ../development/python-modules/uranium { };

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uritools = callPackage ../development/python-modules/uritools { };

  urlgrabber = callPackage ../development/python-modules/urlgrabber { };

  urllib3 = callPackage ../development/python-modules/urllib3 { };

  urwid = callPackage ../development/python-modules/urwid { };

  urwidtrees = callPackage ../development/python-modules/urwidtrees { };

  urwid-readline = callPackage ../development/python-modules/urwid-readline { };

  usbtmc = callPackage ../development/python-modules/usbtmc { };

  us = callPackage ../development/python-modules/us { };

  user-agents = callPackage ../development/python-modules/user-agents { };

  userpath = callPackage ../development/python-modules/userpath { };

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

  vega = callPackage ../development/python-modules/vega { };

  vega_datasets = callPackage ../development/python-modules/vega_datasets { };

  venusian = callPackage ../development/python-modules/venusian { };

  verboselogs = callPackage ../development/python-modules/verboselogs { };

  versioneer = callPackage ../development/python-modules/versioneer { };

  versiontools = callPackage ../development/python-modules/versiontools { };

  vertica-python = callPackage ../development/python-modules/vertica-python { };

  veryprettytable = callPackage ../development/python-modules/veryprettytable { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  viewstate = callPackage ../development/python-modules/viewstate { };

  vine = callPackage ../development/python-modules/vine { };

  virtkey = callPackage ../development/python-modules/virtkey { inherit (pkgs) pkgconfig; };

  virtual-display = callPackage ../development/python-modules/virtual-display { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  virtualenv-clone = callPackage ../development/python-modules/virtualenv-clone { };

  virtualenvwrapper = callPackage ../development/python-modules/virtualenvwrapper { };

  visitor = callPackage ../development/python-modules/visitor { };

  vispy = callPackage ../development/python-modules/vispy { };

  vmprof = callPackage ../development/python-modules/vmprof { };

  vncdo = callPackage ../development/python-modules/vncdo { };

  vobject = callPackage ../development/python-modules/vobject { };

  voluptuous = callPackage ../development/python-modules/voluptuous { };

  voluptuous-serialize = callPackage ../development/python-modules/voluptuous-serialize { };

  vowpalwabbit = callPackage ../development/python-modules/vowpalwabbit { };

  vsts = callPackage ../development/python-modules/vsts { };

  vsts-cd-manager = callPackage ../development/python-modules/vsts-cd-manager { };

  vtk = toPythonModule (pkgs.vtk_7.override {
    inherit (self) python;
    enablePython = true;
  });

  vultr = callPackage ../development/python-modules/vultr { };

  vulture = callPackage ../development/python-modules/vulture { };

  vxi11 = callPackage ../development/python-modules/vxi11 { };

  w3lib = callPackage ../development/python-modules/w3lib { };

  wadllib = callPackage ../development/python-modules/wadllib { };

  waitress = callPackage ../development/python-modules/waitress { };

  waitress-django = callPackage ../development/python-modules/waitress-django { };

  wakeonlan = callPackage ../development/python-modules/wakeonlan { };

  Wand = callPackage ../development/python-modules/Wand { };

  warlock = callPackage ../development/python-modules/warlock { };

  warrant = callPackage ../development/python-modules/warrant { };

  wasabi = callPackage ../development/python-modules/wasabi { };

  watchdog = callPackage ../development/python-modules/watchdog { };

  WazeRouteCalculator = callPackage ../development/python-modules/WazeRouteCalculator { };

  wcwidth = callPackage ../development/python-modules/wcwidth { };

  weasyprint = callPackage ../development/python-modules/weasyprint { };

  webapp2 = callPackage ../development/python-modules/webapp2 { };

  webassets = callPackage ../development/python-modules/webassets { };

  web = callPackage ../development/python-modules/web { };

  webcolors = callPackage ../development/python-modules/webcolors { };

  webdavclient3 = callPackage ../development/python-modules/webdavclient3 { };

  webencodings = callPackage ../development/python-modules/webencodings { };

  webhelpers = callPackage ../development/python-modules/webhelpers { };

  webob = callPackage ../development/python-modules/webob { };

  weboob = callPackage ../development/python-modules/weboob { };

  webrtcvad = callPackage ../development/python-modules/webrtcvad { };

  websocket_client = callPackage ../development/python-modules/websocket_client { };

  websockets = callPackage ../development/python-modules/websockets { };

  websockify = callPackage ../development/python-modules/websockify { };

  webtest = callPackage ../development/python-modules/webtest { };

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  west = callPackage ../development/python-modules/west { };

  wfuzz = callPackage ../development/python-modules/wfuzz { };

  wget = callPackage ../development/python-modules/wget { };

  wheel = callPackage ../development/python-modules/wheel { };

  whichcraft = callPackage ../development/python-modules/whichcraft { };

  whisper = callPackage ../development/python-modules/whisper { };

  whitenoise = callPackage ../development/python-modules/whitenoise { };

  whoosh = callPackage ../development/python-modules/whoosh { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  willow = callPackage ../development/python-modules/willow { };

  wled = callPackage ../development/python-modules/wled { };

  word2vec = callPackage ../development/python-modules/word2vec { };

  wordcloud = callPackage ../development/python-modules/wordcloud { };

  wordfreq = callPackage ../development/python-modules/wordfreq { };

  worldengine = callPackage ../development/python-modules/worldengine { };

  wptserve = callPackage ../development/python-modules/wptserve { };

  wrapio = callPackage ../development/python-modules/wrapio { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  wrf-python = callPackage ../development/python-modules/wrf-python { };

  ws4py = callPackage ../development/python-modules/ws4py { };

  wsgiproxy2 = callPackage ../development/python-modules/wsgiproxy2 { };

  WSGIProxy = callPackage ../development/python-modules/wsgiproxy { };

  wsgitools = callPackage ../development/python-modules/wsgitools { };

  WSME = callPackage ../development/python-modules/WSME { };

  wsnsimpy = callPackage ../development/python-modules/wsnsimpy { };

  wsproto = if (pythonAtLeast "3.6") then
    callPackage ../development/python-modules/wsproto { }
  else
    callPackage ../development/python-modules/wsproto/0.14.nix { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  wtf-peewee = callPackage ../development/python-modules/wtf-peewee { };

  wurlitzer = callPackage ../development/python-modules/wurlitzer { };

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
    inherit (pkgs) pkgconfig;
  };

  wxPython_4_0 = callPackage ../development/python-modules/wxPython/4.0.nix {
    inherit (pkgs) pkgconfig;
    wxGTK = pkgs.wxGTK30.override {
      withGtk2 = false;
      withWebKit = true;
    };
  };

  wxPython_4_1 = callPackage ../development/python-modules/wxPython/4.1.nix {
    inherit (pkgs) pkgconfig;
    wxGTK = pkgs.wxGTK31.override {
      withGtk2 = false;
      withWebKit = true;
    };
  };

  wxPython = self.wxPython30;

  x11_hash = callPackage ../development/python-modules/x11_hash { };

  x256 = callPackage ../development/python-modules/x256 { };

  xapian = callPackage ../development/python-modules/xapian { xapian = pkgs.xapian; };

  xapp = callPackage ../development/python-modules/xapp {
    inherit (pkgs) gtk3 gobject-introspection polkit;
    inherit (pkgs.cinnamon) xapps;
  };

  xarray = callPackage ../development/python-modules/xarray { };

  xattr = callPackage ../development/python-modules/xattr { };

  xcaplib = callPackage ../development/python-modules/xcaplib { };

  xcffib = callPackage ../development/python-modules/xcffib { };

  xdg = callPackage ../development/python-modules/xdg { };

  xdis = callPackage ../development/python-modules/xdis { };

  xdot = callPackage ../development/python-modules/xdot { };

  xenomapper = disabledIf (!isPy3k) (callPackage ../applications/science/biology/xenomapper { });

  xgboost = callPackage ../development/python-modules/xgboost { xgboost = pkgs.xgboost; };

  xhtml2pdf = callPackage ../development/python-modules/xhtml2pdf { };

  xkcdpass = callPackage ../development/python-modules/xkcdpass { };

  xlib = callPackage ../development/python-modules/xlib { };

  xlrd = callPackage ../development/python-modules/xlrd { };

  xlsx2csv = callPackage ../development/python-modules/xlsx2csv { };

  XlsxWriter = callPackage ../development/python-modules/XlsxWriter { };

  xlwt = callPackage ../development/python-modules/xlwt { };

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmljson = callPackage ../development/python-modules/xmljson { };

  xmlschema = callPackage ../development/python-modules/xmlschema { };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xmodem = callPackage ../development/python-modules/xmodem { };

  xmpppy = callPackage ../development/python-modules/xmpppy { };

  xnd = callPackage ../development/python-modules/xnd { };

  xpybutil = callPackage ../development/python-modules/xpybutil { };

  xstatic-bootbox = callPackage ../development/python-modules/xstatic-bootbox { };

  xstatic-bootstrap = callPackage ../development/python-modules/xstatic-bootstrap { };

  xstatic = callPackage ../development/python-modules/xstatic { };

  xstatic-jquery = callPackage ../development/python-modules/xstatic-jquery { };

  xstatic-jquery-file-upload = callPackage ../development/python-modules/xstatic-jquery-file-upload { };

  xstatic-jquery-ui = callPackage ../development/python-modules/xstatic-jquery-ui { };

  xstatic-pygments = callPackage ../development/python-modules/xstatic-pygments { };

  xvfbwrapper = callPackage ../development/python-modules/xvfbwrapper { inherit (pkgs.xorg) xorgserver; };

  xxhash = callPackage ../development/python-modules/xxhash { };

  yahooweather = callPackage ../development/python-modules/yahooweather { };

  yamale = callPackage ../development/python-modules/yamale { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yamlloader = callPackage ../development/python-modules/yamlloader { };

  yamlordereddictloader = callPackage ../development/python-modules/yamlordereddictloader { };

  yanc = callPackage ../development/python-modules/yanc { };

  yapf = callPackage ../development/python-modules/yapf { };

  yappi = callPackage ../development/python-modules/yappi { };

  Yapsy = callPackage ../development/python-modules/yapsy { };

  yarg = callPackage ../development/python-modules/yarg { };

  yarl = callPackage ../development/python-modules/yarl { };

  yattag = callPackage ../development/python-modules/yattag { };

  ydiff = callPackage ../development/python-modules/ydiff { };

  yeelight = callPackage ../development/python-modules/yeelight { };

  yenc = callPackage ../development/python-modules/yenc { };

  yfinance = callPackage ../development/python-modules/yfinance { };

  yoda = toPythonModule (pkgs.yoda.override { inherit python; });

  youtube-dl = callPackage ../tools/misc/youtube-dl { };

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
    phantomjsSupport = false;
  };

  youtube-dlc = callPackage ../development/python-modules/youtube-dlc { };

  yowsup = callPackage ../development/python-modules/yowsup { };

  yq = callPackage ../development/python-modules/yq { };

  yt = callPackage ../development/python-modules/yt { };

  yubico-client = callPackage ../development/python-modules/yubico-client { };

  z3c-checkversions = callPackage ../development/python-modules/z3c-checkversions { };

  z3 = (toPythonModule (pkgs.z3.override { inherit python; })).python;

  zake = callPackage ../development/python-modules/zake { };

  zarr = callPackage ../development/python-modules/zarr { };

  zbase32 = callPackage ../development/python-modules/zbase32 { };

  zc_buildout221 = callPackage ../development/python-modules/buildout { };

  zc_buildout = self.zc_buildout221; # A patched version of buildout, useful for buildout based development on Nix

  zc_buildout_nix = callPackage ../development/python-modules/buildout-nix { };

  zc_lockfile = callPackage ../development/python-modules/zc_lockfile { };

  zconfig = callPackage ../development/python-modules/zconfig { };

  zdaemon = callPackage ../development/python-modules/zdaemon { };

  zeep = callPackage ../development/python-modules/zeep { };

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override { python3 = python; })).py;

  zerobin = callPackage ../development/python-modules/zerobin { };

  zeroc-ice = callPackage ../development/python-modules/zeroc-ice { };

  zeroconf = callPackage ../development/python-modules/zeroconf { };

  zerorpc = callPackage ../development/python-modules/zerorpc { };

  zetup = callPackage ../development/python-modules/zetup { };

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

  zipp = if pythonOlder "3.6" then
    callPackage ../development/python-modules/zipp/1.nix { }
  else
    callPackage ../development/python-modules/zipp { };

  zipstream = callPackage ../development/python-modules/zipstream { };

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

  zopfli = callPackage ../development/python-modules/zopfli { };

  zstandard = callPackage ../development/python-modules/zstandard { };

  zstd = callPackage ../development/python-modules/zstd { inherit (pkgs) zstd pkgconfig; };

  zulip = callPackage ../development/python-modules/zulip { };

  zxcvbn = callPackage ../development/python-modules/zxcvbn { };

}
