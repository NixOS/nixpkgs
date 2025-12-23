{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pythonOlder,
  click,
  click-log,
  click-threading,
  requests-toolbelt,
  requests,
  atomicwrites,
  hypothesis,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-subtesthack,
  setuptools,
  setuptools-scm,
  wheel,
  aiostream,
  aiohttp-oauthlib,
  aiohttp,
  pytest-asyncio,
  trustme,
  aioresponses,
  vdirsyncer,
  testers,
}:

buildPythonPackage rec {
  pname = "vdirsyncer";
  version = "0.20.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/rGlM1AKlcFP0VVzOhBW/jWRklU9gsB8a6BPy/xAsS0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    atomicwrites
    click
    click-log
    click-threading
    requests
    requests-toolbelt
    aiostream
    aiohttp
    aiohttp-oauthlib
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-cov-stub
    pytest-subtesthack
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

  passthru.tests.version = testers.testVersion { package = vdirsyncer; };

  meta = {
    description = "Synchronize calendars and contacts";
    homepage = "https://github.com/pimutils/vdirsyncer";
    changelog = "https://github.com/pimutils/vdirsyncer/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stephen-huan ];
    mainProgram = "vdirsyncer";
  };
}
