{ lib
, home-assistant
}:

let
  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    airzone_cloud = [
      aioairzone
    ];
    bluetooth = [
      pyswitchbot
    ];
    govee_ble = [
      ibeacon-ble
    ];
    lovelace = [
      pychromecast
    ];
    matrix = [
      pydantic
    ];
    mopeka = [
      pyswitchbot
    ];
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
    tilt_ble = [
      ibeacon-ble
    ];
    xiaomi_miio = [
      arrow
    ];
    zha = [
      pydeconz
    ];
  };

  extraDisabledTestPaths = {
  };

  extraDisabledTests = {
    private_ble_device = [
      # AssertionError: assert '90' == '90.0'
      "test_estimated_broadcast_interval"
    ];
    shell_command = [
      # tries to retrieve file from github
      "test_non_text_stdout_capture"
    ];
    sma = [
      # missing operating_status attribute in entity
      "test_sensor_entities"
    ];
  };

  extraPytestFlagsArray = {
    cloud = [
      # Tries to connect to alexa-api.nabucasa.com:443
      "--deselect tests/components/cloud/test_http_api.py::test_websocket_update_preferences_alexa_report_state"
    ];
    dnsip = [
      # Tries to resolve DNS entries
      "--deselect tests/components/dnsip/test_config_flow.py::test_options_flow"
    ];
    jellyfin = [
      # AssertionError: assert 'audio/x-flac' == 'audio/flac'
      "--deselect tests/components/jellyfin/test_media_source.py::test_resolve"
      # AssertionError: assert [+ received] == [- snapshot]
      "--deselect tests/components/jellyfin/test_media_source.py::test_music_library"
    ];
    modem_callerid = [
      # aioserial mock produces wrong state
      "--deselect tests/components/modem_callerid/test_init.py::test_setup_entry"
    ];
  };
in lib.listToAttrs (map (component: lib.nameValuePair component (
  home-assistant.overridePythonAttrs (old: {
    pname = "homeassistant-test-${component}";
    format = "other";

    dontBuild = true;
    dontInstall = true;

    nativeCheckInputs = old.nativeCheckInputs
      ++ home-assistant.getPackages component home-assistant.python.pkgs
      ++ extraCheckInputs.${component} or [ ];

    disabledTests = old.disabledTests or [] ++ extraDisabledTests.${component} or [];
    disabledTestPaths = old.disabledTestPaths or [] ++ extraDisabledTestPaths.${component} or [ ];

    # components are more often racy than the core
    dontUsePytestXdist = true;

    pytestFlagsArray = lib.remove "tests" old.pytestFlagsArray
      ++ extraPytestFlagsArray.${component} or [ ]
      ++ [ "tests/components/${component}" ];

    preCheck = old.preCheck + lib.optionalString (builtins.elem component [ "emulated_hue" "songpal" "system_log" ]) ''
      patch -p1 < ${./patches/tests-mock-source-ip.patch}
    '';

    meta = old.meta // {
      broken = lib.elem component [
        # pinned version incompatible with urllib3>=2.0
        "telegram_bot"
        # depends on telegram_bot
        "telegram"
      ];
      # upstream only tests on Linux, so do we.
      platforms = lib.platforms.linux;
    };
  })
)) home-assistant.supportedComponentsWithTests)
