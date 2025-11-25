{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-resources,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typeshed-client";
  version = "2.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JelleZijlstra";
    repo = "typeshed_client";
    tag = "v${version}";
    hash = "sha256-+muWm2/Psp8V1n7mEloc+ltuwHG/uRvDUgSFRNzz5EQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    importlib-resources
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "typeshed_client" ];

  enabledTestPaths = [ "tests/test.py" ];

  meta = with lib; {
    description = "Retrieve information from typeshed and other typing stubs";
    homepage = "https://github.com/JelleZijlstra/typeshed_client";
    changelog = "https://github.com/JelleZijlstra/typeshed_client/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
