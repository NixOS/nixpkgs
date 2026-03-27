{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,

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

buildPythonPackage rec {
  pname = "hass-web-proxy-lib";
  version = "0.0.7";
  pyproject = true;

  # no tags on git
  src = fetchPypi {
    pname = "hass_web_proxy_lib";
    inherit version;
    hash = "sha256-bhz71tNOpZ+4tSlndS+UbC3w2WW5+dAMtpk7TnnFpuQ=";
  };

  patches = [
    (fetchpatch2 {
      name = "add-missing-build-system.patch";
      url = "https://github.com/dermotduffy/hass-web-proxy-lib/commit/0eed7a57f503fc552948a45e7f490ddaff711896.patch";
      hash = "sha256-ccOdhA0NhlTmdA51sNdB357Xh13E4PsLlvUTU4GQ9jk=";
    })
  ];

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

  disabledTests = [
    # https://github.com/dermotduffy/hass-web-proxy-lib/issues/65
    "test_proxy_view_aiohttp_read_error"
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
}
