{ lib
, home-assistant
}:

let
  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    airzone_cloud = [ aioairzone ];
    alexa = [ av ];
    bluetooth = [ pyswitchbot ];
    bthome = [ xiaomi-ble ];
    camera = [ av ];
    cloud = [ mutagen ];
    config = [ pydispatcher ];
    generic = [ av ];
    google_translate = [ mutagen ];
    google_sheets = [ oauth2client ];
    govee_ble = [ ibeacon-ble ];
    hassio = [ bellows zha-quirks zigpy-deconz zigpy-xbee zigpy-zigate zigpy-znp ];
    homeassistant_sky_connect = [ bellows zha-quirks zigpy-deconz zigpy-xbee zigpy-zigate zigpy-znp zwave-js-server-python ];
    homeassistant_yellow = [ bellows zha-quirks zigpy-deconz zigpy-xbee zigpy-zigate zigpy-znp ];
    lovelace = [ pychromecast ];
    matrix = [ pydantic ];
    mopeka = [ pyswitchbot ];
    nest = [ av ];
    onboarding = [ pymetno radios rpi-bad-power ];
    otbr = [ bellows zha-quirks zigpy-deconz zigpy-xbee zigpy-zigate zigpy-znp ];
    raspberry_pi = [ rpi-bad-power ];
    shelly = [ pyswitchbot ];
    tilt_ble = [ govee-ble ibeacon-ble ];
    tomorrowio = [ pyclimacell ];
    version = [ aioaseko ];
    xiaomi_miio = [ arrow ];
    voicerss = [ mutagen ];
    yandextts = [ mutagen ];
    zha = [ pydeconz ];
    zwave_js = [ homeassistant-pyozw ];
  };

  extraDisabledTestPaths = {
  };

  extraDisabledTests = {
    mqtt = [
      # Assert None is not None
      "test_handle_logging_on_writing_the_entity_state"
    ];
    shell_command = [
      # tries to retrieve file from github
      "test_non_text_stdout_capture"
    ];
    sma = [
      # missing operating_status attribute in entity
      "test_sensor_entities"
    ];
    vesync = [
      # homeassistant.components.vesync:config_validation.py:863 The 'vesync' option has been removed, please remove it from your configuration
      "test_async_get_config_entry_diagnostics__single_humidifier"
      "test_async_get_device_diagnostics__single_fan"
    ];
  };

  extraPytestFlagsArray = {
    conversation = [
      "--deselect tests/components/conversation/test_init.py::test_get_agent_list"
    ];
    dnsip = [
      # Tries to resolve DNS entries
      "--deselect tests/components/dnsip/test_config_flow.py::test_options_flow"
    ];
    history_stats = [
      # Flaky: AssertionError: assert '0.0' == '12.0'
      "--deselect tests/components/history_stats/test_sensor.py::test_end_time_with_microseconds_zeroed"
    ];
    jellyfin = [
      # AssertionError: assert 'audio/x-flac' == 'audio/flac'
      "--deselect tests/components/jellyfin/test_media_source.py::test_resolve"
      # AssertionError: assert [+ received] == [- snapshot]
      "--deselect tests/components/jellyfin/test_media_source.py::test_music_library"
    ];
    modbus = [
      # homeassistant.components.modbus.modbus:modbus.py:317 Pymodbus: modbusTest: Modbus Error: test connect exception
      "--deselect tests/components/modbus/test_init.py::test_pymodbus_connect_fail"
    ];
    modem_callerid = [
      # aioserial mock produces wrong state
      "--deselect tests/components/modem_callerid/test_init.py::test_setup_entry"
    ];
    sonos = [
      # KeyError: 'sonos_media_player'
      "--deselect tests/components/sonos/test_init.py::test_async_poll_manual_hosts_warnings"
      "--deselect tests/components/sonos/test_init.py::test_async_poll_manual_hosts_3"
    ];
    unifiprotect = [
      # "TypeError: object Mock can't be used in 'await' expression
      "--deselect tests/components/unifiprotect/test_repairs.py::test_ea_warning_fix"
    ];
    xiaomi_ble = [
      # assert 0 == 1"
      "--deselect tests/components/xiaomi_ble/test_sensor.py::test_xiaomi_consumable"
    ];
    zha = [
      "--deselect tests/components/zha/test_config_flow.py::test_formation_strategy_restore_manual_backup_non_ezsp"
      "--deselect tests/components/zha/test_config_flow.py::test_formation_strategy_restore_automatic_backup_non_ezsp"
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
      ];
      # upstream only tests on Linux, so do we.
      platforms = lib.platforms.linux;
    };
  })
)) home-assistant.supportedComponentsWithTests)
