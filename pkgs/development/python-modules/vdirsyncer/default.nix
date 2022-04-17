{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, click
, click-log
, click-threading
, requests-toolbelt
, requests
, requests-oauthlib
, atomicwrites
, hypothesis
, pytestCheckHook
, pytest-localserver
, pytest-subtesthack
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "vdirsyncer";
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J7w+1R93STX7ujkpFcjI1M9jmuUaRLZ0aGtJoQJfwgE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click-log>=0.3.0, <0.4.0" "click-log>=0.3.0, <0.5.0"

    sed -i -e '/--cov/d' -e '/--no-cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
    click-threading
    requests
    requests-oauthlib
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
