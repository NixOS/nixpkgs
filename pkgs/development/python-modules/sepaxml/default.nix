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
  version = "2.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-sepaxml";
    rev = version;
    hash = "sha256-T+pHspKUxH/mW+pnotQ9I0EXX1EjgFwtP9za41BySuE=";
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
