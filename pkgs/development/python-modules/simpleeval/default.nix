{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "1.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danthedeckie";
    repo = pname;
    tag = version;
    hash = "sha256-CwCuQ/wd8nLKKXji2dzz9mvZrQEm2/kEm93Pan/8+90=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test_simpleeval.py" ];

  pythonImportsCheck = [ "simpleeval" ];

  meta = with lib; {
    description = "Simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    changelog = "https://github.com/danthedeckie/simpleeval/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ johbo ];
  };
}
