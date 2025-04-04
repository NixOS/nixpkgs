{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  textual,
  typing-extensions,
  hatchling,
}:
buildPythonPackage rec {
  pname = "textual-autocomplete";
  version = "4.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "textual_autocomplete";
    inherit version;
    hash = "sha256-P8s1P+u/xRBj+ExnOyaw9Cf/e9RX6y+wBuNYRiE/3So=";
  };

  build-system = [
    poetry-core
    hatchling
  ];

  dependencies = [
    textual
    typing-extensions
  ];

  pythonImportsCheck = [
    "textual"
    "typing_extensions"
  ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "Python library that provides autocomplete capabilities to textual";
    homepage = "https://github.com/darrenburns/textual-autocomplete";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jorikvanveen ];
  };
}
