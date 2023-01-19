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
  awkward0 = throw "awkward0 has been removed, use awkward instead"; # added 2022-12-13
  Babel = babel; # added 2022-05-06
  bitcoin-price-api = throw "bitcoin-price-api has been removed, it was using setuptools 2to3 translation feautre, which has been removed in setuptools 58"; # added 2022-02-15
  blockdiagcontrib-cisco = throw "blockdiagcontrib-cisco is not compatible with blockdiag 2.0.0 and has been removed."; # added 2020-11-29
  bsblan = python-bsblan; # added 2022-11-04
  bt_proximity = bt-proximity; # added 2021-07-02
  carrot = throw "carrot has been removed, as its development was discontinued in 2012"; # added 2022-01-18
  class-registry = phx-class-registry; # added 2021-10-05
  codespell = throw "codespell has been promoted to a top-level attribute"; # Added 2022-10-02
  ConfigArgParse = configargparse; # added 2021-03-18
  cozy = throw "cozy was removed because it was not actually https://pypi.org/project/Cozy/."; # added 2022-01-14
  cryptography_vectors = "cryptography_vectors is no longer exposed in python*Packages because it is used for testing cryptography only."; # Added 2022-03-23
  dask-xgboost = throw "dask-xgboost was removed because its features are available in xgboost"; # added 2022-05-24
  dateutil = python-dateutil; # added 2021-07-03
  demjson = throw "demjson has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  detox = throw "detox is no longer maintained, and was broken since may 2019"; # added 2020-07-04
  dftfit = throw "dftfit dependency lammps-cython no longer builds"; # added 2021-07-04
  diff_cover = diff-cover; # added 2021-07-02
  discogs_client = discogs-client; # added 2021-07-02
  djangorestframework-jwt = drf-jwt; # added 2021-07-20
  django-sampledatahelper = throw "django-sampledatahelper was removed because it is no longer compatible to latest Django version"; # added 2022-07-18
  django_2 = throw "Django 2 has reached it's projected EOL in 2022/04 and has therefore been removed."; # added 2022-03-05
  django_appconf = django-appconf; # added 2022-03-03
  django-discover-runner = throw "django-discover-runner was removed because it is no longer maintained."; # added 2022-11-21
  django_environ = django-environ; # added 2021-12-25
  django_extensions = django-extensions; # added 2022-01-09
  django_guardian = django-guardian; # added 2022-05-19
  django_modelcluster = django-modelcluster; # added 2022-04-02
  django_reversion = django-reversion; # added 2022-06-18
  django_polymorphic = django-polymorphic; # added 2022-05-24
  django_redis = django-redis; # added 2021-10-11
  django_taggit = django-taggit; # added 2021-10-11
  dns = dnspython; # added 2017-12-10
  dogpile_cache = dogpile-cache; # added 2021-10-28
  dogpile-core = throw "dogpile-core is no longer maintained, use dogpile-cache instead"; # added 2021-11-20
  eebrightbox = throw "eebrightbox is unmaintained upstream and has therefore been removed"; # added 2022-02-03
  email_validator = email-validator; # added 2022-06-22
  face_recognition = face-recognition; # added 2022-10-15
  face_recognition_models = face-recognition-models; # added 2022-10-15
  fake_factory = throw "fake_factory has been removed because it is unused and deprecated by upstream since 2016."; # added 2022-05-30
  faulthandler = throw "faulthandler is built into ${python.executable}"; # added 2021-07-12
  filemagic = throw "inactive since 2014, so use python-magic instead"; # added 2022-11-19
  flaskbabel = flask-babel; # added 2023-01-19
  flask_login = flask-login; # added 2022-10-17
  flask_sqlalchemy = flask-sqlalchemy; # added 2022-07-20
  flask_testing = flask-testing; # added 2022-04-25
  flask_wtf = flask-wtf; # added 2022-05-24
  functorch = throw "functorch is now part of the torch package and has therefore been removed. See https://github.com/pytorch/functorch/releases/tag/v1.13.0 for more info."; # added 2022-12-01
  garages-amsterdam = throw "garages-amsterdam has been renamed odp-amsterdam."; # added 2023-01-04
  garminconnect-ha = garminconnect; # added 2022-02-05
  gigalixir = throw "gigalixir has been promoted to a top-level attribute"; # Added 2022-10-02
  gitdb2 = throw "gitdb2 has been deprecated, use gitdb instead."; # added 2020-03-14
  GitPython = gitpython; # added 2022-10-28
  glances = throw "glances has moved to pkgs.glances"; # added 2020-20-28
  google_api_python_client = google-api-python-client; # added 2021-03-19
  googleapis_common_protos = googleapis-common-protos; # added 2021-03-19
  graphite_api = throw "graphite_api was removed, because it is no longer maintained"; # added 2022-07-10
  graphite_beacon = throw "graphite_beacon was removed, because it is no longer maintained"; # added 2022-07-09
  grpc_google_iam_v1 = grpc-google-iam-v1; # added 2021-08-21
  ha-av = throw "ha-av was removed, because it is no longer maintained"; # added 2022-04-06
  HAP-python = hap-python; # added 2021-06-01
  hbmqtt = throw "hbmqtt was removed because it is no longer maintained"; # added 2021-11-07
  hdlparse = throw "hdlparse has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  hyperkitty = throw "Please use pkgs.mailmanPackages.hyperkitty"; # added 2022-04-29
  IMAPClient = imapclient; # added 2021-10-28
  imdbpy = throw "imdbpy has been renamed to cinemagoer"; # added 2022-08-08
  ipaddress = throw "ipaddress has been removed because it is no longer required since python 2.7."; # added 2022-05-30
  influxgraph = throw "influxgraph has been removed because it is no longer maintained"; # added 2022-07-10
  itanium_demangler = itanium-demangler; # added 2022-1017
  jinja2_time = jinja2-time; # added 2022-11-07
  jupyter_client = jupyter-client; # added 2021-10-15
  jupyter_core = jupyter-core; # added 2023-01-05
  jupyter_server = jupyter-server; # added 2023-01-05
  Keras = keras; # added 2021-11-25
  ldap = python-ldap; # added 2022-09-16
  lammps-cython = throw "lammps-cython no longer builds and is unmaintained"; # added 2021-07-04
  logilab_astng = throw "logilab-astng has not been released since 2013 and is unmaintained"; # added 2022-11-29
  logilab_common = logilab-common; # added 2022-11-21
  loo-py = loopy; # added 2022-05-03
  Markups = markups; # added 2022-02-14
  MechanicalSoup = mechanicalsoup; # added 2021-06-01
  memcached = python-memcached; # added 2022-05-06
  mailman = throw "Please use pkgs.mailman"; # added 2022-04-29
  mailman-hyperkitty = throw "Please use pkgs.mailmanPackages.mailman-hyperkitty"; # added 2022-04-29
  mailman-web = throw "Please use pkgs.mailman-web"; # added 2022-04-29
  mistune_0_8 = throw "mistune_0_8 was removed because it was outdated and insecure"; # added 2022-08-12
  mistune_2_0 = mistune; # added 2022-08-12
  mutmut = throw "mutmut has been promoted to a top-level attribute"; # added 2022-10-02
  net2grid = gridnet; # add 2022-04-22
  nose-cover3 = throw "nose-cover3 has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-02-16
  notifymuch = throw "notifymuch has been promoted to a top-level attribute"; # added 2022-10-02
  ordereddict = throw "ordereddict has been removed because it is only useful on unsupported python versions."; # added 2022-05-28
  pam = python-pam; # added 2020-09-07.
  PasteDeploy = pastedeploy; # added 2021-10-07
  pathpy = path; # added 2022-04-12
  pdfminer = pdfminer-six; # added 2022-05-25
  pep257 = pydocstyle; # added 2022-04-12
  poetry2conda = throw "poetry2conda was promoted to a top-level attribute"; # Added 2022-10-02
  poster3 = throw "poster3 is unmaintained and source is no longer available"; # added 2023-05-29
  postorius = throw "Please use pkgs.mailmanPackages.postorius"; # added 2022-04-29
  powerlineMemSegment = powerline-mem-segment; # added 2021-10-08
  privacyidea = throw "privacyidea has been renamed to pkgs.privacyidea"; # added 2021-06-20
  prometheus_client = prometheus-client; # added 2021-06-10
  prompt_toolkit = prompt-toolkit; # added 2021-07-22
  protonup = protonup-ng; # Added 2022-11-06
  pur = throw "pur has been renamed to pkgs.pur"; # added 2021-11-08
  pushbullet = pushbullet-py;  # Added 2022-10-15
  pydrive = throw "pydrive is broken and deprecated and has been replaced with pydrive2."; # added 2022-06-01
  pyGtkGlade = throw "Glade support for pygtk has been removed"; # added 2022-01-15
  pycallgraph = throw "pycallgraph has been removed, it was using setuptools 2to3 translation feature, which has been removed in setuptools 58"; # added 2022-01-18
  pychef = throw "pychef has been removed because it's been archived upstream and abandoned since 2017."; # added 2022-11-14
  pycryptodome-test-vectors = throw "pycryptodome-test-vectors has been removed because it is an internal package to pycryptodome"; # added 2022-05-28
  pyialarmxr = pyialarmxr-homeassistant; # added 2022-06-07
  pyialarmxr-homeassistant = throw "The package was removed together with the component support in home-assistant 2022.7.0"; # added 2022-07-07
  PyICU = pyicu; # Added 2022-12-22
  pyjson5 = json5; # added 2022-08-28
  pylibgen = throw "pylibgen is unmaintained upstreamed, and removed from nixpkgs"; # added 2020-06-20
  PyLD = pyld; # added 2022-06-22
  pymc3 = pymc; # added 2022-06-05, module was rename starting with 4.0.0
  pymssql = throw "pymssql has been abandoned upstream."; # added 2020-05-04
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
  pytestcov = pytest-cov; # added 2021-01-04
  pytest-pep8 = pytestpep8; # added 2021-01-04
  pytest-pep257 = throw "pytest-pep257 was removed, as the pep257 package was migrated into pycodestyle"; # added 2022-04-12
  pytest-pythonpath = throw "pytest-pythonpath is obsolete as of pytest 7.0.0 and has been removed"; # added 2022-03-09
  pytestpep8 = throw "pytestpep8 was removed because it is abandoned and no longer compatible with pytest v6.0"; # added 2020-12-10
  pytestquickcheck = pytest-quickcheck; # added 2021-07-20
  pytestrunner = pytest-runner; # added 2021-01-04
  python-igraph = igraph; # added 2021-11-11
  python-lz4 = lz4; # added 2018-06-01
  python_magic = python-magic; # added 2022-05-07
  python_mimeparse = python-mimeparse; # added 2021-10-31
  python-language-server = throw "python-language-server is no longer maintained, use the python-lsp-server community fork instead."; # Added 2022-08-03
  python-Levenshtein = levenshtein;
  python-subunit = subunit; # added 2021-09-10
  pytest_xdist = pytest-xdist; # added 2021-01-04
  python_simple_hipchat = python-simple-hipchat; # added 2021-07-21
  pytorch = torch; # added 2022-09-30
  pytorch-bin = torch-bin; # added 2022-09-30
  pytorchWithCuda = torchWithCuda; # added 2022-09-30
  pytorchWithoutCuda = torchWithoutCuda; # added 2022-09-30
  pytwitchapi = twitchapi; # added 2022-03-07
  qasm2image = throw "qasm2image is no longer maintained (since November 2018), and is not compatible with the latest pythonPackages.qiskit versions."; # added 2020-12-09
  qiskit-aqua = throw "qiskit-aqua has been removed due to deprecation, with its functionality moved to different qiskit packages";
  rdflib-jsonld = throw "rdflib-jsonld is not compatible with rdflib 6"; # added 2021-11-05
  repeated_test = repeated-test; # added 2022-11-15
  requests_oauthlib = requests-oauthlib; # added 2022-02-12
  requests_toolbelt = requests-toolbelt; # added 2017-09-26
  rig = throw "rig has been removed because it was pinned to python 2.7 and 3.5, failed to build and is otherwise unmaintained"; # added 2022-11-28
  roboschool = throw "roboschool is deprecated in favor of PyBullet and has been removed"; # added 2022-01-15
  ROPGadget = ropgadget; # added 2021-07-06
  rotate-backups = throw "rotate-backups was removed in favor of the top-level rotate-backups"; # added 2021-07-01
  ruamel_base = ruamel-base; # added 2021-11-01
  ruamel_yaml = ruamel-yaml; # added 2021-11-01
  ruamel_yaml_clib = ruamel-yaml-clib; # added 2021-11-01
  sapi-python-client = kbcstorage; # added 2022-04-20
  scikitlearn = scikit-learn; # added 2021-07-21
  selectors34 = throw "selectors34 has been removed: functionality provided by Python itself; archived by upstream."; # added 2021-06-10
  setuptools_scm = setuptools-scm; # added 2021-06-03
  sharkiqpy = sharkiq; # added 2022-05-21
  smart_open = smart-open; # added 2021-03-14
  smmap2 = throw "smmap2 has been deprecated, use smmap instead."; # added 2020-03-14
  SPARQLWrapper = sparqlwrapper;
  sphinx_rtd_theme = sphinx-rtd-theme; # added 2022-08-03
  sphinxcontrib_plantuml = sphinxcontrib-plantuml; # added 2021-08-02
  sqlalchemy_migrate = sqlalchemy-migrate; # added 2021-10-28
  SQLAlchemy-ImageAttach = throw "sqlalchemy-imageattach has been removed as it is incompatible with sqlalchemy 1.4 and unmaintained"; # added 2022-04-23
  tensorflow-bin_2 = tensorflow-bin; # added 2021-11-25
  tensorflow-build_2 = tensorflow-build; # added 2021-11-25
  tensorflow-estimator_2 = tensorflow-estimator; # added 2021-11-25
  tensorflow-tensorboard = tensorboard; # added 2022-03-06
  tensorflow-tensorboard_2 = tensorflow-tensorboard; # added 2021-11-25
  tumpa = throw "tumpa was promoted to a top-level attribute"; # added 2022-11-19
  tvnamer = throw "tvnamer was moved to pkgs.tvnamer"; # added 2021-07-05
  types-cryptography = throw "types-cryptography has been removed because it is obsolete since cryptography version 3.4.4."; # added 2022-05-30
  types-paramiko = throw "types-paramiko has been removed because it was unused."; # added 2022-05-30
  unittest2 = throw "unittest2 has been removed as it's a backport of unittest that's unmaintained and not needed beyond Python 3.4."; # added 2022-12-01
  uproot3 = throw "uproot3 has been removed, use uproot instead"; # added 2022-12-13
  uproot3-methods = throw "uproot3-methods has been removed"; # added 2022-12-13
  virtual-display = throw "virtual-display has been renamed to PyVirtualDisplay"; # added 2023-01-07
  Wand = wand; # added 2022-11-13
  WazeRouteCalculator = wazeroutecalculator; # added 2021-09-29
  weakrefmethod = throw "weakrefmethod was removed since it's not needed in Python >= 3.4"; # added 2022-12-01
  webapp2 = throw "webapp2 is unmaintained since 2012"; # added 2022-05-29
  websocket_client = websocket-client; # added 2021-06-15
  xenomapper = throw "xenomapper was moved to pkgs.xenomapper"; # added 2021-12-31
  zc-buildout221 = zc-buildout; # added 2021-07-21
  zc_buildout_nix = throw "zc_buildout_nix was pinned to a version no longer compatible with other modules";
})
