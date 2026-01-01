{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "test-results-parser";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "test_results_parser";
<<<<<<< HEAD
    hash = "sha256-Xqktx66EvYnpw/w3UxfYXJgfnROcPMobCv4W2W405/Y=";
=======
    hash = "sha256-L7/YCaLB90Y2AUaAm23zBpDJkkY9fUPnsf7THBp8FbQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-xnX9YwRHo5vFcF4HDj9K/hLV88ZB0UZdpx8RdA+EmrU=";
=======
    hash = "sha256-v82SRGqdcwyaRYpQhDETA/UZYSGD+FBZpysU7zfulrM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
