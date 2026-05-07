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

buildPythonPackage (finalAttrs: {
  pname = "symfc";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symfc";
    repo = "symfc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Szj/s0ZsrpEFJMIo9p/9rDFd5yJiHky58Iab/k3log=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isx86_64 [
    # assert (np.float64(0.5555555555555556) == 1.0 ± 1.0e-06
    "test_fc_basis_set_o3"
  ];

  meta = {
    description = "Generate symmetrized force constants";
    homepage = "https://github.com/symfc/symfc";
    changelog = "https://github.com/symfc/symfc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
