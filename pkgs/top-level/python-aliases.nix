lib: self: super:

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
      if alias.recurseForDerivations or false then
            removeAttrs alias ["recurseForDerivations"]
                else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from
  # python-packages.nix.
  checkInPkgs = n: alias: if builtins.hasAttr n super
                          then throw "Alias ${n} is still in python-packages.nix"
                          else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias: removeDistribute
                             (removeRecurseForDerivations
                              (checkInPkgs n alias)))
                     aliases;
in

  ### Deprecated aliases - for backward compatibility

mapAliases ({
  aioh2 = throw "aioh2 has been removed because it is abandoned and broken."; # Added 2022-03-30
  ansible-base = throw "ansible-base has been removed, because it is end of life"; # added 2022-03-30
  anyjson = throw "anyjson has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  argon2_cffi = argon2-cffi; # added 2022-05-09
  asyncio-nats-client = nats-py; # added 2022-02-08
  Babel = babel; # added 2022-05-06
  bitcoin-price-api = throw "bitcoin-price-api has been removed, it was using setuptools 2to3 translation feautre, which has been removed in setuptools 58"; # added 2022-02-15
  bt_proximity = throw "'bt_proximity' has been renamed to/replaced by 'bt-proximity'"; # Converted to throw 2022-09-24
  carrot = throw "carrot has been removed, as its development was discontinued in 2012"; # added 2022-01-18
  class-registry = phx-class-registry; # added 2021-10-05
  ConfigArgParse = throw "'ConfigArgParse' has been renamed to/replaced by 'configargparse'"; # Converted to throw 2022-09-24
  cozy = throw "cozy was removed because it was not actually https://pypi.org/project/Cozy/."; # added 2022-01-14
  cryptography_vectors = "cryptography_vectors is no longer exposed in python*Packages because it is used for testing cryptography only."; # Added 2022-03-23
  dask-xgboost = throw "dask-xgboost was removed because its features are available in xgboost"; # added 2022-05-24
  dateutil = throw "'dateutil' has been renamed to/replaced by 'python-dateutil'"; # Converted to throw 2022-09-24
  demjson = throw "demjson has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  diff_cover = throw "'diff_cover' has been renamed to/replaced by 'diff-cover'"; # Converted to throw 2022-09-24
  discogs_client = throw "'discogs_client' has been renamed to/replaced by 'discogs-client'"; # Converted to throw 2022-09-24
  djangorestframework-jwt = throw "'djangorestframework-jwt' has been renamed to/replaced by 'drf-jwt'"; # Converted to throw 2022-09-24
  django-sampledatahelper = throw "django-sampledatahelper was removed because it is no longer compatible to latest Django version"; # added 2022-07-18
  django_2 = throw "Django 2 has reached it's projected EOL in 2022/04 and has therefore been removed."; # added 2022-03-05
  django_appconf = django-appconf; # added 2022-03-03
  django_environ = django-environ; # added 2021-12-25
  django_extensions = django-extensions; # added 2022-01-09
  django_guardian = django-guardian; # added 2022-05-19
  django_modelcluster = django-modelcluster; # added 2022-04-02
  django_reversion = django-reversion; # added 2022-06-18
  django_polymorphic = django-polymorphic; # added 2022-05-24
  django_redis = django-redis; # added 2021-10-11
  django_taggit = django-taggit; # added 2021-10-11
  dns = throw "'dns' has been renamed to/replaced by 'dnspython'"; # Converted to throw 2022-09-24
  dogpile_cache = dogpile-cache; # added 2021-10-28
  dogpile-core = throw "dogpile-core is no longer maintained, use dogpile-cache instead"; # added 2021-11-20
  eebrightbox = throw "eebrightbox is unmaintained upstream and has therefore been removed"; # added 2022-02-03
  email_validator = email-validator; # added 2022-06-22
  fake_factory = throw "fake_factory has been removed because it is unused and deprecated by upstream since 2016."; # added 2022-05-30
  flask_sqlalchemy = flask-sqlalchemy; # added 2022-07-20
  flask_testing = flask-testing; # added 2022-04-25
  flask_wtf = flask-wtf; # added 2022-05-24
  garminconnect-ha = garminconnect; # added 2022-02-05
  glances = throw "glances has moved to pkgs.glances"; # added 2020-20-28
  google_api_python_client = throw "'google_api_python_client' has been renamed to/replaced by 'google-api-python-client'"; # Converted to throw 2022-09-24
  googleapis_common_protos = throw "'googleapis_common_protos' has been renamed to/replaced by 'googleapis-common-protos'"; # Converted to throw 2022-09-24
  graphite_api = throw "graphite_api was removed, because it is no longer maintained"; # added 2022-07-10
  graphite_beacon = throw "graphite_beacon was removed, because it is no longer maintained"; # added 2022-07-09
  grpc_google_iam_v1 = throw "'grpc_google_iam_v1' has been renamed to/replaced by 'grpc-google-iam-v1'"; # Converted to throw 2022-09-24
  ha-av = throw "ha-av was removed, because it is no longer maintained"; # added 2022-04-06
  HAP-python = throw "'HAP-python' has been renamed to/replaced by 'hap-python'"; # Converted to throw 2022-09-24
  hbmqtt = throw "hbmqtt was removed because it is no longer maintained"; # added 2021-11-07
  hdlparse = throw "hdlparse has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  hyperkitty = throw "Please use pkgs.mailmanPackages.hyperkitty"; # added 2022-04-29
  IMAPClient = imapclient; # added 2021-10-28
  imdbpy = throw "imdbpy has been renamed to cinemagoer"; # added 2022-08-08
  ipaddress = throw "ipaddress has been removed because it is no longer required since python 2.7."; # added 2022-05-30
  influxgraph = throw "influxgraph has been removed because it is no longer maintained"; # added 2022-07-10
  jupyter_client = jupyter-client; # added 2021-10-15
  Keras = keras; # added 2021-11-25
  ldap = python-ldap; # added 2022-09-16
  lammps-cython = throw "lammps-cython no longer builds and is unmaintained"; # added 2021-07-04
  loo-py = loopy; # added 2022-05-03
  Markups = markups; # added 2022-02-14
  MechanicalSoup = throw "'MechanicalSoup' has been renamed to/replaced by 'mechanicalsoup'"; # Converted to throw 2022-09-24
  memcached = python-memcached; # added 2022-05-06
  mailman = throw "Please use pkgs.mailman"; # added 2022-04-29
  mailman-hyperkitty = throw "Please use pkgs.mailmanPackages.mailman-hyperkitty"; # added 2022-04-29
  mailman-web = throw "Please use pkgs.mailman-web"; # added 2022-04-29
  mistune_0_8 = throw "mistune_0_8 was removed because it was outdated and insecure"; # added 2022-08-12
  mistune_2_0 = mistune; # added 2022-08-12
  net2grid = gridnet; # add 2022-04-22
  nose-cover3 = throw "nose-cover3 has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-02-16
  ordereddict = throw "ordereddict has been removed because it is only useful on unsupported python versions."; # added 2022-05-28
  pam = python-pam; # added 2020-09-07.
  PasteDeploy = pastedeploy; # added 2021-10-07
  pathpy = path; # added 2022-04-12
  pdfminer = pdfminer-six; # added 2022-05-25
  pep257 = pydocstyle; # added 2022-04-12
  poster3 = throw "poster3 is unmaintained and source is no longer available"; # added 2023-05-29
  postorius = throw "Please use pkgs.mailmanPackages.postorius"; # added 2022-04-29
  powerlineMemSegment = powerline-mem-segment; # added 2021-10-08
  prometheus_client = throw "'prometheus_client' has been renamed to/replaced by 'prometheus-client'"; # Converted to throw 2022-09-24
  prompt_toolkit = throw "'prompt_toolkit' has been renamed to/replaced by 'prompt-toolkit'"; # Converted to throw 2022-09-24
  pur = throw "pur has been renamed to pkgs.pur"; # added 2021-11-08
  pydrive = throw "pydrive is broken and deprecated and has been replaced with pydrive2."; # added 2022-06-01
  pyGtkGlade = throw "Glade support for pygtk has been removed"; # added 2022-01-15
  pycallgraph = throw "pycallgraph has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  pycryptodome-test-vectors = throw "pycryptodome-test-vectors has been removed because it is an internal package to pycryptodome"; # added 2022-05-28
  pyialarmxr = pyialarmxr-homeassistant; # added 2022-06-07
  pyialarmxr-homeassistant = throw "The package was removed together with the component support in home-assistant 2022.7.0"; # added 2022-07-07
  pyjson5 = json5; # added 2022-08-28
  PyLD = pyld; # added 2022-06-22
  pymc3 = pymc; # added 2022-06-05, module was rename starting with 4.0.0
  pyreadability = readability-lxml; # added 2022-05-24
  pyroute2-core = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-ethtool = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-ipdb = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-ipset = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-ndb = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-nftables = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-nslink = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pyroute2-protocols = throw "pyroute2 migrated back to a single package scheme in version 0.7.1"; # added 2022-07-16
  pysmart-smartx = pysmart; # added 2021-10-22
  pyspotify = throw "pyspotify has been removed because Spotify stopped supporting libspotify"; # added 2022-05-29
  pytest_6 = pytest; # added 2022-02-10
  pytestcov = throw "'pytestcov' has been renamed to/replaced by 'pytest-cov'"; # Converted to throw 2022-09-24
  pytest-pep8 = throw "'pytest-pep8' has been renamed to/replaced by 'pytestpep8'"; # Converted to throw 2022-09-24
  pytest-pep257 = throw "pytest-pep257 was removed, as the pep257 package was migrated into pycodestyle"; # added 2022-04-12
  pytest-pythonpath = throw "pytest-pythonpath is obsolete as of pytest 7.0.0 and has been removed"; # added 2022-03-09
  pytestquickcheck = throw "'pytestquickcheck' has been renamed to/replaced by 'pytest-quickcheck'"; # Converted to throw 2022-09-24
  pytestrunner = throw "'pytestrunner' has been renamed to/replaced by 'pytest-runner'"; # Converted to throw 2022-09-24
  python-igraph = igraph; # added 2021-11-11
  python-lz4 = throw "'python-lz4' has been renamed to/replaced by 'lz4'"; # Converted to throw 2022-09-24
  python_magic = python-magic; # added 2022-05-07
  python_mimeparse = python-mimeparse; # added 2021-10-31
  python-language-server = throw "python-language-server is no longer maintained, use the python-lsp-server community fork instead."; # Added 2022-08-03
  python-subunit = subunit; # added 2021-09-10
  pytest_xdist = throw "'pytest_xdist' has been renamed to/replaced by 'pytest-xdist'"; # Converted to throw 2022-09-24
  python_simple_hipchat = throw "'python_simple_hipchat' has been renamed to/replaced by 'python-simple-hipchat'"; # Converted to throw 2022-09-24
  pytorch = torch; # added 2022-09-30
  pytorch-bin = torch-bin; # added 2022-09-30
  pytorchWithCuda = torchWithCuda; # added 2022-09-30
  pytorchWithoutCuda = torchWithoutCuda; # added 2022-09-30
  pytwitchapi = twitchapi; # added 2022-03-07
  qiskit-aqua = throw "qiskit-aqua has been removed due to deprecation, with its functionality moved to different qiskit packages";
  rdflib-jsonld = throw "rdflib-jsonld is not compatible with rdflib 6"; # added 2021-11-05
  repeated_test = throw "repeated_test is no longer maintained"; # added 2022-01-11
  requests_oauthlib = requests-oauthlib; # added 2022-02-12
  requests_toolbelt = throw "'requests_toolbelt' has been renamed to/replaced by 'requests-toolbelt'"; # Converted to throw 2022-09-24
  roboschool = throw "roboschool is deprecated in favor of PyBullet and has been removed"; # added 2022-01-15
  ROPGadget = throw "'ROPGadget' has been renamed to/replaced by 'ropgadget'"; # Converted to throw 2022-09-24
  ruamel_base = ruamel-base; # added 2021-11-01
  ruamel_yaml = ruamel-yaml; # added 2021-11-01
  ruamel_yaml_clib = ruamel-yaml-clib; # added 2021-11-01
  sapi-python-client = kbcstorage; # added 2022-04-20
  scikitlearn = throw "'scikitlearn' has been renamed to/replaced by 'scikit-learn'"; # Converted to throw 2022-09-24
  setuptools_scm = throw "'setuptools_scm' has been renamed to/replaced by 'setuptools-scm'"; # Converted to throw 2022-09-24
  sharkiqpy = sharkiq; # added 2022-05-21
  smart_open = throw "'smart_open' has been renamed to/replaced by 'smart-open'"; # Converted to throw 2022-09-24
  SPARQLWrapper = sparqlwrapper; # Added 2022-03-31
  sphinx_rtd_theme = sphinx-rtd-theme; # added 2022-08-03
  sphinxcontrib_plantuml = throw "'sphinxcontrib_plantuml' has been renamed to/replaced by 'sphinxcontrib-plantuml'"; # Converted to throw 2022-09-24
  sqlalchemy_migrate = sqlalchemy-migrate; # added 2021-10-28
  SQLAlchemy-ImageAttach = throw "sqlalchemy-imageattach has been removed as it is incompatible with sqlalchemy 1.4 and unmaintained"; # added 2022-04-23
  tensorflow-bin_2 = tensorflow-bin; # added 2021-11-25
  tensorflow-build_2 = tensorflow-build; # added 2021-11-25
  tensorflow-estimator_2 = tensorflow-estimator; # added 2021-11-25
  tensorflow-tensorboard = tensorboard; # added 2022-03-06
  tensorflow-tensorboard_2 = tensorflow-tensorboard; # added 2021-11-25
  types-cryptography = throw "types-cryptography has been removed because it is obsolete since cryptography version 3.4.4."; # added 2022-05-30
  types-paramiko = throw "types-paramiko has been removed because it was unused."; # added 2022-05-30
  WazeRouteCalculator = wazeroutecalculator; # added 2021-09-29
  webapp2 = throw "webapp2 is unmaintained since 2012"; # added 2022-05-29
  websocket_client = throw "'websocket_client' has been renamed to/replaced by 'websocket-client'"; # Converted to throw 2022-09-24
  xenomapper = throw "xenomapper was moved to pkgs.xenomapper"; # added 2021-12-31
  zc-buildout221 = throw "'zc-buildout221' has been renamed to/replaced by 'zc-buildout'"; # Converted to throw 2022-09-24
  zc_buildout_nix = throw "zc_buildout_nix was pinned to a version no longer compatible with other modules"; # Added 2021-12-08
})
