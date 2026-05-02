{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "simpleeval";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = "simpleeval";
    tag = finalAttrs.version;
    hash = "sha256-w3Ukb1W5DV9LVcV4IyraBsaFjOgoOoxzQ62N3BBxk1M=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_simpleeval.py" ];

  pythonImportsCheck = [ "simpleeval" ];

  meta = {
    description = "Simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    changelog = "https://github.com/danthedeckie/simpleeval/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johbo ];
  };
})
