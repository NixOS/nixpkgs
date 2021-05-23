{ stdenv
, lib
, fetchFromGitHub
, python3
, inetutils
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
    (self: super: {
      pyjwt = super.pyjwt.overridePythonAttrs (oldAttrs: rec {
        version = "1.7.1";
        src = oldAttrs.src.override {
          sha256 = "15hflax5qkw1v6nssk1r0wkj83jgghskcmn875m3wgvpzdvajncd";
        };
        disabledTests = [
          "test_ec_verify_should_return_false_if_signature_invalid"
        ];
      });
    })

    # Pinned due to bug in ring-doorbell 0.7.0
    # https://github.com/tchellomello/python-ring-doorbell/issues/240
    (mkOverride "ring-doorbell" "0.6.2"
      "fbd537722a27b3b854c26506d894b7399bb8dc57ff36083285971227a2d46560")

    # Pinned due to API changes in pyflunearyou>=2.0
    (self: super: {
      pyflunearyou = super.pyflunearyou.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.7";
        src = fetchFromGitHub {
          owner = "bachya";
          repo = "pyflunearyou";
          rev = version;
          sha256 = "0hq55k298m9a90qb3lasw9bi093hzndrah00rfq94bp53aq0is99";
        };
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry.api" "poetry.core.masonry.api" \
            --replace 'msgpack = "^0.6.2"' 'msgpack = "*"' \
            --replace 'ujson = "^1.35"' 'ujson = "*"'
        '';
      });
    })

    # Pinned due to API changes in pylast 4.2.1
    (mkOverride "pylast" "4.2.0"
      "0zd0dn2l738ndz62vpa751z0ldnm91dcz9zzbvxv53r08l0s9yf3")

    # Pinned due to API changes in pyopenuv>=1.1.0
    (self: super: {
      pyopenuv = super.pyopenuv.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.13";
        src = fetchFromGitHub {
          owner = "bachya";
          repo = "pyopenuv";
          rev = version;
          sha256 = "1gx9xjkyvqqy8410lnbshq1j5y4cb0cdc4m505g17rwdzdwb01y8";
        };
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry.api" "poetry.core.masonry.api"
        '';
      });
    })

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

    # Remove after https://github.com/NixOS/nixpkgs/pull/121854 has passed staging-next
    (self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.13";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0npsg38d11skv04zvsi90j93f6jdgm8666ds2ri7shr1pz1732hx";
        };
        patches = [];
        propagatedBuildInputs = [ python3.pkgs.greenlet ];
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
  hassVersion = "2021.5.5";

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
    sha256 = "1vdxygjik1ay58xgyr1rk12cgy63raqi4fldnd4mlhs4i21c7ff8";
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
    # test infrastructure (selectively from requirement_test.txt)
    pytest-aiohttp
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    requests-mock
    jsonpickle
    respx
    # required by tests/auth/mfa_modules
    pyotp
  ] ++ lib.concatMap (component: getPackages component py.pkgs) componentTests;

  # We can reasonably test components that don't communicate with any network
  # services. Before adding new components to this list make sure we have all
  # its dependencies packaged and listed in ./component-packages.nix.
  componentTests = [
    "abode"
    "accuweather"
    "acmeda"
    "adguard"
    "advantage_air"
    "agent_dvr"
    "air_quality"
    "airly"
    "airnow"
    "airvisual"
    "alarm_control_panel"
    "alarmdecoder"
    "alert"
    "alexa"
    "almond"
    "ambiclimate"
    "ambient_station"
    "analytics"
    "androidtv"
    "apache_kafka"
    "api"
    "apple_tv"
    "apprise"
    "arlo"
    "asuswrt"
    "august"
    "aurora"
    "auth"
    "automation"
    "awair"
    "aws"
    "axis"
    "bayesian"
    "binary_sensor"
    "blackbird"
    "blueprint"
    "bluetooth_le_tracker"
    "braviatv"
    "broadlink"
    "brother"
    "bsblan"
    "caldav"
    "calendar"
    "camera"
    "canary"
    "cast"
    "cert_expiry"
    "climacell"
    "climate"
    "cloud"
    "cloudflare"
    "comfoconnect"
    "command_line"
    "compensation"
    "config"
    "configurator"
    "conversation"
    "coronavirus"
    "counter"
    "cover"
    "daikin"
    "darksky"
    "datadog"
    "deconz"
    "default_config"
    "demo"
    "denonavr"
    "derivative"
    "device_automation"
    "device_sun_light_trigger"
    "device_tracker"
    "devolo_home_control"
    "dexcom"
    "dhcp"
    "dialogflow"
    "discovery"
    "dsmr"
    "dte_energy_bridge"
    "duckdns"
    "dyson"
    "eafm"
    "econet"
    "efergy"
    "emonitor"
    "emulated_hue"
    "enphase_envoy"
    "esphome"
    "everlights"
    "ezviz"
    "faa_delays"
    "facebook"
    "facebox"
    "fail2ban"
    "fan"
    "feedreader"
    "ffmpeg"
    "fido"
    "file"
    "filesize"
    "filter"
    "firmata"
    "flo"
    "flume"
    "flunearyou"
    "flux"
    "folder"
    "folder_watcher"
    "freebox"
    "freedns"
    "fritz"
    "fritzbox"
    "fritzbox_callmonitor"
    "frontend"
    "generic"
    "generic_thermostat"
    "geo_json_events"
    "geo_location"
    "geofency"
    "glances"
    "google"
    "google_assistant"
    "google_domains"
    "google_pubsub"
    "google_translate"
    "google_travel_time"
    "google_wifi"
    "gpslogger"
    "graphite"
    "group"
    "guardian"
    "harmony"
    "hassio"
    "hddtemp"
    "history"
    "history_stats"
    "home_connect"
    "home_plus_control"
    "homeassistant"
    "homekit"
    "homekit_controller"
    "homematic"
    "homematicip_cloud"
    "html5"
    "http"
    "hue"
    "humidifier"
    "hyperion"
    "ialarm"
    "iaqualink"
    "icloud"
    "ifttt"
    "image"
    "image_processing"
    "imap_email_content"
    "influxdb"
    "input_boolean"
    "input_datetime"
    "input_number"
    "input_select"
    "input_text"
    "insteon"
    "integration"
    "intent"
    "intent_script"
    "ios"
    "ipp"
    "iqvia"
    "islamic_prayer_times"
    "jewish_calendar"
    "kira"
    "kmtronic"
    "knx"
    "kodi"
    "lastfm"
    "lcn"
    "light"
    "litterrobot"
    "local_file"
    "local_ip"
    "locative"
    "lock"
    "logbook"
    "logentries"
    "logger"
    "london_air"
    "lovelace"
    "luftdaten"
    "lutron_caseta"
    "lyric"
    "mailbox"
    "manual"
    "manual_mqtt"
    "mazda"
    "media_player"
    "media_source"
    "meraki"
    "met"
    "met_eireann"
    "microsoft_face"
    "microsoft_face_detect"
    "microsoft_face_identify"
    "mikrotik"
    "min_max"
    "minecraft_server"
    "minio"
    "mobile_app"
    "modbus"
    "mold_indicator"
    "moon"
    "motioneye"
    "mqtt"
    "mqtt_eventstream"
    "mqtt_json"
    "mqtt_room"
    "mqtt_statestream"
    "mullvad"
    "mutesync"
    "my"
    "myq"
    "mysensors"
    "namecheapdns"
    "neato"
    "netatmo"
    "nexia"
    "no_ip"
    "notify"
    "notion"
    "nuki"
    "number"
    "nws"
    "nx584"
    "omnilogic"
    "onboarding"
    "ondilo_ico"
    "openalpr_cloud"
    "openalpr_local"
    "openerz"
    "openhardwaremonitor"
    "opentherm_gw"
    "openuv"
    "openweathermap"
    "opnsense"
    "ovo_energy"
    "owntracks"
    "ozw"
    "panel_custom"
    "panel_iframe"
    "persistent_notification"
    "person"
    "philips_js"
    "pi_hole"
    "picnic"
    "ping"
    "plaato"
    "plant"
    "plex"
    "plugwise"
    "poolsense"
    "profiler"
    "prometheus"
    "proximity"
    "push"
    "pushbullet"
    "pvpc_hourly_pricing"
    "python_script"
    "rachio"
    "radarr"
    "rainmachine"
    "random"
    "recollect_waste"
    "recorder"
    "reddit"
    "remote"
    "rest"
    "rest_command"
    "ring"
    "risco"
    "rituals_perfume_genie"
    "rmvtransport"
    "roku"
    "roomba"
    "rss_feed_template"
    "ruckus_unleashed"
    "safe_mode"
    "samsungtv"
    "scene"
    "screenlogic"
    "script"
    "search"
    "season"
    "sensor"
    "sentry"
    "sharkiq"
    "shell_command"
    "shelly"
    "shopping_list"
    "sigfox"
    "sighthound"
    "simplisafe"
    "simulated"
    "slack"
    "sleepiq"
    "sma"
    "smappee"
    "smartthings"
    "smarttub"
    "smhi"
    "smtp"
    "snips"
    "solaredge"
    "soma"
    "somfy"
    "sonos"
    "soundtouch"
    "spaceapi"
    "speedtestdotnet"
    "spotify"
    "sql"
    "squeezebox"
    "ssdp"
    "startca"
    "statistics"
    "statsd"
    "stream"
    "stt"
    "subaru"
    "sun"
    "surepetcare"
    "switch"
    "switcher_kis"
    "system_health"
    "system_log"
    "tado"
    "tag"
    "tasmota"
    "tcp"
    "telegram"
    "tellduslive"
    "template"
    "tesla"
    "threshold"
    "tile"
    "time_date"
    "timer"
    "tod"
    "tomato"
    "toon"
    "tplink"
    "trace"
    "transmission"
    "trend"
    "tts"
    "tuya"
    "twentemilieu"
    "twilio"
    "twinkly"
    "twitch"
    "uk_transport"
    "unifi"
    "unifi_direct"
    "universal"
    "updater"
    "upnp"
    "uptime"
    "usgs_earthquakes_feed"
    "utility_meter"
    "uvc"
    "vacuum"
    "velbus"
    "vera"
    "verisure"
    "version"
    "vesync"
    "vizio"
    "voicerss"
    "volumio"
    "vultr"
    "wake_on_lan"
    "water_heater"
    "waze_travel_time"
    "weather"
    "webhook"
    "webostv"
    "websocket_api"
    "wemo"
    "wiffi"
    "wilight"
    "wled"
    "workday"
    "worldclock"
    "wsdot"
    "wunderground"
    "xiaomi"
    "xiaomi_aqara"
    "xiaomi_miio"
    "yamaha"
    "yandex_transport"
    "yandextts"
    "yeelight"
    "zeroconf"
    "zerproc"
    "zha"
    "zodiac"
    "zone"
    "zwave"
    "zwave_js"
  ] ++ lib.optionals (builtins.any (s: s == stdenv.hostPlatform.system) debugpy.meta.platforms) [
    "debugpy"
  ];

  pytestFlagsArray = [
    # parallelize test run
    "--numprocesses auto"
    # assign tests grouped by file to workers
    "--dist loadfile"
    # retry racy tests that end in "RuntimeError: Event loop is closed"
    "--reruns 3"
    "--only-rerun RuntimeError"
    # enable full variable printing on error
    "--showlocals"
    # screenlogic/test_config_flow.py: Tries to send out UDP broadcasts
    "--deselect tests/components/screenlogic/test_config_flow.py::test_form_cannot_connect"
    # asuswrt/test_config_flow.py: Sandbox network limitations, fails with unexpected error
    "--deselect tests/components/asuswrt/test_config_flow.py::test_on_connect_failed"
    # shelly/test_config_flow.py: Tries to join multicast group
    "--deselect tests/components/shelly/test_config_flow.py::test_form"
    "--deselect tests/components/shelly/test_config_flow.py::test_title_without_name"
    "--deselect tests/components/shelly/test_config_flow.py::test_form_auth"
    "--deselect tests/components/shelly/test_config_flow.py::test_form_errors_test_connection"
    "--deselect tests/components/shelly/test_config_flow.py::test_user_setup_ignored_device"
    "--deselect tests/components/shelly/test_config_flow.py::test_form_auth_errors_test_connection"
    "--deselect tests/components/shelly/test_config_flow.py::test_form_auth_errors_test_connection"
    "--deselect tests/components/shelly/test_config_flow.py::test_form_auth_errors_test_connection"
    "--deselect tests/components/shelly/test_config_flow.py::test_zeroconf"
    "--deselect tests/components/shelly/test_config_flow.py::test_zeroconf_sleeping_device"
    "--deselect tests/components/shelly/test_config_flow.py::test_zeroconf_sleeping_device_error"
    "--deselect tests/components/shelly/test_config_flow.py::test_zeroconf_sleeping_device_error"
    "--deselect tests/components/shelly/test_config_flow.py::test_zeroconf_require_auth"
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
    # util/test_package.py: AssertionError on package.is_installed('homeassistant>=999.999.999')
    "test_check_package_version_does_not_match"
    # homeassistant/util/thread.py:51: SystemError
    "test_executor_shutdown_can_interrupt_threads"
    # {'theme_color': '#03A9F4'} != {'theme_color': 'blue'}
    "test_webhook_handle_get_config"
    # onboarding tests rpi_power component, for which we are lacking rpi_bad_power library
    "test_onboarding_core_sets_up_rpi_power"
    "test_onboarding_core_no_rpi_power"
  ];

  preCheck = ''
    export HOME="$TEMPDIR"

    # the tests require the existance of a media dir
    mkdir /build/media

    # put ping binary into PATH, e.g. for wake_on_lan tests
    export PATH=${inetutils}/bin:$PATH

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
