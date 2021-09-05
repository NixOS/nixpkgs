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
  version = "20.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ef4e8ee4710826e98ff3075c9a4739e2cb1040de6a2a8d35db0055840dc96a0";
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
    "test_can_build_c_extensions"
    "test_xonsh" # imports xonsh, which is not in pythonPackages
    # tests search `python3`, fail on python2, pypy
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
