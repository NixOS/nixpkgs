{
  lib,
  buildPythonPackage,
  isPyPy,
  distlib,
  fetchFromGitHub,
  filelock,
  flaky,
  hatch-vcs,
  hatchling,
  platformdirs,
  pytest-freezer,
  pytest-mock,
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.36.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "virtualenv";
    tag = version;
    hash = "sha256-8fiC7+9FzQnmoI+N4cA5kKBLH9tpU7LXZ7pVj8Bz8Wc=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    distlib
    filelock
    platformdirs
  ];

  nativeCheckInputs = [
    flaky
    pytest-mock
    pytestCheckHook
  ]
  ++ lib.optionals isPyPy [ pytest-freezer ]
  ++ lib.optionals (!isPyPy) [ time-machine ];

  disabledTestPaths = [
    # Ignore tests which require network access
    "tests/unit/create/test_creator.py"
    "tests/unit/create/via_global_ref/test_build_c_ext.py"
  ];

  disabledTests = [
    # Network access
    "test_seed_link_via_app_data"
  ]
  ++ lib.optionals isPyPy [
    # encoding problems
    "test_bash"
    # permission error
    "test_can_build_c_extensions"
    # fails to detect pypy version
    "test_discover_ok"
    # type error
    "test_fallback_existent_system_executable"
  ];

  pythonImportsCheck = [ "virtualenv" ];

  meta = {
    description = "Tool to create isolated Python environments";
    mainProgram = "virtualenv";
    homepage = "http://www.virtualenv.org";
    changelog = "https://github.com/pypa/virtualenv/blob/${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
