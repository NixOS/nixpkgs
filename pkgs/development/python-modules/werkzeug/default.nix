{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  # build-system
  flit-core,

  # dependencies
  markupsafe,

  # optional-dependencies
  watchdog,

  # tests
  cffi,
  cryptography,
  ephemeral-port-reserve,
  pytest-timeout,
  pytestCheckHook,

  # reverse dependencies
  moto,
  sentry-sdk,
}:

buildPythonPackage rec {
  pname = "werkzeug";
  version = "3.1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YHI86UXBkyhnl5DjKCzHWKpKYEDkuzMPU9MPpUbUR0Y=";
  };

  build-system = [ flit-core ];

  dependencies = [ markupsafe ];

  optional-dependencies = {
    watchdog = [ watchdog ];
  };

  nativeCheckInputs = [
    cffi
    cryptography
    ephemeral-port-reserve
    pytest-timeout
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "werkzeug" ];

  disabledTests = [
    # ConnectionRefusedError: [Errno 111] Connection refused
    "test_http_proxy"
    # ResourceWarning: subprocess 309 is still running
    "test_basic"
    "test_long_build"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_get_machine_id" ];

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

  meta = {
    changelog = "https://werkzeug.palletsprojects.com/en/${lib.versions.majorMinor version}.x/changes/#version-${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "Comprehensive WSGI web application library";
    longDescription = ''
      Werkzeug is a comprehensive WSGI web application library. It
      began as a simple collection of various utilities for WSGI
      applications and has become one of the most advanced WSGI
      utility libraries.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
