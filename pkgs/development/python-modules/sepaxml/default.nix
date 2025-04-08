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
  version = "2.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-sepaxml";
    rev = version;
    hash = "sha256-l5UMy0M3Ovzb6rcSAteGOnKdmBPHn4L9ZWY+YGOCn40=";
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
