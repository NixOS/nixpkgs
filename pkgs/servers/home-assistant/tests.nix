{
  lib,
  home-assistant,
}:

let
  getComponentDeps = component: home-assistant.getPackages component home-assistant.python.pkgs;

  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    axis = getComponentDeps "deconz";
    gardena_bluetooth = getComponentDeps "husqvarna_automower_ble";
    govee_ble = [
      ibeacon-ble
    ];
    hassio = getComponentDeps "homeassistant_yellow";
    homeassistant_hardware = getComponentDeps "otbr" ++ getComponentDeps "zha";
    homeassistant_sky_connect = getComponentDeps "zha";
    homeassistant_yellow = getComponentDeps "zha";
    husqvarna_automower_ble = getComponentDeps "gardena_bluetooth";
    lovelace = [
      pychromecast
    ];
    matrix = [
      pydantic
    ];
    mopeka = getComponentDeps "switchbot";
    onboarding = [
      pymetno
      radios
      rpi-bad-power
    ];
    raspberry_pi = [
      rpi-bad-power
    ];
    shelly = [
      pyswitchbot
    ];
    songpal = [
      isal
    ];
    swiss_public_transport = getComponentDeps "cookidoo";
    system_log = [
      isal
    ];
    tesla_fleet = getComponentDeps "teslemetry";
    xiaomi_miio = [
      arrow
    ];
    zeroconf = [
      aioshelly
    ];
    zha = [
      pydeconz
    ];
  };

  extraDisabledTestPaths = {
    overseerr = [
      # imports broken future module
      "tests/components/overseerr/test_event.py"
    ];
  };

  extraDisabledTests = {
    sensor = [
      # Failed: Translation not found for sensor
      "test_validate_unit_change_convertible"
      "test_validate_statistics_unit_change_no_device_class"
      "test_validate_statistics_state_class_removed"
      "test_validate_statistics_state_class_removed_issue_cleaned_up"
      "test_validate_statistics_unit_change_no_conversion"
      "test_validate_statistics_unit_change_equivalent_units_2"
      "test_update_statistics_issues"
      "test_validate_statistics_mean_type_changed"
    ];
    shell_command = [
      # tries to retrieve file from github
      "test_non_text_stdout_capture"
    ];
    stream = [
      # crashes with x265>=4.0
      "test_h265_video_is_hvc1"
    ];
    websocket_api = [
      # AssertionError: assert 'unknown_error' == 'template_error'
      "test_render_template_with_timeout"
    ];
    zeroconf = [
      # multicast socket bind, not possible in the sandbox
      "test_subscribe_discovery"
    ];
  };

  extraPytestFlagsArray = {
    backup = [
      # outdated snapshot
      "--deselect tests/components/backup/test_sensors.py::test_sensors"
    ];
    bmw_connected_drive = [
      # outdated snapshot
      "--deselect tests/components/bmw_connected_drive/test_binary_sensor.py::test_entity_state_attrs"
    ];
    dnsip = [
      # Tries to resolve DNS entries
      "--deselect tests/components/dnsip/test_config_flow.py::test_options_flow"
    ];
    jellyfin = [
      # AssertionError: assert 'audio/x-flac' == 'audio/flac'
      "--deselect tests/components/jellyfin/test_media_source.py::test_resolve"
      "--deselect tests/components/jellyfin/test_media_source.py::test_audio_codec_resolve"
      "--deselect tests/components/jellyfin/test_media_source.py::test_music_library"
    ];
    matter = [
      # outdated snapshot in eve_weather_sensor variant
      "--deselect tests/components/matter/test_number.py::test_numbers"
    ];
    modem_callerid = [
      # aioserial mock produces wrong state
      "--deselect tests/components/modem_callerid/test_init.py::test_setup_entry"
    ];
    openai_conversation = [
      # outdated snapshot
      "--deselect tests/components/openai_conversation/test_conversation.py::test_function_call"
    ];
    technove = [
      # outdated snapshot
      "--deselect tests/components/technove/test_switch.py::test_switches"
    ];
  };
in
lib.listToAttrs (
  map (
    component:
    lib.nameValuePair component (
      home-assistant.overridePythonAttrs (old: {
        pname = "homeassistant-test-${component}";
        pyproject = null;
        format = "other";

        dontBuild = true;
        dontInstall = true;

        nativeCheckInputs =
          old.nativeCheckInputs
          ++ home-assistant.getPackages component home-assistant.python.pkgs
          ++ extraCheckInputs.${component} or [ ];

        disabledTests = old.disabledTests or [ ] ++ extraDisabledTests.${component} or [ ];
        disabledTestPaths = old.disabledTestPaths or [ ] ++ extraDisabledTestPaths.${component} or [ ];

        # components are more often racy than the core
        dontUsePytestXdist = true;

        pytestFlagsArray =
          lib.remove "tests" old.pytestFlagsArray
          ++ extraPytestFlagsArray.${component} or [ ]
          ++ [ "tests/components/${component}" ];

        meta = old.meta // {
          broken = lib.elem component [ ];
          # upstream only tests on Linux, so do we.
          platforms = lib.platforms.linux;
        };
      })
    )
  ) home-assistant.supportedComponentsWithTests
)
