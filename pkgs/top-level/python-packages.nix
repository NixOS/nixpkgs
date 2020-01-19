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
  inherit (python.passthru) isPy27 isPy33 isPy34 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast pythonOlder;

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

  inherit (python.passthru) isPy27 isPy33 isPy34 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast pythonOlder;
  inherit python bootstrapped-pip buildPythonPackage buildPythonApplication;
  inherit fetchPypi callPackage;
  inherit hasPythonModule requiredPythonModules makePythonPath disabledIf;
  inherit toPythonModule toPythonApplication;
  inherit buildSetupcfg;

  inherit (callPackage ../development/interpreters/python/hooks { })
    eggUnpackHook eggBuildHook eggInstallHook flitBuildHook pipBuildHook pipInstallHook pytestCheckHook pythonCatchConflictsHook pythonImportsCheckHook pythonRemoveBinBytecodeHook setuptoolsBuildHook setuptoolsCheckHook venvShellHook wheelUnpackHook;

  # helpers

  wrapPython = callPackage ../development/interpreters/python/wrap-python.nix {inherit python; inherit (pkgs) makeSetupHook makeWrapper; };

  # Dont take pythonPackages from "global" pkgs scope to avoid mixing python versions
  pythonPackages = self;

  # specials

  recursivePthLoader = callPackage ../development/python-modules/recursive-pth-loader { };

  setuptools = callPackage ../development/python-modules/setuptools { };

  vowpalwabbit = callPackage ../development/python-modules/vowpalwabbit { };

  acoustics = callPackage ../development/python-modules/acoustics { };

  py3to2 = callPackage ../development/python-modules/3to2 { };

  pynamodb = callPackage ../development/python-modules/pynamodb { };

  absl-py = callPackage ../development/python-modules/absl-py { };

  adb-homeassistant = callPackage ../development/python-modules/adb-homeassistant { };

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

  aiolifx = callPackage ../development/python-modules/aiolifx { };

  aiolifx-effects = callPackage ../development/python-modules/aiolifx-effects { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  aioredis = callPackage ../development/python-modules/aioredis { };

  aiorun = callPackage ../development/python-modules/aiorun { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  ansiwrap =  callPackage ../development/python-modules/ansiwrap { };

  ansi2html = callPackage ../development/python-modules/ansi2html { };

  anytree = callPackage ../development/python-modules/anytree {
    inherit (pkgs) graphviz;
  };

  aplpy = callPackage ../development/python-modules/aplpy { };

  apprise = callPackage ../development/python-modules/apprise { };

  arrayqueues = callPackage ../development/python-modules/arrayqueues { };

  aresponses = callPackage ../development/python-modules/aresponses { };

  argon2_cffi = callPackage ../development/python-modules/argon2_cffi { };

  arviz = callPackage ../development/python-modules/arviz { };

  asana = callPackage ../development/python-modules/asana { };

  asdf = callPackage ../development/python-modules/asdf { };

  asciimatics = callPackage ../development/python-modules/asciimatics { };

  asciitree = callPackage ../development/python-modules/asciitree { };

  ase = if isPy27 then
          callPackage ../development/python-modules/ase/3.17.nix { }
        else
          callPackage ../development/python-modules/ase { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  aspy-yaml = callPackage ../development/python-modules/aspy.yaml { };

  astral = callPackage ../development/python-modules/astral { };

  astropy = callPackage ../development/python-modules/astropy { };

  astropy-helpers = callPackage ../development/python-modules/astropy-helpers { };

  astropy-healpix = callPackage ../development/python-modules/astropy-healpix { };

  astroquery = callPackage ../development/python-modules/astroquery { };

  asttokens = callPackage ../development/python-modules/asttokens { };

  atom = callPackage ../development/python-modules/atom { };

  augeas = callPackage ../development/python-modules/augeas {
    inherit (pkgs) augeas;
  };

  authheaders = callPackage ../development/python-modules/authheaders { };

  authres = callPackage ../development/python-modules/authres { };

  autograd = callPackage ../development/python-modules/autograd { };

  autologging = callPackage ../development/python-modules/autologging { };

  automat = callPackage ../development/python-modules/automat { };

  awkward = callPackage ../development/python-modules/awkward { };
  awkward1 = callPackage ../development/python-modules/awkward1 { };

  aws-sam-translator = callPackage ../development/python-modules/aws-sam-translator { };

  aws-xray-sdk = callPackage ../development/python-modules/aws-xray-sdk { };

  aws-adfs = callPackage ../development/python-modules/aws-adfs { };

  atomman = callPackage ../development/python-modules/atomman { };

  authlib = callPackage ../development/python-modules/authlib { };

  # packages defined elsewhere

  amazon_kclpy = callPackage ../development/python-modules/amazon_kclpy { };

  ansiconv = callPackage ../development/python-modules/ansiconv { };

  avahi = toPythonModule (pkgs.avahi.override {
    inherit python;
    withPython = true;
  });

  azure = callPackage ../development/python-modules/azure { };

  azure-nspkg = callPackage ../development/python-modules/azure-nspkg { };

  azure-common = callPackage ../development/python-modules/azure-common { };

  azure-cosmos = callPackage ../development/python-modules/azure-cosmos { };

  azure-applicationinsights = callPackage ../development/python-modules/azure-applicationinsights { };

  azure-batch = callPackage ../development/python-modules/azure-batch { };

  azure-core = callPackage ../development/python-modules/azure-core { };

  azure-cosmosdb-nspkg = callPackage ../development/python-modules/azure-cosmosdb-nspkg { };

  azure-cosmosdb-table = callPackage ../development/python-modules/azure-cosmosdb-table { };

  azure-datalake-store = callPackage ../development/python-modules/azure-datalake-store { };

  azure-eventgrid = callPackage ../development/python-modules/azure-eventgrid { };

  azure-functions-devops-build = callPackage ../development/python-modules/azure-functions-devops-build { };

  azure-graphrbac = callPackage ../development/python-modules/azure-graphrbac { };

  azure-identity = callPackage ../development/python-modules/azure-identity { };

  azure-keyvault = callPackage ../development/python-modules/azure-keyvault { };

  azure-keyvault-keys = callPackage ../development/python-modules/azure-keyvault-keys { };

  azure-keyvault-nspkg = callPackage ../development/python-modules/azure-keyvault-nspkg { };

  azure-keyvault-secrets = callPackage ../development/python-modules/azure-keyvault-secrets { };

  azure-loganalytics = callPackage ../development/python-modules/azure-loganalytics { };

  azure-servicebus = callPackage ../development/python-modules/azure-servicebus { };

  azure-servicefabric = callPackage ../development/python-modules/azure-servicefabric { };

  azure-servicemanagement-legacy = callPackage ../development/python-modules/azure-servicemanagement-legacy { };

  azure-storage-nspkg = callPackage ../development/python-modules/azure-storage-nspkg { };

  azure-storage-common = callPackage ../development/python-modules/azure-storage-common { };

  azure-storage = callPackage ../development/python-modules/azure-storage { };

  azure-storage-blob = callPackage ../development/python-modules/azure-storage-blob { };

  azure-storage-file = callPackage ../development/python-modules/azure-storage-file { };

  azure-storage-queue = callPackage ../development/python-modules/azure-storage-queue { };

  azure-mgmt-nspkg = callPackage ../development/python-modules/azure-mgmt-nspkg { };

  azure-mgmt-common = callPackage ../development/python-modules/azure-mgmt-common { };

  azure-mgmt-advisor = callPackage ../development/python-modules/azure-mgmt-advisor { };

  azure-mgmt-apimanagement = callPackage ../development/python-modules/azure-mgmt-apimanagement { };

  azure-mgmt-appconfiguration = callPackage ../development/python-modules/azure-mgmt-appconfiguration { };

  azure-mgmt-applicationinsights = callPackage ../development/python-modules/azure-mgmt-applicationinsights { };

  azure-mgmt-authorization = callPackage ../development/python-modules/azure-mgmt-authorization { };

  azure-mgmt-batch = callPackage ../development/python-modules/azure-mgmt-batch { };

  azure-mgmt-batchai = callPackage ../development/python-modules/azure-mgmt-batchai { };

  azure-mgmt-billing = callPackage ../development/python-modules/azure-mgmt-billing { };

  azure-mgmt-botservice = callPackage ../development/python-modules/azure-mgmt-botservice { };

  azure-mgmt-cdn = callPackage ../development/python-modules/azure-mgmt-cdn { };

  azure-mgmt-cognitiveservices = callPackage ../development/python-modules/azure-mgmt-cognitiveservices { };

  azure-mgmt-commerce = callPackage ../development/python-modules/azure-mgmt-commerce { };

  azure-mgmt-compute = callPackage ../development/python-modules/azure-mgmt-compute { };

  azure-mgmt-consumption = callPackage ../development/python-modules/azure-mgmt-consumption { };

  azure-mgmt-containerinstance = callPackage ../development/python-modules/azure-mgmt-containerinstance { };

  azure-mgmt-containerregistry = callPackage ../development/python-modules/azure-mgmt-containerregistry { };

  azure-mgmt-containerservice = callPackage ../development/python-modules/azure-mgmt-containerservice { };

  azure-mgmt-cosmosdb = callPackage ../development/python-modules/azure-mgmt-cosmosdb { };

  azure-mgmt-datafactory = callPackage ../development/python-modules/azure-mgmt-datafactory { };

  azure-mgmt-datalake-analytics = callPackage ../development/python-modules/azure-mgmt-datalake-analytics { };

  azure-mgmt-datalake-nspkg = callPackage ../development/python-modules/azure-mgmt-datalake-nspkg { };

  azure-mgmt-datalake-store = callPackage ../development/python-modules/azure-mgmt-datalake-store { };

  azure-mgmt-datamigration = callPackage ../development/python-modules/azure-mgmt-datamigration { };

  azure-mgmt-devspaces = callPackage ../development/python-modules/azure-mgmt-devspaces { };

  azure-mgmt-devtestlabs = callPackage ../development/python-modules/azure-mgmt-devtestlabs { };

  azure-mgmt-deploymentmanager = callPackage ../development/python-modules/azure-mgmt-deploymentmanager { };

  azure-mgmt-dns = callPackage ../development/python-modules/azure-mgmt-dns { };

  azure-mgmt-eventgrid = callPackage ../development/python-modules/azure-mgmt-eventgrid { };

  azure-mgmt-eventhub = callPackage ../development/python-modules/azure-mgmt-eventhub { };

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

  azure-mgmt-policyinsights = callPackage ../development/python-modules/azure-mgmt-policyinsights { };

  azure-mgmt-powerbiembedded = callPackage ../development/python-modules/azure-mgmt-powerbiembedded { };

  azure-mgmt-privatedns = callPackage ../development/python-modules/azure-mgmt-privatedns { };

  azure-mgmt-rdbms = callPackage ../development/python-modules/azure-mgmt-rdbms { };

  azure-mgmt-recoveryservices = callPackage ../development/python-modules/azure-mgmt-recoveryservices { };

  azure-mgmt-recoveryservicesbackup = callPackage ../development/python-modules/azure-mgmt-recoveryservicesbackup { };

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

  azure-mgmt-trafficmanager = callPackage ../development/python-modules/azure-mgmt-trafficmanager { };

  azure-mgmt-web = callPackage ../development/python-modules/azure-mgmt-web { };

  azure-multiapi-storage = callPackage ../development/python-modules/azure-multiapi-storage { };

  backports_csv = callPackage ../development/python-modules/backports_csv {};

  backports-shutil-which = callPackage ../development/python-modules/backports-shutil-which {};

  bap = callPackage ../development/python-modules/bap {
    bap = pkgs.ocaml-ng.ocamlPackages_4_06.bap;
  };

  baselines = callPackage ../development/python-modules/baselines { };

  bash_kernel = callPackage ../development/python-modules/bash_kernel { };

  bashlex = callPackage ../development/python-modules/bashlex { };

  bayespy = callPackage ../development/python-modules/bayespy { };

  beanstalkc = callPackage ../development/python-modules/beanstalkc { };

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

  bugseverywhere = throw "bugseverywhere has been removed: Abandoned by upstream."; # Added 2019-11-27

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cachelib = callPackage ../development/python-modules/cachelib { };

  cachy = callPackage ../development/python-modules/cachy { };

  cadquery = callPackage ../development/python-modules/cadquery { };

  catalogue = callPackage ../development/python-modules/catalogue { };

  cdecimal = callPackage ../development/python-modules/cdecimal { };

  cfn-flip = callPackage ../development/python-modules/cfn-flip { };

  chalice = callPackage ../development/python-modules/chalice { };

  channels-redis = callPackage ../development/python-modules/channels-redis { };

  cleo = callPackage ../development/python-modules/cleo { };

  clikit = callPackage ../development/python-modules/clikit { };

  cliff = callPackage ../development/python-modules/cliff { };

  clifford = callPackage ../development/python-modules/clifford { };

  clickclick = callPackage ../development/python-modules/clickclick { };

  clustershell = callPackage ../development/python-modules/clustershell { };

  cnvkit = callPackage ../development/python-modules/cnvkit { };

  cocotb = callPackage ../development/python-modules/cocotb { };

  compiledb = callPackage ../development/python-modules/compiledb { };

  connexion = callPackage ../development/python-modules/connexion { };

  coordinates = callPackage ../development/python-modules/coordinates { };

  cozy = callPackage ../development/python-modules/cozy { };

  codespell = callPackage ../development/python-modules/codespell { };

  crc32c = callPackage ../development/python-modules/crc32c { };

  curio = callPackage ../development/python-modules/curio { };

  dendropy = callPackage ../development/python-modules/dendropy { };

  dependency-injector = callPackage ../development/python-modules/dependency-injector { };

  btchip = callPackage ../development/python-modules/btchip { };

  datatable = callPackage ../development/python-modules/datatable {
    inherit (pkgs.llvmPackages) openmp libcxx libcxxabi;
  };

  databases = callPackage ../development/python-modules/databases { };

  datamodeldict = callPackage ../development/python-modules/datamodeldict { };

  datasette = callPackage ../development/python-modules/datasette { };

  datashader = callPackage ../development/python-modules/datashader { };

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  deap = callPackage ../development/python-modules/deap { };

  deeptoolsintervals = callPackage ../development/python-modules/deeptoolsintervals { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  dictionaries = callPackage ../development/python-modules/dictionaries { };

  diff_cover = callPackage ../development/python-modules/diff_cover { };

  diofant = callPackage ../development/python-modules/diofant { };

  docrep = callPackage ../development/python-modules/docrep { };

  dominate = callPackage ../development/python-modules/dominate { };

  dotnetcore2 = callPackage ../development/python-modules/dotnetcore2 {
    inherit (pkgs) substituteAll dotnet-sdk;
  };

  emcee = callPackage ../development/python-modules/emcee { };

  emailthreads = callPackage ../development/python-modules/emailthreads { };

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

  distlib = callPackage ../development/python-modules/distlib { };

  distributed = callPackage ../development/python-modules/distributed { };

  docutils = callPackage ../development/python-modules/docutils { };

  dogtail = callPackage ../development/python-modules/dogtail { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  entrance = callPackage ../development/python-modules/entrance { routerFeatures = false; };

  entrance-with-router-features = callPackage ../development/python-modules/entrance { routerFeatures = true; };

  eradicate = callPackage ../development/python-modules/eradicate {  };

  face = callPackage ../development/python-modules/face { };

  fastparquet = callPackage ../development/python-modules/fastparquet { };

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 {  };

  fasttext = callPackage ../development/python-modules/fasttext {  };

  facedancer = callPackage ../development/python-modules/facedancer {  };

  favicon = callPackage ../development/python-modules/favicon {  };

  fdint = callPackage ../development/python-modules/fdint { };

  fido2 = callPackage ../development/python-modules/fido2 {  };

  filterpy = callPackage ../development/python-modules/filterpy { };

  filemagic = callPackage ../development/python-modules/filemagic { };

  fints = callPackage ../development/python-modules/fints { };

  fire = callPackage ../development/python-modules/fire { };

  firetv = callPackage ../development/python-modules/firetv { };

  flufl_bounce = callPackage ../development/python-modules/flufl/bounce.nix { };

  flufl_i18n = callPackage ../development/python-modules/flufl/i18n.nix { };

  flufl_lock = callPackage ../development/python-modules/flufl/lock.nix { };

  fluidasserts = callPackage ../development/python-modules/fluidasserts { };

  foxdot = callPackage ../development/python-modules/foxdot { };

  fsspec = callPackage ../development/python-modules/fsspec { };

  fuse = callPackage ../development/python-modules/fuse-python {
    inherit (pkgs) fuse pkgconfig;
  };

  fuzzywuzzy = callPackage ../development/python-modules/fuzzywuzzy { };

  genanki = callPackage ../development/python-modules/genanki { };

  geoip2 = callPackage ../development/python-modules/geoip2 { };

  getmac = callPackage ../development/python-modules/getmac { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  gin-config = callPackage ../development/python-modules/gin-config { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  glymur = callPackage ../development/python-modules/glymur { };

  glob2 = callPackage ../development/python-modules/glob2 { };

  glom = callPackage ../development/python-modules/glom { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  grandalf = callPackage ../development/python-modules/grandalf { };

  gprof2dot = callPackage ../development/python-modules/gprof2dot {
    inherit (pkgs) graphviz;
  };

  gsd = if isPy27 then
      callPackage ../development/python-modules/gsd/1.7.nix { }
    else
      callPackage ../development/python-modules/gsd { };

  gssapi = callPackage ../development/python-modules/gssapi {
    inherit (pkgs) darwin krb5Full;
  };

  guestfs = callPackage ../development/python-modules/guestfs { };

  gumath = callPackage ../development/python-modules/gumath { };

  h3 = callPackage ../development/python-modules/h3 { inherit (pkgs) h3; };

  h5py = callPackage ../development/python-modules/h5py {
    hdf5 = pkgs.hdf5;
  };

  h5py-mpi = self.h5py.override {
    hdf5 = pkgs.hdf5-mpi;
  };

  ha-ffmpeg = callPackage ../development/python-modules/ha-ffmpeg { };

  habanero = callPackage ../development/python-modules/habanero { };

  handout = callPackage ../development/python-modules/handout { };

  helper = callPackage ../development/python-modules/helper { };

  hdmedians = callPackage ../development/python-modules/hdmedians { };

  hocr-tools = callPackage ../development/python-modules/hocr-tools { };

  holidays = callPackage ../development/python-modules/holidays { };

  holoviews = callPackage ../development/python-modules/holoviews { };

  hoomd-blue = toPythonModule (callPackage ../development/python-modules/hoomd-blue {
    inherit python;
  });

  hopcroftkarp = callPackage ../development/python-modules/hopcroftkarp { };

  http-ece = callPackage ../development/python-modules/http-ece { };

  httpsig = callPackage ../development/python-modules/httpsig { };

  httptools = callPackage ../development/python-modules/httptools { };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  ihatemoney = callPackage ../development/python-modules/ihatemoney { };

  imutils = callPackage ../development/python-modules/imutils { };

  inotify-simple = callPackage ../development/python-modules/inotify-simple { };

  intake = callPackage ../development/python-modules/intake { };

  intelhex = callPackage ../development/python-modules/intelhex { };

  inquirer = callPackage ../development/python-modules/inquirer { };

  itanium_demangler = callPackage ../development/python-modules/itanium_demangler { };

  janus = callPackage ../development/python-modules/janus { };

  jira = callPackage ../development/python-modules/jira { };

  junit-xml = callPackage ../development/python-modules/junit-xml { };

  junitparser = callPackage ../development/python-modules/junitparser { };

  jwcrypto = callPackage ../development/python-modules/jwcrypto { };

  kconfiglib = callPackage ../development/python-modules/kconfiglib { };

  labelbox = callPackage ../development/python-modules/labelbox { };

  lammps-cython = callPackage ../development/python-modules/lammps-cython {
    mpi = pkgs.openmpi;
  };

  langdetect = callPackage ../development/python-modules/langdetect { };

  lazr_config = callPackage ../development/python-modules/lazr/config.nix { };

  lazr_delegates = callPackage ../development/python-modules/lazr/delegates.nix { };

  libmr = callPackage ../development/python-modules/libmr { };

  limitlessled = callPackage ../development/python-modules/limitlessled { };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  logster = callPackage ../development/python-modules/logster { };

  loguru = callPackage ../development/python-modules/loguru { };

  logzero = callPackage ../development/python-modules/logzero { };

  macropy = callPackage ../development/python-modules/macropy { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  mailman = callPackage ../servers/mail/mailman { };

  mailman-web = callPackage ../servers/mail/mailman/web.nix { };

  mailmanclient = callPackage ../development/python-modules/mailmanclient { };

  mailman-hyperkitty = callPackage ../development/python-modules/mailman-hyperkitty { };

  manhole = callPackage ../development/python-modules/manhole { };

  mapbox = callPackage ../development/python-modules/mapbox { };

  markerlib = callPackage ../development/python-modules/markerlib { };

  matchpy = callPackage ../development/python-modules/matchpy { };

  maxminddb = callPackage ../development/python-modules/maxminddb { };

  mininet-python = (toPythonModule (pkgs.mininet.override{ inherit python; })).py;

  mkl-service = callPackage ../development/python-modules/mkl-service { };

  mnist = callPackage ../development/python-modules/mnist { };

  monkeyhex = callPackage ../development/python-modules/monkeyhex { };

  monty = callPackage ../development/python-modules/monty { };

  mpi4py = callPackage ../development/python-modules/mpi4py {
    mpi = pkgs.openmpi;
  };

  msal = callPackage ../development/python-modules/msal { };

  msal-extensions = callPackage ../development/python-modules/msal-extensions { };

  msrest = callPackage ../development/python-modules/msrest { };

  msrestazure = callPackage ../development/python-modules/msrestazure { };

  multiset = callPackage ../development/python-modules/multiset { };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

  nagiosplugin = callPackage ../development/python-modules/nagiosplugin { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python { inherit (pkgs) nanomsg; };

  nbsmoke = callPackage ../development/python-modules/nbsmoke { };

  nbsphinx = callPackage ../development/python-modules/nbsphinx { };

  nbval = callPackage ../development/python-modules/nbval { };

  ndtypes = callPackage ../development/python-modules/ndtypes { };

  nest-asyncio = callPackage ../development/python-modules/nest-asyncio { };

  neuron = pkgs.neuron.override {
    inherit python;
  };

  neuron-mpi = pkgs.neuron-mpi.override {
    inherit python;
  };

  nix-prefetch-github = callPackage ../development/python-modules/nix-prefetch-github { };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # This is used for NixOps to make sure we won't break it with the next major
  # version of nixpart.
  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4 { };

  nltk = callPackage ../development/python-modules/nltk { };

  ntlm-auth = callPackage ../development/python-modules/ntlm-auth { };

  nvchecker = callPackage ../development/python-modules/nvchecker { };

  numericalunits = callPackage ../development/python-modules/numericalunits { };

  oath = callPackage ../development/python-modules/oath { };

  oauthenticator = callPackage ../development/python-modules/oauthenticator { };

  onnx = callPackage ../development/python-modules/onnx { };

  ordered-set = callPackage ../development/python-modules/ordered-set { };

  ortools = (toPythonModule (pkgs.or-tools.override {
    inherit (self) python;
    pythonProtobuf = self.protobuf;
  })).python;

  osmnx = callPackage ../development/python-modules/osmnx { };

  outcome = callPackage ../development/python-modules/outcome {};

  ovito = toPythonModule (pkgs.libsForQt5.callPackage ../development/python-modules/ovito {
      pythonPackages = self;
    });

  palettable = callPackage ../development/python-modules/palettable { };

  papermill = callPackage ../development/python-modules/papermill { };

  parsley = callPackage ../development/python-modules/parsley { };

  pastel = callPackage ../development/python-modules/pastel { };

  pathlib = callPackage ../development/python-modules/pathlib { };

  pc-ble-driver-py = toPythonModule (callPackage ../development/python-modules/pc-ble-driver-py { });

  pcpp = callPackage ../development/python-modules/pcpp { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfminer = callPackage ../development/python-modules/pdfminer_six { };

  pdftotext = callPackage ../development/python-modules/pdftotext { };

  pdfx = callPackage ../development/python-modules/pdfx { };

  pyperf = callPackage ../development/python-modules/pyperf { };

  pefile = callPackage ../development/python-modules/pefile { };

  perfplot = callPackage ../development/python-modules/perfplot { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  phik = callPackage ../development/python-modules/phik {};

  piccata = callPackage ../development/python-modules/piccata {};

  pims = callPackage ../development/python-modules/pims { };

  poetry = callPackage ../development/python-modules/poetry { };

  polyline = callPackage ../development/python-modules/polyline { };

  postorius = disabledIf (!isPy3k) (callPackage ../servers/mail/mailman/postorius.nix { });

  pplpy = callPackage ../development/python-modules/pplpy { };

  pprintpp = callPackage ../development/python-modules/pprintpp { };

  progress = callPackage ../development/python-modules/progress { };

  proglog = callPackage ../development/python-modules/proglog { };

  pure-python-adb-homeassistant = callPackage ../development/python-modules/pure-python-adb-homeassistant { };

  purl = callPackage ../development/python-modules/purl { };

  pymystem3 = callPackage ../development/python-modules/pymystem3 { };

  pymysql = callPackage ../development/python-modules/pymysql { };

  pymupdf = callPackage ../development/python-modules/pymupdf { };

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

  pybids = callPackage ../development/python-modules/pybids { };

  pybind11 = callPackage ../development/python-modules/pybind11 { };

  py3buddy = toPythonModule (callPackage ../development/python-modules/py3buddy { });

  pybullet = callPackage ../development/python-modules/pybullet { };

  pycairo = callPackage ../development/python-modules/pycairo {
    inherit (pkgs) meson pkgconfig;
  };

  pycategories = callPackage ../development/python-modules/pycategories { };

  pycangjie = disabledIf (!isPy3k) (callPackage ../development/python-modules/pycangjie {
    inherit (pkgs) pkgconfig;
  });

  pycrc = callPackage ../development/python-modules/pycrc { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  PyChromecast = callPackage ../development/python-modules/pychromecast { };

  pycm = callPackage ../development/python-modules/pycm { };

  py-cpuinfo = callPackage ../development/python-modules/py-cpuinfo { };

  py-lru-cache = callPackage ../development/python-modules/py-lru-cache { };

  py-radix = callPackage ../development/python-modules/py-radix { };

  pydbus = callPackage ../development/python-modules/pydbus { };

  pydicom = callPackage ../development/python-modules/pydicom { };

  pydocstyle =
    if isPy27 then
      callPackage ../development/python-modules/pydocstyle/2.nix { }
    else
      callPackage ../development/python-modules/pydocstyle { };

  pydocumentdb = callPackage ../development/python-modules/pydocumentdb { };

  pydrive = callPackage ../development/python-modules/pydrive { };

  pydy = callPackage ../development/python-modules/pydy { };

  pyexiv2 = disabledIf isPy3k (toPythonModule (callPackage ../development/python-modules/pyexiv2 {}));

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { };

  pyfakefs = callPackage ../development/python-modules/pyfakefs {};

  pyfaidx = callPackage ../development/python-modules/pyfaidx { };

  pyfttt = callPackage ../development/python-modules/pyfttt { };

  pyftdi = callPackage ../development/python-modules/pyftdi { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygbm = callPackage ../development/python-modules/pygbm { };

  pygame_sdl2 = callPackage ../development/python-modules/pygame_sdl2 { };

  pygdbmi = callPackage ../development/python-modules/pygdbmi { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygobject2 = callPackage ../development/python-modules/pygobject {
    inherit (pkgs) pkgconfig;
  };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix {
    inherit (pkgs) meson pkgconfig;
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

  pykdtree = callPackage ../development/python-modules/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykerberos = callPackage ../development/python-modules/pykerberos { };

  pykeepass = callPackage ../development/python-modules/pykeepass { };

  pylev = callPackage ../development/python-modules/pylev { };

  pymatgen = callPackage ../development/python-modules/pymatgen { };

  pymatgen-lammps = callPackage ../development/python-modules/pymatgen-lammps { };

  pymavlink = callPackage ../development/python-modules/pymavlink { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pyparser = callPackage ../development/python-modules/pyparser { };

  pyres = callPackage ../development/python-modules/pyres { };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix {
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

  pyqt5_with_qtmultimedia = self.pyqt5.override { withMultimedia = true; };

  pyqtwebengine = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtwebengine {
    pythonPackages = self;
  };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscard = callPackage ../development/python-modules/pyscard { inherit (pkgs.darwin.apple_sdk.frameworks) PCSC; };

  pyschedule = callPackage ../development/python-modules/pyschedule { };

  pyscreenshot = callPackage ../development/python-modules/pyscreenshot { };

  pyside = callPackage ../development/python-modules/pyside {
    inherit (pkgs) mesa;
  };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix {
    inherit (pkgs) libxml2 libxslt; # Do not need the Python bindings.
  };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pyside2 = toPythonModule (callPackage ../development/python-modules/pyside2 {
    inherit (pkgs) cmake qt5 ninja;
  });

  shiboken2 = toPythonModule (callPackage ../development/python-modules/shiboken2 {
    inherit (pkgs) cmake qt5 llvmPackages;
  });

  simplefix = callPackage ../development/python-modules/simplefix { };

  pyside2-tools = toPythonModule (callPackage ../development/python-modules/pyside2-tools {
    inherit (pkgs) cmake qt5;
  });

  pyslurm = callPackage ../development/python-modules/pyslurm {
    slurm = pkgs.slurm;
  };

  pysmb = callPackage ../development/python-modules/pysmb { };

  pysmf = callPackage ../development/python-modules/pysmf { };

  pyspinel = callPackage ../development/python-modules/pyspinel {};

  pyssim = callPackage ../development/python-modules/pyssim { };

  pystache = callPackage ../development/python-modules/pystache { };

  pytelegrambotapi = callPackage ../development/python-modules/pyTelegramBotAPI { };

  pytesseract = callPackage ../development/python-modules/pytesseract { };

  pytest-bdd = callPackage ../development/python-modules/pytest-bdd { };

  pytest-black = callPackage ../development/python-modules/pytest-black { };

  pytest-click = callPackage ../development/python-modules/pytest-click { };

  pytest-check = callPackage ../development/python-modules/pytest-check { };

  pytest-env = callPackage ../development/python-modules/pytest-env { };

  pytest-flask = callPackage ../development/python-modules/pytest-flask { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-ordering = callPackage ../development/python-modules/pytest-ordering { };

  pytest-pylint = callPackage ../development/python-modules/pytest-pylint { };

  pytest-qt = callPackage ../development/python-modules/pytest-qt { };

  pytest-testmon = callPackage ../development/python-modules/pytest-testmon { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  pytest-xprocess = callPackage ../development/python-modules/pytest-xprocess { };

  pytest-xvfb = callPackage ../development/python-modules/pytest-xvfb { };

  pytmx = callPackage ../development/python-modules/pytmx { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-dbusmock = callPackage ../development/python-modules/python-dbusmock { };

  python-dotenv = callPackage ../development/python-modules/python-dotenv { };

  python-engineio = callPackage ../development/python-modules/python-engineio { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-lz4 = callPackage ../development/python-modules/python-lz4 { };
  lz4 = self.python-lz4; # alias 2018-12-05

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

  python-mnist = callPackage ../development/python-modules/python-mnist { };

  pythonocc-core = toPythonModule (callPackage ../development/python-modules/pythonocc-core {
    inherit (pkgs.xorg) libX11;
  });

  python-igraph = callPackage ../development/python-modules/python-igraph {
    pkgconfig = pkgs.pkgconfig;
    igraph = pkgs.igraph;
  };

  python-olm = callPackage ../development/python-modules/python-olm { };

  python3-openid = callPackage ../development/python-modules/python3-openid { };

  python-packer = callPackage ../development/python-modules/python-packer { };

  python-periphery = callPackage ../development/python-modules/python-periphery { };

  python-prctl = callPackage ../development/python-modules/python-prctl { };

  python-rapidjson = callPackage ../development/python-modules/python-rapidjson { };

  python-redis-lock = callPackage ../development/python-modules/python-redis-lock { };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python-snappy = callPackage ../development/python-modules/python-snappy {
    inherit (pkgs) snappy;
  };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-socketio = callPackage ../development/python-modules/python-socketio { };

  python-utils = callPackage ../development/python-modules/python-utils { };

  python-vipaccess = callPackage ../development/python-modules/python-vipaccess { };

  pytimeparse =  callPackage ../development/python-modules/pytimeparse { };

  pytricia =  callPackage ../development/python-modules/pytricia { };

  pytrends = callPackage ../development/python-modules/pytrends { };

  py-vapid = callPackage ../development/python-modules/py-vapid { };

  PyWebDAV = callPackage ../development/python-modules/pywebdav { };

  pywebpush = callPackage ../development/python-modules/pywebpush { };

  pyxml = disabledIf isPy3k (callPackage ../development/python-modules/pyxml{ });

  pyvcd = callPackage ../development/python-modules/pyvcd { };

  pyvcf = callPackage ../development/python-modules/pyvcf { };

  pyvoro = callPackage ../development/python-modules/pyvoro { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  reproject = callPackage ../development/python-modules/reproject { };

  remotecv = callPackage ../development/python-modules/remotecv { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  rig = callPackage ../development/python-modules/rig { };

  rhpl = disabledIf isPy3k (callPackage ../development/python-modules/rhpl {});

  rlp = callPackage ../development/python-modules/rlp { };

  rq = callPackage ../development/python-modules/rq { };

  rx = callPackage ../development/python-modules/rx { };

  sabyenc = callPackage ../development/python-modules/sabyenc { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  selectors2 = callPackage ../development/python-modules/selectors2 { };

  sacremoses = callPackage ../development/python-modules/sacremoses { };

  sentencepiece = callPackage ../development/python-modules/sentencepiece {
    inherit (pkgs) sentencepiece pkgconfig;
  };

  transformers = callPackage ../development/python-modules/transformers { };

  sentinel = callPackage ../development/python-modules/sentinel { };

  sentry-sdk = callPackage ../development/python-modules/sentry-sdk {};

  sepaxml = callPackage ../development/python-modules/sepaxml { };

  serversyncstorage = callPackage ../development/python-modules/serversyncstorage {};

  shellingham = callPackage ../development/python-modules/shellingham {};

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  simple-salesforce = callPackage ../development/python-modules/simple-salesforce { };

  singledispatch = callPackage ../development/python-modules/singledispatch { };

  sip = callPackage ../development/python-modules/sip { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  slackclient = callPackage ../development/python-modules/slackclient { };

  slicedimage = callPackage ../development/python-modules/slicedimage { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  slither-analyzer = callPackage ../development/python-modules/slither-analyzer { };

  sly = callPackage ../development/python-modules/sly { };

  snapcast = callPackage ../development/python-modules/snapcast { };

  soapysdr = toPythonModule (pkgs.soapysdr.override {
    python = self.python;
    usePython = true;
  });

  soapysdr-with-plugins = toPythonModule (pkgs.soapysdr-with-plugins.override {
    python = self.python;
    usePython = true;
  });

  sparse = callPackage ../development/python-modules/sparse { };

  spglib = callPackage ../development/python-modules/spglib { };

  sshpubkeys = callPackage ../development/python-modules/sshpubkeys { };

  sshtunnel = callPackage ../development/python-modules/sshtunnel { };

  sslib = callPackage ../development/python-modules/sslib { };

  statistics = callPackage ../development/python-modules/statistics { };

  stm32loader = callPackage ../development/python-modules/stm32loader { };

  stumpy = callPackage ../development/python-modules/stumpy { };

  stups-cli-support = callPackage ../development/python-modules/stups-cli-support { };

  stups-fullstop = callPackage ../development/python-modules/stups-fullstop { };

  stups-pierone = callPackage ../development/python-modules/stups-pierone { };

  stups-tokens = callPackage ../development/python-modules/stups-tokens { };

  stups-zign = callPackage ../development/python-modules/stups-zign { };

  sumo = callPackage ../development/python-modules/sumo { };

  supervise_api = callPackage ../development/python-modules/supervise_api { };

  tables = if isPy3k then callPackage ../development/python-modules/tables {
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  } else callPackage ../development/python-modules/tables/3.5.nix {
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  };

  tableaudocumentapi = callPackage ../development/python-modules/tableaudocumentapi { };

  tesserocr = callPackage ../development/python-modules/tesserocr { };

  trueskill = callPackage ../development/python-modules/trueskill { };

  trustme = callPackage ../development/python-modules/trustme {};

  trio = callPackage ../development/python-modules/trio {};

  sniffio = callPackage ../development/python-modules/sniffio { };

  spyder-kernels = callPackage ../development/python-modules/spyder-kernels {};
  spyder = callPackage ../development/python-modules/spyder {};

  tenacity = callPackage ../development/python-modules/tenacity { };

  tokenserver = callPackage ../development/python-modules/tokenserver {};

  toml = callPackage ../development/python-modules/toml { };

  tomlkit = callPackage ../development/python-modules/tomlkit { };

  toggl-cli = callPackage ../development/python-modules/toggl-cli { };

  uamqp = callPackage ../development/python-modules/uamqp {
    inherit (pkgs.darwin.apple_sdk.frameworks) CFNetwork Security;
  };

  unifi = callPackage ../development/python-modules/unifi { };

  uvloop = callPackage ../development/python-modules/uvloop {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  };

  pyunifi = callPackage ../development/python-modules/pyunifi { };

  vdf = callPackage ../development/python-modules/vdf { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  webapp2 = callPackage ../development/python-modules/webapp2 { };

  wrf-python = callPackage ../development/python-modules/wrf-python { };

  pyunbound = callPackage ../tools/networking/unbound/python.nix { };

  WazeRouteCalculator = callPackage ../development/python-modules/WazeRouteCalculator { };

  yarg = callPackage ../development/python-modules/yarg { };

  yt = callPackage ../development/python-modules/yt { };

  # packages defined here

  aafigure = callPackage ../development/python-modules/aafigure { };

  addic7ed-cli = callPackage ../development/python-modules/addic7ed-cli { };

  algebraic-data-types = callPackage ../development/python-modules/algebraic-data-types { };

  altair = callPackage ../development/python-modules/altair { };

  vega = callPackage ../development/python-modules/vega { };

  accupy = callPackage ../development/python-modules/accupy { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  adal = callPackage ../development/python-modules/adal { };

  affine = callPackage ../development/python-modules/affine { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aioh2 = callPackage ../development/python-modules/aioh2 { };

  aioftp = callPackage ../development/python-modules/aioftp { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp-cors { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aiohttp-socks = callPackage ../development/python-modules/aiohttp-socks { };

  aiohttp-swagger = callPackage ../development/python-modules/aiohttp-swagger { };

  aiomysql = callPackage ../development/python-modules/aiomysql { };

  aioprocessing = callPackage ../development/python-modules/aioprocessing { };

  aioresponses = callPackage ../development/python-modules/aioresponses { };

  aiosqlite = callPackage ../development/python-modules/aiosqlite { };

  aiorpcx = callPackage ../development/python-modules/aiorpcx { };

  aiosmtpd = callPackage ../development/python-modules/aiosmtpd { };

  aiounifi = callPackage ../development/python-modules/aiounifi { };

  aiounittest = callPackage ../development/python-modules/aiounittest { };

  aiozeroconf = callPackage ../development/python-modules/aiozeroconf { };

  ajpy = callPackage ../development/python-modules/ajpy { };

  alabaster = callPackage ../development/python-modules/alabaster {};

  alembic = callPackage ../development/python-modules/alembic {};

  allpairspy = callPackage ../development/python-modules/allpairspy { };

  annexremote = callPackage ../development/python-modules/annexremote { };

  ansible = callPackage ../development/python-modules/ansible { };

  ansible-kernel = callPackage ../development/python-modules/ansible-kernel { };

  ansible-lint = callPackage ../development/python-modules/ansible-lint { };

  ansible-runner = callPackage ../development/python-modules/ansible-runner { };

  ansicolors = callPackage ../development/python-modules/ansicolors {};

  aniso8601 = callPackage ../development/python-modules/aniso8601 {};

  anonip = callPackage ../development/python-modules/anonip { };

  asgiref = callPackage ../development/python-modules/asgiref { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg {};

  python-uinput = callPackage ../development/python-modules/python-uinput {};

  python-sybase = callPackage ../development/python-modules/sybase {};

  alot = callPackage ../development/python-modules/alot {};

  anyjson = callPackage ../development/python-modules/anyjson {};

  amqp = callPackage ../development/python-modules/amqp {};

  amqplib = callPackage ../development/python-modules/amqplib {};

  antlr4-python2-runtime = callPackage ../development/python-modules/antlr4-python2-runtime { antlr4 = pkgs.antlr4; };

  antlr4-python3-runtime = callPackage ../development/python-modules/antlr4-python3-runtime { antlr4 = pkgs.antlr4; };

  apache-airflow = callPackage ../development/python-modules/apache-airflow { };

  apipkg = callPackage ../development/python-modules/apipkg {};

  apispec = callPackage ../development/python-modules/apispec {};

  appdirs = callPackage ../development/python-modules/appdirs { };

  appleseed = disabledIf isPy3k
    (toPythonModule (pkgs.appleseed.override {
      inherit (self) python;
    }));

  application = callPackage ../development/python-modules/application { };

  applicationinsights = callPackage ../development/python-modules/applicationinsights { };

  appnope = callPackage ../development/python-modules/appnope { };

  approvaltests = callPackage ../development/python-modules/approvaltests { };

  apsw = callPackage ../development/python-modules/apsw {};

  astor = callPackage ../development/python-modules/astor {};

  asyncpg = callPackage ../development/python-modules/asyncpg { };

  asyncssh = callPackage ../development/python-modules/asyncssh { };

  atpublic = callPackage ../development/python-modules/atpublic { };

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  APScheduler = callPackage ../development/python-modules/APScheduler { };

  args = callPackage ../development/python-modules/args { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  area = callPackage ../development/python-modules/area { };

  arxiv2bib = callPackage ../development/python-modules/arxiv2bib { };

  chai = callPackage ../development/python-modules/chai { };

  chainmap = callPackage ../development/python-modules/chainmap { };

  arelle = callPackage ../development/python-modules/arelle {
    gui = true;
  };

  arelle-headless = callPackage ../development/python-modules/arelle {
    gui = false;
  };

  delegator-py = callPackage ../development/python-modules/delegator-py { };

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

  avro-python3 = callPackage ../development/python-modules/avro-python3 {};

  aws-lambda-builders = callPackage ../development/python-modules/aws-lambda-builders { };

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

  bandit = callPackage ../development/python-modules/bandit {};

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

  bids-validator = callPackage ../development/python-modules/bids-validator { };

  binwalk = callPackage ../development/python-modules/binwalk { };

  binwalk-full = appendToName "full" (self.binwalk.override {
    pyqtgraph = self.pyqtgraph;
  });

  bitmath = callPackage ../development/python-modules/bitmath { };

  bitstruct = callPackage ../development/python-modules/bitstruct { };

  caldav = callPackage ../development/python-modules/caldav { };

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

  boolean-py = callPackage ../development/python-modules/boolean-py { };

  bumps = callPackage ../development/python-modules/bumps {};

  bx-python = callPackage ../development/python-modules/bx-python {
    inherit (pkgs) zlib;
  };

  cached-property = callPackage ../development/python-modules/cached-property { };

  caffe = toPythonModule (pkgs.caffe.override {
    pythonSupport = true;
    inherit (self) python numpy boost;
  });

  capstone = callPackage ../development/python-modules/capstone { };

  capturer = callPackage ../development/python-modules/capturer { };

  cement = callPackage ../development/python-modules/cement {};

  cgen = callPackage ../development/python-modules/cgen { };

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils {};

  chainer = callPackage ../development/python-modules/chainer {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  channels = callPackage ../development/python-modules/channels {};

  cheroot = callPackage ../development/python-modules/cheroot {};

  chevron = callPackage ../development/python-modules/chevron {};

  cli-helpers = callPackage ../development/python-modules/cli-helpers {};

  cmarkgfm = callPackage ../development/python-modules/cmarkgfm { };

  colorcet = callPackage ../development/python-modules/colorcet { };

  coloredlogs = callPackage ../development/python-modules/coloredlogs { };

  colorclass = callPackage ../development/python-modules/colorclass {};

  colorlog = callPackage ../development/python-modules/colorlog { };

  colorspacious = callPackage ../development/python-modules/colorspacious { };

  colour = callPackage ../development/python-modules/colour {};

  colormath = callPackage ../development/python-modules/colormath {};

  configshell = callPackage ../development/python-modules/configshell { };

  consonance = callPackage ../development/python-modules/consonance { };

  constantly = callPackage ../development/python-modules/constantly { };

  cornice = callPackage ../development/python-modules/cornice { };

  cram = callPackage ../development/python-modules/cram { };

  crc16 = callPackage ../development/python-modules/crc16 { };

  crccheck = callPackage ../development/python-modules/crccheck { };

  croniter = callPackage ../development/python-modules/croniter { };

  csscompressor = callPackage ../development/python-modules/csscompressor {};

  csvs-to-sqlite = callPackage ../development/python-modules/csvs-to-sqlite { };

  cufflinks = callPackage ../development/python-modules/cufflinks { };

  cupy = callPackage ../development/python-modules/cupy {
    cudatoolkit = pkgs.cudatoolkit_10_0;
    cudnn = pkgs.cudnn_cudatoolkit_10_0;
    nccl = pkgs.nccl_cudatoolkit_10;
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

  dodgy = callPackage ../development/python-modules/dodgy { };

  dugong = callPackage ../development/python-modules/dugong {};

  easysnmp = callPackage ../development/python-modules/easysnmp {
    openssl = pkgs.openssl;
    net-snmp = pkgs.net-snmp;
  };

  iowait = callPackage ../development/python-modules/iowait {};

  responses = callPackage ../development/python-modules/responses {};

  rarfile = callPackage ../development/python-modules/rarfile { inherit (pkgs) libarchive; };

  proboscis = callPackage ../development/python-modules/proboscis {};

  poster3 = callPackage ../development/python-modules/poster3 { };

  py4j = callPackage ../development/python-modules/py4j { };

  pyechonest = callPackage ../development/python-modules/pyechonest { };

  pyepsg = callPackage ../development/python-modules/pyepsg { };

  billiard = callPackage ../development/python-modules/billiard { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  bitbucket_api = callPackage ../development/python-modules/bitbucket-api { };

  bitbucket-cli = callPackage ../development/python-modules/bitbucket-cli { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  blaze = callPackage ../development/python-modules/blaze { };

  html5-parser = callPackage ../development/python-modules/html5-parser {
    inherit (pkgs) pkgconfig;
  };

  HTSeq = callPackage ../development/python-modules/HTSeq { };

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

  box2d = callPackage ../development/python-modules/box2d { };

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


  cairocffi = if isPy3k then
    callPackage ../development/python-modules/cairocffi {}
  else
    callPackage ../development/python-modules/cairocffi/0_9.nix {};

  cairosvg = if isPy3k then
    callPackage ../development/python-modules/cairosvg {}
  else
    callPackage ../development/python-modules/cairosvg/1_x.nix {};

  carrot = callPackage ../development/python-modules/carrot {};

  cartopy = callPackage ../development/python-modules/cartopy {};

  casbin = callPackage ../development/python-modules/casbin { };

  case = callPackage ../development/python-modules/case {};

  cbor = callPackage ../development/python-modules/cbor {};

  cbor2 = callPackage ../development/python-modules/cbor2 {};

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  cccolutils = callPackage ../development/python-modules/cccolutils {};

  cchardet = callPackage ../development/python-modules/cchardet { };

  CDDB = callPackage ../development/python-modules/cddb { };

  cntk = callPackage ../development/python-modules/cntk { };

  celery = callPackage ../development/python-modules/celery { };

  cerberus = callPackage ../development/python-modules/cerberus { };

  certifi = callPackage ../development/python-modules/certifi { };

  certipy = callPackage ../development/python-modules/certipy {};

  characteristic = callPackage ../development/python-modules/characteristic { };

  chart-studio = callPackage ../development/python-modules/chart-studio { };

  cheetah = callPackage ../development/python-modules/cheetah { };

  cherrypy = if isPy3k then
    callPackage ../development/python-modules/cherrypy { }
  else
    callPackage ../development/python-modules/cherrypy/17.nix { };

  cfgv = callPackage ../development/python-modules/cfgv { };

  cfn-lint = callPackage ../development/python-modules/cfn-lint { };

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

  cryptography_vectors = callPackage ../development/python-modules/cryptography/vectors.nix { };

  curtsies = callPackage ../development/python-modules/curtsies { };

  envs = callPackage ../development/python-modules/envs { };

  etelemetry = callPackage ../development/python-modules/etelemetry { };

  eth-hash = callPackage ../development/python-modules/eth-hash { };

  eth-typing = callPackage ../development/python-modules/eth-typing { };

  eth-utils = callPackage ../development/python-modules/eth-utils { };

  impacket = callPackage ../development/python-modules/impacket { };

  jsonlines = callPackage ../development/python-modules/jsonlines { };

  json-merge-patch = callPackage ../development/python-modules/json-merge-patch { };

  jsonrpc-async = callPackage ../development/python-modules/jsonrpc-async { };

  jsonrpc-base = callPackage ../development/python-modules/jsonrpc-base { };

  jsonrpc-websocket = callPackage ../development/python-modules/jsonrpc-websocket { };

  onkyo-eiscp = callPackage ../development/python-modules/onkyo-eiscp { };

  tablib = callPackage ../development/python-modules/tablib { };

  wakeonlan = callPackage ../development/python-modules/wakeonlan { };

  openant = callPackage ../development/python-modules/openant { };

  opencv = disabledIf isPy3k (toPythonModule (pkgs.opencv.override {
    enablePython = true;
    pythonPackages = self;
  }));

  opencv3 = toPythonModule (pkgs.opencv3.override {
    enablePython = true;
    pythonPackages = self;
  });

  opencv4 = toPythonModule (pkgs.opencv4.override {
    enablePython = true;
    pythonPackages = self;
  });

  opentracing = callPackage ../development/python-modules/opentracing { };

  openidc-client = callPackage ../development/python-modules/openidc-client {};

  optuna = callPackage ../development/python-modules/optuna { };

  idna = callPackage ../development/python-modules/idna { };

  mahotas = callPackage ../development/python-modules/mahotas { };

  MDP = callPackage ../development/python-modules/mdp {};

  minidb = callPackage ../development/python-modules/minidb { };

  miniupnpc = callPackage ../development/python-modules/miniupnpc {};

  mixpanel = callPackage ../development/python-modules/mixpanel { };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mxnet = callPackage ../development/python-modules/mxnet { };

  parsy = callPackage ../development/python-modules/parsy { };

  portalocker = callPackage ../development/python-modules/portalocker { };

  portpicker = callPackage ../development/python-modules/portpicker { };

  pkginfo = callPackage ../development/python-modules/pkginfo { };

  pre-commit = callPackage ../development/python-modules/pre-commit { };

  pretend = callPackage ../development/python-modules/pretend { };

  detox = callPackage ../development/python-modules/detox { };

  pbkdf2 = callPackage ../development/python-modules/pbkdf2 { };

  bcrypt = callPackage ../development/python-modules/bcrypt { };

  cffi = callPackage ../development/python-modules/cffi { };

  pyavm = callPackage ../development/python-modules/pyavm { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycontracts = callPackage ../development/python-modules/pycontracts { };

  pycparser = callPackage ../development/python-modules/pycparser { };

  pydub = callPackage ../development/python-modules/pydub {};

  pyjade = callPackage ../development/python-modules/pyjade {};

  pyjet = callPackage ../development/python-modules/pyjet {};

  pyjks = callPackage ../development/python-modules/pyjks {};

  PyLD = callPackage ../development/python-modules/PyLD { };

  python-jose = callPackage ../development/python-modules/python-jose {};

  python-json-logger = callPackage ../development/python-modules/python-json-logger { };

  python-ly = callPackage ../development/python-modules/python-ly {};

  pyhepmc = callPackage ../development/python-modules/pyhepmc { };

  pytest = if isPy3k then self.pytest_5 else self.pytest_4;

  pytest_5 = callPackage ../development/python-modules/pytest {
    # hypothesis tests require pytest that causes dependency cycle
    hypothesis = self.hypothesis.override { doCheck = false; };
  };

  pytest_4 = callPackage ../development/python-modules/pytest/4.nix {
    # hypothesis tests require pytest that causes dependency cycle
    hypothesis = self.hypothesis.override { doCheck = false; };
  };

  pytest-helpers-namespace = callPackage ../development/python-modules/pytest-helpers-namespace { };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytest-annotate = callPackage ../development/python-modules/pytest-annotate { };

  pytest-ansible = callPackage ../development/python-modules/pytest-ansible { };

  pytest-aiohttp = callPackage ../development/python-modules/pytest-aiohttp { };

  pytest-arraydiff = callPackage ../development/python-modules/pytest-arraydiff { };

  pytest-astropy = callPackage ../development/python-modules/pytest-astropy { };

  pytest-benchmark = callPackage ../development/python-modules/pytest-benchmark { };

  pytestcache = callPackage ../development/python-modules/pytestcache { };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-doctestplus = callPackage ../development/python-modules/pytest-doctestplus { };

  pytest-faulthandler = callPackage ../development/python-modules/pytest-faulthandler { };

  pytest-fixture-config = callPackage ../development/python-modules/pytest-fixture-config { };

  pytest-forked = callPackage ../development/python-modules/pytest-forked { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-remotedata = callPackage ../development/python-modules/pytest-remotedata { };

  pytest-sanic = callPackage ../development/python-modules/pytest-sanic { };

  pytest-flake8 = callPackage ../development/python-modules/pytest-flake8 { };

  pytest-flakes = callPackage ../development/python-modules/pytest-flakes { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-mpl = callPackage ../development/python-modules/pytest-mpl { };

  pytest-mock = callPackage ../development/python-modules/pytest-mock { };

  pytest-openfiles = callPackage ../development/python-modules/pytest-openfiles { };

  pytest-timeout = callPackage ../development/python-modules/pytest-timeout { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytest-watch = callPackage ../development/python-modules/pytest-watch { };

  pytestpep8 = callPackage ../development/python-modules/pytest-pep8 { };

  pytest-pep257 = callPackage ../development/python-modules/pytest-pep257 { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-random-order = callPackage ../development/python-modules/pytest-random-order { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytestrunner = callPackage ../development/python-modules/pytestrunner { };

  pytestquickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-services = callPackage ../development/python-modules/pytest-services { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  pytest-socket = callPackage ../development/python-modules/pytest-socket { };

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

  dask-mpi = callPackage ../development/python-modules/dask-mpi { };

  dask-xgboost = callPackage ../development/python-modules/dask-xgboost { };

  datrie = callPackage ../development/python-modules/datrie { };

  heapdict = callPackage ../development/python-modules/heapdict { };

  zict = callPackage ../development/python-modules/zict { };

  zigpy = callPackage ../development/python-modules/zigpy { };

  zigpy-deconz = callPackage ../development/python-modules/zigpy-deconz { };

  digital-ocean = callPackage ../development/python-modules/digitalocean { };

  leather = callPackage ../development/python-modules/leather { };

  libais = callPackage ../development/python-modules/libais { };

  libfdt = toPythonModule (pkgs.dtc.override {
    inherit python;
  });

  libtmux = callPackage ../development/python-modules/libtmux { };

  libusb1 = callPackage ../development/python-modules/libusb1 { inherit (pkgs) libusb1; };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  locket = callPackage ../development/python-modules/locket { };

  loo-py = callPackage ../development/python-modules/loo-py { };

  tblib = callPackage ../development/python-modules/tblib { };

  s3fs = callPackage ../development/python-modules/s3fs { };

  datashape = callPackage ../development/python-modules/datashape { };

  requests-cache = callPackage ../development/python-modules/requests-cache { };

  requests-file = callPackage ../development/python-modules/requests-file { };

  requests-kerberos = callPackage ../development/python-modules/requests-kerberos { };

  requests-unixsocket = callPackage ../development/python-modules/requests-unixsocket {};

  requests-aws4auth = callPackage ../development/python-modules/requests-aws4auth { };

  howdoi = callPackage ../development/python-modules/howdoi {};

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

  deprecated = callPackage ../development/python-modules/deprecated { };

  deprecation = callPackage ../development/python-modules/deprecation { };

  derpconf = callPackage ../development/python-modules/derpconf { };

  deskcon = callPackage ../development/python-modules/deskcon { };

  dill = callPackage ../development/python-modules/dill { };

  discogs_client = callPackage ../development/python-modules/discogs_client { };

  dmenu-python = callPackage ../development/python-modules/dmenu { };

  dnslib = callPackage ../development/python-modules/dnslib { };

  dnspython = callPackage ../development/python-modules/dnspython { };
  dns = self.dnspython; # Alias for compatibility, 2017-12-10

  docker = callPackage ../development/python-modules/docker {};

  dockerfile-parse = callPackage ../development/python-modules/dockerfile-parse {};

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

  drms = callPackage ../development/python-modules/drms { };

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

  edward = callPackage ../development/python-modules/edward { };

  elasticsearch = callPackage ../development/python-modules/elasticsearch { };

  elasticsearch-dsl = callPackage ../development/python-modules/elasticsearch-dsl { };
  # alias
  elasticsearchdsl = self.elasticsearch-dsl;

  elementpath = callPackage ../development/python-modules/elementpath { };

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

  executor = callPackage ../development/python-modules/executor { };

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

  flammkuchen = callPackage ../development/python-modules/flammkuchen { };

  flexmock = callPackage ../development/python-modules/flexmock { };

  flit = callPackage ../development/python-modules/flit { };

  flowlogs_reader = callPackage ../development/python-modules/flowlogs_reader { };

  fluent-logger = callPackage ../development/python-modules/fluent-logger {};

  flux-led = callPackage ../development/python-modules/flux-led { };

  python-forecastio = callPackage ../development/python-modules/python-forecastio { };

  fpdf = callPackage ../development/python-modules/fpdf { };

  fpylll = callPackage ../development/python-modules/fpylll { };

  fritzconnection = callPackage ../development/python-modules/fritzconnection { };

  frozendict = callPackage ../development/python-modules/frozendict { };

  ftputil = callPackage ../development/python-modules/ftputil { };

  fudge = callPackage ../development/python-modules/fudge { };

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  fastentrypoints = callPackage ../development/python-modules/fastentrypoints { };

  functools32 = callPackage ../development/python-modules/functools32 { };

  future-fstrings = callPackage ../development/python-modules/future-fstrings { };

  fx2 = callPackage ../development/python-modules/fx2 { };

  # gaia isn't supported with python3 and it's not available from pypi
  gaia = disabledIf (isPyPy || isPy3k) (toPythonModule (pkgs.gaia.override {
    pythonPackages = self;
    pythonSupport = true;
  }));

  gateone = callPackage ../development/python-modules/gateone { };

  GeoIP = callPackage ../development/python-modules/GeoIP { };

  glasgow = callPackage ../development/python-modules/glasgow { };

  gmpy = callPackage ../development/python-modules/gmpy { };

  gmpy2 = callPackage ../development/python-modules/gmpy2 { };

  gmusicapi = callPackage ../development/python-modules/gmusicapi { };

  gnureadline = callPackage ../development/python-modules/gnureadline { };

  gnutls = callPackage ../development/python-modules/gnutls { };

  gpy = callPackage ../development/python-modules/gpy { };

  gpyopt = callPackage ../development/python-modules/gpyopt { };

  gitdb = callPackage ../development/python-modules/gitdb { };

  gitdb2 = callPackage ../development/python-modules/gitdb2 { };

  GitPython = callPackage ../development/python-modules/GitPython { };

  git-annex-adapter = callPackage ../development/python-modules/git-annex-adapter {
    inherit (pkgs.gitAndTools) git-annex;
  };

  python-gitlab = callPackage ../development/python-modules/python-gitlab { };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-music = callPackage ../development/python-modules/google-music { };

  google-music-proto = callPackage ../development/python-modules/google-music-proto { };

  google-music-utils = callPackage ../development/python-modules/google-music-utils { };

  google-pasta = callPackage ../development/python-modules/google-pasta { };

  gpapi = callPackage ../development/python-modules/gpapi { };
  gplaycli = callPackage ../development/python-modules/gplaycli { };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  gpxpy = callPackage ../development/python-modules/gpxpy { };

  grip = callPackage ../development/python-modules/grip { };

  gst-python = callPackage ../development/python-modules/gst-python {
    inherit (pkgs) meson pkgconfig;
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

  hass-nabucasa = callPackage ../development/python-modules/hass-nabucasa { };

  hbmqtt = callPackage ../development/python-modules/hbmqtt { };

  hiro = callPackage ../development/python-modules/hiro {};

  hglib = callPackage ../development/python-modules/hglib {};

  humanize = callPackage ../development/python-modules/humanize { };

  humanfriendly = callPackage ../development/python-modules/humanfriendly { };

  hupper = callPackage ../development/python-modules/hupper {};

  hsaudiotag = callPackage ../development/python-modules/hsaudiotag { };

  hsaudiotag3k = callPackage ../development/python-modules/hsaudiotag3k { };

  hstspreload = callPackage ../development/python-modules/hstspreload { };

  htmlmin = callPackage ../development/python-modules/htmlmin {};

  httpauth = callPackage ../development/python-modules/httpauth { };

  httpx = callPackage ../development/python-modules/httpx { };

  idna-ssl = callPackage ../development/python-modules/idna-ssl { };

  identify = callPackage ../development/python-modules/identify { };

  ijson = callPackage ../development/python-modules/ijson {};

  imagecodecs-lite = disabledIf (!isPy3k) (callPackage ../development/python-modules/imagecodecs-lite { });

  imagesize = callPackage ../development/python-modules/imagesize { };

  image-match = callPackage ../development/python-modules/image-match { };

  imbalanced-learn =
    if isPy27 then
      callPackage ../development/python-modules/imbalanced-learn/0.4.nix { }
    else
      callPackage ../development/python-modules/imbalanced-learn { };

  immutables = callPackage ../development/python-modules/immutables {};

  imread = callPackage ../development/python-modules/imread {
    inherit (pkgs) pkgconfig libjpeg libpng libtiff libwebp;
  };

  imaplib2 = callPackage ../development/python-modules/imaplib2 { };

  ipfsapi = callPackage ../development/python-modules/ipfsapi { };

  isbnlib = callPackage ../development/python-modules/isbnlib { };

  islpy = callPackage ../development/python-modules/islpy { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous { };

  iniparse = callPackage ../development/python-modules/iniparse { };

  intreehooks = callPackage ../development/python-modules/intreehooks { };

  i3-py = callPackage ../development/python-modules/i3-py { };

  JayDeBeApi = callPackage ../development/python-modules/JayDeBeApi {};

  jdcal = callPackage ../development/python-modules/jdcal { };

  jieba = callPackage ../development/python-modules/jieba { };

  internetarchive = callPackage ../development/python-modules/internetarchive {};

  JPype1 = callPackage ../development/python-modules/JPype1 {};

  jpylyzer = callPackage ../development/python-modules/jpylyzer {};

  josepy = callPackage ../development/python-modules/josepy {};

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier {};

  jug = callPackage ../development/python-modules/jug {};

  jsmin = callPackage ../development/python-modules/jsmin { };

  jsonmerge = callPackage ../development/python-modules/jsonmerge { };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpickle = callPackage ../development/python-modules/jsonpickle { };

  jsonpointer = callPackage ../development/python-modules/jsonpointer { };

  jsonrpclib = callPackage ../development/python-modules/jsonrpclib { };

  jsonrpclib-pelix = callPackage ../development/python-modules/jsonrpclib-pelix {};

  jsonwatch = callPackage ../development/python-modules/jsonwatch { };

  latexcodec = callPackage ../development/python-modules/latexcodec {};

  libselinux = pipe pkgs.libselinux [
    toPythonModule

    (p: p.overrideAttrs (super: {
      meta = super.meta // {
        outputsToInstall = [ "py" ];
      };
    }))

    (p: p.override {
      enablePython = true;
      inherit python;
    })

    (p: p.py)
  ];

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libthumbor = callPackage ../development/python-modules/libthumbor { };

  license-expression = callPackage ../development/python-modules/license-expression { };

  lightblue = callPackage ../development/python-modules/lightblue { };

  lightgbm = callPackage ../development/python-modules/lightgbm { };

  lightning = callPackage ../development/python-modules/lightning { };

  lightparam = callPackage ../development/python-modules/lightparam { };

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

  measurement = callPackage ../development/python-modules/measurement {};

  midiutil = callPackage ../development/python-modules/midiutil {};

  misaka = callPackage ../development/python-modules/misaka {};

  mlrose = callPackage ../development/python-modules/mlrose { };

  mt-940 = callPackage ../development/python-modules/mt-940 { };

  mwlib = callPackage ../development/python-modules/mwlib { };

  mwlib-ext = callPackage ../development/python-modules/mwlib-ext { };

  mwlib-rl = callPackage ../development/python-modules/mwlib-rl { };

  myfitnesspal = callPackage ../development/python-modules/myfitnesspal { };

  natsort = callPackage ../development/python-modules/natsort { };

  naturalsort = callPackage ../development/python-modules/naturalsort { };

  ncclient = callPackage ../development/python-modules/ncclient {};

  logfury = callPackage ../development/python-modules/logfury { };

  ndg-httpsclient = callPackage ../development/python-modules/ndg-httpsclient { };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  netdisco = callPackage ../development/python-modules/netdisco { };

  Nikola = callPackage ../development/python-modules/Nikola { };

  nmigen = callPackage ../development/python-modules/nmigen { };

  nmigen-boards = callPackage ../development/python-modules/nmigen-boards { };

  nxt-python = callPackage ../development/python-modules/nxt-python { };

  odfpy = callPackage ../development/python-modules/odfpy { };

  openrazer = callPackage ../development/python-modules/openrazer/pylib.nix { };
  openrazer-daemon = callPackage ../development/python-modules/openrazer/daemon.nix { };

  oset = callPackage ../development/python-modules/oset { };

  oscrypto = callPackage ../development/python-modules/oscrypto { };

  oyaml = callPackage ../development/python-modules/oyaml { };

  pamela = callPackage ../development/python-modules/pamela { };

  paperspace = callPackage ../development/python-modules/paperspace { };

  paperwork-backend = callPackage ../applications/office/paperwork/backend.nix { };

  papis = callPackage ../development/python-modules/papis { };

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

  pycuda = callPackage ../development/python-modules/pycuda {
    cudatoolkit = pkgs.cudatoolkit_7_5;
    inherit (pkgs.stdenv) mkDerivation;
  };

  pydotplus = callPackage ../development/python-modules/pydotplus { };

  pyfxa = callPackage ../development/python-modules/pyfxa { };

  pyhomematic = callPackage ../development/python-modules/pyhomematic { };

  pylama = callPackage ../development/python-modules/pylama { };

  pymbolic = callPackage ../development/python-modules/pymbolic { };

  pymediainfo = callPackage ../development/python-modules/pymediainfo { };

  pyphen = callPackage ../development/python-modules/pyphen {};

  pypoppler = callPackage ../development/python-modules/pypoppler { };

  pypillowfight = callPackage ../development/python-modules/pypillowfight { };

  pyprind = callPackage ../development/python-modules/pyprind { };

  python-axolotl = callPackage ../development/python-modules/python-axolotl { };

  python-axolotl-curve25519 = callPackage ../development/python-modules/python-axolotl-curve25519 { };

  pythonix = callPackage ../development/python-modules/pythonix {
    inherit (pkgs) meson pkgconfig;
  };

  python-lzf = callPackage ../development/python-modules/python-lzf { };

  pyramid = callPackage ../development/python-modules/pyramid { };

  pyramid_beaker = callPackage ../development/python-modules/pyramid_beaker { };

  pyramid_chameleon = callPackage ../development/python-modules/pyramid_chameleon { };

  pyramid_jinja2 = callPackage ../development/python-modules/pyramid_jinja2 { };

  pyramid_mako = callPackage ../development/python-modules/pyramid_mako { };

  peewee =  callPackage ../development/python-modules/peewee { };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyspf = callPackage ../development/python-modules/pyspf { };

  pysptk = callPackage ../development/python-modules/pysptk { };

  pysrim = callPackage ../development/python-modules/pysrim { };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pytools = callPackage ../development/python-modules/pytools { };

  python-ctags3 = callPackage ../development/python-modules/python-ctags3 { };

  python-lzo = callPackage ../development/python-modules/python-lzo {
    inherit (pkgs) lzo;
  };

  junos-eznc = callPackage ../development/python-modules/junos-eznc {};

  raven = callPackage ../development/python-modules/raven { };

  rawkit = callPackage ../development/python-modules/rawkit { };

  joblib = callPackage ../development/python-modules/joblib { };

  sarge = callPackage ../development/python-modules/sarge { };

  subliminal = callPackage ../development/python-modules/subliminal {};

  sunpy = callPackage ../development/python-modules/sunpy { };

  hyperkitty = callPackage ../servers/mail/mailman/hyperkitty.nix { };

  robot-detection = callPackage ../development/python-modules/robot-detection {};

  cssmin = callPackage ../development/python-modules/cssmin {};

  django-paintstore = callPackage ../development/python-modules/django-paintstore {};

  django-q = callPackage ../development/python-modules/django-q {};

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

  regional = callPackage ../development/python-modules/regional { };

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

  rotate-backups = callPackage ../tools/backup/rotate-backups { };

  librosa = callPackage ../development/python-modules/librosa { };

  samplerate = callPackage ../development/python-modules/samplerate { };

  ssdeep = callPackage ../development/python-modules/ssdeep { };

  ssdp = callPackage ../development/python-modules/ssdp { };

  statsd = callPackage ../development/python-modules/statsd { };

  starfish = callPackage ../development/python-modules/starfish { };

  swagger-ui-bundle = callPackage ../development/python-modules/swagger-ui-bundle { };

  multi_key_dict = callPackage ../development/python-modules/multi_key_dict { };

  random2 = callPackage ../development/python-modules/random2 { };

  schedule = callPackage ../development/python-modules/schedule { };

  repoze_lru = callPackage ../development/python-modules/repoze_lru { };

  repoze_sphinx_autointerface =  callPackage ../development/python-modules/repoze_sphinx_autointerface { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  sievelib = callPackage ../development/python-modules/sievelib { };

  watchdog = callPackage ../development/python-modules/watchdog { };

  zope_deprecation = callPackage ../development/python-modules/zope_deprecation { };

  validators = callPackage ../development/python-modules/validators { };

  validictory = callPackage ../development/python-modules/validictory { };

  validate-email = callPackage ../development/python-modules/validate-email { };

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

  django_2_2 = callPackage ../development/python-modules/django/2_2.nix { };

  django_1_8 = callPackage ../development/python-modules/django/1_8.nix { };

  django-allauth = callPackage ../development/python-modules/django-allauth { };

  django_appconf = callPackage ../development/python-modules/django_appconf { };

  django-auth-ldap = callPackage ../development/python-modules/django-auth-ldap { };

  django_colorful = callPackage ../development/python-modules/django_colorful { };

  django-cache-url = callPackage ../development/python-modules/django-cache-url { };

  django-cleanup = callPackage ../development/python-modules/django-cleanup { };

  django-configurations = callPackage ../development/python-modules/django-configurations { };

  django_compressor = callPackage ../development/python-modules/django_compressor { };

  django_compat = callPackage ../development/python-modules/django-compat { };

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

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-logentry-admin = callPackage ../development/python-modules/django-logentry-admin { };

  django-mailman3 = callPackage ../development/python-modules/django-mailman3 { };

  django-oauth-toolkit = callPackage ../development/python-modules/django-oauth-toolkit { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django_polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-postgresql-netfields = callPackage ../development/python-modules/django-postgresql-netfields { };

  django-ranged-response = callPackage ../development/python-modules/django-ranged-response { };

  django-rest-auth = callPackage ../development/python-modules/django-rest-auth { };

  django-sampledatahelper = callPackage ../development/python-modules/django-sampledatahelper { };

  django-simple-captcha = callPackage ../development/python-modules/django-simple-captcha { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django-storages = callPackage ../development/python-modules/django-storages { };

  django-versatileimagefield = callPackage ../development/python-modules/django-versatileimagefield  { };

  django-webpack-loader = callPackage ../development/python-modules/django-webpack-loader { };

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

  djangoql = callPackage ../development/python-modules/djangoql { };

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

  fiona = callPackage ../development/python-modules/fiona { gdal_2 = pkgs.gdal_2; };

  fitbit = callPackage ../development/python-modules/fitbit { };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flake8-import-order = callPackage ../development/python-modules/flake8-import-order { };

  flake8-polyfill = callPackage ../development/python-modules/flake8-polyfill { };

  flaky = callPackage ../development/python-modules/flaky { };

  flask = callPackage ../development/python-modules/flask { };

  flask-admin = callPackage ../development/python-modules/flask-admin { };

  flask-appbuilder = callPackage ../development/python-modules/flask-appbuilder { };

  flask-api = callPackage ../development/python-modules/flask-api { };

  flask_assets = callPackage ../development/python-modules/flask-assets { };

  flask-autoindex = callPackage ../development/python-modules/flask-autoindex { };

  flask-babel = callPackage ../development/python-modules/flask-babel { };

  flask-babelex = callPackage ../development/python-modules/flask-babelex { };

  flask-bcrypt = callPackage ../development/python-modules/flask-bcrypt { };

  flask-bootstrap = callPackage ../development/python-modules/flask-bootstrap { };

  flask-caching = callPackage ../development/python-modules/flask-caching { };

  flask-common = callPackage ../development/python-modules/flask-common { };

  flask-compress = callPackage ../development/python-modules/flask-compress { };

  flask-cors = callPackage ../development/python-modules/flask-cors { };

  flask_elastic = callPackage ../development/python-modules/flask-elastic { };

  flask-httpauth = callPackage ../development/python-modules/flask-httpauth { };

  flask-jwt-extended = callPackage ../development/python-modules/flask-jwt-extended { };

  flask-limiter = callPackage ../development/python-modules/flask-limiter { };

  flask_login = callPackage ../development/python-modules/flask-login { };

  flask_ldap_login = callPackage ../development/python-modules/flask-ldap-login { };

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

  flask_script = callPackage ../development/python-modules/flask-script { };

  flask-silk = callPackage ../development/python-modules/flask-silk { };

  flask-socketio = callPackage ../development/python-modules/flask-socketio { };

  flask_sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask-swagger = callPackage ../development/python-modules/flask-swagger { };

  flask-swagger-ui = callPackage ../development/python-modules/flask-swagger-ui { };

  flask_testing = callPackage ../development/python-modules/flask-testing { };

  flask_wtf = callPackage ../development/python-modules/flask-wtf { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  wtf-peewee = callPackage ../development/python-modules/wtf-peewee { };

  graph-tool = callPackage ../development/python-modules/graph-tool/2.x.x.nix {
    inherit (pkgs) pkg-config;
  };

  grappelli_safe = callPackage ../development/python-modules/grappelli_safe { };

  greatfet = callPackage ../development/python-modules/greatfet { };

  pygreat = callPackage ../development/python-modules/pygreat { };

  pytorch = callPackage ../development/python-modules/pytorch {
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  pyro-ppl = callPackage ../development/python-modules/pyro-ppl {};

  opt-einsum = if isPy27 then
      callPackage ../development/python-modules/opt-einsum/2.nix {}
    else
      callPackage ../development/python-modules/opt-einsum {};

  pytorchWithCuda = self.pytorch.override {
    cudaSupport = true;
  };

  pytorchWithoutCuda = self.pytorch.override {
    cudaSupport = false;
  };

  pythondialog = callPackage ../development/python-modules/pythondialog { };

  python2-pythondialog = callPackage ../development/python-modules/python2-pythondialog { };

  pyRFC3339 = callPackage ../development/python-modules/pyrfc3339 { };

  rfc3987 = callPackage ../development/python-modules/rfc3987 { };

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

  git-revise = callPackage ../development/python-modules/git-revise { };

  git-sweep = callPackage ../development/python-modules/git-sweep { };

  glances = callPackage ../development/python-modules/glances { };

  github3_py = callPackage ../development/python-modules/github3_py { };

  github-webhook = callPackage ../development/python-modules/github-webhook { };

  goobook = callPackage ../development/python-modules/goobook { };

  googleapis_common_protos = callPackage ../development/python-modules/googleapis_common_protos { };

  google-auth-httplib2 = callPackage ../development/python-modules/google-auth-httplib2 { };

  google-auth-oauthlib = callPackage ../development/python-modules/google-auth-oauthlib { };

  google_api_core = callPackage ../development/python-modules/google_api_core { };

  google_api_python_client = let
    google_api_python_client = callPackage ../development/python-modules/google-api-python-client { };
  in if isPy3k then google_api_python_client else
    # Python 2.7 support was deprecated but is still needed by weboob and duplicity
    google_api_python_client.overridePythonAttrs (old: rec {
      version = "1.7.6";
      src = old.src.override {
        inherit version;
        sha256 = "14w5sdrp0bk9n0r2lmpqmrbf2zclpfq6q7giyahnskkfzdkb165z";
      };
    });

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

  gtts-token = callPackage ../development/python-modules/gtts-token { };

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

  hiredis = callPackage ../development/python-modules/hiredis { };

  homeassistant-pyozw = callPackage ../development/python-modules/homeassistant-pyozw { };

  htmllaundry = callPackage ../development/python-modules/htmllaundry { };

  html5lib = callPackage ../development/python-modules/html5lib { };

  httmock = callPackage ../development/python-modules/httmock { };

  http_signature = callPackage ../development/python-modules/http_signature { };

  httpbin = callPackage ../development/python-modules/httpbin { };

  httplib2 = callPackage ../development/python-modules/httplib2 { };

  hvac = callPackage ../development/python-modules/hvac { };

  hydra = callPackage ../development/python-modules/hydra { };

  hypothesis = callPackage ../development/python-modules/hypothesis { };

  colored = callPackage ../development/python-modules/colored { };

  xdis = callPackage ../development/python-modules/xdis { };

  xnd = callPackage ../development/python-modules/xnd { };

  uncompyle6 = callPackage ../development/python-modules/uncompyle6 { };

  lsi = callPackage ../development/python-modules/lsi { };

  hkdf = callPackage ../development/python-modules/hkdf { };

  httpretty = callPackage ../development/python-modules/httpretty { };

  icalendar = callPackage ../development/python-modules/icalendar { };

  ics = callPackage ../development/python-modules/ics { };

  ifaddr = callPackage ../development/python-modules/ifaddr { };

  imageio = callPackage ../development/python-modules/imageio { };

  imageio-ffmpeg = callPackage ../development/python-modules/imageio-ffmpeg { };

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

  ipython = if isPy27 then
      callPackage ../development/python-modules/ipython/5.nix { }
    else if isPy35 then
      callPackage ../development/python-modules/ipython/7.9.nix { }
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

  isoweek = callPackage ../development/python-modules/isoweek {};

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

  keyring = if isPy3k then
    callPackage ../development/python-modules/keyring { }
  else
    callPackage ../development/python-modules/keyring/2.nix { };

  keyutils = callPackage ../development/python-modules/keyutils { inherit (pkgs) keyutils; };

  kiwisolver = callPackage ../development/python-modules/kiwisolver { };

  klaus = callPackage ../development/python-modules/klaus {};

  klein = callPackage ../development/python-modules/klein { };

  koji = callPackage ../development/python-modules/koji { };

  kombu = callPackage ../development/python-modules/kombu { };

  konfig = callPackage ../development/python-modules/konfig { };

  kitchen = callPackage ../development/python-modules/kitchen { };

  knack = callPackage ../development/python-modules/knack { };

  kubernetes = callPackage ../development/python-modules/kubernetes { };

  k5test = callPackage ../development/python-modules/k5test {
    inherit (pkgs) krb5Full findutils which;
  };

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

  leveldb = callPackage ../development/python-modules/leveldb { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  python_openzwave = callPackage ../development/python-modules/python_openzwave {
    inherit (pkgs) pkgconfig;
  };

  python-Levenshtein = callPackage ../development/python-modules/python-levenshtein { };

  python-unshare = callPackage ../development/python-modules/python-unshare { };

  fs = callPackage ../development/python-modules/fs { };

  fs-s3fs = callPackage ../development/python-modules/fs-s3fs { };

  libarcus = callPackage ../development/python-modules/libarcus { inherit (pkgs) protobuf; };

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
    (toPythonModule (pkgs.libplist.override { enablePython = true; inherit python; })).py;

  libxml2 = (toPythonModule (pkgs.libxml2.override{pythonSupport=true; inherit python;})).py;

  libxslt = (toPythonModule (pkgs.libxslt.override{pythonSupport=true; inherit python; inherit (self) libxml2;})).py;

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

  llvmlite = callPackage ../development/python-modules/llvmlite { llvm = pkgs.llvm_8; };

  lockfile = callPackage ../development/python-modules/lockfile { };

  logilab_common = callPackage ../development/python-modules/logilab/common.nix {};

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix {};

  lxml = callPackage ../development/python-modules/lxml {inherit (pkgs) libxml2 libxslt zlib;};

  lxc = callPackage ../development/python-modules/lxc { };

  py_scrypt = callPackage ../development/python-modules/py_scrypt { };

  python_magic = callPackage ../development/python-modules/python-magic { };

  m3u8 = callPackage ../development/python-modules/m3u8 { };

  magic = callPackage ../development/python-modules/magic { };

  m2crypto = callPackage ../development/python-modules/m2crypto { };

  Mako = callPackage ../development/python-modules/Mako { };

  macfsevents = callPackage ../development/python-modules/macfsevents {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;
  };

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

  Markups = callPackage ../development/python-modules/Markups { };

  markupsafe = callPackage ../development/python-modules/markupsafe { };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-enum = callPackage ../development/python-modules/marshmallow-enum { };

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

  matrix-nio = callPackage ../development/python-modules/matrix-nio { };

  mautrix = callPackage ../development/python-modules/mautrix { };
  mautrix-appservice = self.mautrix; # alias 2019-12-28

  maya = callPackage ../development/python-modules/maya { };

  mccabe = callPackage ../development/python-modules/mccabe { };

  mechanize = callPackage ../development/python-modules/mechanize { };

  MechanicalSoup = callPackage ../development/python-modules/MechanicalSoup { };

  meld3 = callPackage ../development/python-modules/meld3 { };

  meliae = callPackage ../development/python-modules/meliae {};

  meinheld = callPackage ../development/python-modules/meinheld { };

  memcached = callPackage ../development/python-modules/memcached { };

  memory_profiler = callPackage ../development/python-modules/memory_profiler { };

  mesa = callPackage ../development/python-modules/mesa { };

  meson = disabledIf (pythonOlder "3.5") (toPythonModule ((pkgs.meson.override {
    python3Packages = self;
  }).overrideAttrs(oldAttrs: {
     # We do not want the setup hook in Python packages
     # because the build is performed differently.
    setupHook = null;
  })));

  mesonpep517 = callPackage ../development/python-modules/mesonpep517 { };

  metaphone = callPackage ../development/python-modules/metaphone { };

  mezzanine = callPackage ../development/python-modules/mezzanine { };

  micawber = callPackage ../development/python-modules/micawber { };

  milksnake = callPackage ../development/python-modules/milksnake { };

  minimock = callPackage ../development/python-modules/minimock { };

  minio = callPackage ../development/python-modules/minio { };

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

  modeled = callPackage ../development/python-modules/modeled { };

  moderngl = callPackage ../development/python-modules/moderngl { };

  moderngl-window = callPackage ../development/python-modules/moderngl_window { };

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

  mpv = callPackage ../development/python-modules/mpv { mpv = pkgs.mpv; };

  mrbob = callPackage ../development/python-modules/mrbob {};

  msgpack = callPackage ../development/python-modules/msgpack {};

  msgpack-numpy = callPackage ../development/python-modules/msgpack-numpy {};

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

  mypy-extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  neuronpy = callPackage ../development/python-modules/neuronpy { };

  persisting-theory = callPackage ../development/python-modules/persisting-theory { };

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

  merkletools = callPackage ../development/python-modules/merkletools { };

  monosat = disabledIf (!isPy3k) (pkgs.monosat.python { inherit buildPythonPackage; inherit (self) cython; });

  monotonic = callPackage ../development/python-modules/monotonic { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  namebench = callPackage ../development/python-modules/namebench { };

  namedlist = callPackage ../development/python-modules/namedlist { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  names = callPackage ../development/python-modules/names { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbdime = callPackage ../development/python-modules/nbdime { };

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

  nidaqmx = callPackage ../development/python-modules/nidaqmx { };

  nilearn = callPackage ../development/python-modules/nilearn {};

  nimfa = callPackage ../development/python-modules/nimfa {};

  nipy = callPackage ../development/python-modules/nipy { };

  nipype = callPackage ../development/python-modules/nipype {
    inherit (pkgs) which;
  };

  nixpkgs = callPackage ../development/python-modules/nixpkgs { };

  nixpkgs-pytools = callPackage ../development/python-modules/nixpkgs-pytools { };

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

  notebook = if isPy3k then callPackage ../development/python-modules/notebook { }
  else callPackage ../development/python-modules/notebook/2.nix { };

  notedown = callPackage ../development/python-modules/notedown { };

  notify = callPackage ../development/python-modules/notify { };

  notify2 = callPackage ../development/python-modules/notify2 {};

  notmuch = callPackage ../development/python-modules/notmuch { };

  emoji = callPackage ../development/python-modules/emoji { };

  ntplib = callPackage ../development/python-modules/ntplib { };

  num2words = callPackage ../development/python-modules/num2words { };

  numba = callPackage ../development/python-modules/numba { };

  numcodecs = callPackage ../development/python-modules/numcodecs {
    inherit (pkgs) gcc8;
  };

  numexpr = callPackage ../development/python-modules/numexpr { };

  Nuitka = callPackage ../development/python-modules/nuitka { };

  numpy = let
    numpy_ = callPackage ../development/python-modules/numpy {
      blas = pkgs.openblasCompat;
    };
    numpy_2 = numpy_.overridePythonAttrs(oldAttrs: rec {
      version = "1.16.5";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "8bb452d94e964b312205b0de1238dd7209da452343653ab214b5d681780e7a0c";
      };
    });
  in if pythonOlder "3.5" then numpy_2 else numpy_;

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

  openpyxl = if isPy3k then
    callPackage ../development/python-modules/openpyxl { }
  else
    callPackage ../development/python-modules/openpyxl/2.nix { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  ordereddict = callPackage ../development/python-modules/ordereddict { };

  od = callPackage ../development/python-modules/od { };

  omegaconf = callPackage ../development/python-modules/omegaconf { };

  orderedset = callPackage ../development/python-modules/orderedset { };

  python-multipart = callPackage ../development/python-modules/python-multipart { };

  python-otr = callPackage ../development/python-modules/python-otr { };

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  ply = callPackage ../development/python-modules/ply { };

  plyplus = callPackage ../development/python-modules/plyplus { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  osc = callPackage ../development/python-modules/osc { };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  cachetools = let
    cachetools' = callPackage ../development/python-modules/cachetools {};
    cachetools_2 = cachetools'.overridePythonAttrs(oldAttrs: rec {
      version = "3.1.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "16m69l6n6y1r1y7cklm92rr7v69ldig2n3lbl3j323w5jz7d78lf";
      };

    });
  in if isPy3k then cachetools' else cachetools_2;

  cma = callPackage ../development/python-modules/cma { };

  cmd2 = callPackage ../development/python-modules/cmd2 {};

  warlock = callPackage ../development/python-modules/warlock { };

  pecan = callPackage ../development/python-modules/pecan { };

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  Kajiki = callPackage ../development/python-modules/kajiki { };

  WSME = callPackage ../development/python-modules/WSME { };

  zake = callPackage ../development/python-modules/zake { };

  zarr = callPackage ../development/python-modules/zarr { };

  kazoo = callPackage ../development/python-modules/kazoo { };

  FormEncode = callPackage ../development/python-modules/FormEncode { };

  pycountry = callPackage ../development/python-modules/pycountry { };

  nine = callPackage ../development/python-modules/nine { };

  logutils = callPackage ../development/python-modules/logutils { };

  ldappool = callPackage ../development/python-modules/ldappool { };

  retrying = callPackage ../development/python-modules/retrying { };

  fasteners = callPackage ../development/python-modules/fasteners { };

  aiocontextvars = callPackage ../development/python-modules/aiocontextvars { };

  aioeventlet = callPackage ../development/python-modules/aioeventlet { };

  aiokafka = callPackage ../development/python-modules/aiokafka { };

  olefile = callPackage ../development/python-modules/olefile { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  mox3 = callPackage ../development/python-modules/mox3 { };

  doc8 = callPackage ../development/python-modules/doc8 { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  pagerduty = callPackage ../development/python-modules/pagerduty { };

  pandas = if isPy3k then
    callPackage ../development/python-modules/pandas { }
  else
    callPackage ../development/python-modules/pandas/2.nix { };

  panel = callPackage ../development/python-modules/panel { };

  xlrd = callPackage ../development/python-modules/xlrd { };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt { };

  pamqp = callPackage ../development/python-modules/pamqp { };

  parsedatetime = callPackage ../development/python-modules/parsedatetime { };

  param = callPackage ../development/python-modules/param { };

  paramiko = callPackage ../development/python-modules/paramiko { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  paramz = callPackage ../development/python-modules/paramz { };

  parfive = callPackage ../development/python-modules/parfive { };

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

  pathpy = if isPy3k then
    callPackage ../development/python-modules/path.py { }
  else
    callPackage ../development/python-modules/path.py/2.nix { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbr = callPackage ../development/python-modules/pbr { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  fipy = callPackage ../development/python-modules/fipy { };

  pelican = callPackage ../development/python-modules/pelican {
    inherit (pkgs) glibcLocales git;
  };

  pep8 = callPackage ../development/python-modules/pep8 { };

  pep8-naming = callPackage ../development/python-modules/pep8-naming { };

  pep257 = callPackage ../development/python-modules/pep257 { };

  percol = callPackage ../development/python-modules/percol { };

  pexif = callPackage ../development/python-modules/pexif { };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pdfkit = callPackage ../development/python-modules/pdfkit { };

  periodictable = callPackage ../development/python-modules/periodictable { };

  pgcli = callPackage ../development/tools/database/pgcli {};

  pg8000 = callPackage ../development/python-modules/pg8000 { };
  pg8000_1_12 = callPackage ../development/python-modules/pg8000/1_12.nix { };

  pglast = callPackage ../development/python-modules/pglast { };

  pgsanity = callPackage ../development/python-modules/pgsanity { };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  pgpy = callPackage ../development/python-modules/pgpy { };

  pickleshare = callPackage ../development/python-modules/pickleshare { };

  picos = callPackage ../development/python-modules/picos { };

  piep = callPackage ../development/python-modules/piep { };

  piexif = callPackage ../development/python-modules/piexif { };

  pip = callPackage ../development/python-modules/pip { };

  pip-tools = callPackage ../development/python-modules/pip-tools {
    git = pkgs.gitMinimal;
    glibcLocales = pkgs.glibcLocales;
  };

  pipdate = callPackage ../development/python-modules/pipdate { };

  pika = callPackage ../development/python-modules/pika { };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  pikepdf = callPackage ../development/python-modules/pikepdf { };

  kmapper = callPackage ../development/python-modules/kmapper { };

  kmsxx = toPythonModule ((callPackage ../development/libraries/kmsxx {
    inherit (pkgs.kmsxx) stdenv;
    inherit (pkgs) pkgconfig;
    withPython = true;
  }).overrideAttrs (oldAttrs: {
    name = "${python.libPrefix}-${pkgs.kmsxx.name}";
  }));

  precis-i18n = callPackage ../development/python-modules/precis-i18n { };

  prox-tv = callPackage ../development/python-modules/prox-tv {
    # We need to use blas instead of openblas on darwin,
    # see https://github.com/NixOS/nixpkgs/pull/45013.
    useOpenblas = ! stdenv.isDarwin;
  };

  pvlib = callPackage ../development/python-modules/pvlib { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibmc = callPackage ../development/python-modules/pylibmc {};

  pymetar = callPackage ../development/python-modules/pymetar { };

  pysftp = callPackage ../development/python-modules/pysftp { };

  soundfile = callPackage ../development/python-modules/soundfile { };

  pysoundfile = self.soundfile;  # Alias added 23-06-2019

  python-jenkins = callPackage ../development/python-modules/python-jenkins { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pyviz-comms = callPackage ../development/python-modules/pyviz-comms { };

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

  praw = if isPy3k then callPackage ../development/python-modules/praw { }
    else callPackage ../development/python-modules/praw/6.3.nix { };

  prance = callPackage ../development/python-modules/prance { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  premailer = callPackage ../development/python-modules/premailer { };

  prettytable = callPackage ../development/python-modules/prettytable { };

  property-manager = callPackage ../development/python-modules/property-manager { };

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

  ptable = callPackage ../development/python-modules/ptable { };

  publicsuffix = callPackage ../development/python-modules/publicsuffix {};

  py = callPackage ../development/python-modules/py { };

  pyacoustid = callPackage ../development/python-modules/pyacoustid { };

  pyalgotrade = callPackage ../development/python-modules/pyalgotrade { };

  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyatmo = callPackage ../development/python-modules/pyatmo { };

  pyaudio = callPackage ../development/python-modules/pyaudio { };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = callPackage ../development/python-modules/pysaml2 {
    inherit (pkgs) xmlsec;
  };

  python-pushover = callPackage ../development/python-modules/pushover {};

  pystemd = callPackage ../development/python-modules/pystemd { systemd = pkgs.systemd; };

  mongodict = callPackage ../development/python-modules/mongodict { };

  mongoengine = callPackage ../development/python-modules/mongoengine { };

  repoze_who = callPackage ../development/python-modules/repoze_who { };

  vobject = callPackage ../development/python-modules/vobject { };

  pycarddav = callPackage ../development/python-modules/pycarddav { };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  Babel = callPackage ../development/python-modules/Babel { };

  babelgladeextractor = callPackage ../development/python-modules/babelgladeextractor { };

  pybfd = callPackage ../development/python-modules/pybfd { };

  pybigwig = callPackage ../development/python-modules/pybigwig { };

  py2bit = callPackage ../development/python-modules/py2bit { };

  pyblock = callPackage ../development/python-modules/pyblock { };

  pyblosxom = callPackage ../development/python-modules/pyblosxom { };

  pycapnp = callPackage ../development/python-modules/pycapnp { };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycdio = callPackage ../development/python-modules/pycdio { };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycryptopp = callPackage ../development/python-modules/pycryptopp { };

  pyct = callPackage ../development/python-modules/pyct { };

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycurl2 = callPackage ../development/python-modules/pycurl2 { };

  pydispatcher = callPackage ../development/python-modules/pydispatcher { };

  pydot = callPackage ../development/python-modules/pydot {
    inherit (pkgs) graphviz;
  };

  pydot_ng = callPackage ../development/python-modules/pydot_ng { graphviz = pkgs.graphviz; };

  pyelftools = callPackage ../development/python-modules/pyelftools { };

  pyenchant = callPackage ../development/python-modules/pyenchant { };

  pyexcelerator = callPackage ../development/python-modules/pyexcelerator { };

  pyext = callPackage ../development/python-modules/pyext { };

  pyfantom = callPackage ../development/python-modules/pyfantom { };

  pyfma = callPackage ../development/python-modules/pyfma { };

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

  pylint-celery = callPackage ../development/python-modules/pylint-celery { };

  pylint-django = callPackage ../development/python-modules/pylint-django { };

  pylint-flask = callPackage ../development/python-modules/pylint-flask { };

  pylint-plugin-utils = callPackage ../development/python-modules/pylint-plugin-utils { };

  pyomo = callPackage ../development/python-modules/pyomo { };

  pyopencl = callPackage ../development/python-modules/pyopencl { };

  pyotp = callPackage ../development/python-modules/pyotp { };

  pyproj = callPackage ../development/python-modules/pyproj { };

  pyqrcode = callPackage ../development/python-modules/pyqrcode { };

  pyrabbit2 = callPackage ../development/python-modules/pyrabbit2 { };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pysha3 = callPackage ../development/python-modules/pysha3 { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pysmbc = callPackage ../development/python-modules/pysmbc {
    inherit (pkgs) pkgconfig;
  };

  pyspread = callPackage ../development/python-modules/pyspread { };

  pysparse = callPackage ../development/python-modules/pysparse { };

  pyupdate = callPackage ../development/python-modules/pyupdate {};

  pyvmomi = callPackage ../development/python-modules/pyvmomi { };

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

  pymemoize = callPackage ../development/python-modules/pymemoize { };

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

  pynrrd = callPackage ../development/python-modules/pynrrd { };

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

  pyhocon = callPackage ../development/python-modules/pyhocon { };

  pyjson5 = callPackage ../development/python-modules/pyjson5 {};

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

  pyserial-asyncio = callPackage ../development/python-modules/pyserial-asyncio { };

  pysonos = callPackage ../development/python-modules/pysonos {};

  pymongo = callPackage ../development/python-modules/pymongo {};

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pysqlite = callPackage ../development/python-modules/pysqlite { };

  pysvn = callPackage ../development/python-modules/pysvn { };

  python-markdown-math = callPackage ../development/python-modules/python-markdown-math { };

  python-miio = callPackage ../development/python-modules/python-miio { };

  python-pipedrive = callPackage ../development/python-modules/python-pipedrive { };

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

  pyutilib = callPackage ../development/python-modules/pyutilib { };

  pywal = callPackage ../development/python-modules/pywal { };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pyxattr = let
    pyxattr' = callPackage ../development/python-modules/pyxattr { };
    pyxattr_2 = pyxattr'.overridePythonAttrs(oldAttrs: rec {
      version = "0.6.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "b525843f6b51036198b3b87c4773a5093d6dec57d60c18a1f269dd7059aa16e3";
      };
    });
  in if isPy3k then pyxattr' else pyxattr_2;

  pyamg = callPackage ../development/python-modules/pyamg { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  pyyaml_3 = (callPackage ../development/python-modules/pyyaml { }).overridePythonAttrs (oldAttrs: rec {
    version = "3.13";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf";
    };
    # https://github.com/yaml/pyyaml/issues/298#issuecomment-511990948
    patches = singleton (pkgs.fetchpatch {
      url = "https://github.com/yaml/pyyaml/commit/c5b135fe39d41cffbdc006f28ccb2032df6005e0.patch";
      sha256 = "0x1v45rkmj194c41d1nqi3ihj9z4rsy8zvpfcd8p960g1fia7fhn";
    });
    # https://github.com/yaml/pyyaml/issues/298#issuecomment-511990948
    doCheck = false;
  });

  rabbitpy = callPackage ../development/python-modules/rabbitpy { };

  rasterio = callPackage ../development/python-modules/rasterio {
    gdal = pkgs.gdal_2; # gdal 3.0 not supported yet
  };

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

  roboschool = callPackage ../development/python-modules/roboschool {
    inherit (pkgs) pkgconfig; # use normal pkgconfig, not the python package
  };

  rfc6555 = callPackage ../development/python-modules/rfc6555 { };

  qdarkstyle = callPackage ../development/python-modules/qdarkstyle { };

  qds_sdk = callPackage ../development/python-modules/qds_sdk { };

  qimage2ndarray = callPackage ../development/python-modules/qimage2ndarray { };

  quamash = callPackage ../development/python-modules/quamash { };

  quandl = callPackage ../development/python-modules/quandl { };
  # alias for an older package which did not support Python 3
  Quandl = callPackage ../development/python-modules/quandl { };

  qscintilla-qt4 = callPackage ../development/python-modules/qscintilla { };

  qscintilla-qt5 = pkgs.libsForQt5.callPackage ../development/python-modules/qscintilla-qt5 {
    pythonPackages = self;
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

  restrictedpython = callPackage ../development/python-modules/restrictedpython { };

  restview = callPackage ../development/python-modules/restview { };

  readme = callPackage ../development/python-modules/readme { };

  readme_renderer = callPackage ../development/python-modules/readme_renderer { };

  readchar = callPackage ../development/python-modules/readchar { };

  rivet = disabledIf isPy3k (toPythonModule (pkgs.rivet.override {
    python2 = python;
  }));

  ripser = callPackage ../development/python-modules/ripser { };

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  geoalchemy2 = callPackage ../development/python-modules/geoalchemy2 { };

  geographiclib = callPackage ../development/python-modules/geographiclib { };

  geopy = if isPy3k
    then callPackage ../development/python-modules/geopy { }
    else callPackage ../development/python-modules/geopy/2.nix { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  isodate = callPackage ../development/python-modules/isodate { };

  owslib = callPackage ../development/python-modules/owslib { };

  readthedocs-sphinx-ext = callPackage ../development/python-modules/readthedocs-sphinx-ext { };

  requests-http-signature = callPackage ../development/python-modules/requests-http-signature { };

  requirements-detector = callPackage ../development/python-modules/requirements-detector { };

  resampy = callPackage ../development/python-modules/resampy { };

  restructuredtext_lint = callPackage ../development/python-modules/restructuredtext_lint { };

  retry = callPackage ../development/python-modules/retry { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-requests = callPackage ../development/python-modules/robotframework-requests { };

  robotframework-ride = callPackage ../development/python-modules/robotframework-ride { };

  robotframework-seleniumlibrary = callPackage ../development/python-modules/robotframework-seleniumlibrary { };

  robotframework-selenium2library = callPackage ../development/python-modules/robotframework-selenium2library { };

  robotframework-sshlibrary = callPackage ../development/python-modules/robotframework-sshlibrary { };

  robotframework-tools = callPackage ../development/python-modules/robotframework-tools { };

  robotstatuschecker = callPackage ../development/python-modules/robotstatuschecker { };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  serpent = callPackage ../development/python-modules/serpent { };

  selectors34 = callPackage ../development/python-modules/selectors34 { };

  Pyro4 = callPackage ../development/python-modules/pyro4 { };

  rope = callPackage ../development/python-modules/rope { };

  ropper = callPackage ../development/python-modules/ropper { };

  rpkg = callPackage ../development/python-modules/rpkg {};

  rply = callPackage ../development/python-modules/rply {};

  rpm = toPythonModule (pkgs.rpm.override{inherit python;});

  rpmfluff = callPackage ../development/python-modules/rpmfluff {};

  rpy2 = if isPy3k
    then callPackage ../development/python-modules/rpy2 { }
    else callPackage ../development/python-modules/rpy2/2.nix { };

  rtslib = callPackage ../development/python-modules/rtslib {};

  Rtree = callPackage ../development/python-modules/Rtree { inherit (pkgs) libspatialindex; };

  typing = callPackage ../development/python-modules/typing { };

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  typesentry = callPackage ../development/python-modules/typesentry { };

  typesystem = callPackage ../development/python-modules/typesystem { };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  sequoia = disabledIf (isPyPy || !isPy3k) (toPythonModule (pkgs.sequoia.override {
    pythonPackages = self;
    pythonSupport = true;
  }));

  safe = callPackage ../development/python-modules/safe { };

  sampledata = callPackage ../development/python-modules/sampledata { };

  sasmodels = callPackage ../development/python-modules/sasmodels { };

  scapy = callPackage ../development/python-modules/scapy { };

  scipy = let
    scipy_ = callPackage ../development/python-modules/scipy { };
    scipy_1_2 = scipy_.overridePythonAttrs(oldAttrs: rec {
      version = "1.2.2";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "a4331e0b8dab1ff75d2c67b5158a8bb9a83c799d7140094dda936d876c7cfbb1";
      };
    });
  in if pythonOlder "3.5" then scipy_1_2 else scipy_;

  scikitimage = callPackage ../development/python-modules/scikit-image { };

  scikitlearn = let
    args = { inherit (pkgs) gfortran glibcLocales; };
  in
    if isPy3k then callPackage ../development/python-modules/scikitlearn args
    else callPackage ../development/python-modules/scikitlearn/0.20.nix args;

  scikit-bio = callPackage ../development/python-modules/scikit-bio { };

  scikit-build = callPackage ../development/python-modules/scikit-build { };

  scikits-odes = callPackage ../development/python-modules/scikits-odes { };

  scikit-optimize = callPackage ../development/python-modules/scikit-optimize { };

  scikit-tda = callPackage ../development/python-modules/scikit-tda { };

  scikit-fmm = callPackage ../development/python-modules/scikit-fmm { };

  scp = callPackage ../development/python-modules/scp {};

  seaborn = callPackage ../development/python-modules/seaborn { };

  seabreeze = callPackage ../development/python-modules/seabreeze { };

  selenium = callPackage ../development/python-modules/selenium { };

  serpy = callPackage ../development/python-modules/serpy { };

  setuptools_scm = callPackage ../development/python-modules/setuptools_scm { };

  setuptools-scm-git-archive = callPackage ../development/python-modules/setuptools-scm-git-archive { };

  serverlessrepo = callPackage ../development/python-modules/serverlessrepo { };

  shippai = callPackage ../development/python-modules/shippai {};

  shutilwhich = callPackage ../development/python-modules/shutilwhich { };

  simanneal = callPackage ../development/python-modules/simanneal { };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  shamir-mnemonic = callPackage ../development/python-modules/shamir-mnemonic { };

  shodan = callPackage ../development/python-modules/shodan { };

  should-dsl = callPackage ../development/python-modules/should-dsl { };

  showit = callPackage ../development/python-modules/showit { };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simplekml = callPackage ../development/python-modules/simplekml { };

  slimit = callPackage ../development/python-modules/slimit { };

  snowflake-connector-python = callPackage ../development/python-modules/snowflake-connector-python { };

  snowflake-sqlalchemy = callPackage ../development/python-modules/snowflake-sqlalchemy { };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  snitun = callPackage ../development/python-modules/snitun { };

  snscrape = callPackage ../development/python-modules/snscrape { };

  snug = callPackage ../development/python-modules/snug { };

  snuggs = callPackage ../development/python-modules/snuggs { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  supervisor = callPackage ../development/python-modules/supervisor {};

  subprocess32 = callPackage ../development/python-modules/subprocess32 { };

  spark_parser = callPackage ../development/python-modules/spark_parser { };

  sphinx = if isPy3k then
    callPackage ../development/python-modules/sphinx { }
  else
    callPackage ../development/python-modules/sphinx/2.nix { };

  # Only exists for a Haskell package.
  sphinx_1_7_9 = (callPackage ../development/python-modules/sphinx/2.nix { })
    .overridePythonAttrs (oldAttrs: rec {
      version = "1.7.9";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "217a7705adcb573da5bbe1e0f5cab4fa0bd89fd9342c9159121746f593c2d5a4";
      };
    });

  sphinx-argparse = callPackage ../development/python-modules/sphinx-argparse { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  hvplot = callPackage ../development/python-modules/hvplot { };

  guzzle_sphinx_theme = callPackage ../development/python-modules/guzzle_sphinx_theme { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinxcontrib-applehelp = callPackage ../development/python-modules/sphinxcontrib-applehelp {};

  sphinxcontrib-devhelp = callPackage ../development/python-modules/sphinxcontrib-devhelp {};

  sphinxcontrib-htmlhelp = callPackage ../development/python-modules/sphinxcontrib-htmlhelp {};

  sphinxcontrib-jsmath = callPackage ../development/python-modules/sphinxcontrib-jsmath {};

  sphinxcontrib-qthelp = callPackage ../development/python-modules/sphinxcontrib-qthelp {};

  sphinxcontrib-serializinghtml = callPackage ../development/python-modules/sphinxcontrib-serializinghtml {};

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex {};

  sphinx-navtree = callPackage ../development/python-modules/sphinx-navtree {};

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  splinter = callPackage ../development/python-modules/splinter { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy-citext = callPackage ../development/python-modules/sqlalchemy-citext { };

  sqlalchemy_migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  sqlalchemy-utils = callPackage ../development/python-modules/sqlalchemy-utils { };

  staticjinja = callPackage ../development/python-modules/staticjinja { };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  strategies = callPackage ../development/python-modules/strategies { };

  stravalib = callPackage ../development/python-modules/stravalib { };

  streamz = callPackage ../development/python-modules/streamz { };

  structlog = callPackage ../development/python-modules/structlog { };

  stytra = callPackage ../development/python-modules/stytra { };

  sybil = callPackage ../development/python-modules/sybil { };

  # legacy alias
  syncthing-gtk = pkgs.syncthing-gtk;

  systemd = callPackage ../development/python-modules/systemd {
    inherit (pkgs) pkgconfig systemd;
  };

  sysv_ipc = callPackage ../development/python-modules/sysv_ipc { };

  tabulate = callPackage ../development/python-modules/tabulate { };

  tadasets = callPackage ../development/python-modules/tadasets { };

  tasklib = callPackage ../development/python-modules/tasklib { };

  tatsu = callPackage ../development/python-modules/tatsu { };

  tbm-utils = callPackage ../development/python-modules/tbm-utils { };

  tempita = callPackage ../development/python-modules/tempita { };

  terminado = callPackage ../development/python-modules/terminado { };

  tess = callPackage ../development/python-modules/tess { };

  testresources = callPackage ../development/python-modules/testresources { };

  testtools = callPackage ../development/python-modules/testtools { };

  traitlets = callPackage ../development/python-modules/traitlets { };

  transitions = callPackage ../development/python-modules/transitions { };

  extras = callPackage ../development/python-modules/extras { };

  texttable = callPackage ../development/python-modules/texttable { };

  textwrap3 =  callPackage ../development/python-modules/textwrap3 { };

  tiledb = callPackage ../development/python-modules/tiledb {
    inherit (pkgs) tiledb;
  };

  timezonefinder = callPackage ../development/python-modules/timezonefinder { };

  tiros = callPackage ../development/python-modules/tiros { };

  tinydb = callPackage ../development/python-modules/tinydb { };

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

  ueberzug = callPackage ../development/python-modules/ueberzug {
    inherit (pkgs.xorg) libX11 libXext;
  };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  umap-learn = callPackage ../development/python-modules/umap-learn { };

  umemcache = callPackage ../development/python-modules/umemcache {};

  uritools = callPackage ../development/python-modules/uritools { };

  update_checker = callPackage ../development/python-modules/update_checker {};

  update-copyright = callPackage ../development/python-modules/update-copyright {};

  update-dotdee = callPackage ../development/python-modules/update-dotdee { };

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uproot = callPackage ../development/python-modules/uproot {};

  uproot-methods = callPackage ../development/python-modules/uproot-methods { };

  urlgrabber = callPackage ../development/python-modules/urlgrabber {};

  urwid = callPackage ../development/python-modules/urwid {};

  user-agents = callPackage ../development/python-modules/user-agents { };

  verboselogs = callPackage ../development/python-modules/verboselogs { };

  vega_datasets = callPackage ../development/python-modules/vega_datasets { };

  virtkey = callPackage ../development/python-modules/virtkey {
    inherit (pkgs) pkgconfig;
  };

  virtual-display = callPackage ../development/python-modules/virtual-display { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  vsts = callPackage ../development/python-modules/vsts { };

  vsts-cd-manager = callPackage ../development/python-modules/vsts-cd-manager { };

  python-vlc = callPackage ../development/python-modules/python-vlc { };

  weasyprint = callPackage ../development/python-modules/weasyprint { };

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

  wxPython_4_0 = callPackage ../development/python-modules/wxPython/4.0.nix {
    inherit (pkgs) pkgconfig;
    wxGTK = pkgs.wxGTK30.override { withGtk2 = false; withWebKit = true; };
  };

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmlschema = callPackage ../development/python-modules/xmlschema { };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xarray = callPackage ../development/python-modules/xarray { };

  xapian = callPackage ../development/python-modules/xapian { xapian = pkgs.xapian; };

  xapp = callPackage ../development/python-modules/xapp {
    inherit (pkgs) gtk3 gobject-introspection polkit;
    inherit (pkgs.cinnamon) xapps;
  };

  xlwt = callPackage ../development/python-modules/xlwt { };

  xxhash = callPackage ../development/python-modules/xxhash { };

  youtube-dl = callPackage ../tools/misc/youtube-dl {};

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
    phantomjsSupport = false;
  };

  zconfig = callPackage ../development/python-modules/zconfig { };

  zc_lockfile = callPackage ../development/python-modules/zc_lockfile { };

  zerorpc = callPackage ../development/python-modules/zerorpc { };

  zipstream = callPackage ../development/python-modules/zipstream { };

  zodb = callPackage ../development/python-modules/zodb {};

  zodbpickle = callPackage ../development/python-modules/zodbpickle {};

  BTrees = callPackage ../development/python-modules/btrees {};

  persistent = callPackage ../development/python-modules/persistent {};

  persim = callPackage ../development/python-modules/persim { };

  xdot = callPackage ../development/python-modules/xdot { };

  zetup = callPackage ../development/python-modules/zetup { };

  routes = callPackage ../development/python-modules/routes { };

  rpyc = callPackage ../development/python-modules/rpyc { };

  rsa = callPackage ../development/python-modules/rsa { };

  squaremap = callPackage ../development/python-modules/squaremap { };

  ruamel_base = callPackage ../development/python-modules/ruamel_base { };

  ruamel_ordereddict = callPackage ../development/python-modules/ruamel_ordereddict { };

  ruamel_yaml = callPackage ../development/python-modules/ruamel_yaml { };

  ruamel_yaml_clib = callPackage ../development/python-modules/ruamel_yaml_clib { };

  ruffus = callPackage ../development/python-modules/ruffus { };

  runsnakerun = callPackage ../development/python-modules/runsnakerun { };

  pysendfile = callPackage ../development/python-modules/pysendfile { };

  pyxl3 = callPackage ../development/python-modules/pyxl3 { };

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

  symengine = callPackage ../development/python-modules/symengine {
    symengine = pkgs.symengine;
  };

  sympy = callPackage ../development/python-modules/sympy { };

  pilkit = callPackage ../development/python-modules/pilkit { };

  clint = callPackage ../development/python-modules/clint { };

  argh = callPackage ../development/python-modules/argh { };

  nose_progressive = callPackage ../development/python-modules/nose_progressive { };

  blessings = callPackage ../development/python-modules/blessings { };

  secretstorage = if isPy3k
    then callPackage ../development/python-modules/secretstorage { }
    else callPackage ../development/python-modules/secretstorage/2.nix { };

  secure = callPackage ../development/python-modules/secure { };

  semantic = callPackage ../development/python-modules/semantic { };

  sandboxlib = callPackage ../development/python-modules/sandboxlib { };

  sanic = callPackage ../development/python-modules/sanic { };

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

  soupsieve = callPackage ../development/python-modules/soupsieve { };

  sphinx_rtd_theme = callPackage ../development/python-modules/sphinx_rtd_theme { };

  sphinxcontrib-blockdiag = callPackage ../development/python-modules/sphinxcontrib-blockdiag { };

  sphinxcontrib-openapi = callPackage ../development/python-modules/sphinxcontrib-openapi { };

  sphinxcontrib_httpdomain = callPackage ../development/python-modules/sphinxcontrib_httpdomain { };

  sphinxcontrib_newsfeed = callPackage ../development/python-modules/sphinxcontrib_newsfeed { };

  sphinxcontrib_plantuml = callPackage ../development/python-modules/sphinxcontrib_plantuml {
    inherit (pkgs) plantuml;
  };

  sphinxcontrib-spelling = callPackage ../development/python-modules/sphinxcontrib-spelling { };

  sphinxcontrib-tikz = callPackage ../development/python-modules/sphinxcontrib-tikz {
    texLive = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small standalone pgfplots; };
  };

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

  swagger-spec-validator = callPackage ../development/python-modules/swagger-spec-validator { };

  openapi-spec-validator = callPackage ../development/python-modules/openapi-spec-validator { };

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

  python-twitter = callPackage ../development/python-modules/python-twitter { };

  umalqurra = callPackage ../development/python-modules/umalqurra { };

  unicodecsv = callPackage ../development/python-modules/unicodecsv { };

  unicode-slugify = callPackage ../development/python-modules/unicode-slugify { };

  unidiff = callPackage ../development/python-modules/unidiff { };

  units = callPackage ../development/python-modules/units { };

  unittest-data-provider = callPackage ../development/python-modules/unittest-data-provider { };

  unittest2 = callPackage ../development/python-modules/unittest2 { };

  unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

  traceback2 = callPackage ../development/python-modules/traceback2 { };

  trackpy = callPackage ../development/python-modules/trackpy { };

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

  wurlitzer = callPackage ../development/python-modules/wurlitzer { };

  xcaplib = callPackage ../development/python-modules/xcaplib { };

  xlib = callPackage ../development/python-modules/xlib { };

  yappi = callPackage ../development/python-modules/yappi { };

  zbase32 = callPackage ../development/python-modules/zbase32 { };

  zdaemon = callPackage ../development/python-modules/zdaemon { };

  zfec = callPackage ../development/python-modules/zfec { };

  zha-quirks = callPackage ../development/python-modules/zha-quirks { };

  zipp = callPackage ../development/python-modules/zipp { };

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

  python-logstash = callPackage ../development/python-modules/python-logstash { };

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

  websocket_client = callPackage ../development/python-modules/websocket_client { };

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

  graph_nets = callPackage ../development/python-modules/graph_nets { };

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

  snakebite = callPackage ../development/python-modules/snakebite { };

  snapperGUI = callPackage ../development/python-modules/snappergui { };

  dm-sonnet = callPackage ../development/python-modules/dm-sonnet { };

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

  html2text = if isPy3k then callPackage ../development/python-modules/html2text { }
                        else callPackage ../development/python-modules/html2text/2018.nix { };

  pychart = callPackage ../development/python-modules/pychart {};

  parsimonious = callPackage ../development/python-modules/parsimonious { };

  networkx = if isPy3k then callPackage ../development/python-modules/networkx { }
    else
      callPackage ../development/python-modules/networkx/2.2.nix { };

  ofxclient = callPackage ../development/python-modules/ofxclient {};

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = callPackage ../development/python-modules/ofxparse { };

  ofxtools = callPackage ../development/python-modules/ofxtools { };

  orm = callPackage ../development/python-modules/orm { };

  basemap = callPackage ../development/python-modules/basemap { };

  dict2xml = callPackage ../development/python-modules/dict2xml { };

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

  pyregion = callPackage ../development/python-modules/pyregion {};

  python-nomad = callPackage ../development/python-modules/python-nomad { };

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  python-xmp-toolkit = callPackage ../development/python-modules/python-xmp-toolkit { };

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

  xhtml2pdf = callPackage ../development/python-modules/xhtml2pdf { };

  xkcdpass = callPackage ../development/python-modules/xkcdpass { };

  xlsx2csv = callPackage ../development/python-modules/xlsx2csv { };

  xmodem = callPackage ../development/python-modules/xmodem {};

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

  ckcc-protocol = callPackage ../development/python-modules/ckcc-protocol { };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  keepkey_agent = callPackage ../development/python-modules/keepkey_agent { };

  libagent = callPackage ../development/python-modules/libagent { };

  ledger_agent = callPackage ../development/python-modules/ledger_agent { };

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

  pandoc-attributes = callPackage ../development/python-modules/pandoc-attributes { };

  htmltreediff = callPackage ../development/python-modules/htmltreediff { };

  repeated_test = callPackage ../development/python-modules/repeated_test { };

  Keras = callPackage ../development/python-modules/keras { };

  keras-applications = callPackage ../development/python-modules/keras-applications { };

  keras-preprocessing = callPackage ../development/python-modules/keras-preprocessing { };

  Lasagne = callPackage ../development/python-modules/lasagne { };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sigtools = callPackage ../development/python-modules/sigtools { };

  annoy = callPackage ../development/python-modules/annoy { };

  clize = callPackage ../development/python-modules/clize { };

  rl-coach = callPackage ../development/python-modules/rl-coach { };

  zerobin = callPackage ../development/python-modules/zerobin { };

  tensorflow-estimator = callPackage ../development/python-modules/tensorflow-estimator { };

  tensorflow-probability = callPackage ../development/python-modules/tensorflow-probability { };

  tensorflow-tensorboard = callPackage ../development/python-modules/tensorflow-tensorboard { };

  tensorflow-bin = callPackage ../development/python-modules/tensorflow/bin.nix {
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
    cudatoolkit = pkgs.cudatoolkit_10;
    cudnn = pkgs.cudnn_cudatoolkit_10;
  };

  tensorflow-build = callPackage ../development/python-modules/tensorflow {
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
    cudatoolkit = pkgs.cudatoolkit_10;
    cudnn = pkgs.cudnn_cudatoolkit_10;
    nccl = pkgs.nccl_cudatoolkit_10;
    openssl = pkgs.openssl_1_0_2;
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation Security;
  };

  tensorflow = self.tensorflow-build;

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

  more-itertools = if isPy27 then
    callPackage ../development/python-modules/more-itertools/2.7.nix { }
  else callPackage ../development/python-modules/more-itertools { };

  jaraco_functools = callPackage ../development/python-modules/jaraco_functools { };

  jaraco_classes = callPackage ../development/python-modules/jaraco_classes { };

  jaraco_stream = callPackage ../development/python-modules/jaraco_stream { };

  javaobj-py3 = callPackage ../development/python-modules/javaobj-py3 { };

  javaproperties = callPackage ../development/python-modules/javaproperties { };

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

  prison = callPackage ../development/python-modules/prison { };

  pytoml = callPackage ../development/python-modules/pytoml { };

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yanc = callPackage ../development/python-modules/yanc { };

  yarl = callPackage ../development/python-modules/yarl { };

  solo-python = disabledIf (! pythonAtLeast "3.6") (callPackage ../development/python-modules/solo-python { });

  suseapi = callPackage ../development/python-modules/suseapi { };

  typed-ast = callPackage ../development/python-modules/typed-ast { };

  stripe = callPackage ../development/python-modules/stripe { };

  strict-rfc3339 = callPackage ../development/python-modules/strict-rfc3339 { };

  strictyaml = callPackage ../development/python-modules/strictyaml { };

  twilio = callPackage ../development/python-modules/twilio { };

  twofish = callPackage ../development/python-modules/twofish { };

  uranium = callPackage ../development/python-modules/uranium { };

  uuid = callPackage ../development/python-modules/uuid { };

  versioneer = callPackage ../development/python-modules/versioneer { };

  viewstate = callPackage ../development/python-modules/viewstate { };

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

  zxcvbn = callPackage ../development/python-modules/zxcvbn { };

  incremental = callPackage ../development/python-modules/incremental { };

  treq = callPackage ../development/python-modules/treq { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  nitpick = callPackage ../applications/version-management/nitpick { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  diskcache = callPackage ../development/python-modules/diskcache { };

  dissononce = callPackage ../development/python-modules/dissononce { };

  distro = callPackage ../development/python-modules/distro { };

  bz2file =  callPackage ../development/python-modules/bz2file { };

  smart_open =  callPackage ../development/python-modules/smart_open { };

  gensim = callPackage  ../development/python-modules/gensim { };

  genpy = callPackage ../development/python-modules/genpy { };

  cymem = callPackage ../development/python-modules/cymem { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  plac = callPackage ../development/python-modules/plac { };

  preshed = callPackage ../development/python-modules/preshed { };

  backports_weakref = callPackage ../development/python-modules/backports_weakref { };

  blis = callPackage ../development/python-modules/blis { };

  srsly = callPackage ../development/python-modules/srsly { };

  thinc = callPackage ../development/python-modules/thinc { };

  wasabi = callPackage ../development/python-modules/wasabi { };

  yahooweather = callPackage ../development/python-modules/yahooweather { };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy_models = callPackage ../development/python-modules/spacy/models.nix { };

  pyspark = callPackage ../development/python-modules/pyspark { };

  pysensors = callPackage ../development/python-modules/pysensors { };

  python-toolbox = callPackage ../development/python-modules/python-toolbox { };

  pysnooper = callPackage ../development/python-modules/pysnooper { };

  sseclient = callPackage ../development/python-modules/sseclient { };

  warrant = callPackage ../development/python-modules/warrant { };

  textacy = callPackage ../development/python-modules/textacy { };

  tld = callPackage ../development/python-modules/tld { };

  tldextract = callPackage ../development/python-modules/tldextract { };

  pyemd  = callPackage ../development/python-modules/pyemd { };

  pulp  = callPackage ../development/python-modules/pulp { };

  behave = callPackage ../development/python-modules/behave { };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest { };

  pyhaversion = callPackage ../development/python-modules/pyhaversion { };

  parse = callPackage ../development/python-modules/parse { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  ephem = callPackage ../development/python-modules/ephem { };

  voluptuous = callPackage ../development/python-modules/voluptuous { };

  voluptuous-serialize = callPackage ../development/python-modules/voluptuous-serialize { };

  pysigset = callPackage ../development/python-modules/pysigset { };

  us = callPackage ../development/python-modules/us { };

  wsproto = if (pythonAtLeast "3.6") then
      callPackage ../development/python-modules/wsproto { }
    else
      callPackage ../development/python-modules/wsproto/0.14.nix { };

  h11 = callPackage ../development/python-modules/h11 { };

  python-docx = callPackage ../development/python-modules/python-docx { };

  python-doi = callPackage ../development/python-modules/python-doi { };

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

  ibis = callPackage ../development/python-modules/ibis { };

  ibis-framework = callPackage ../development/python-modules/ibis-framework { };

  qiskit = callPackage ../development/python-modules/qiskit { };

  qasm2image = callPackage ../development/python-modules/qasm2image { };

  simpy = callPackage ../development/python-modules/simpy { };

  x256 = callPackage ../development/python-modules/x256 { };

  yattag = callPackage ../development/python-modules/yattag { };

  xenomapper = disabledIf (!isPy3k) (callPackage ../applications/science/biology/xenomapper { });

  z3 = (toPythonModule (pkgs.z3.override {
    inherit python;
  })).python;

  zeroc-ice = callPackage ../development/python-modules/zeroc-ice { };

  zm-py = callPackage ../development/python-modules/zm-py { };

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  foundationdb51 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb51; };
  foundationdb52 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb52; };
  foundationdb60 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb60; };
  foundationdb61 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb61; };

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

  lzstring = callPackage ../development/python-modules/lzstring { };

  flickrapi = callPackage ../development/python-modules/flickrapi { };

  aioesphomeapi = callPackage ../development/python-modules/aioesphomeapi { };

  mwparserfromhell = callPackage ../development/python-modules/mwparserfromhell { };

  starlette = callPackage ../development/python-modules/starlette { };

  uvicorn = callPackage ../development/python-modules/uvicorn { };

  pydantic = callPackage ../development/python-modules/pydantic { };

  fastapi = callPackage ../development/python-modules/fastapi { };

  stringcase = callPackage ../development/python-modules/stringcase { };

  webrtcvad = callPackage ../development/python-modules/webrtcvad { };

  wfuzz = callPackage ../development/python-modules/wfuzz { };

  wget = callPackage ../development/python-modules/wget { };

  runway-python = callPackage ../development/python-modules/runway-python { };

  pyprof2calltree = callPackage ../development/python-modules/pyprof2calltree { };

  hcloud = callPackage ../development/python-modules/hcloud { };

  managesieve = callPackage ../development/python-modules/managesieve { };

  pony = callPackage ../development/python-modules/pony { };

  rxv     = callPackage ../development/python-modules/rxv     { };

});

in fix' (extends overrides packages)
