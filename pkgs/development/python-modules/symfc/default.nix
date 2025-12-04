{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,
  spglib,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "symfc";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symfc";
    repo = "symfc";
    tag = "v${version}";
    hash = "sha256-YDVO1/vt30ZaBOTCaYBtr3fkcuJmPa8Eg72k3XWpacg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    spglib
  ];

  pythonImportsCheck = [ "symfc" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # assert (np.float64(0.5555555555555556) == 1.0 ± 1.0e-06
    "test_fc_basis_set_o3"
  ];

  meta = {
    description = "Generate symmetrized force constants";
    homepage = "https://github.com/symfc/symfc";
    changelog = "https://github.com/symfc/symfc/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
