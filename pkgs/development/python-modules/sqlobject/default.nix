{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, formencode
, pastedeploy
, paste
, pydispatcher
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sqlobject";
  version = "3.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SQLObject";
    inherit version;
    hash = "sha256-dW9IsIdOSnCG3thWhYwIsz0Oa5runnXD84S5ITPH3ww=";
  };

  propagatedBuildInputs = [
    formencode
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
    changelog = "https://github.com/sqlobject/sqlobject/blob/${version}/docs/News.rst";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
