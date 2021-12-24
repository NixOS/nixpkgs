{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, python3
, substituteAll
, ffmpeg
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
    # aiounify 29 breaks integration tests
    (self: super: {
      aiounifi = super.aiounifi.overridePythonAttrs (oldAttrs: rec {
        version = "28";
        src = fetchFromGitHub {
          owner = "Kane610";
          repo = "aiounifi";
          rev = "v${version}";
          sha256 = "1r86pk80sa1la2s7c6v9svh5cpkci6jcw1xziz0h09jdvv5j5iff";
        };
      });
    })

    # Override the version of some packages pinned in Home Assistant's setup.py and requirements_all.txt
    (mkOverride "python-slugify" "4.0.1" "69a517766e00c1268e5bbfc0d010a0a8508de0b18d30ad5a1ff357f8ae724270")

    (self: super: {
      httpcore = super.httpcore.overridePythonAttrs (oldAttrs: rec {
        version = "0.14.3";
        src = fetchFromGitHub {
          owner = "encode";
          repo = "httpcore";
          rev = version;
          sha256 = "sha256-jPsbMhY1lWKBXlh6hsX6DGKXi/g7VQSU00tF6H7qkOo=";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.certifi ];
        doCheck = false;
      });
    })

    (self: super: {
      httpx = super.httpx.overridePythonAttrs (oldAttrs: rec {
        version = "0.21.1";
        src = fetchFromGitHub {
          owner = "encode";
          repo = "httpx";
          rev = version;
          sha256 = "sha256-ayhLP+1hPWAx2ds227CKp5cebVkD5B2Z59L+3dzdINc=";
        };
        doCheck = false;
      });
    })

    (self: super: {
      pytest-httpx = super.pytest-httpx.overridePythonAttrs (oldAttrs: rec {
        version = "0.15.0";
        src = fetchFromGitHub {
          owner = "Colin-bin";
          repo = "pytest_httpx";
          rev = "v${version}";
          sha256 = "08dxvjkxlnam3r0yp17495d1vksyawzzkpykacjql1gi6hqlfrwg";
        };
      });
    })

    (self: super: {
      respx = super.respx.overridePythonAttrs (oldAttrs: rec {
        version = "0.19.0";
        src = fetchFromGitHub {
          owner = "lundberg";
          repo = "respx";
          rev = version;
          sha256 = "sha256-xiAt42kc1+rro99KMwzYKi3XC+wxYVqOY11tM+M/uV8=";
        };
      });
    })

    (self: super: {
      envoy-reader = super.envoy-reader.overridePythonAttrs (oldAttrs: rec {
        patches = [
          # Support for later httpx, https://github.com/jesserizzo/envoy_reader/pull/82
          (fetchpatch {
            name = "support-later-httpx.patch";
            url = "https://github.com/jesserizzo/envoy_reader/commit/6019a89419fe9c830ba839be7d39ec54725268b0.patch";
            sha256 = "17vsrx13rskvh8swvjisb2dk6x1jdbjcm8ikkpidia35pa24h272";
          })
        ];
      });
    })

    (self: super: {
      sanic = super.sanic.overridePythonAttrs (oldAttrs: rec {
        version = "21.9.3";
        src = fetchFromGitHub {
          owner = "sanic-org";
          repo = "sanic";
          rev = "v${version}";
          sha256 = "0m18jdw1mvf7jhpnrxhm96p24pxvv0h9m71a8c7sqqkwnnpa3p5i";
        };
        disabledTests = oldAttrs.disabledTests ++ [
          "test_redirect"
          "test_chained_redirect"
          "test_unix_connection"
        ];
      });
    })

    (self: super: {
      huawei-lte-api = super.huawei-lte-api.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.18";
        src = fetchFromGitHub {
          owner = "Salamek";
          repo = "huawei-lte-api";
          rev = version;
          sha256 = "1qaqxmh03j10wa9wqbwgc5r3ays8wfr7bldvsm45fycr3qfyn5fg";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.dicttoxml ];
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

    # Pinned due to API changes in influxdb-client>1.21.0
    (self: super: {
      influxdb-client = super.influxdb-client.overridePythonAttrs (oldAttrs: rec {
        version = "1.21.0";
        src = fetchFromGitHub {
          owner = "influxdata";
          repo = "influxdb-client-python";
          rev = "v${version}";
          sha256 = "081pwd3aa7kbgxqcl1hfi2ny4iapnxkcp9ypsfslr69d0khvfc4s";
        };
      });
    })

    (mkOverride "jinja2" "3.0.3" "1mvwr02s86zck5wsmd9wjxxb9iaqr17hdi5xza9vkwv8rmrv46v1")

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

    # Pinned due to API changes in 0.1.0
    (mkOverride "poolsense" "0.0.8" "09y4fq0gdvgkfsykpxnvmfv92dpbknnq5v82spz43ak6hjnhgcyp")

    # Pinned due to API changes in 0.4.0
    (self: super: {
      vilfo-api-client = super.vilfo-api-client.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.3";
        src = fetchFromGitHub {
          owner = "ManneW";
          repo = "vilfo-api-client-python";
          rev = "v$version}";
          sha256 = "1gy5gpsg99rcm1cc3m30232za00r9i46sp74zpd12p3vzz1wyyqf";
        };
      });
    })

    # Pinned due to API changes ~1.0
    (self: super: {
      vultr = super.vultr.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.2";
        src = fetchFromGitHub {
          owner = "spry-group";
          repo = "python-vultr";
          rev = "v${version}";
          sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
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
  hassVersion = "2021.12.5";

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
    hash = "sha256:116qklmzvqh3hn3i6i7lvsnqydd2qclk612rwlxs3v56kzpks62n";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    (substituteAll {
      src = ./patches/ffmpeg-path.patch;
      ffmpeg = "${lib.getBin ffmpeg}/bin/ffmpeg";
    })
    ./patches/tests-ignore-OSErrors-in-hass-fixture.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp==3.8.1" "aiohttp" \
      --replace "async_timeout==4.0.0" "async_timeout" \
      --replace "bcrypt==3.1.7" "bcrypt" \
      --replace "cryptography==35.0.0" "cryptography" \
      --replace "httpx==0.21.0" "httpx" \
      --replace "pip>=8.0.3,<20.3" "pip" \
      --replace "pyyaml==6.0" "pyyaml" \
      --replace "yarl==1.6.3" "yarl"
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'
  '';

  propagatedBuildInputs = [
    # Only packages required in setup.py
    aiohttp
    astral
    async-timeout
    atomicwrites
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
    ruamel-yaml
    voluptuous
    voluptuous-serialize
    yarl
    # Not in setup.py, but used in homeassistant/util/package.py
    setuptools
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ] ++ componentBuildInputs ++ extraBuildInputs;

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = [
    # test infrastructure (selectively from requirement_test.txt)
    freezegun
    pytest-aiohttp
    pytest-freezegun
    pytest-mock
    pytest-rerunfailures
    pytest-socket
    pytest-xdist
    pytestCheckHook
    requests-mock
    stdlib-list
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
    "airthings"
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
    "eafm"
    "ecobee"
    "econet"
    "ee_brightbox"
    "efergy"
    "elgato"
    "elkm1"
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
    "fjaraskupan"
    "flick_electric"
    "flipr"
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
    # updated to incompatible version and overriding is annoying because of async_timeout<4 pin
    # "glances"
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
    "hisense_aehw4a1"
    "history"
    "history_stats"
    "hive"
    "hlk_sw16"
    "home_connect"
    "home_plus_control"
    "homeassistant"
    # disable homekit tests because they fail in the network component
    #"homekit"
    "homekit_controller"
    "homematic"
    "homematicip_cloud"
    "honeywell"
    "html5"
    "http"
    "huawei_lte"
    "hue"
    "huisbaasje"
    "humidifier"
    "hunterdouglas_powerview"
    "hvv_departures"
    "hyperion"
    "ialarm"
    "iaqualink"
    "icloud"
    "ifttt"
    "ign_sismologia"
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
    "isy994"
    "izone"
    "jewish_calendar"
    "juicenet"
    "keenetic_ndms2"
    "kira"
    "kmtronic"
    "knx"
    "kodi"
    "konnected"
    "kraken"
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
    "maxcube"
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
    "motion_blinds"
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
    "mythicbeastsdns"
    "nam"
    "namecheapdns"
    "neato"
    "ness_alarm"
    # python-nest has an unfree license, this prevents builds through ofborg
    # "nest"
    "netatmo"
    "nexia"
    "nightscout"
    "no_ip"
    "notify"
    "notion"
    "nsw_rural_fire_service_feed"
    "nuki"
    "number"
    "nws"
    "nx584"
    "octoprint"
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
    "p1_monitor"
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
    "point"
    "poolsense"
    "profiler"
    "prometheus"
    "proximity"
    "push"
    "pushbullet"
    "pvpc_hourly_pricing"
    "python_script"
    "qld_bushfire"
    "rachio"
    "radarr"
    "rainmachine"
    "random"
    "recollect_waste"
    "recorder"
    "reddit"
    "remote"
    "renault"
    "rest"
    "rest_command"
    "rflink"
    "rfxtrx"
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
    "sia"
    "sigfox"
    "sighthound"
    "simplisafe"
    "simulated"
    "slack"
    "sleepiq"
    "sma"
    "smappee"
    "smart_meter_texas"
    "smarthab"
    "smartthings"
    "smarttub"
    "smhi"
    "smtp"
    "snips"
    "solaredge"
    "soma"
    "somfy"
    "somfy_mylink"
    "sonarr"
    "songpal"
    # disable sonos components test because they rely on ssdp, which doesn't work in our sandbox
    # "sonos"
    "soundtouch"
    "spaceapi"
    "spc"
    "speedtestdotnet"
    "spider"
    "spotify"
    "sql"
    "squeezebox"
    "srp_energy"
    "ssdp"
    "starline"
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
    "syncthing"
    "syncthru"
    "synology_dsm"
    "system_health"
    "system_log"
    "tado"
    "tag"
    "tasmota"
    "tcp"
    "telegram"
    "tellduslive"
    "template"
    "threshold"
    "tibber"
    "tile"
    "time_date"
    "timer"
    "tod"
    "tomato"
    "toon"
    "totalconnect"
    "tplink"
    "traccar"
    "trace"
    "tradfri"
    "transmission"
    "transport_nsw"
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
    "upb"
    "upcloud"
    "updater"
    # disabled, because it tries to join a multicast group and fails to find a usable network interface
    # "upnp"
    "uptime"
    "uptimerobot"
    "usgs_earthquakes_feed"
    "utility_meter"
    "uvc"
    "vacuum"
    "velbus"
    # disabled, because it includes onewire component tests, for which we lack p1wire dependency
    # "venstar"
    "vera"
    "verisure"
    "version"
    "vesync"
    "vilfo"
    "vizio"
    "vlc_telnet"
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
    "xbox"
    "xiaomi"
    "xiaomi_aqara"
    # disabled, because we require cryptography>=35.0 for the miio package
    # "xiaomi_miio"
    "yamaha"
    "yandex_transport"
    "yandextts"
    "yeelight"
    "youless"
    # disabled, because it tries to join a multicast group and fails to find a usable network interface
    # "zeroconf"
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
    "--numprocesses $NIX_BUILD_CORES"
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
    # default_config/test_init.py: Tries to check for updates and fails ungracefully without network access
    "--deselect tests/components/default_config/test_init.py::test_setup"
    # local_ip/test_{init,config_flow}.py: tries to lookup a route towards a multicast address and fails
    "--deselect tests/components/local_ip/test_init.py::test_basic_setup"
    "--deselect tests/components/local_ip/test_config_flow.py::test_config_flow"
    # netatmo/test_select.py: NoneType object has no attribute state
    "--deselect tests/components/netatmo/test_select.py::test_select_schedule_thermostats"
    # wemo/test_sensor.py: KeyError for various power attributes
    "--deselect tests/components/wemo/test_sensor.py::TestInsightTodayEnergy::test_state_unavailable"
    "--deselect tests/components/wemo/test_sensor.py::TestInsightCurrentPower::test_state_unavailable"
    # helpers/test_system_info.py: AssertionError: assert 'Unknown' == 'Home Assistant Container'
    "--deselect tests/helpers/test_system_info.py::test_container_installationtype"
    # tests are located in tests/
    "tests"
    # dynamically add packages required for component tests
  ] ++ map (component: "tests/components/" + component) componentTests;

  disabledTestPaths = [
    # don't bulk test all components
    "tests/components"
    # pyotp since v2.4.0 complains about the short mock keys, hass pins v2.3.0
    "tests/auth/mfa_modules/test_notify.py"
    # emulated_hue/test_upnp.py: Tries to establish the public ipv4 address
    "tests/components/emulated_hue/test_upnp.py"
    # tado/test_{climate,water_heater}.py: Tries to connect to my.tado.com
    "tests/components/tado/test_climate.py"
    "tests/components/tado/test_water_heater.py"
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
    # august/test_lock.py: AssertionError: assert 'unlocked' == 'locked' / assert 'off' == 'on'
    "test_lock_update_via_pubnub"
    "test_door_sense_update_via_pubnub"
  ];

  preCheck = ''
    export HOME="$TEMPDIR"

    patch -p1 < ${./patches/tests-mock-source-ip.patch}

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
    inherit availableComponents extraComponents;
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
