{ stdenv, nixosTests, lib, fetchurl, fetchFromGitHub, fetchpatch, python3, protobuf3_6

# Look up dependencies of specified components in component-packages.nix
, extraComponents ? [ ]

# Additional packages to add to propagatedBuildInputs
, extraPackages ? ps: []

# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: {
  # TODO: Remove this override after updating to cryptography 2.8:

}

# Skip pip install of required packages on startup
, skipPip ? true }:

let

  defaultOverrides = [
    # Override the version of some packages pinned in Home Assistant's setup.py

    # required by the sun/moon plugins
    # https://github.com/home-assistant/core/issues/36636
    (mkOverride "astral" "1.10.1"
      "d2a67243c4503131c856cafb1b1276de52a86e5b8a1d507b7e08bee51cb67bf1")

    # We have 3.x in nixpkgs which is incompatible with home-assistant atm:
    # https://github.com/home-assistant/core/blob/dev/requirements_all.txt
    (mkOverride "pyowm" "2.10.0"
      "1xvcv3sbcn9na8cwz21nnjlixysfk5lymnf65d1nqkbgacc1mm4g")

    (mkOverride "bcrypt" "3.1.7"
      "0hhywhxx301cxivgxrpslrangbfpccc8y83qbwn1f57cab3nj00b")

    # hass-frontend does not exist in python3.pkgs
    (self: super: {
      hass-frontend = self.callPackage ./frontend.nix { };
    })
  ];

  mkOverride = attrname: version: sha256:
    self: super: {
      ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
      });
    };

  py = python3.override {
    # Put packageOverrides at the start so they are applied after defaultOverrides
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  getPackages = component: builtins.getAttr component componentPackages.components;

  componentBuildInputs = lib.concatMap (component: getPackages component py.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages py.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "0.114.4";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  disabled = pythonOlder "3.5";

  patches = [
    ./relax-dependencies.patch
  ];

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = version;
    sha256 = "0k9px4ny0b72d9ysr3x72idprgfgjab1z91ildr87629826bb4n7";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "yarl==1.4.2" "yarl~=1.4"
  '';

  propagatedBuildInputs = [
    # From setup.py
    aiohttp astral async-timeout attrs bcrypt certifi importlib-metadata jinja2
    pyjwt cryptography pip python-slugify pytz pyyaml requests ruamel_yaml
    setuptools voluptuous voluptuous-serialize
    # From http, frontend and recorder components and auth.mfa_modules.totp
    sqlalchemy aiohttp-cors hass-frontend pyotp pyqrcode ciso8601
  ] ++ componentBuildInputs ++ extraBuildInputs;

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = [
    asynctest pytest pytest-aiohttp requests-mock hass-nabucasa netdisco pydispatcher
  ];

  checkPhase = ''
    # - components' dependencies are not included, so they cannot be tested
    # - test_merge_id_schema requires pyqwikswitch
    # - test_loader.py tries to load not-packaged dependencies
    # - test_notify pyotp doesn't like the short mock keys
    # - unclear why test_merge fails: assert merge_log_err.call_count != 0
    # - test_setup_safe_mode_if_no_frontend: requires dependencies for components we have not packaged
    py.test \
      --ignore tests/components \
      --ignore tests/test_loader.py \
      --ignore tests/auth/mfa_modules/test_notify.py \
      -k "not test_setup_safe_mode_if_no_frontend and not test_merge_id_schema and not test_merge"

    # Some basic components should be tested however
    py.test \
      tests/components/{api,config,configurator,demo,discovery,frontend,group,history} \
      tests/components/{homeassistant,http,logger,script,shell_command,system_log,websocket_api}
  '';

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  passthru = {
    inherit (py.pkgs) hass-frontend;
    tests = {
      inherit (nixosTests) home-assistant;
    };
  };

  meta = with lib; {
    homepage = "https://home-assistant.io/";
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda globin mic92 hexa ];
  };
}
