{
  lib,
  buildPythonPackage,
  pythonOlder,
  isPyPy,
<<<<<<< HEAD
  distlib,
  fetchFromGitHub,
=======
  cython,
  distlib,
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  filelock,
  flaky,
  hatch-vcs,
  hatchling,
<<<<<<< HEAD
  platformdirs,
  pytest-mock,
=======
  importlib-metadata,
  platformdirs,
  pytest-freezegun,
  pytest-mock,
  pytest-timeout,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage rec {
  pname = "virtualenv";
<<<<<<< HEAD
  version = "20.35.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "virtualenv";
    tag = version;
    hash = "sha256-0PWIYU1/zXiOBUV/45rJsJwVlcqHeac68nRM2tvEPHo=";
  };

  build-system = [
=======
  version = "20.33.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G0RHjZ4mGz+4uqXnSgyjvA4F8hqjYWe/nL+FDlQnZbg=";
  };

  nativeBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hatch-vcs
    hatchling
  ];

<<<<<<< HEAD
  dependencies = [
    distlib
    filelock
    platformdirs
  ];

  nativeCheckInputs = [
    flaky
    pytest-mock
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytestCheckHook
  ]
  ++ lib.optionals (!isPyPy) [ time-machine ];

<<<<<<< HEAD
  disabledTestPaths = [
    # Ignore tests which require network access
    "tests/unit/create/test_creator.py"
    "tests/unit/create/via_global_ref/test_build_c_ext.py"
=======
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Ignore tests which require network access
    "tests/unit/create/test_creator.py"
    "tests/unit/seed/embed/test_bootstrap_link_via_app_data.py"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  disabledTests = [
    # Network access
<<<<<<< HEAD
    "test_seed_link_via_app_data"
=======
    "test_create_no_seed"
    "test_seed_link_via_app_data"
    # Permission Error
    "test_bad_exe_py_info_no_raise"
    # https://github.com/pypa/virtualenv/issues/2933
    # https://github.com/pypa/virtualenv/issues/2939
    "test_py_info_cache_invalidation_on_py_info_change"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ lib.optionals (pythonOlder "3.11") [ "test_help" ]
  ++ lib.optionals isPyPy [
    # encoding problems
    "test_bash"
    # permission error
    "test_can_build_c_extensions"
    # fails to detect pypy version
    "test_discover_ok"
<<<<<<< HEAD
    # type error
    "test_fallback_existent_system_executable"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "virtualenv" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tool to create isolated Python environments";
    mainProgram = "virtualenv";
    homepage = "http://www.virtualenv.org";
    changelog = "https://github.com/pypa/virtualenv/blob/${version}/docs/changelog.rst";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
