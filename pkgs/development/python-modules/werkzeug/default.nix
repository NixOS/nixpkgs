{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, watchdog
, ephemeral-port-reserve
, pytest-timeout
, pytest-xprocess
, pytestCheckHook
, markupsafe
  # for passthru.tests
, moto
, sentry-sdk
}:

buildPythonPackage rec {
  pname = "werkzeug";
  version = "2.3.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "werkzeug";
    rev = "refs/tags/${version}";
    hash = "sha256-+7WJJbeoVSzhbHn4mkoxIMnu6IHyTjfbK/N167Zv1mU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    markupsafe
  ];

  nativeCheckInputs = [
    ephemeral-port-reserve
    pytest-xprocess
    pytest-timeout
    pytestCheckHook
  ] ++ passthru.optional-dependencies.watchdog;

  disabledTestPaths = [
    # ConnectionRefusedError: [Errno 111] Connection refused
    "tests/test_debug.py"
    "tests/test_serving.py"
    "tests/middleware/test_http_proxy.py"
  ];

  passthru.tests = {
    inherit moto sentry-sdk;
  };

  passthru.optional-dependencies = {
    watchdog = [ watchdog ];
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
    maintainers = with maintainers; [ ];
  };
}
