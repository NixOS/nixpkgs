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
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v${version}";
    hash = "sha256-sQgi3F44eT/iL3cE9YuKyjJmE4nZM+OcwirUyl3maGo=";
  };

  dependencies = [ hass-web-proxy-lib ];

  dontBuild = true;

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

  disabledTests = [
    # uses deprecated and removed constants
    # https://github.com/blakeblackshear/frigate-hass-integration/issues/860
    "test_duplicate"
    "test_options_advanced"
    "test_options"
  ];

  meta = with lib; {
    description = "Provides Home Assistant integration to interface with a separately running Frigate service";
    homepage = "https://github.com/blakeblackshear/frigate-hass-integration";
    changelog = "https://github.com/blakeblackshear/frigate-hass-integration/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
