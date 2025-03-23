{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  pyperclip,
  textual,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "textual-textarea";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    tag = "v${version}";
    hash = "sha256-aaeXgD6RMQ3tlK5H/2lk3ueTyA3yYjHrYL51w/1tvSI=";
  };

  patches = [
    # https://github.com/tconbeer/textual-textarea/issues/296
    ./textual-2.0.0.diff
  ];

  pythonRelaxDeps = [
    "textual"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    pyperclip
    textual
  ] ++ textual.optional-dependencies.syntax;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "textual_textarea" ];

  disabledTestPaths = [
    # https://github.com/tconbeer/textual-textarea/issues/296
    "tests/functional_tests/test_textarea.py"
  ];

  meta = {
    description = "A text area (multi-line input) with syntax highlighting for Textual";
    homepage = "https://github.com/tconbeer/textual-textarea";
    changelog = "https://github.com/tconbeer/textual-textarea/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
