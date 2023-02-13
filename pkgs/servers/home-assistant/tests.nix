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
    lovelace = [ PyChromecast ];
    nest = [ av ];
    onboarding = [ pymetno radios rpi-bad-power ];
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
    roku = [
      # homeassistant.components.roku.media_player:media_player.py:428 Media type music is not supported with format None (mime: audio/x-matroska)
      "test_services_play_media_audio"
    ];
  };

  extraPytestFlagsArray = {
    dnsip = [
      # AssertionError: assert <FlowResultType.FORM: 'form'> == <FlowResultTy...create_entry'>
      "--deselect tests/components/dnsip/test_config_flow.py::test_options_flow"
    ];
    history_stats = [
      # Flaky: AssertionError: assert '0.0' == '12.0'
      "--deselect tests/components/history_stats/test_sensor.py::test_end_time_with_microseconds_zeroed"
    ];
    logbook = [
      "--deselect tests/components/logbook/test_websocket_api.py::test_recorder_is_far_behind "
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
      ++ [ "--numprocesses=4" ]
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
