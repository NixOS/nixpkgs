{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  dill,
  numpy,
  pandas,
  sortedcontainers,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "syne-tune";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "syne-tune";
    repo = "syne-tune";
    rev = "v${version}";
    hash = "sha256-yurUrztmeW5n3EPhTf12SOebncEPIwbMEzfF5+tNxRw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    dill
    numpy
    pandas
    sortedcontainers
    typing-extensions
  ];

  pythonImportsCheck = [
    "syne_tune"
  ];

  meta = {
    description = "Large scale and asynchronous Hyperparameter and Architecture Optimization at your fingertips";
    homepage = "https://github.com/syne-tune/syne-tune";
    changelog = "https://github.com/syne-tune/syne-tune/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
