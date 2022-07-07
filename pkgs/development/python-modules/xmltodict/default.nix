{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.13.0";
  format = "setuptools";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NBWVpIjj4BqFqdiRHYkS/ZIu3l/sxNzkN+tLbI0DflY=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xmltodict" ];

  meta = with lib; {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
