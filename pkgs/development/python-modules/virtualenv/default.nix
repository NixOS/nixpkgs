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
<<<<<<< HEAD
=======
, importlib-resources
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, platformdirs
, pytest-freezegun
, pytest-mock
, pytest-timeout
, pytestCheckHook
<<<<<<< HEAD
, time-machine
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "virtualenv";
<<<<<<< HEAD
  version = "20.24.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4qfO+dqIDWk7kz23ZUNndU8U4gZQ3GDo7nOFVx+Fk6M=";
=======
  version = "20.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N6ZAuoLtQLImWZxSLUEeS+XtszmgwN4DDA3HtkbWFZA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    distlib
    filelock
    platformdirs
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

<<<<<<< HEAD
=======
  patches = lib.optionals (isPy27) [
    ./0001-Check-base_prefix-and-base_exec_prefix-for-Python-2.patch
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    cython
    flaky
    pytest-freezegun
    pytest-mock
    pytest-timeout
    pytestCheckHook
<<<<<<< HEAD
  ] ++ lib.optionals (!isPyPy) [
    time-machine
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/pypa/virtualenv/blob/${version}/docs/changelog.rst";
=======
    changelog = "https://github.com/pypa/virtualenv/releases/tag/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
