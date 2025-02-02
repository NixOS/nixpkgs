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
  version = "0.14.2";
  pyproject = true;

  src = fetchPypi {
    pname = "textual_textarea";
    inherit version;
    hash = "sha256-AJU7BBoev6pBrLhvbfF4I7l+E8YnO5jCD5OIsNf6NW0=";
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
