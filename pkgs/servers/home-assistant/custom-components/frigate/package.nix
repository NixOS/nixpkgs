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
  version = "5.15.4";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v${version}";
    hash = "sha256-xckHpwKujlWJ0M/fDlCU96WocMIlMk37+TwmY8iEnNo=";
  };

  patches = [
    # https://github.com/blakeblackshear/frigate-hass-integration/pull/1070
    ./service-to-action.patch
    # https://github.com/blakeblackshear/frigate-hass-integration/pull/1085
    ./llmcontext-user-prompt.patch
    # https://github.com/blakeblackshear/frigate-hass-integration/pull/1096
    ./async-publish-compat.patch
    # https://github.com/blakeblackshear/frigate-hass-integration/pull/1095
    ./remove-advanced-options-gate.patch
  ];

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
  ++ (homeassistant.getPackages "mqtt" homeassistant.python3Packages)
  ++ (homeassistant.getPackages "stream" homeassistant.python3Packages);

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
