{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "test-results-parser";
  version = "0.5.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "test_results_parser";
    hash = "sha256-L7/YCaLB90Y2AUaAm23zBpDJkkY9fUPnsf7THBp8FbQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-v82SRGqdcwyaRYpQhDETA/UZYSGD+FBZpysU7zfulrM=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [
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
