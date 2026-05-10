{
  lib,
  stdenv,
  home-assistant,
}:

let
  getComponentDeps = component: home-assistant.getPackages component home-assistant.python.pkgs;

  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    alexa = map getComponentDeps [
      "cloud"
      "frontend"
      "stream"
    ];
    anthropic = getComponentDeps "ai_task" ++ getComponentDeps "openai_conversation";
    assist_pipeline = getComponentDeps "frontend";
    automation = getComponentDeps "frontend" ++ getComponentDeps "mobile_app";
    axis = getComponentDeps "deconz";
    bluetooth = getComponentDeps "switchbot";
    braviatv = getComponentDeps "ssdp";
    bthome = getComponentDeps "frontend";
    camera = getComponentDeps "stream";
    deconz = getComponentDeps "frontend";
    elkm1 = getComponentDeps "frontend";
    emulated_hue = [
      defusedxml
    ];
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
    http = getComponentDeps "cloud" ++ getComponentDeps "frontend";
    intelliclima = getComponentDeps "intellifire";
    logbook = getComponentDeps "alexa";
    lovelace = getComponentDeps "frontend" ++ [
      pychromecast
    ];
    lutron_caseta = getComponentDeps "frontend";
    mastodon = map getComponentDeps [
      "stream"
    ];
    miele = getComponentDeps "cloud";
    mobile_app = getComponentDeps "frontend";
    mopeka = getComponentDeps "switchbot";
    nest = [
      av
    ];
    ollama = getComponentDeps "ai_task";
    onboarding = [
      pymetno
      radios
      rpi-bad-power
    ];
    open_router = getComponentDeps "ai_task";
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
    zwave_js = getComponentDeps "frontend";
  };

  extraDisabledTestPaths = {
    influxdb = [
      # These tests fail because they check for the number of warnings in the
      # logs and there is an extra warning in the logs:
      # `WARNING:aiohttp_fast_zlib:zlib_ng and isal are not available, falling back to zlib, performance will be degraded.`
      "tests/components/influxdb/test_sensor.py::test_state_for_no_results"
      "tests/components/influxdb/test_sensor.py::test_state_matches_first_query_result_for_multiple_return"
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
    overseerr = [
      # imports broken future module
      "tests/components/overseerr/test_event.py"
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
    ecovacs = [
      # Translation not found for vacuum
      "test_raise_segment_changed_issue"
    ];
    homeassistant_sky_connect = [
      # 2026.5.0: after reload device is in loaded state instead of retry state
      "test_usb_device_reactivity"
    ];
    homeassistant_connect_zbt2 = [
      # 2026.5.0: after reload device is in loaded state instead of retry state
      "test_usb_device_reactivity"
    ];
    zeroconf = [
      # multicast socket bind, not possible in the sandbox
      "test_subscribe_discovery"
    ];
  };
in
lib.listToAttrs (
  map (
    component:
    lib.nameValuePair component (
      home-assistant.overridePythonAttrs (old: {
        pname = "homeassistant-test-${component}";
        pyproject = false;

        dontBuild = true;
        dontInstall = true;

        nativeCheckInputs =
          old.requirementsTest
          ++ home-assistant.getPackages component home-assistant.python.pkgs
          ++ extraCheckInputs.${component} or [ ];

        disabledTests = extraDisabledTests.${component} or [ ];
        disabledTestPaths = extraDisabledTestPaths.${component} or [ ];

        # components are more often racy than the core
        dontUsePytestXdist = true;

        enabledTestPaths = [ "tests/components/${component}" ];

        meta = old.meta // {
          broken = lib.elem component [ ];
          # upstream only tests on Linux, so do we.
          platforms = lib.platforms.linux;
        };
      })
    )
  ) home-assistant.supportedComponentsWithTests
)
