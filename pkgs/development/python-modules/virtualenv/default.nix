{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, isPy27
, backports-entry-points-selectable
, cython
, distlib
, fetchPypi
, filelock
, flaky
, importlib-metadata
, importlib-resources
, pathlib2
, platformdirs
, pytest-freezegun
, pytest-mock
, pytest-timeout
, pytestCheckHook
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KIFxE0ov87+xovVPEZ53zRuBwp/BJlojVvPo0Ux9WMQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    backports-entry-points-selectable
    distlib
    filelock
    platformdirs
    six
  ] ++ lib.optionals (pythonOlder "3.4" && !stdenv.hostPlatform.isWindows) [
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
    # Network access
    "test_create_no_seed"
    "test_seed_link_via_app_data"
    # Permission Error
    "test_bad_exe_py_info_no_raise"
  ] ++ lib.optionals isPy27 [
    "test_python_via_env_var"
    "test_python_multi_value_prefer_newline_via_env_var"
  ];

  pythonImportsCheck = [ "virtualenv" ];

  meta = with lib; {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
