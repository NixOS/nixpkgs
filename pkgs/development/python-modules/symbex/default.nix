{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  pytestCheckHook,
  pyyaml,
  pytest-icdiff,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "symbex";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "symbex";
    tag = version;
    hash = "sha256-swg98z4DpQJ5rq7tdsd3FofbYF7O5S+9ZR0weoM2DoI=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  pythonImportsCheck = [ "symbex" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    pytest-icdiff
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Ask questions of LLM documentation using LLM";
    homepage = "https://github.com/simonw/llm-docs";
    changelog = "https://github.com/simonw/llm-docs/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
