{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, FormEncode
, pastedeploy
, paste
, pydispatcher
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sqlobject";
  version = "3.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SQLObject";
    inherit version;
    hash = "sha256-/PPqJ/ha8GRQpY/uQOLIF0v90p9tZKrHTCMkusiIuEQ=";
  };

  propagatedBuildInputs = [
    FormEncode
    paste
    pastedeploy
    pydispatcher
  ];

  nativeCheckInputs = [
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
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
