{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  sphinx,
  sphinx-markdown-builder,
  langchain-ollama,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "sphinx-llm";
  version = "0.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "sphinx-llm";
    tag = finalAttrs.version;
    hash = "sha256-hrJ2g4Zcjs0ojueCtrMpsMv1MRwd5kuBFYI4cnhPZrs=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    sphinx
    sphinx-markdown-builder
    langchain-ollama
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "sphinx_llm.txt"
    "sphinx_llm.docref"
  ];

  meta = {
    description = "LLM extensions for Sphinx Documentation";
    homepage = "https://github.com/NVIDIA/sphinx-llm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
  };
})
