{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi

# build-system
, flit-core

# dependencies
, markupsafe

# optional-dependencies
, watchdog

# tests
, cryptography
, ephemeral-port-reserve
, greenlet
, pytest-timeout
, pytest-xprocess
, pytestCheckHook

# reverse dependencies
, moto
, sentry-sdk
}:

buildPythonPackage rec {
  pname = "werkzeug";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UH6BHs6nKxikBJR63tSzOQ4duPgmtJTXZVDvRbs7Hcw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    markupsafe
  ];

  passthru.optional-dependencies = {
    watchdog = lib.optionals (!stdenv.isDarwin) [
      # watchdog requires macos-sdk 10.13
      watchdog
    ];
  };

  nativeCheckInputs = [
    cryptography
    ephemeral-port-reserve
    pytest-timeout
    pytest-xprocess
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.11") [
    greenlet
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
    changelog = "https://werkzeug.palletsprojects.com/en/${versions.majorMinor version}.x/changes/#version-${replaceStrings [ "." ] [ "-" ] version}";
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "The comprehensive WSGI web application library";
    longDescription = ''
      Werkzeug is a comprehensive WSGI web application library. It
      began as a simple collection of various utilities for WSGI
      applications and has become one of the most advanced WSGI
      utility libraries.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
