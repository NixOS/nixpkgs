{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, click
, click-log
, click-threading
, requests-toolbelt
, requests
, requests_oauthlib # required for google oauth sync
, atomicwrites
, hypothesis
, pytestCheckHook
, pytest-localserver
, pytest-subtesthack
, setuptools-scm
}:

buildPythonPackage rec {
  version = "0.18.0";
  pname = "vdirsyncer";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J7w+1R93STX7ujkpFcjI1M9jmuUaRLZ0aGtJoQJfwgE=";
  };

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
    click-threading
    requests
    requests_oauthlib # required for google oauth sync
    requests-toolbelt
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
    pytest-localserver
    pytest-subtesthack
  ];

  postPatch = ''
    sed -i -e '/--cov/d' -e '/--no-cov/d' setup.cfg
  '';

  preCheck = ''
    export DETERMINISTIC_TESTS=true
  '';

  disabledTests = [
    "test_create_collections" # Flaky test exceeds deadline on hydra: https://github.com/pimutils/vdirsyncer/issues/837
    "test_request_ssl"
    "test_verbosity"
  ];

  meta = with lib; {
    homepage = "https://github.com/pimutils/vdirsyncer";
    description = "Synchronize calendars and contacts";
    license = licenses.mit;
    maintainers = with maintainers; [ loewenheim ];
  };
}
