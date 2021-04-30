{ stdenv
, lib
, fetchFromGitHub
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
    # https://github.com/home-assistant/core/pull/48573; Remove >= 2021.5
    (mkOverride "astral" "1.10.1"
      "d2a67243c4503131c856cafb1b1276de52a86e5b8a1d507b7e08bee51cb67bf1")

    # Pinned due to API changes in brother>=1.0, remove >= 2021.5
    (self: super: {
      brother = super.brother.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.2";
        src = fetchFromGitHub {
          owner = "bieniu";
          repo = "brother";
          rev = version;
          sha256 = "sha256-vIefcL3K3ZbAUxMFM7gbbTFdrnmufWZHcq4OA19SYXE=";
        };
      });
    })

    # Pinned due to API changes in iaqualink>=2.0, remove after
    # https://github.com/home-assistant/core/pull/48137 was merged
    (self: super: {
      iaqualink = super.iaqualink.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.4";
        src = fetchFromGitHub {
          owner = "flz";
          repo = "iaqualink-py";
          rev = "v${version}";
          sha256 = "16mn6nd9x3hm6j6da99qhwbqs95hh8wx21r1h1m9csl76z77n9lh";
        };
        checkInputs = oldAttrs.checkInputs ++ [ python3.pkgs.asynctest ];
      });
    })

    # Pinned due to API changes in pyjwt>=2.0
    (mkOverride "pyjwt" "1.7.1"
      "15hflax5qkw1v6nssk1r0wkj83jgghskcmn875m3wgvpzdvajncd")

    # Pinned due to API changes in pykmtronic>=0.2.0
    (mkOverride "pykmtronic" "0.0.3"
      "sha256-8bxn27DU1XUQUxQFJklEge29DHx1DMu7pJG4hVE1jDU=")

    # Pinned due to API changes in pylilterbot>=2021.3.0
    # https://github.com/home-assistant/core/pull/48300; Remove >= 2021.5
    (self: super: {
      pylitterbot = super.pylitterbot.overridePythonAttrs (oldAttrs: rec {
        version = "2021.2.8";
        src = fetchFromGitHub {
          owner = "natekspencer";
          repo = "pylitterbot";
          rev = version;
          sha256 = "142lhijm51v11cd0lhcfdnjdd143jxi2hjsrqdq0rrbbnmj6mymp";
        };
        # had no tests before 2021.3.0
        doCheck = false;
      });
    })

    # Pinned due to bug in ring-doorbell 0.7.0
    # https://github.com/tchellomello/python-ring-doorbell/issues/240
    (mkOverride "ring-doorbell" "0.6.2"
      "fbd537722a27b3b854c26506d894b7399bb8dc57ff36083285971227a2d46560")

    # Pinned due to API changes in pyruckus>0.12
    (self: super: {
      pyruckus = super.pyruckus.overridePythonAttrs (oldAttrs: rec {
        version = "0.12";
        src = fetchFromGitHub {
          owner = "gabe565";
          repo = "pyruckus";
          rev = version;
          sha256 = "0ykv6r6blbj3fg9fplk9i7xclkv5d93rwvx0fm5s8ms9f2s9ih8z";
        };
      });
    })

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
  hassVersion = "2021.4.6";

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
    sha256 = "1s1slwcqls2prz9kgyhggs8xi3x7ghwdi33j983kvpg0gva7d2f0";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "awesomeversion==21.2.3" "awesomeversion" \
      --replace "bcrypt==3.1.7" "bcrypt" \
      --replace "cryptography==3.3.2" "cryptography" \
      --replace "pip>=8.0.3,<20.3" "pip" \
      --replace "pytz>=2021.1" "pytz" \
      --replace "pyyaml==5.4.1" "pyyaml" \
      --replace "ruamel.yaml==0.15.100" "ruamel.yaml"
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
    "accuweather"
    "airly"
    "analytics"
    "alert"
    "api"
    "auth"
    "automation"
    "axis"
    "bayesian"
    "binary_sensor"
    "brother"
    "caldav"
    "calendar"
    "camera"
    "cast"
    "climate"
    "cloud"
    "comfoconnect"
    "command_line"
    "config"
    "configurator"
    "conversation"
    "counter"
    "cover"
    "deconz"
    "default_config"
    "demo"
    "derivative"
    "device_automation"
    "device_sun_light_trigger"
    "device_tracker"
    "devolo_home_control"
    "dhcp"
    "discovery"
    "dsmr"
    "econet"
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
    "freebox"
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
    "home_connect"
    "home_plus_control"
    "homekit"
    "homekit_controller"
    "homeassistant"
    "homematic"
    "homematicip_cloud"
    "html5"
    "http"
    "hue"
    "hyperion"
    "iaqualink"
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
    "knx"
    "kodi"
    "light"
    "litterrobot"
    "local_file"
    "local_ip"
    "lock"
    "logbook"
    "logentries"
    "logger"
    "lovelace"
    "lutron_caseta"
    "manual"
    "manual_mqtt"
    "mazda"
    "media_player"
    "media_source"
    "met"
    "minecraft_server"
    "mobile_app"
    "modbus"
    "moon"
    "mqtt"
    "mqtt_eventstream"
    "mqtt_json"
    "mqtt_room"
    "mqtt_statestream"
    "mullvad"
    "nexia"
    "notify"
    "notion"
    "number"
    "nx584"
    "omnilogic"
    "ondilo_ico"
    "openerz"
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
    "roku"
    "rss_feed_template"
    "ruckus_unleashed"
    "safe_mode"
    "scene"
    "screenlogic"
    "script"
    "search"
    "shell_command"
    "shopping_list"
    "simplisafe"
    "simulated"
    "sleepiq"
    "sma"
    "smhi"
    "sensor"
    "slack"
    "smartthings"
    "smarttub"
    "smtp"
    "smappee"
    "solaredge"
    "sonos"
    "spotify"
    "sql"
    "ssdp"
    "stream"
    "subaru"
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
    "trace"
    "tts"
    "universal"
    "updater"
    "upnp"
    "uptime"
    "vacuum"
    "verisure"
    "weather"
    "webhook"
    "websocket_api"
    "wemo"
    "wled"
    "workday"
    "worldclock"
    "yeelight"
    "zeroconf"
    "zha"
    "zone"
    "zwave"
    "zwave_js"
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
    # screenlogic/test_config_flow.py: Tries to send out UDP broadcasts
    "--deselect tests/components/screenlogic/test_config_flow.py::test_form_cannot_connect"
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
    # util/test_package.py: AssertionError on package.is_installed('homeassistant>=999.999.999')
    "test_check_package_version_does_not_match"
  ];

  preCheck = ''
    export HOME="$TEMPDIR"

    # the tests require the existance of a media dir
    mkdir /build/media

    # error out when component test directory is missing, otherwise hidden by xdist execution :(
    for component in ${lib.concatStringsSep " " (map lib.escapeShellArg componentTests)}; do
      test -d "tests/components/$component" || {
        >2& echo "ERROR: Tests for component '$component' were enabled, but they do not exist!"
        exit 1
      }
    done
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
    maintainers = teams.home-assistant.members;
    platforms = platforms.linux;
  };
}
