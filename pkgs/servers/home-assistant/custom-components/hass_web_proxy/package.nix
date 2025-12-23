{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchpatch,
  hass-web-proxy-lib,
  urlmatch,
  pytestCheckHook,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytest-timeout,
}:

buildHomeAssistantComponent rec {
  owner = "dermotduffy";
  domain = "hass_web_proxy";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "hass-web-proxy-integration";
    tag = "v${version}";
    hash = "sha256-qtiea0L0Zw0CtrUpuPjS/DuBzlV61v6K4SARzHGGgUY=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/dermotduffy/hass-web-proxy-integration/pull/106
      url = "https://github.com/dermotduffy/hass-web-proxy-integration/commit/77964d49fd6e9d7aefe0cd9c19226a80477dc909.patch";
      hash = "sha256-PZBRHVoHXMiELHitmj+YmgVSQiOqEmyP4o3MBc1Yjsg=";
    })
  ];

  dependencies = [
    hass-web-proxy-lib
    urlmatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
    pytest-timeout
  ];

  meta = {
    changelog = "https://github.com/dermotduffy/hass-web-proxy-integration/releases/tag/${src.tag}";
    description = "Home Assistant Web Proxy";
    homepage = "https://github.com/dermotduffy/hass-web-proxy-integration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
