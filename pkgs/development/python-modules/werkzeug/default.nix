{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, watchdog
, dataclasses
, pytest-timeout
, pytest-xprocess
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "werkzeug";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Werkzeug";
    inherit version;
    sha256 = "sha256-qiu2/I3ujWxQTArB5/X33FgQqZA+eTtvcVqfAVva25o=";
  };

  propagatedBuildInputs = lib.optionals (!stdenv.isDarwin) [
    # watchdog requires macos-sdk 10.13+
    watchdog
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    pytest-timeout
    pytest-xprocess
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_get_machine_id"
  ];

  pytestFlagsArray = [
    # don't run tests that are marked with filterwarnings, they fail with
    # warnings._OptionError: unknown warning category: 'pytest.PytestUnraisableExceptionWarning'
    "-m 'not filterwarnings'"
  ];

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
    maintainers = with maintainers; [ ];
  };
}
