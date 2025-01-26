{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "truncnorm";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jluttine";
    repo = "truncnorm";
    tag = version;
    hash = "sha256-F+RBXN/pjxmHf26/Vxptz1NbF58eqU018l3zmepSoJk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
  ];

  # No checks
  doCheck = false;

  pythonImportsCheck = [ "truncnorm" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/truncnorm";
    description = "Moments for doubly truncated multivariate normal distributions";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
