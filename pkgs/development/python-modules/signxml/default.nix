{
  lib,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitHub,
  lxml,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "signxml";
  version = "4.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "XML-Security";
    repo = "signxml";
    rev = "refs/tags/v${version}";
    hash = "sha256-TZqYNYVzGEhftP/RXiBtThK38AOPLi2DRAwnFh2Za5U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    cryptography
    lxml
    pyopenssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "signxml" ];

  pytestFlagsArray = [ "test/test.py" ];

  meta = with lib; {
    description = "Python XML Signature and XAdES library";
    homepage = "https://github.com/XML-Security/signxml";
    changelog = "https://github.com/XML-Security/signxml/blob/${src.rev}/Changes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
