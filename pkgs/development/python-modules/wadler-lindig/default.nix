{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # tests
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wadler-lindig";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "wadler_lindig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qP826zdzR5BEQ8bGd45RFSLTH6Eal+b7UN+BW07/glo=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "wadler_lindig"
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  meta = {
    description = "Wadler--Lindig pretty printer for Python";
    homepage = "https://github.com/patrick-kidger/wadler_lindig";
    changelog = "https://github.com/patrick-kidger/wadler_lindig/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
