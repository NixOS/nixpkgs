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
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v${version}";
    hash = "sha256-XVHw9AjngzbMnzRPJ/VL1Hy0gG3q+rV4Gfh8K7pIW6M=";
  };

  dependencies = [ hass-web-proxy-lib ];

  nativeCheckInputs =
    [
      homeassistant
      pytest-aiohttp
      pytest-cov-stub
      pytest-homeassistant-custom-component
      pytest-timeout
      pytestCheckHook
    ]
    ++ (homeassistant.getPackages "mqtt" homeassistant.python.pkgs)
    ++ (homeassistant.getPackages "stream" homeassistant.python.pkgs);

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
