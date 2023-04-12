{ lib
, home-assistant
}:

let
  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
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
    vesync = [
      # homeassistant.components.vesync:config_validation.py:863 The 'vesync' option has been removed, please remove it from your configuration
      "test_async_get_config_entry_diagnostics__single_humidifier"
      "test_async_get_device_diagnostics__single_fan"
    ];
  };

  extraPytestFlagsArray = {
    dnsip = [
      # Tries to resolve DNS entries
      "--deselect tests/components/dnsip/test_config_flow.py::test_options_flow"
    ];
    history_stats = [
      # Flaky: AssertionError: assert '0.0' == '12.0'
      "--deselect tests/components/history_stats/test_sensor.py::test_end_time_with_microseconds_zeroed"
    ];
    modbus = [
      # homeassistant.components.modbus.modbus:modbus.py:317 Pymodbus: modbusTest: Modbus Error: test connect exception
      "--deselect tests/components/modbus/test_init.py::test_pymodbus_connect_fail"
    ];
    modem_callerid = [
      # aioserial mock produces wrong state
      "--deselect tests/components/modem_callerid/test_init.py::test_setup_entry"
    ];
    unifiprotect = [
      # "TypeError: object Mock can't be used in 'await' expression
      "--deselect tests/components/unifiprotect/test_repairs.py::test_ea_warning_fix"
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
      ++ [ "--numprocesses=2" ]
      ++ extraPytestFlagsArray.${component} or [ ]
      ++ [ "tests/components/${component}" ];

    preCheck = old.preCheck + lib.optionalString (builtins.elem component [ "emulated_hue" "songpal" "system_log" ]) ''
      patch -p1 < ${./patches/tests-mock-source-ip.patch}
    '';

    meta = old.meta // {
      broken = lib.elem component [
      ];
      # upstream only tests on Linux, so do we.
      platforms = lib.platforms.linux;
    };
  })
)) home-assistant.supportedComponentsWithTests)
