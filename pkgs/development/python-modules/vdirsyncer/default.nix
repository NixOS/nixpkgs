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
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.19.2";
=======
  version = "0.19.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-/QWM7quCk0WaBGbNmw5Ks7OUYsbgiaDwrDfDB0INgro=";
=======
    hash = "sha256-qnbHclqlpxH2N0vFzYO+eKrmjHSCljWp7Qc81MCfA64=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i -e '/--cov/d' -e '/--no-cov/d' pyproject.toml
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "Synchronize calendars and contacts";
    homepage = "https://github.com/pimutils/vdirsyncer";
    changelog = "https://github.com/pimutils/vdirsyncer/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
=======
    homepage = "https://github.com/pimutils/vdirsyncer";
    description = "Synchronize calendars and contacts";
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ loewenheim ];
  };
}
