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

buildPythonPackage (finalAttrs: {
  pname = "textual-textarea";
  version = "0.18.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ixSzT6Mxh7n7pLlXnb9y2XJoSUwcETpJ9qylON0NxIo=";
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
    changelog = "https://github.com/tconbeer/textual-textarea/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
})
