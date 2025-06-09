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
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "typing-inspection";
    tag = "v${version}";
    hash = "sha256-sWWO+TRqNf791s+q5YeEcl9ZMHCBuxQLGXHmEk1AU0Y=";
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
    changelog = "https://github.com/pydantic/typing-inspection/releases/tag/${src.tag}";
    description = "Runtime typing introspection tools";
    homepage = "https://github.com/pydantic/typing-inspection";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
