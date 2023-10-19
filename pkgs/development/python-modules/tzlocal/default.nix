{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, wheel
, pytz-deprecation-shim
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tzlocal";
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
