{ buildPythonPackage
, appdirs
, contextlib2
, cython
, distlib
, fetchPypi
, filelock
, fish
, flaky
, importlib-metadata
, importlib-resources
, isPy27
, lib
, pathlib2
, pytest-freezegun
, pytest-mock
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools_scm
, six
, stdenv
, xonsh
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DBEaIjaxkUIrN/6MKLjIKM7TmqtL9WJ/pcMxrv+1cNk=";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    appdirs
    distlib
    filelock
    six
  ] ++ lib.optionals isPy27 [
    contextlib2
  ] ++ lib.optionals (isPy27 && !stdenv.hostPlatform.isWindows) [
    pathlib2
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  patches = lib.optionals (isPy27) [
    ./0001-Check-base_prefix-and-base_exec_prefix-for-Python-2.patch
  ];

  checkInputs = [
    cython
    fish
    flaky
    pytest-freezegun
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.9") [
    xonsh
  ];

  preCheck = "export HOME=$(mktemp -d)";

  # Ignore tests which requires network access
  pytestFlagsArray = [
    "--ignore tests/unit/create/test_creator.py"
    "--ignore tests/unit/seed/embed/test_bootstrap_link_via_app_data.py"
  ];

  disabledTests = [ "test_can_build_c_extensions" ];
  pythonImportsCheck = [ "virtualenv" ];

  meta = with lib; {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
