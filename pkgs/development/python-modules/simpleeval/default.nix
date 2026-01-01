{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = "simpleeval";
    tag = version;
    hash = "sha256-CwCuQ/wd8nLKKXji2dzz9mvZrQEm2/kEm93Pan/8+90=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_simpleeval.py" ];

  pythonImportsCheck = [ "simpleeval" ];

<<<<<<< HEAD
  meta = {
    description = "Simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    changelog = "https://github.com/danthedeckie/simpleeval/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johbo ];
=======
  meta = with lib; {
    description = "Simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    changelog = "https://github.com/danthedeckie/simpleeval/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ johbo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
