{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  lxml,
  pytestCheckHook,
  text-unidecode,
  xmlschema,
}:

buildPythonPackage rec {
  pname = "sepaxml";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-sepaxml";
    rev = version;
    hash = "sha256-SSkqHLP4I3C48209+89omWcD66QBJOjkUh+4qPNzOZ0=";
  };

  propagatedBuildInputs = [
    text-unidecode
    xmlschema
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sepaxml" ];

  meta = with lib; {
    description = "SEPA Direct Debit XML generation in python";
    homepage = "https://github.com/raphaelm/python-sepaxml/";
    license = licenses.mit;
  };
}
