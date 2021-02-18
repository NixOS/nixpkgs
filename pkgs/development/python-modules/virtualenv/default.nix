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
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0aac7525e880a429764cefd3aaaff54afb5d9f25c82627563603f5d7de5a6e5";
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
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Ignore tests which require network access
  disabledTestPaths = [
    "tests/unit/create/test_creator.py"
    "tests/unit/seed/embed/test_bootstrap_link_via_app_data.py"
  ];

  disabledTests = [
    "test_can_build_c_extensions"
    "test_xonsh" # imports xonsh, which is not in pythonPackages
  ];

  pythonImportsCheck = [ "virtualenv" ];

  meta = with lib; {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
