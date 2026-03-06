{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  wandb,
  wasabi,

  # tests
  pytestCheckHook,
  spacy,
  spacy-loggers,
}:

buildPythonPackage (finalAttrs: {
  pname = "spacy-loggers";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-loggers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kl8FSs+sbIF2Ml5AJhP5aY7lWnDLqUr7QBAq+63SW5Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    wandb
    wasabi
  ];

  pythonImportsCheck = [ "spacy_loggers" ];

  nativeCheckInputs = [
    spacy
    pytestCheckHook
  ];
  # skipping the checks, because it requires a cycle dependency to spacy as well.
  doCheck = false;

  passthru = {
    tests.pytest = spacy-loggers.overridePythonAttrs {
      doCheck = true;
    };
  };

  meta = {
    description = "Logging utilities for spaCy";
    homepage = "https://github.com/explosion/spacy-loggers";
    changelog = "https://github.com/explosion/spacy-loggers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stunkymonkey ];
  };
})
