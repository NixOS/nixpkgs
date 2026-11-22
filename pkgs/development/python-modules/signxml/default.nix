{
  lib,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage (finalAttrs: {
  pname = "signxml";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XML-Security";
    repo = "signxml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PU4VISGt2gEJ1NOYQjbrn6fZQIc4mARPr4LhpwQxQRs=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    certifi
    cryptography
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "signxml" ];

  enabledTestPaths = [ "test/test.py" ];

  meta = {
    description = "Python XML Signature and XAdES library";
    homepage = "https://github.com/XML-Security/signxml";
    changelog = "https://github.com/XML-Security/signxml/blob/${finalAttrs.src.tag}/Changes.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
