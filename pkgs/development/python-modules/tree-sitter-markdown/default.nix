{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tree-sitter-markdown";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-markdown";
    tag = "v${version}";
    hash = "sha256-Oe2iL5b1Cyv+dK0nQYFNLCCOCe+93nojxt6ukH2lEmU=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_markdown" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  meta = {
    description = "Markdown grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
    changelog = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
