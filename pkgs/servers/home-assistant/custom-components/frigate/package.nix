{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,

  # dependencies
  hass-web-proxy-lib,

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
  version = "5.9.4";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v${version}";
    hash = "sha256-LzrIvHJMB6mFAEfKoMIs0wL+xbEjoBIx48pSEcCHmg4=";
  };

  dependencies = [ hass-web-proxy-lib ];

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

  meta = with lib; {
    description = "Provides Home Assistant integration to interface with a separately running Frigate service";
    homepage = "https://github.com/blakeblackshear/frigate-hass-integration";
    changelog = "https://github.com/blakeblackshear/frigate-hass-integration/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
