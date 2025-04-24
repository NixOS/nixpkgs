{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "test-results-parser";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "test_results_parser";
    hash = "sha256-DaUSTu4Hg9SbJwBd3PlMcIAm/o63Q1yM5E7dVxbOwM8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-dhreAWm/Hses/N3XocYX7IZru9nYJqDrmTnJPkKaOwY=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImpotsCheck = [
    "test_results_parser"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Codecov test results parser";
    homepage = "https://github.com/codecov/test-results-parser";
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
}
