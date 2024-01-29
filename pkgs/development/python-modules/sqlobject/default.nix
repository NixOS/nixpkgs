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
  version = "3.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SQLObject";
    inherit version;
    hash = "sha256-QrGyrM6e1cxCtF4GxoivXU/Gj2H8VnG7EFcgimLfdng=";
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
    homepage = "https://www.sqlobject.org/";
    changelog = "https://github.com/sqlobject/sqlobject/blob/${version}/docs/News.rst";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
