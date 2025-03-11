{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyperclip,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  textual,
}:

buildPythonPackage rec {
  pname = "textual-textarea";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    tag = "v${version}";
    hash = "sha256-aaeXgD6RMQ3tlK5H/2lk3ueTyA3yYjHrYL51w/1tvSI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyperclip
    textual
  ] ++ textual.optional-dependencies.syntax;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textual_textarea" ];

  meta = {
    description = "A text area (multi-line input) with syntax highlighting for Textual";
    homepage = "https://github.com/tconbeer/textual-textarea";
    changelog = "https://github.com/tconbeer/textual-textarea/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
