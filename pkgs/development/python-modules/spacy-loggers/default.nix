{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, wandb
, wasabi
}:

buildPythonPackage rec {
  pname = "spacy-loggers";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-511E9M+Z5nY9cTLKfIxCDgqSeQIioIvI654k6iwTU24=";
  };

  propagatedBuildInputs = [
    wandb
    wasabi
  ];

  pythonImportsCheck = [ "spacy_loggers" ];

  # skipping the checks, becaus it requires a cycle dependency to spacy as well.
  doCheck = false;

  meta = with lib; {
    description = "Logging utilities for spaCy";
    homepage = "https://github.com/explosion/spacy-loggers";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
  };
}
