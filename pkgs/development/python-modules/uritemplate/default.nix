{ lib
, buildPythonPackage
, fetchPypi
, simplejson
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "4.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q0bt/Fw7efaUvM1tYJmjIrvrYo2/LNhu6lWkVs5RJPA=";
  };

  propagatedBuildInputs = [
    simplejson
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "uritemplate"
  ];

  meta = with lib; {
    description = "Implementation of RFC 6570 URI templates";
    homepage = "https://github.com/python-hyper/uritemplate";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
