{
  lib,
  home-assistant,
}:

let
  getComponentDeps = component: home-assistant.getPackages component home-assistant.python.pkgs;

  # some components' tests have additional dependencies
  extraCheckInputs = with home-assistant.python.pkgs; {
    abode = getComponentDeps "camera";
    agent_dvr = getComponentDeps "camera";
    air_quality = getComponentDeps "camera" ++ getComponentDeps "conversation";
    alexa = getComponentDeps "cloud" ++ getComponentDeps "frontend" ++ getComponentDeps "stream";
    android_ip_webcam = getComponentDeps "camera";
    anthropic = getComponentDeps "ai_task";
    assist_pipeline = getComponentDeps "frontend";
    automation = getComponentDeps "frontend" ++ getComponentDeps "mobile_app";
    axis = getComponentDeps "camera" ++ getComponentDeps "deconz";
    blink = getComponentDeps "camera";
    bthome = getComponentDeps "frontend";
    buienradar = getComponentDeps "camera";
    camera = getComponentDeps "conversation" ++ getComponentDeps "stream";
    canary = getComponentDeps "camera";
    climate = getComponentDeps "conversation";
    color_extractor = getComponentDeps "camera" ++ getComponentDeps "conversation";
    deconz = getComponentDeps "frontend";
    demo = getComponentDeps "camera";
    device_tracker = getComponentDeps "conversation";
    dialogflow = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    dlib_face_detect = getComponentDeps "image_processing";
    dlib_face_identify = getComponentDeps "image_processing";
    doorbird = getComponentDeps "camera";
    dremel_3d_printer = getComponentDeps "camera";
    elevenlabs = getComponentDeps "tts";
    elkm1 = getComponentDeps "frontend";
    emulated_hue = getComponentDeps "conversation" ++ [
      defusedxml
    ];
    emulated_kasa = getComponentDeps "camera" ++ getComponentDeps "conversation";
    environment_canada = getComponentDeps "camera";
    esphome = getComponentDeps "camera";
    fan = getComponentDeps "conversation";
    foscam = getComponentDeps "camera";
    freebox = getComponentDeps "camera";
    fully_kiosk = getComponentDeps "camera";
    gardena_bluetooth = getComponentDeps "husqvarna_automower_ble";
    geofency = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    google_assistant = getComponentDeps "conversation";
    google_assistant_sdk = getComponentDeps "conversation" ++ getComponentDeps "frontend";
    google_cloud = getComponentDeps "tts";
    google_drive = getComponentDeps "frontend";
    google_generative_ai_conversation = getComponentDeps "ai_task";
    google_translate = getComponentDeps "tts";
    govee_ble = [
      ibeacon-ble
    ];
    gpslogger = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    group = getComponentDeps "camera" ++ getComponentDeps "conversation";
    hassio = getComponentDeps "frontend" ++ getComponentDeps "homeassistant_yellow";
    homeassistant = getComponentDeps "camera" ++ getComponentDeps "conversation";
    homeassistant_connect_zbt2 = getComponentDeps "zha";
    homeassistant_hardware = getComponentDeps "otbr" ++ getComponentDeps "zha";
    homeassistant_sky_connect = getComponentDeps "zha";
    homeassistant_yellow = getComponentDeps "zha";
    homekit = getComponentDeps "conversation" ++ getComponentDeps "frontend";
    homekit_controller = getComponentDeps "camera";
    http = getComponentDeps "cloud" ++ getComponentDeps "frontend";
    humidifier = getComponentDeps "conversation";
    hyperion = getComponentDeps "camera";
    ifttt = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    image_processing = getComponentDeps "conversation";
    intent = getComponentDeps "conversation";
    light = getComponentDeps "conversation";
    local_file = getComponentDeps "camera";
    locative = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    logbook = getComponentDeps "alexa";
    lovelace = [
      pychromecast
    ];
    lutron_caseta = getComponentDeps "frontend";
    mailgun = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    marytts = getComponentDeps "tts";
    media_player = getComponentDeps "camera" ++ getComponentDeps "conversation";
    microsoft = getComponentDeps "tts";
    microsoft_face_detect = getComponentDeps "conversation";
    microsoft_face_identify = getComponentDeps "conversation";
    miele = getComponentDeps "cloud";
    mjpeg = getComponentDeps "camera";
    mobile_app = getComponentDeps "frontend";
    motioneye = getComponentDeps "camera";
    mqtt = getComponentDeps "camera";
    nest = getComponentDeps "camera" ++ [
      av
    ];
    number = getComponentDeps "conversation";
    octoprint = getComponentDeps "camera";
    ollama = getComponentDeps "ai_task";
    onboarding = getComponentDeps "tts" ++ [
      pymetno
      radios
      rpi-bad-power
    ];
    onvif = getComponentDeps "camera";
    open_router = getComponentDeps "ai_task";
    openai_conversation = getComponentDeps "camera";
    openalpr_cloud = getComponentDeps "camera" ++ getComponentDeps "conversation";
    prosegur = getComponentDeps "camera";
    prusalink = getComponentDeps "camera";
    push = getComponentDeps "camera";
    raspberry_pi = [
      rpi-bad-power
    ];
    reolink = getComponentDeps "stream";
    ring = getComponentDeps "camera";
    roku = getComponentDeps "camera";
    rss_feed_template = [
      defusedxml
    ];
    script = getComponentDeps "frontend" ++ getComponentDeps "mobile_app";
    sensor = getComponentDeps "camera" ++ getComponentDeps "conversation";
    shelly = getComponentDeps "frontend" ++ getComponentDeps "switchbot";
    sighthound = getComponentDeps "conversation" ++ getComponentDeps "image_processing";
    skybell = getComponentDeps "camera";
    sleep_as_android = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    songpal = [
      isal
    ];
    swiss_public_transport = getComponentDeps "cookidoo";
    switch = getComponentDeps "camera" ++ getComponentDeps "conversation";
    switch_as_x = getComponentDeps "camera" ++ getComponentDeps "conversation";
    synology_dsm = getComponentDeps "camera";
    system_log = [
      isal
    ];
    tasmota = getComponentDeps "camera";
    todo = getComponentDeps "conversation";
    traccar = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    trafikverket_camera = getComponentDeps "camera";
    tts = getComponentDeps "conversation";
    tuya = getComponentDeps "camera";
    twilio = getComponentDeps "assist_pipeline" ++ getComponentDeps "camera";
    unifiprotect = getComponentDeps "camera";
    universal = getComponentDeps "camera" ++ getComponentDeps "conversation";
    uvc = getComponentDeps "camera";
    voicerss = getComponentDeps "tts";
    weather = getComponentDeps "conversation";
    websocket_api = getComponentDeps "camera" ++ getComponentDeps "conversation";
    xiaomi_miio = [
      arrow
    ];
    yandextts = getComponentDeps "tts";
    yolink = getComponentDeps "cloud";
    zeroconf = getComponentDeps "shelly";
    zha = getComponentDeps "deconz" ++ getComponentDeps "frontend";
    zwave_js = getComponentDeps "frontend";
  };

  extraDisabledTestPaths = {
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
    modem_callerid = [
      # aioserial mock produces wrong state
      "tests/components/modem_callerid/test_init.py::test_setup_entry"
    ];
    nzbget = [
      # type assertion fails due to introduction of parameterized type
      "tests/components/nzbget/test_config_flow.py::test_user_form"
      "tests/components/nzbget/test_config_flow.py::test_user_form_show_advanced_options"
      "tests/components/nzbget/test_config_flow.py::test_user_form_cannot_connect"
      "tests/components/nzbget/test_init.py::test_async_setup_raises_entry_not_ready"
    ];
    overseerr = [
      # imports broken future module
      "tests/components/overseerr/test_event.py"
    ];
    systemmonitor = [
      # sandbox doesn't grant access to /sys/class/power_supply
      "tests/components/systemmonitor/test_config_flow.py::test_add_and_remove_processes"
    ];
    youtube = [
      # outdated snapshot
      "tests/components/youtube/test_sensor.py::test_sensor"
    ];
  };

  extraDisabledTests = {
    conversation = [
      # intent fixture mismatch
      "test_error_no_device_on_floor"
    ];
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
        pyproject = null;
        format = "other";

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
