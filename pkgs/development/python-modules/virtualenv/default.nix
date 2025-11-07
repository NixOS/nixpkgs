{
  lib,
  buildPythonPackage,
  pythonOlder,
  isPyPy,
  cython,
  distlib,
  fetchPypi,
  filelock,
  flaky,
  hatch-vcs,
  hatchling,
  importlib-metadata,
  platformdirs,
  pytest-freezegun,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.33.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G0RHjZ4mGz+4uqXnSgyjvA4F8hqjYWe/nL+FDlQnZbg=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    distlib
    filelock
    platformdirs
  ]
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    cython
    flaky
    pytest-freezegun
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.optionals (!isPyPy) [ time-machine ];

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
    # https://github.com/pypa/virtualenv/issues/2933
    # https://github.com/pypa/virtualenv/issues/2939
    "test_py_info_cache_invalidation_on_py_info_change"
  ]
  ++ lib.optionals (pythonOlder "3.11") [ "test_help" ]
  ++ lib.optionals isPyPy [
    # encoding problems
    "test_bash"
    # permission error
    "test_can_build_c_extensions"
    # fails to detect pypy version
    "test_discover_ok"
  ];

  pythonImportsCheck = [ "virtualenv" ];

  meta = with lib; {
    description = "Tool to create isolated Python environments";
    mainProgram = "virtualenv";
    homepage = "http://www.virtualenv.org";
    changelog = "https://github.com/pypa/virtualenv/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
