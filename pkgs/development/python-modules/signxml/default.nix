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
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "signxml";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "XML-Security";
    repo = "signxml";
    tag = "v${version}";
    hash = "sha256-oyDhJZVn08rIcR3ti9jsYxyBPgz6VaJSbBVYrTQkbVU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    certifi
    cryptography
    lxml
    pyopenssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "signxml" ];

  enabledTestPaths = [ "test/test.py" ];

  meta = with lib; {
    description = "Python XML Signature and XAdES library";
    homepage = "https://github.com/XML-Security/signxml";
    changelog = "https://github.com/XML-Security/signxml/blob/${src.tag}/Changes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
