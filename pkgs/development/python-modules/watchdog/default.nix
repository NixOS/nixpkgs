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
, fetchpatch
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.1.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q84g67NqUfIfo3b3bR1GkkUrJSfM1gGVDWntNrniFgk=";
  };

  patches = lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    ./force-kqueue.patch
  ] ++ [
    (fetchpatch {
      url = "https://github.com/gorakhargosh/watchdog/commit/255d1e45c17929dd5ba8a6f91aa28771109931cd.patch";
      sha256 = "sha256-gGgEGuB/0g+4Pv1dXMvIdObjqKruWKkxtufS/dzSlY8=";
      excludes = [ "changelog.rst" ];
    })
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

  disabledTests = [
    # probably failing because of an encoding related issue
    "test_create_wrong_encoding"
  ] ++ lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
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
