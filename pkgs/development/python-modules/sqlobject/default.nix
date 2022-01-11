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
  version = "3.9.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "SQLObject";
    inherit version;
    sha256 = "45064184decf7f42d386704e5f47a70dee517d3e449b610506e174025f84d921";
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
