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
  bugseverywhere = throw "bugseverywhere has been removed: Abandoned by upstream."; # Added 2019-11-27
  detox = throw "detox is no longer maintained, and was broken since may 2019"; # added 2020-07-04
  dns = dnspython; # Alias for compatibility, 2017-12-10
  faulthandler = throw "faulthandler is built into ${python.executable}";
  gitdb2 = throw "gitdb2 has been deprecated, use gitdb instead."; # added 2020-03-14
  glances = throw "glances has moved to pkgs.glances"; # added 2020-20-28
  google_api_python_client = google-api-python-client; # added 2021-03-19
  googleapis_common_protos = googleapis-common-protos; # added 2021-03-19
  HAP-python = hap-python; # added 2021-06-01
  MechanicalSoup = mechanicalsoup; # added 2021-06-01
  privacyidea = throw "renamed to pkgs.privacyidea"; # added 2021-06-20
  pylibgen = throw "pylibgen is unmaintained upstreamed, and removed from nixpkgs"; # added 2020-06-20
  pymssql = throw "pymssql has been abandoned upstream."; # added 2020-05-04
  pytest-pep8 = pytestpep8; # added 2021-01-04
  pytestpep8 = throw "pytestpep8 was removed because it is abandoned and no longer compatible with pytest v6.0"; # added 2020-12-10
  qasm2image = throw "qasm2image is no longer maintained (since November 2018), and is not compatible with the latest pythonPackages.qiskit versions."; # added 2020-12-09
  selectors34 = throw "selectors34 has been removed: functionality provided by Python itself; archived by upstream."; # Added 2021-06-10
  setuptools_scm = setuptools-scm; # added 2021-06-03
  smart_open = smart-open; # added 2021-03-14
  smmap2 = throw "smmap2 has been deprecated, use smmap instead."; # added 2020-03-14
  topydo = throw "python3Packages.topydo was moved to topydo"; # 2017-09-22
  websocket_client = websocket-client;
})
