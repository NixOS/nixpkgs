{
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
  cbor,
  numpy,
  fetchFromGitHub,
}:
buildPythonPackage {
  pname = "trec-car-tools";
  version = "unstable-2025-08-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Gurjaka";
    repo = "trec-car-tools";
    rev = "45c13c29d9729b201e09cf8ae5327cf25217d2ed";
    hash = "sha256-bivSQOSDC3v4Ex/XAHSqjiwKai24h0rcxa6+BpcefOM=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    cbor
    numpy
  ];

  pythonImportsCheck = [
    "trec_car"
  ];

  meta = {
    description = "Tools for working with the TREC CAR dataset";
    homepage = "https://github.com/Gurjaka/trec-car-tools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "trec-car-tools";
  };
}
