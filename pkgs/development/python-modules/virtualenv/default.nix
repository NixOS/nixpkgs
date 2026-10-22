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
  python,
  python-discovery,
  time-machine,
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "21.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "virtualenv";
    tag = version;
    hash = "sha256-8LOmA1Mhfqbl3hsGZa8tQutjfjEVeDlpOKyVut5rDVI=";
  };

  # Make the pip seeded into each venv prefer the system CA bundle over its vendored certifi.
  # virtualenv checks each bundled wheel against BUNDLE_SHA256, so update the hash too.
  postPatch = ''
    for whl in src/virtualenv/seed/wheels/embed/pip-*.whl; do
      old=$(sha256sum "$whl" | cut -d' ' -f1)
      ${python.pythonOnBuildForHost.interpreter} ${../../interpreters/python/cpython/ensurepip-certifi.py} \
        ${../../interpreters/python/pip-certifi-override.py} "$whl"
      substituteInPlace src/virtualenv/seed/wheels/embed/__init__.py \
        --replace-fail "$old" "$(sha256sum "$whl" | cut -d' ' -f1)"
    done
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    distlib
    filelock
    platformdirs
    python-discovery
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
    homepage = "https://virtualenv.pypa.io/en/latest/";
    changelog = "https://github.com/pypa/virtualenv/blob/${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
