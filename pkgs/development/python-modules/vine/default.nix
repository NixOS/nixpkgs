{ lib
, buildPythonPackage
, case
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "vine";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fTsWJKlT2oLvY0YgE7vScdPrdXUUifmAdZjo80C9Y34=";
  };

  checkInputs = [
    case
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "vine"
  ];

  meta = with lib; {
    description = "Python promises";
    homepage = "https://github.com/celery/vine";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
