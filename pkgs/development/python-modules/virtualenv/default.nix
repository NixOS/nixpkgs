{
  lib,
  buildPythonPackage,
  isPyPy,
  distlib,
  fetchFromGitHub,
  filelock,
  flaky,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  packaging,
  platformdirs,
  pytest-freezer,
  pytest-mock,
  pytestCheckHook,
  python-discovery,
  time-machine,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "21.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "virtualenv";
    tag = version;
    hash = "sha256-7oxYkJE4/OlJMMym7D5WhEXsWvvCohVog3OQzNVov1c=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    distlib
    filelock
    packaging
    platformdirs
    python-discovery
  ];

  nativeCheckInputs = [
    flaky
    pytest-mock
    pytestCheckHook
    versionCheckHook
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
    # Assumes FHS paths
    "test_bash_relocation_rejects_sourced_wrapper"
    # chmod fails in sandbox
    "test_app_data_setgid_keeps_group_write"
    # bash: cannot set terminal process group (1): Inappropriate ioctl for device
    "test_activator_prompt_stays_data"
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
    homepage = "https://virtualenv.pypa.io/en/latest/";
    changelog = "https://github.com/pypa/virtualenv/blob/${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
