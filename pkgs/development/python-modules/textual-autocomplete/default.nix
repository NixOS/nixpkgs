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
  version = "4.0.6";
  pyproject = true;

  src = fetchPypi {
    pname = "textual_autocomplete";
    inherit version;
    hash = "sha256-K6Lw12e+RIDsrLPksTDPBzQOAzw1APxCT+2RJdJ6RYY=";
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
