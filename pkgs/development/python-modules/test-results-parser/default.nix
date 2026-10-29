{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "test-results-parser";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "test_results_parser";
    hash = "sha256-Xqktx66EvYnpw/w3UxfYXJgfnROcPMobCv4W2W405/Y=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xnX9YwRHo5vFcF4HDj9K/hLV88ZB0UZdpx8RdA+EmrU=";
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
})
