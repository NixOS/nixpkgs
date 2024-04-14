{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "5.2"; # version needs to be compatible with APScheduler

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jTmSBVePGpNCgWQJzB5GqT69V1XjnqLYUzS+qRG/Dm4=";
  };

  nativeBuildInputs = [
    setuptools
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
