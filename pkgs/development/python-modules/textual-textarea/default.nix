{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pyperclip,
  textual,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  tree-sitter-python,
  tree-sitter-sql,
}:

buildPythonPackage rec {
  pname = "textual-textarea";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    tag = "v${version}";
    hash = "sha256-AIt3UqfZbJBgAACxJHElhvAsJWk9I6zjdeRjBtI/FiA=";
  };

  pythonRelaxDeps = [
    "textual"
    "tree-sitter-sql"
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    pyperclip
    textual
  ]
  ++ textual.optional-dependencies.syntax;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    tree-sitter-python
    tree-sitter-sql
  ];

  pythonImportsCheck = [ "textual_textarea" ];

  meta = {
    description = "Text area (multi-line input) with syntax highlighting for Textual";
    homepage = "https://github.com/tconbeer/textual-textarea";
    changelog = "https://github.com/tconbeer/textual-textarea/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
