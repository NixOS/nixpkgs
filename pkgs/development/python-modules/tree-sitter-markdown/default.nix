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
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-markdown";
    tag = "v${version}";
    hash = "sha256-JJCFksPDwaiOmU+nZ3PHeLHlPKWTZBTnqcD/tQorWdU=";
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
    changelog = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      gepbird
    ];
  };
}
