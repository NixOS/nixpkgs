{ lib
, stdenv
, buildPythonPackage
, CoreServices
, fetchpatch
, fetchPypi
, flaky
, pathtools
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g8+Lxg2cYTtmpMAYBRhz1ic9nkXQQO7QbWqWJBvY7AE=";
  };

  patches = lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    ./force-kqueue.patch
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  propagatedBuildInputs = [
    pathtools
    pyyaml
  ];

  nativeCheckInputs = [
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
  ] ++ lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    "test_delete"
    "test_separate_consecutive_moves"
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
    changelog = "https://github.com/gorakhargosh/watchdog/blob/v${version}/changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
