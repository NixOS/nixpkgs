{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typing-inspection";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "typing-inspection";
    tag = "v${version}";
    hash = "sha256-MzOXl1i+rmr08TSH3Nxc0fFkcjATY6i9dFRLsYp+5m0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "typing_inspection" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pydantic/typing-inspection/blob/${src.tag}/HISTORY.md";
    description = "Runtime typing introspection tools";
    homepage = "https://github.com/pydantic/typing-inspection";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
