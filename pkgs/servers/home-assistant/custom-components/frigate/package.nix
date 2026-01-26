{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,

  # dependencies
  hass-web-proxy-lib,
  titlecase,

  # tests
  homeassistant,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-timeout,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "blakeblackshear";
  domain = "frigate";
  version = "5.14.1";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v${version}";
    hash = "sha256-fiy1G/gi2nr8uh6VaC48p/uXat+Q1uiThbg3kn6jRxs=";
  };

  dependencies = [
    hass-web-proxy-lib
    titlecase
  ];

  nativeCheckInputs = [
    homeassistant
    pytest-aiohttp
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytest-timeout
    pytestCheckHook
  ]
  ++ (homeassistant.getPackages "mqtt" homeassistant.python.pkgs)
  ++ (homeassistant.getPackages "stream" homeassistant.python.pkgs);

  disabledTests = [
    # https://github.com/blakeblackshear/frigate-hass-integration/issues/922
    "test_frigate_camera_setup"
    "test_frigate_camera_setup_birdseye"
    "test_frigate_camera_setup_webrtc"
    "test_frigate_camera_setup_birdseye_webrtc"
  ];

  disabledTestPaths = [
    # https://github.com/blakeblackshear/frigate-hass-integration/issues/907
    "tests/test_media_source.py"
  ];

  meta = {
    description = "Provides Home Assistant integration to interface with a separately running Frigate service";
    homepage = "https://github.com/blakeblackshear/frigate-hass-integration";
    changelog = "https://github.com/blakeblackshear/frigate-hass-integration/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ presto8 ];
    license = lib.licenses.mit;
  };
}
