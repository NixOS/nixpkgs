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
    # Override the version of some packages pinned in Home Assistant's setup.py and requirements_all.txt

    # https://github.com/NixOS/nixpkgs/pull/125414
    (mkOverride "flask" "2.0.1" "0mcgwq7b4qd99mf5bsvs3wphchxarf8kgil4hwww3blj31xjak0w")
    (mkOverride "itsdangerous" "2.0.1" "1w6gfb2zhbcmrfj6digwzw1z68w6zg1q87rm6la2m412zil4swly")
    (mkOverride "jinja2" "3.0.1" "197ms1wimxql650245v63wkv04n8bicj549wfhp51bx68x5lhgvh")
    (mkOverride "markupsafe" "2.0.1" "02k2ynmqvvd0z0gakkf8s4idyb606r7zgga41jrkhqmigy06fk2r")
    (self: super: {
      werkzeug = super.werkzeug.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0hlwawnn8c41f254qify5jnjj8xb97n294h09bqimzqhs0qdpq8x";
        };
        checkInputs = oldAttrs.checkInputs ++ [ python3.pkgs.pytest-xprocess ];
        pytestFlagsArray = [ "-m 'not filterwarnings'" ];
      });
    })
    (mkOverride "flask-restful" "0.3.9" "0gm5dz088v3d2k1dkcp9b3nnqpkk0fp2jly870hijj2xhc5nbv6c")
    (self: super: {
      debugpy = super.debugpy.overridePythonAttrs (oldAttrs: rec {
        # tests fail with flask/werkezug>=2.0
        doCheck = false;
      });
    })

    # Pinned due to API changes in iaqualink>=2.0, remove after
    # https://github.com/home-assistant/core/pull/48137 was merged
    (self: super: {
      iaqualink = super.iaqualink.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.90";
        src = fetchFromGitHub {
          owner = "flz";
          repo = "iaqualink-py";
          rev = "v${version}";
          sha256 = "0c8ckbbr1n8gx5k63ymgyfkbz3d0rbdvghg8fqdvbg4nrigrs5v0";
        };
        checkInputs = oldAttrs.checkInputs ++ [ python3.pkgs.asynctest ];
      });
    })

    # Pinned due to API changes in pyjwt>=2.0
    (self: super: {
      pyjwt = super.pyjwt.overridePythonAttrs (oldAttrs: rec {
        version = "1.7.1";
        src = oldAttrs.src.override {
          inherit version;
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

    # Pinned due to API changes in eebrightbox>=0.0.5
    (self: super: {
      eebrightbox = super.eebrightbox.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.4";
        src = fetchFromGitHub {
          owner = "krygal";
          repo = "eebrightbox";
          rev = version;
          sha256 = "0d8mmpwgrd7gymw5263r1v2wjv6dx6w6pq13d62fkfm4h2hya4a4";
        };
      });
    })

    # home-assistant-frontend does not exist in python3.pkgs
    (self: super: {
      home-assistant-frontend = self.callPackage ./frontend.nix { };
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
  hassVersion = "2021.6.5";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = pythonOlder "3.8";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = version;
    sha256 = "1cp294hy35k9hjbp8iqmaf1m5qbbkh3jwf92ym49waw8di5a5wvh";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "attrs==21.2.0" "attrs" \
      --replace "awesomeversion==21.4.0" "awesomeversion" \
      --replace "bcrypt==3.1.7" "bcrypt" \
      --replace "cryptography==3.3.2" "cryptography" \
      --replace "pip>=8.0.3,<20.3" "pip" \
      --replace "ruamel.yaml==0.15.100" "ruamel.yaml"
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'
  '';

  propagatedBuildInputs = [
    # Only packages required in setup.py
    aiohttp
    astral
    async-timeout
    attrs
    awesomeversion
    bcrypt
    certifi
    ciso8601
    cryptography
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
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
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
    "aemet"
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
    "aprs"
    "arcam_fmj"
    "arlo"
    "asuswrt"
    "atag"
    "august"
    "aurora"
    "auth"
    "automation"
    "awair"
    "aws"
    "axis"
    "azure_devops"
    "azure_event_hub"
    "bayesian"
    "binary_sensor"
    "blackbird"
    "blebox"
    "blink"
    "blueprint"
    "bluetooth_le_tracker"
    "bmw_connected_drive"
    "bond"
    "bosch_shc"
    "braviatv"
    "broadlink"
    "brother"
    "bsblan"
    "buienradar"
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
    "color_extractor"
    "comfoconnect"
    "command_line"
    "compensation"
    "config"
    "configurator"
    "control4"
    "conversation"
    "coolmaster"
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
    "directv"
    "discovery"
    "doorbird"
    "dsmr"
    "dte_energy_bridge"
    "duckdns"
    "dunehd"
    "dyson"
    "eafm"
    "ecobee"
    "econet"
    "ee_brightbox"
    "efergy"
    "elgato"
    "emonitor"
    "emulated_hue"
    "emulated_kasa"
    "emulated_roku"
    "enocean"
    "enphase_envoy"
    "epson"
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
    "fireservicerota"
    "firmata"
    "flick_electric"
    "flo"
    "flume"
    "flunearyou"
    "flux"
    "folder"
    "folder_watcher"
    "foobot"
    "foscam"
    "freebox"
    "freedns"
    "fritz"
    "fritzbox"
    "fritzbox_callmonitor"
    "frontend"
    "garages_amsterdam"
    "garmin_connect"
    "gdacs"
    "generic"
    "generic_thermostat"
    "geo_json_events"
    "geo_location"
    "geo_rss_events"
    "geofency"
    "geonetnz_quakes"
    "geonetnz_volcano"
    "gios"
    "glances"
    "goalzero"
    "gogogate2"
    "google"
    "google_assistant"
    "google_domains"
    "google_pubsub"
    "google_translate"
    "google_travel_time"
    "google_wifi"
    "gpslogger"
    "graphite"
    "gree"
    "group"
    "growatt_server"
    "guardian"
    "habitica"
    "hangouts"
    "harmony"
    "hassio"
    "hddtemp"
    "heos"
    "here_travel_time"
    "history"
    "history_stats"
    "hive"
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
    "ipma"
    "ipp"
    "iqvia"
    "islamic_prayer_times"
    "jewish_calendar"
    "kira"
    "kmtronic"
    "knx"
    "kodi"
    "kulersky"
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
    "meteoclimatic"
    "mhz19"
    "microsoft_face"
    "microsoft_face_detect"
    "microsoft_face_identify"
    "mikrotik"
    "mill"
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
    "nam"
    "namecheapdns"
    "neato"
    "netatmo"
    "nexia"
    "no_ip"
    "notify"
    "notion"
    "nsw_rural_fire_service_feed"
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
    "roon"
    "rss_feed_template"
    "ruckus_unleashed"
    "safe_mode"
    "samsungtv"
    "scene"
    "screenlogic"
    "script"
    "search"
    "season"
    "sense"
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
    "spider"
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
    "tibber"
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
    "venstar"
    "vera"
    "verisure"
    "version"
    "vesync"
    "vizio"
    "voicerss"
    "volumio"
    "vultr"
    "wake_on_lan"
    "wallbox"
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
    "xbox"
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
    # here_travel_time/test_sensor.py: Tries to access HERE API: herepy.error.HEREError: Error occured on __get
    "--deselect tests/components/here_travel_time/test_sensor.py::test_invalid_credentials"
    # screenlogic/test_config_flow.py: Tries to send out UDP broadcasts
    "--deselect tests/components/screenlogic/test_config_flow.py::test_form_cannot_connect"
    # abode/test_camera.py: Race condition in pickle file creationg
    "--deselect tests/components/abode/test_camera.py::test_camera_off"
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
    # prometheus/test_init.py: Spurious AssertionError regarding humidifier_target_humidity_percent metric
    "--deselect tests/components/prometheus/test_init.py::test_view"
    # smhi/test_init.py: Tries to fetch data from the network: socket.gaierror: [Errno -2] Name or service not known
    "--deselect tests/components/smhi/test_init.py::test_remove_entry"
    # wallbox/test_config_flow.py: Tries to connect to api.wall-box.cim: Failed to establish a new connection: [Errno -2] Name or service not known
    "--deselect tests/components/wallbox/test_config_flow.py::test_form_invalid_auth"
    "--deselect tests/components/wallbox/test_config_flow.py::test_form_cannot_connect"
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
    # hue/test_sensor_base.py: Race condition when counting events
    "test_hue_events"
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
    inherit availableComponents;
    python = py;
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
