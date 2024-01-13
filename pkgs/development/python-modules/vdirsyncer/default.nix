{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, click
, click-log
, click-threading
, requests-toolbelt
, requests
, atomicwrites
, hypothesis
, pytestCheckHook
, pytest-subtesthack
, setuptools
, setuptools-scm
, wheel
, aiostream
, aiohttp-oauthlib
, aiohttp
, pytest-asyncio
, trustme
, aioresponses
, vdirsyncer
, testers
}:

buildPythonPackage rec {
  pname = "vdirsyncer";
  version = "0.19.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/QWM7quCk0WaBGbNmw5Ks7OUYsbgiaDwrDfDB0INgro=";
  };

  postPatch = ''
    sed -i -e '/--cov/d' -e '/--no-cov/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

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

  meta = with lib; {
    description = "Synchronize calendars and contacts";
    homepage = "https://github.com/pimutils/vdirsyncer";
    changelog = "https://github.com/pimutils/vdirsyncer/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ loewenheim ];
    mainProgram = "vdirsyncer";
  };
}
