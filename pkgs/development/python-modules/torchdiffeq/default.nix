{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  # dependencies
  torch,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torchdiffeq";
  version = "0.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tQ03YNE/0TjczqxlH0uAOW9E/vzr0DegM/7P6qnMEuc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    torch
    scipy
  ];

  pythonImportsCheck = [ "torchdiffeq" ];

  # no tests in sdist, no tags on git
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Differentiable ODE solvers with full GPU support and O(1)-memory backpropagation";
    homepage = "https://github.com/rtqichen/torchdiffeq";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
}
