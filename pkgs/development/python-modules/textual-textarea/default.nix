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
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    tag = "v${version}";
    hash = "sha256-y+2WvqD96eYkDEJn5qCGfGFNiJFAcF4KWWNgAIZUqJo=";
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

  disabledTests = [
    # AssertionError: assert None == 'word'
    # https://github.com/tconbeer/textual-textarea/issues/312
    "test_autocomplete"
    "test_autocomplete_with_types"
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
