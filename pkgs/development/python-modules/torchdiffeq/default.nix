{ lib
, buildPythonPackage
, fetchPypi

# dependencies
, torch
, scipy

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "torchdiffeq";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/nX0NLkJCsDCdwLgK+0hRysPhwNb5lgfUe3F1AE+oxo=";
  };

  propagatedBuildInputs = [
    torch
    scipy
  ];

  pythonImportsCheck = [ "torchdiffeq" ];

  # no tests in sdist, no tags on git
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Differentiable ODE solvers with full GPU support and O(1)-memory backpropagation";
    homepage = "https://github.com/rtqichen/torchdiffeq";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
