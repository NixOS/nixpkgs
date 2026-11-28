{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  polib,
  regex,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-lint";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "sphinx-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cg/14asXB1ivKSoGuLghne7kmQiXuimYTUqmdVqba6M=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    polib
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "sphinxlint" ];

  meta = {
    description = "Check for stylistic and formal issues in .rst and .py files included in the documentation";
    homepage = "https://github.com/sphinx-contrib/sphinx-lint";
    changelog = "https://github.com/sphinx-contrib/sphinx-lint/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "sphinx-lint";
  };
})
