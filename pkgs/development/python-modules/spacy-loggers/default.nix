{
  lib,
  fetchPypi,
  buildPythonPackage,
  wandb,
  wasabi,
}:

buildPythonPackage rec {
  pname = "spacy-loggers";
  version = "1.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1gsL2/kVpg5RbMLmU7rv+Ubwz8RhtFLRGk1UWMb+XyQ=";
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
