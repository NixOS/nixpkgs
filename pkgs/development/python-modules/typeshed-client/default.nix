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
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JelleZijlstra";
    repo = "typeshed_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-TZMCitRQlPLZyXJbPmK7SVAcGAyxWDk/y7Gzj24mgIQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    importlib-resources
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "typeshed_client" ];

  pytestFlagsArray = [ "tests/test.py" ];

  meta = with lib; {
    description = "Retrieve information from typeshed and other typing stubs";
    homepage = "https://github.com/JelleZijlstra/typeshed_client";
    changelog = "https://github.com/JelleZijlstra/typeshed_client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
