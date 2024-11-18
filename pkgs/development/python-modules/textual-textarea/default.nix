{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pyperclip,
  textual,
}:

buildPythonPackage rec {
  pname = "textual-textarea";
  version = "0.14.4";
  pyproject = true;

  src = fetchPypi {
    pname = "textual_textarea";
    inherit version;
    hash = "sha256-VgSJF5sZQmuFRrhSF1Cs3iL1cCGzr8CLBkNVcEj7cxU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyperclip
    textual
  ];

  pythonImportsCheck = [
    "textual_textarea"
  ];

  meta = {
    description = "A text area (multi-line input) with syntax highlighting for Textual";
    homepage = "https://pypi.org/project/textual-textarea/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
