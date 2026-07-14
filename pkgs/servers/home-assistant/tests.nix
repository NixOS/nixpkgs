{
  lib,
  stdenv,
  home-assistant,
  writableTmpDirAsHomeHook,
}:

let
  getComponentDeps = component: home-assistant.getPackages component home-assistant.python3Packages;
  inherit (lib) concatMap;

  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python3Packages; {
    alexa = concatMap getComponentDeps [
      "cloud"
      "frontend"
      "stream"
    ];
    analytics = getComponentDeps "homeassistant_hardware";
    anthropic = getComponentDeps "ai_task" ++ getComponentDeps "openai_conversation";
    assist_pipeline = getComponentDeps "frontend";
    automation = getComponentDeps "frontend" ++ getComponentDeps "mobile_app";
    axis = getComponentDeps "deconz";
    backup = getComponentDeps "homeassistant_hardware";
    bluetooth = getComponentDeps "switchbot";
    braviatv = getComponentDeps "ssdp";
    bthome = getComponentDeps "frontend";
    camera = getComponentDeps "stream";
    deconz = getComponentDeps "frontend";
    elkm1 = getComponentDeps "frontend";
    emulated_hue = [
      defusedxml
    ];
    esphome = getComponentDeps "homeassistant_hardware";
    gardena_bluetooth = getComponentDeps "husqvarna_automower_ble";
    go2rtc = [
      tqdm
    ];
    google_assistant_sdk = getComponentDeps "frontend";
    google_drive = getComponentDeps "frontend";
    google_generative_ai_conversation = getComponentDeps "ai_task";
    govee_ble = [
      ibeacon-ble
    ];
    hassio = getComponentDeps "frontend" ++ getComponentDeps "homeassistant_yellow";
    homeassistant_connect_zbt2 = getComponentDeps "zha";
    homeassistant_hardware = getComponentDeps "otbr" ++ getComponentDeps "zha";
    homeassistant_sky_connect = getComponentDeps "zha";
    homeassistant_yellow = getComponentDeps "zha";
    homekit = getComponentDeps "frontend";
    http = concatMap getComponentDeps [
      "cloud"
      "frontend"
      "homeassistant_hardware"
    ];
    influxdb = getComponentDeps "isal";
    intelliclima = getComponentDeps "intellifire";
    logbook = getComponentDeps "alexa";
    lovelace = getComponentDeps "frontend" ++ [
      pychromecast
    ];
    lutron_caseta = getComponentDeps "frontend";
    mastodon = concatMap getComponentDeps [
      "stream"
    ];
    matter = getComponentDeps "homeassistant_hardware";
    miele = getComponentDeps "cloud";
    mobile_app = getComponentDeps "frontend";
    mopeka = getComponentDeps "switchbot";
    mqtt = getComponentDeps "homeassistant_hardware";
    nest = [
      av
    ];
    ollama = getComponentDeps "ai_task";
    onboarding = [
      pymetno
      radios
      rpi-bad-power
    ]
    ++ getComponentDeps "homeassistant_hardware"
    ++ getComponentDeps "usb";
    open_router = getComponentDeps "ai_task";
    osoenergy = [
      # loguru wants to write into HOME
      writableTmpDirAsHomeHook
    ];
    raspberry_pi = [
      rpi-bad-power
    ];
    reolink = getComponentDeps "stream";
    rss_feed_template = [
      defusedxml
    ];
    script = getComponentDeps "frontend" ++ getComponentDeps "mobile_app";
    shelly = getComponentDeps "frontend" ++ getComponentDeps "switchbot";
    songpal = [
      isal
    ];
    sonos = getComponentDeps "frontend";
    swiss_public_transport = getComponentDeps "cookidoo";
    system_log = [
      isal
    ];
    unifi_discovery = getComponentDeps "unifiprotect";
    xiaomi_miio = [
      arrow
    ];
    yolink = getComponentDeps "cloud";
    zeroconf = getComponentDeps "shelly";
    zha = getComponentDeps "deconz" ++ getComponentDeps "frontend";
    zwave_js = getComponentDeps "frontend" ++ getComponentDeps "homeassistant_hardware";
  };

  extraDisabledTestPaths = {
    ecovacs = [
      # [2026.7.2] Outdated snapshots
      "tests/components/ecovacs/test_vacuum.py::test_clean_area_room_from_not_current_map"
      "tests/components/ecovacs/test_vacuum.py::test_clean_area_no_map"
      "tests/components/ecovacs/test_vacuum.py::test_clean_area_invalid_map_id"
    ];
    izone = [
      # [2026.7.2] Failed: Description not found for placeholder `host` in component.izone.config.step.confirm.description
      "tests/components/izone/test_config_flow.py::test_not_found"
      "tests/components/izone/test_config_flow.py::test_found"
    ];
    jellyfin = [
      # AssertionError: assert 'audio/x-flac' == 'audio/flac'
      "tests/components/jellyfin/test_media_source.py::test_resolve"
      "tests/components/jellyfin/test_media_source.py::test_audio_codec_resolve"
      "tests/components/jellyfin/test_media_source.py::test_music_library"
    ];
    minecraft_server = [
      # FileNotFoundError: [Errno 2] No such file or directory: '/etc/resolv.conf'
      "tests/components/minecraft_server/test_binary_sensor.py"
      "tests/components/minecraft_server/test_diagnostics.py"
      "tests/components/minecraft_server/test_init.py"
      "tests/components/minecraft_server/test_sensor.py"
    ];
    netatmo = [
      # [2026.7.2] Language string mismatch (id vs ID)
      "tests/components/netatmo/test_media_source.py::test_async_browse_media"
    ];
    wmspro = [
      # [2026.7.2] Outdated snapshot
      "tests/components/wmspro/test_number.py::test_number_update"
    ];
    systemmonitor = [
      # sandbox doesn't grant access to /sys/class/power_supply
      "tests/components/systemmonitor/test_config_flow.py::test_add_and_remove_processes"
    ];
  };

  extraDisabledTests = {
    conversation = lib.optionals stdenv.hostPlatform.isAarch64 [
      # intent fixture mismatch on aarch64
      "test_error_no_device_on_floor"
    ];
    homeassistant_connect_zbt2 = [
      # [2026.6.1] AssertionError: assert <ConfigEntryState.LOADED: 'loaded'> is <ConfigEntryState.SETUP_RETRY: 'setup_retry'>
      "test_usb_device_reactivity"
    ];
    homeassistant = [
      # disabled via nixos-was-never-supported.patch
      "test_deprecated_installation_issue_core"
    ];
    smlight = [
      # [2026.7.1] outdated snapshot
      "test_entry_diagnostics"
    ];
    zeroconf = [
      # multicast socket bind, not possible in the sandbox
      "test_subscribe_discovery"
    ];
  };
in
lib.genAttrs home-assistant.supportedComponentsWithTests (
  component:
  home-assistant.overridePythonAttrs (old: {
    pname = "homeassistant-test-${component}";
    pyproject = false;

    dontBuild = true;
    dontInstall = true;

    nativeCheckInputs =
      old.requirementsTest
      ++ home-assistant.getPackages component home-assistant.python3Packages
      ++ extraCheckInputs.${component} or [ ];

    disabledTests = extraDisabledTests.${component} or [ ];
    disabledTestPaths = extraDisabledTestPaths.${component} or [ ];

    # components are more often racy than the core
    dontUsePytestXdist = true;

    enabledTestPaths = [ "tests/components/${component}" ];

    pytestFlags = [ "-vvv" ];

    meta = old.meta // {
      broken = lib.elem component [ ];
      # upstream only tests on Linux, so do we.
      platforms = lib.platforms.linux;
    };
  })
)
