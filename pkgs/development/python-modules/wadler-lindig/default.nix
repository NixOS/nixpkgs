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
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "wadler_lindig";
    tag = "v${version}";
    hash = "sha256-EO47eYZk3Hr4328liDmRfCbwi5NDJ4V9NUzk3bpY9IM=";
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
    changelog = "https://github.com/patrick-kidger/wadler_lindig/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
