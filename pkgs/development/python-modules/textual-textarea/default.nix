{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pyperclip,
  textual,
  tree-sitter,
  tree-sitter-python,
  tree-sitter-sql,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textual-textarea";
  version = "0.17.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    tag = "v${version}";
    hash = "sha256-E6Yw/NRjfrdCeERgM0jdjfmG9zL2GhY2qAWUB1XwFic=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyperclip
    textual
    tree-sitter
    tree-sitter-python
    tree-sitter-sql
  ]
  ++ textual.optional-dependencies.syntax;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
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
