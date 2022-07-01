{ lib
, home-assistant
}:

let
  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    alexa = [ av ];
    camera = [ av ];
    cloud = [ mutagen ];
    config = [ pydispatcher ];
    generic = [ av ];
    google_translate = [ mutagen ];
    lovelace = [ PyChromecast ];
    nest = [ av ];
    onboarding = [ pymetno radios rpi-bad-power ];
    raspberry_pi = [ rpi-bad-power ];
    tomorrowio = [ pyclimacell ];
    version = [ aioaseko ];
    voicerss = [ mutagen ];
    yandextts = [ mutagen ];
    zha = [ pydeconz ];
    zwave_js = [ homeassistant-pyozw ];
  };

  extraDisabledTestPaths = {
    tado = [
      # tado/test_{climate,water_heater}.py: Tries to connect to my.tado.com
      "tests/components/tado/test_climate.py"
      "tests/components/tado/test_water_heater.py"
    ];
  };

  extraDisabledTests = {
    roku = [
      # homeassistant.components.roku.media_player:media_player.py:428 Media type music is not supported with format None (mime: audio/x-matroska)
      "test_services_play_media_audio"
    ];
  };

  extraPytestFlagsArray = {
    asuswrt = [
      # asuswrt/test_config_flow.py: Sandbox network limitations, fails with unexpected error
      "--deselect tests/components/asuswrt/test_config_flow.py::test_on_connect_failed"
    ];
  };
in lib.listToAttrs (map (component: lib.nameValuePair component (
  home-assistant.overridePythonAttrs (old: {
    pname = "homeassistant-test-${component}";

    dontBuild = true;
    dontInstall = true;

    checkInputs = old.checkInputs
      ++ home-assistant.getPackages component home-assistant.python.pkgs
      ++ extraCheckInputs.${component} or [ ];

    disabledTests = old.disabledTests ++ extraDisabledTests.${component} or [];
    disabledTestPaths = old.disabledTestPaths ++ extraDisabledTestPaths.${component} or [ ];

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
        "bsblan"
        "dnsip"
        "efergy"
        "ssdp"
        "subaru"
      ];
      # upstream only tests on Linux, so do we.
      platforms = lib.platforms.linux;
    };
  })
)) home-assistant.supportedComponentsWithTests)
