{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NBWVpIjj4BqFqdiRHYkS/ZIu3l/sxNzkN+tLbI0DflY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xmltodict" ];

  meta = with lib; {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
