{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  click,
  click-log,
  requests,
  hypothesis,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
  aiostream,
  aiohttp-oauthlib,
  aiohttp,
  tenacity,
  pytest-asyncio,
  trustme,
  aioresponses,
  nixosTests,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "vdirsyncer";
  version = "0.21.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tqwEC4gNpnWPZcF6NpVy9i5zI76NIc0zDCb6E00bE3M=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    click-log
    requests
    aiostream
    aiohttp
    tenacity
  ];

  optional-dependencies = {
    google = [ aiohttp-oauthlib ];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
    trustme
    aioresponses
  ];

  preCheck = ''
    export DETERMINISTIC_TESTS=true
  '';

  disabledTests = [
    "test_create_collections" # Flaky test exceeds deadline on hydra: https://github.com/pimutils/vdirsyncer/issues/837
    "test_request_ssl"
    "test_verbosity"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.tests = {
    inherit (nixosTests) vdirsyncer;
  };

  meta = {
    description = "Synchronize calendars and contacts";
    homepage = "https://github.com/pimutils/vdirsyncer";
    changelog = "https://github.com/pimutils/vdirsyncer/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stephen-huan ];
    mainProgram = "vdirsyncer";
  };
})
