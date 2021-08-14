{ lib
, backports-zoneinfo
, buildPythonPackage
, fetchPypi
, pytz
, pythonOlder
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9ObjbbUEmeDZL3m2c2EEHwSOJgnRZuk0VrUHRtxK7xI=";
  };

  propagatedBuildInputs = [
    pytz
  ]  ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Timezone test fail
    "test_symlink_localtime"
  ];

  pythonImportsCheck = [ "tzlocal" ];

  meta = with lib; {
    description = "Tzinfo object for the local timezone";
    homepage = "https://github.com/regebro/tzlocal";
    license = licenses.cddl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
