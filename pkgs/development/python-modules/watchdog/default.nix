{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pathtools
, pyyaml
, flaky
, pytest-timeout
, pytestCheckHook
, CoreServices
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.1.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43ce20ebb36a51f21fa376f76d1d4692452b2527ccd601950d69ed36b9e21609";
  };

  patches = lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    ./force-kqueue.patch
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  propagatedBuildInputs = [
    pathtools
    pyyaml
  ];

  checkInputs = [
    flaky
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=watchdog" "" \
      --replace "--cov-report=term-missing" ""
  '';

  disabledTests = lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    "test_delete"
  ];

  disabledTestPaths = [
    # Tests are flaky
    "tests/test_inotify_buffer.py"
  ];

  pythonImportsCheck = [
    "watchdog"
  ];

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
