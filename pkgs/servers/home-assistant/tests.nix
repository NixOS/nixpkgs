{ lib
, home-assistant
}:

let
  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    alexa = [ ha-av ];
    camera = [ ha-av ];
    cloud = [ mutagen ];
    config = [ pydispatcher ];
    generic = [ ha-av ];
    google_translate = [ mutagen ];
    nest = [ ha-av ];
    onboarding = [ pymetno rpi-bad-power ];
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

    disabledTestPaths = old.disabledTestPaths ++ extraDisabledTestPaths.${component} or [ ];

    pytestFlagsArray = lib.remove "tests" old.pytestFlagsArray
      ++ extraPytestFlagsArray.${component} or [ ]
      ++ [ "tests/components/${component}" ];

    preCheck = old.preCheck + lib.optionalString (builtins.elem component [ "emulated_hue" "songpal" "system_log" ]) ''
      patch -p1 < ${./patches/tests-mock-source-ip.patch}
    '';

    meta = old.meta // {
      broken = lib.elem component [
        "airtouch4"
        "dnsip"
      ];
      # upstream only tests on Linux, so do we.
      platforms = lib.platforms.linux;
    };
  })
)) home-assistant.supportedComponentsWithTests)
