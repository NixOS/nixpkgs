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
  version = "0.19.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5DeFH+uYXew1RGVPj5z23RCbCwP34ZlWCGYDCS/+so8=";
  };

  patches = [
    (
      # Fix event_loop missing
      # TODO: remove it after vdirsyncer release 0.19.4
      fetchpatch {
        # https://github.com/pimutils/vdirsyncer/pull/1185
        url = "https://github.com/pimutils/vdirsyncer/commit/164559ad7a95ed795ce4ae8d9b287bd27704742d.patch";
        hash = "sha256-nUGvkBnHr8nVPpBuhQ5GjaRs3QSxokdZUEIsOrQ+lpo=";
      }
    )
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  pythonRelaxDeps = [ "aiostream" ];

  propagatedBuildInputs = [
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
