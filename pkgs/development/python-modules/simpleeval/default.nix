{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = "simpleeval";
    tag = version;
    hash = "sha256-+YSPRaX4kulUgPeKspCvJn29iFTfrPTbmWi6pSe7LSw=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_simpleeval.py" ];

  pythonImportsCheck = [ "simpleeval" ];

  meta = {
    description = "Simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    changelog = "https://github.com/danthedeckie/simpleeval/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johbo ];
  };
}
