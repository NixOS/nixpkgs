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

buildPythonPackage rec {
  pname = "wadler-lindig";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "wadler_lindig";
    rev = "v${version}";
    hash = "sha256-akb1x9UYbfEwnVS6ahpb42XnEl3y7kk3WkhwD8p7AA4=";
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
    description = "A Wadler--Lindig pretty printer for Python";
    homepage = "https://github.com/patrick-kidger/wadler_lindig";
    changelog = "https://github.com/patrick-kidger/wadler_lindig/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
