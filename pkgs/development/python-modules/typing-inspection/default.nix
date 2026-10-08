{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "typing-inspection";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "typing-inspection";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jNAMYV9mpUnClLOahQyLisBkOfELcmjKavKJgyxkQr4=";
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
    changelog = "https://github.com/pydantic/typing-inspection/blob/${finalAttrs.src.tag}/HISTORY.md";
    description = "Runtime typing introspection tools";
    homepage = "https://github.com/pydantic/typing-inspection";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
