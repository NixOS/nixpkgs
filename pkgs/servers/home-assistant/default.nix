{ stdenv, nixosTests, lib, fetchurl, fetchFromGitHub, fetchpatch, python3, protobuf3_6

# Look up dependencies of specified components in component-packages.nix
, extraComponents ? [ ]

# Additional packages to add to propagatedBuildInputs
, extraPackages ? ps: []

# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: {
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
  hassVersion = "0.116.0";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = pythonOlder "3.7.1";

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = version;
    sha256 = "1bqpk9dpra53yhasmp0yb7kzmfwdvlhb7jrf6wyv12rwzf8wy5w7";
  };

  patches = [
    (fetchpatch {
      #  Fix group tests when run in parallel, remove >= 0.117.0
      url = "https://github.com/home-assistant/core/pull/41446/commits/c79dc478b7136b6df43707bf0ad6b53419c8a909.patch";
      sha256 = "1cl81swq960vd2f733dcqq60c0jjzrkm0l2sibcblhmyw597b4vj";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography==2.9.2" "cryptography" \
      --replace "ruamel.yaml==0.15.100" "ruamel.yaml>=0.15.100" \
      --replace "yarl==1.4.2" "yarl~=1.4"
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'
  '';

  propagatedBuildInputs = [
    # From setup.py
    aiohttp astral async-timeout attrs bcrypt certifi importlib-metadata jinja2
    pyjwt cryptography pip python-slugify pytz pyyaml requests ruamel_yaml
    setuptools voluptuous voluptuous-serialize
    # From default_config. frontend, http, image, mobile_app and recorder components as well as
    # the auth.mfa_modules.totp module
    aiohttp-cors ciso8601 defusedxml distro emoji hass-frontend pynacl pillow pyotp
    pyqrcode sqlalchemy
  ] ++ componentBuildInputs ++ extraBuildInputs;

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = [
    asynctest pytestCheckHook pytest-aiohttp pytest_xdist requests-mock hass-nabucasa netdisco pydispatcher
  ];

  # We cannot test all components, since they'd introduce lots of dependencies, some of which are unpackaged,
  # but we should test very common stuff, like what's in `default_config`.
  componentTests = [
    "api"
    "automation"
    "config"
    "configurator"
    "default_config"
    "demo"
    "discovery"
    "frontend"
    "group"
    "history"
    "homeassistant"
    "http"
    "input_boolean"
    "input_datetime"
    "input_text"
    "input_number"
    "input_select"
    "logbook"
    "logger"
    "media_source"
    "mobile_app"
    "person"
    "scene"
    "script"
    "shell_command"
    "ssdp"
    "sun"
    "system_health"
    "system_log"
    "tag"
    "websocket_api"
    "zeroconf"
    "zone"
  ];

  pytestFlagsArray = [
    "-n auto"
    # don't bulk test all components
    "--ignore tests/components"
    # prone to race conditions due to parallel file access
    "--ignore tests/test_config.py"
    # tries to import unpackaged dependencies
    "--ignore tests/test_loader.py"
    # pyotp since v2.4.0 complains about the short mock keys, hass pins v2.3.0
    "--ignore tests/auth/mfa_modules/test_notify.py"
    "tests"
  ] ++ map (component: "tests/components/" + component) componentTests;

  disabledTests = [
    # AssertionError: merge_log_err.call_count != 0
    "test_merge"
    # ModuleNotFoundError: No module named 'pyqwikswitch'
    "test_merge_id_schema"
    # AssertionError: assert 'unknown' == 'not_home'
    "test_device_tracker_not_home"
    # Racy https://github.com/home-assistant/core/issues/41425
    "test_cached_event_message"
  ];

  preCheck = ''
    # the tests require the existance of a media dir
    mkdir /build/media
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
