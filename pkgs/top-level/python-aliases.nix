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
  blockdiagcontrib-cisco = throw "blockdiagcontrib-cisco is not compatible with blockdiag 2.0.0 and has been removed."; # Added 2020-11-29
  bt_proximity = bt-proximity; # added 2021-07-02
  bugseverywhere = throw "bugseverywhere has been removed: Abandoned by upstream."; # Added 2019-11-27
  ConfigArgParse = configargparse; # added 2021-03-18
  dateutil = python-dateutil; # added 2021-07-03
  detox = throw "detox is no longer maintained, and was broken since may 2019"; # added 2020-07-04
  dftfit = throw "it's dependency lammps-cython no longer builds";
  diff_cover = diff-cover; # added 2021-07-02
  discogs_client = discogs-client; # added 2021-07-02
  djangorestframework-jwt = drf-jwt;
  dns = dnspython; # Alias for compatibility, 2017-12-10
  faulthandler = throw "faulthandler is built into ${python.executable}";
  gitdb2 = throw "gitdb2 has been deprecated, use gitdb instead."; # added 2020-03-14
  glances = throw "glances has moved to pkgs.glances"; # added 2020-20-28
  google_api_python_client = google-api-python-client; # added 2021-03-19
  googleapis_common_protos = googleapis-common-protos; # added 2021-03-19
  HAP-python = hap-python; # added 2021-06-01
  lammps-cython = throw "no longer builds and is unmaintained";
  MechanicalSoup = mechanicalsoup; # added 2021-06-01
  privacyidea = throw "renamed to pkgs.privacyidea"; # added 2021-06-20
  pylibgen = throw "pylibgen is unmaintained upstreamed, and removed from nixpkgs"; # added 2020-06-20
  pymssql = throw "pymssql has been abandoned upstream."; # added 2020-05-04
  pytestcov = pytest-cov; # added 2021-01-04
  pytest-pep8 = pytestpep8; # added 2021-01-04
  pytestpep8 = throw "pytestpep8 was removed because it is abandoned and no longer compatible with pytest v6.0"; # added 2020-12-10
  pytestquickcheck = pytest-quickcheck; # added 2021-07-20
  pytestrunner = pytest-runner; # added 2021-01-04
  pytest_xdist = pytest-xdist; # added 2021-01-04
  python_simple_hipchat = python-simple-hipchat; # added 2021-07-21
  qasm2image = throw "qasm2image is no longer maintained (since November 2018), and is not compatible with the latest pythonPackages.qiskit versions."; # added 2020-12-09
  requests_toolbelt = requests-toolbelt; # added 2017-09-26
  rotate-backups = throw "pythonPackages.rotate-backups was removed in favor of the top-level rotate-backups"; # added 2021-07-01
  scikitlearn = scikit-learn; # added 2021-07-21
  selectors34 = throw "selectors34 has been removed: functionality provided by Python itself; archived by upstream."; # Added 2021-06-10
  setuptools_scm = setuptools-scm; # added 2021-06-03
  smart_open = smart-open; # added 2021-03-14
  smmap2 = throw "smmap2 has been deprecated, use smmap instead."; # added 2020-03-14
  topydo = throw "python3Packages.topydo was moved to topydo"; # 2017-09-22
  tvnamer = throw "python3Packages.tvnamer was moved to tvnamer"; # 2021-07-05
  websocket_client = websocket-client;
  zc_buildout221 = zc_buildout; # added 2021-07-21
})
