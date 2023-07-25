{ lib
, buildPythonPackage
, pythonOlder
, isPy27
, isPyPy
, cython
, distlib
, fetchPypi
, filelock
, flaky
, hatch-vcs
, hatchling
, importlib-metadata
, importlib-resources
, platformdirs
, pytest-freezegun
, pytest-mock
, pytest-timeout
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N6ZAuoLtQLImWZxSLUEeS+XtszmgwN4DDA3HtkbWFZA=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    distlib
    filelock
    platformdirs
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  patches = lib.optionals (isPy27) [
    ./0001-Check-base_prefix-and-base_exec_prefix-for-Python-2.patch
  ];

  nativeCheckInputs = [
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

  disabledTestPaths = [
    # Ignore tests which require network access
    "tests/unit/create/test_creator.py"
    "tests/unit/seed/embed/test_bootstrap_link_via_app_data.py"
  ];

  disabledTests = [
    # Network access
    "test_create_no_seed"
    "test_seed_link_via_app_data"
    # Permission Error
    "test_bad_exe_py_info_no_raise"
  ] ++ lib.optionals (isPyPy) [
    # encoding problems
    "test_bash"
    # permission error
    "test_can_build_c_extensions"
    # fails to detect pypy version
    "test_discover_ok"
  ];

  pythonImportsCheck = [
    "virtualenv"
  ];

  meta = with lib; {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    changelog = "https://github.com/pypa/virtualenv/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
