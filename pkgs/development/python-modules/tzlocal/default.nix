{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
<<<<<<< HEAD
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytz-deprecation-shim
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tzlocal";
<<<<<<< HEAD
  version = "4.3"; # version needs to be compatible with APScheduler

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PyHQnhsqqfLazKEtokDKN947pSN6k63f1tWTr+kHM1U=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
  version = "4.2"; # version needs to be compatible with APScheduler

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    pytz-deprecation-shim
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    "test_conflicting"
    "test_noconflict"
    "test_symlink_localtime"
  ] ++ lib.optional stdenv.isDarwin "test_assert_tz_offset";

  pythonImportsCheck = [ "tzlocal" ];

  meta = with lib; {
    description = "Tzinfo object for the local timezone";
    homepage = "https://github.com/regebro/tzlocal";
    changelog = "https://github.com/regebro/tzlocal/blob/${version}/CHANGES.txt";
    license = licenses.cddl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
