{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typeshed-client";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JelleZijlstra";
    repo = "typeshed_client";
    tag = "v${version}";
    hash = "sha256-c28oGVzWS0S5JSZHORTto4exNJUDjixLaA1yVsmdh2s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "typeshed_client" ];

  enabledTestPaths = [ "tests/test.py" ];

  meta = {
    description = "Retrieve information from typeshed and other typing stubs";
    homepage = "https://github.com/JelleZijlstra/typeshed_client";
    changelog = "https://github.com/JelleZijlstra/typeshed_client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
