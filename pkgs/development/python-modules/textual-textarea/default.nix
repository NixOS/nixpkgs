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
  version = "0.14.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    rev = "refs/tags/v${version}";
    hash = "sha256-tmbSCU1VgxR9aXG22UVpweD71dVmhKSRBTDm1Gf33jM=";
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
