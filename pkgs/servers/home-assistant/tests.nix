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
    husqvarna_automower_ble = getComponentDeps "gardena_bluetooth";
    lovelace = [
      pychromecast
    ];
    matrix = [
      pydantic
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
    songpal = [
      isal
    ];
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
  };

  extraDisabledTests = {
    shell_command = [
      # tries to retrieve file from github
      "test_non_text_stdout_capture"
    ];
    sma = [
      # missing operating_status attribute in entity
      "test_sensor_entities"
    ];
    websocket_api = [
      # AssertionError: assert 'unknown_error' == 'template_error'
      "test_render_template_with_timeout"
    ];
  };

  extraPytestFlagsArray = {
    dnsip = [
      # Tries to resolve DNS entries
      "--deselect tests/components/dnsip/test_config_flow.py::test_options_flow"
    ];
    honeywell = [
      # Failed: Unused ignore translations: component.honeywell.config.abort.reauth_successful. Please remove them from the ignore_translations fixture.
      "--deselect=tests/components/honeywell/test_config_flow.py::test_reauth_flow"
    ];
    jellyfin = [
      # AssertionError: assert 'audio/x-flac' == 'audio/flac'
      "--deselect tests/components/jellyfin/test_media_source.py::test_resolve"
      "--deselect tests/components/jellyfin/test_media_source.py::test_audio_codec_resolve"
      # AssertionError: assert [+ received] == [- snapshot]
      "--deselect tests/components/jellyfin/test_media_source.py::test_music_library"
    ];
    jewish_calendar = [
      # Failed: Unused ignore translations: component.jewish_calendar.config.abort.reconfigure_successful. Please remove them from the ignore_translations fixture.
      "--deselect tests/components/jewish_calendar/test_config_flow.py::test_reconfigure"
    ];
    modem_callerid = [
      # aioserial mock produces wrong state
      "--deselect tests/components/modem_callerid/test_init.py::test_setup_entry"
    ];
    nina = [
      # Failed: Unused ignore translations: component.nina.options.error.unknown. Please remove them from the ignore_translations fixture.
      "--deselect tests/components/nina/test_config_flow.py::test_options_flow_unexpected_exception"
    ];
    sql = [
      "-W"
      "ignore::sqlalchemy.exc.SAWarning"
    ];
    vicare = [
      # Snapshot 'test_all_entities[sensor.model0_electricity_consumption_today-entry]' does not exist!
      "--deselect=tests/components/vicare/test_sensor.py::test_all_entities"
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

        preCheck =
          old.preCheck
          +
            lib.optionalString
              (builtins.elem component [
                "emulated_hue"
                "songpal"
                "system_log"
              ])
              ''
                patch -p1 < ${./patches/tests-mock-source-ip.patch}
              '';

        meta = old.meta // {
          broken = lib.elem component [ ];
          # upstream only tests on Linux, so do we.
          platforms = lib.platforms.linux;
        };
      })
    )
  ) home-assistant.supportedComponentsWithTests
)
