{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, watchdog
, ephemeral-port-reserve
, pytest-timeout
, pytest-xprocess
, pytestCheckHook
, markupsafe
# for passthru.tests
, moto, sentry-sdk
}:

buildPythonPackage rec {
  pname = "werkzeug";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Werkzeug";
    inherit version;
    hash = "sha256-LhzMlBfU2jWLnebxdOOsCUOR6h1PvvLWZ4ZdgZ39Cv4=";
  };

  propagatedBuildInputs = [
    markupsafe
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # watchdog requires macos-sdk 10.13+
    watchdog
  ];

  nativeCheckInputs = [
    ephemeral-port-reserve
    pytest-timeout
    pytest-xprocess
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_get_machine_id"
  ];

  disabledTestPaths = [
    # ConnectionRefusedError: [Errno 111] Connection refused
    "tests/test_serving.py"
  ];

  pytestFlagsArray = [
    # don't run tests that are marked with filterwarnings, they fail with
    # warnings._OptionError: unknown warning category: 'pytest.PytestUnraisableExceptionWarning'
    "-m 'not filterwarnings'"
  ];

  passthru.tests = {
    inherit moto sentry-sdk;
  };

  meta = with lib; {
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "The comprehensive WSGI web application library";
    longDescription = ''
      Werkzeug is a comprehensive WSGI web application library. It
      began as a simple collection of various utilities for WSGI
      applications and has become one of the most advanced WSGI
      utility libraries.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
