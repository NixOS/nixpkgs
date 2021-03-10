{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, python3
, nixosTests

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

    # Pinned due to bug in ring-doorbell 0.7.0
    # https://github.com/tchellomello/python-ring-doorbell/issues/240
    (mkOverride "ring-doorbell" "0.6.2"
      "fbd537722a27b3b854c26506d894b7399bb8dc57ff36083285971227a2d46560")

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
  hassVersion = "2021.3.3";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = pythonOlder "3.8";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = version;
    sha256 = "0kfvjpzz6ynw8bwd91nm0aiw1pkrmaydwf1r93dnwi8rmzq10zpb";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    (fetchpatch {
      # Fix I-frame interval in stream test video
      # https://github.com/home-assistant/core/pull/47638
      url = "https://github.com/home-assistant/core/commit/d9bf63103fde44ddd38fb6b9a510d82609802b36.patch";
      sha256 = "1y34cmw9zqb2lxyzm0q7vxlm05wwz76mhysgnh1jn39484fn9f9m";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp==3.7.4" "aiohttp>=3.7.3" \
      --replace "attrs==19.3.0" "attrs>=19.3.0" \
      --replace "bcrypt==3.1.7" "bcrypt>=3.1.7" \
      --replace "cryptography==3.3.2" "cryptography" \
      --replace "httpx==0.16.1" "httpx>=0.16.1" \
      --replace "jinja2>=2.11.3" "jinja2>=2.11.2" \
      --replace "pip>=8.0.3,<20.3" "pip" \
      --replace "pytz>=2021.1" "pytz>=2020.5" \
      --replace "pyyaml==5.4.1" "pyyaml" \
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

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = [
    # test infrastructure
    asynctest
    pytest-aiohttp
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    requests-mock
    # component dependencies
    pyotp
    respx
  ] ++ lib.concatMap (component: getPackages component py.pkgs) componentTests;

  # We can reasonably test components that don't communicate with any network
  # services. Before adding new components to this list make sure we have all
  # its dependencies packaged and listed in ./component-packages.nix.
  componentTests = [
    "alert"
    "api"
    "auth"
    "automation"
    "bayesian"
    "binary_sensor"
    "caldav"
    "calendar"
    "camera"
    "climate"
    "cloud"
    "command_line"
    "config"
    "configurator"
    "conversation"
    "counter"
    "cover"
    "default_config"
    "demo"
    "derivative"
    "device_automation"
    "device_sun_light_trigger"
    "device_tracker"
    "dhcp"
    "discovery"
    "emulated_hue"
    "esphome"
    "fan"
    "faa_delays"
    "ffmpeg"
    "file"
    "filesize"
    "filter"
    "flux"
    "folder"
    "folder_watcher"
    "fritzbox"
    "fritzbox_callmonitor"
    "frontend"
    "generic"
    "generic_thermostat"
    "geo_json_events"
    "geo_location"
    "group"
    "hddtemp"
    "history"
    "history_stats"
    "homekit_controller"
    "homeassistant"
    "html5"
    "http"
    "hue"
    "ifttt"
    "image"
    "image_processing"
    "influxdb"
    "input_boolean"
    "input_datetime"
    "input_text"
    "input_number"
    "input_select"
    "intent"
    "intent_script"
    "ipp"
    "kmtronic"
    "light"
    "local_file"
    "local_ip"
    "lock"
    "logbook"
    "logentries"
    "logger"
    "lovelace"
    "manual"
    "manual_mqtt"
    "mazda"
    "media_player"
    "media_source"
    "met"
    "mobile_app"
    "modbus"
    "moon"
    "mqtt"
    "mqtt_eventstream"
    "mqtt_json"
    "mqtt_room"
    "mqtt_statestream"
    "mullvad"
    "notify"
    "number"
    "ozw"
    "panel_custom"
    "panel_iframe"
    "persistent_notification"
    "person"
    "plaato"
    "prometheus"
    "proximity"
    "push"
    "python_script"
    "random"
    "recorder"
    "rest"
    "rest_command"
    "rituals_perfume_genie"
    "rmvtransport"
    "rss_feed_template"
    "safe_mode"
    "scene"
    "script"
    "search"
    "shell_command"
    "shopping_list"
    "simulated"
    "sensor"
    "smarttub"
    "smtp"
    "sql"
    "ssdp"
    "stream"
    "sun"
    "switch"
    "system_health"
    "system_log"
    "tag"
    "tasmota"
    "tcp"
    "template"
    "threshold"
    "time_date"
    "timer"
    "tod"
    "tts"
    "universal"
    "updater"
    "upnp"
    "uptime"
    "vacuum"
    "weather"
    "webhook"
    "websocket_api"
    "wled"
    "workday"
    "worldclock"
    "zeroconf"
    "zha"
    "zone"
    "zwave"
  ];

  pytestFlagsArray = [
    # limit amout of runners to reduce race conditions
    "-n auto"
    # retry racy tests that end in "RuntimeError: Event loop is closed"
    "--reruns 3"
    "--only-rerun RuntimeError"
    # assign tests grouped by file to workers
    "--dist loadfile"
    # tests are located in tests/
    "tests"
    # dynamically add packages required for component tests
  ] ++ map (component: "tests/components/" + component) componentTests;

  disabledTestPaths = [
    # don't bulk test all components
    "tests/components"
    # pyotp since v2.4.0 complains about the short mock keys, hass pins v2.3.0
    "tests/auth/mfa_modules/test_notify.py"
  ];

  disabledTests = [
    # AssertionError: assert 1 == 0
    "test_error_posted_as_event"
    "test_merge"
    # ModuleNotFoundError: No module named 'pyqwikswitch'
    "test_merge_id_schema"
    # keyring.errors.NoKeyringError: No recommended backend was available.
    "test_secrets_from_unrelated_fails"
    "test_secrets_credstash"
    # generic/test_camera.py: AssertionError: 500 == 200
    "test_fetching_without_verify_ssl"
    "test_fetching_url_with_verify_ssl"
  ];

  preCheck = ''
    # the tests require the existance of a media dir
    mkdir /build/media
  '';

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
