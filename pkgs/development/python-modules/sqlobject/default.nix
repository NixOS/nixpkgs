{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, FormEncode
, pastedeploy
, paste
, pydispatcher
}:

buildPythonPackage rec {
  pname = "sqlobject";
  version = "3.10.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "SQLObject";
    inherit version;
    sha256 = "sha256-i/wBFu8z/DS5Gtj00ZKrbuPsvqDH3O5GmbrknGbvJ7A=";
  };

  propagatedBuildInputs = [
    FormEncode
    paste
    pastedeploy
    pydispatcher
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/sqlobject/sqlobject/issues/179
    "test_fail"
  ];

  pythonImportsCheck = [
    "sqlobject"
  ];

  meta = with lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
