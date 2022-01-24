{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, flaky
, pytestCheckHook
, CoreServices
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N2y8KjXAOSsP5/8W+8GzA/2Z1N2ZEatVge6daa3IiYI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  propagatedBuildInputs = [
    argh
    pathtools
    pyyaml
  ];

  checkInputs = [
    flaky
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=watchdog" "" \
      --replace "--cov-report=term-missing" ""
  '';

  disabledTestPaths = [
    # Tests are flaky
    "tests/test_inotify_buffer.py"
  ];

  pytestFlagsArray = lib.optional stdenv.isDarwin [
    # fail in darwin sandbox
    "--deselect=tests/test_fsevents.py::test_unschedule_removed_folder"
    "--deselect=tests/test_fsevents.py::test_watchdog_recursive"
  ];

  pythonImportsCheck = [
    "watchdog"
  ];

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
  };
}
