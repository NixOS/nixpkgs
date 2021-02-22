{ stdenv, nixosTests, lib, fetchFromGitHub, python3

# Look up dependencies of specified components in component-packages.nix
, extraComponents ? [ ]

# Additional packages to add to propagatedBuildInputs
, extraPackages ? ps: []

# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: {}

# Skip pip install of required packages on startup
, skipPip ? true }:

let
  defaultOverrides = [
    # Override the version of some packages pinned in Home Assistant's setup.py

    # Pinned due to API changes in astral>=2.0, required by the sun/moon plugins
    # https://github.com/home-assistant/core/issues/36636
    (mkOverride "astral" "1.10.1"
      "d2a67243c4503131c856cafb1b1276de52a86e5b8a1d507b7e08bee51cb67bf1")

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
  hassVersion = "2021.2.3";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = pythonOlder "3.7.1";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = version;
    sha256 = "0s1jcd94wwvmvzq86w8s9dwfvnmjs9l661z9pc6kwgagggjjgd8c";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "attrs==19.3.0" "attrs>=19.3.0" \
      --replace "bcrypt==3.1.7" "bcrypt>=3.1.7" \
      --replace "cryptography==3.2" "cryptography" \
      --replace "pip>=8.0.3,<20.3" "pip" \
      --replace "pytz>=2020.5" "pytz>=2020.4" \
      --replace "pyyaml==5.4.1" "pyyaml" \
      --replace "requests==2.25.1" "requests>=2.25.0" \
      --replace "ruamel.yaml==0.15.100" "ruamel.yaml>=0.15.100"
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'
  '';

  propagatedBuildInputs = [
    # Only packages required in setup.py + hass-frontend
    aiohttp
    astral
    async-timeout
    attrs
    awesomeversion
    bcrypt
    certifi
    ciso8601
    cryptography
    hass-frontend
    httpx
    jinja2
    pip
    pyjwt
    python-slugify
    pytz
    pyyaml
    requests
    ruamel_yaml
    voluptuous
    voluptuous-serialize
    yarl
  ] ++ componentBuildInputs ++ extraBuildInputs;

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = [
    # test infrastructure
    asynctest
    pytest-aiohttp
    pytest-xdist
    pytestCheckHook
    requests-mock
    # component dependencies
    pyotp
  ] ++ lib.concatMap (component: getPackages component py.pkgs) componentTests;

  # We cannot test all components, since they'd introduce lots of dependencies, some of which are unpackaged,
  # but we should test very common stuff, like what's in `default_config`.
  # https://github.com/home-assistant/core/commits/dev/homeassistant/components/default_config/manifest.json
  componentTests = [
    "api"
    "automation"
    "config"
    "configurator"
    "counter"
    "default_config"
    "demo"
    "dhcp"
    "discovery"
    "frontend"
    "group"
    "history"
    "homeassistant"
    "http"
    "hue"
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
    "timer"
    "webhook"
    "websocket_api"
    "zeroconf"
    "zone"
    "zwave"
  ];

  pytestFlagsArray = [
    # limit amout of runners to reduce race conditions
    "-n 2"
    # assign tests grouped by file to workers
    "--dist loadfile"
    # don't bulk test all components
    "--ignore tests/components"
    # pyotp since v2.4.0 complains about the short mock keys, hass pins v2.3.0
    "--ignore tests/auth/mfa_modules/test_notify.py"
    "tests"
  ] ++ map (component: "tests/components/" + component) componentTests;

  disabledTests = [
    # AssertionError: assert 1 == 0
    "test_merge"
    # ModuleNotFoundError: No module named 'pyqwikswitch'
    "test_merge_id_schema"
    # keyring.errors.NoKeyringError: No recommended backend was available.
    "test_secrets_from_unrelated_fails"
    "test_secrets_credstash"
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
    description = "Open source home automation that puts local control and privacy first";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda globin mic92 hexa ];
  };
}
