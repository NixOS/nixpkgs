{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,

  # tests
  home-assistant,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-timeout,
  pytestCheckHook,

  # reverse dependencies
  home-assistant-custom-components,
}:

buildPythonPackage (finalAttrs: {
  pname = "hass-web-proxy-lib";
  version = "0.0.8";
  pyproject = true;

  # no tags on git
  src = fetchPypi {
    pname = "hass_web_proxy_lib";
    inherit (finalAttrs) version;
    hash = "sha256-H9C8jwJeR6skvCVn8jeaWqmIL0fmcab+/BQ5SzUIt00=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    home-assistant
    pytest-aiohttp
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hass_web_proxy_lib"
  ];

  passthru.tests = {
    inherit (home-assistant-custom-components) frigate;
  };

  meta = {
    description = "Library to proxy web traffic through Home Assistant integrations";
    homepage = "https://github.com/dermotduffy/hass-web-proxy-lib";
    license = lib.licenses.mit;
    maintainers = home-assistant-custom-components.frigate.meta.maintainers;
  };
})
