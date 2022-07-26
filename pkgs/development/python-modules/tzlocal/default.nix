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
  version = "4.2"; # version needs to be compatible with APScheduler

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7";
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
    changelog = "https://github.com/regebro/tzlocal/blob/${version}/CHANGES.txt";
    license = licenses.cddl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
