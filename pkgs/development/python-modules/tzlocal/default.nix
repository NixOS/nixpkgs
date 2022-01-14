{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytz-deprecation-shim
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "4.1"; # version needs to be compatible with APScheduler

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DygBWsaKXAZyEEAKkZf8XTa6m8P46vHaPL1ZrN/tngk=";
  };

  propagatedBuildInputs = [
    pytz-deprecation-shim
  ];

  checkInputs = [
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
    license = licenses.cddl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
