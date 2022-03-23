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
  version = "2.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o25132x2fL9G9hqRxws7pxgR36CspKMk2UB6Bqi3ouc=";
  };

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

  disabledTests = [
    # probably failing because of an encoding related issue
    "test_create_wrong_encoding"
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
    # error: use of undeclared identifier 'kFSEventStreamEventFlagItemCloned'
    # builds fine on aarch64-darwin
    broken = stdenv.isDarwin && !stdenv.isAarch64;
  };
}
