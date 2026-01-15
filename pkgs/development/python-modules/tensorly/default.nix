{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tensorly";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tensorly";
    repo = "tensorly";
    tag = version;
    hash = "sha256-A6Zlp8fa7XFgf4qpg7SEtNLlYSNtDGLuRUEfzD+crQc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "tensorly"
    "tensorly.base"
    "tensorly.cp_tensor"
    "tensorly.tucker_tensor"
    "tensorly.tt_tensor"
    "tensorly.tt_matrix"
    "tensorly.parafac2_tensor"
    "tensorly.tenalg"
    "tensorly.decomposition"
    "tensorly.regression"
    "tensorly.solvers"
    "tensorly.metrics"
    "tensorly.random"
    "tensorly.datasets"
    "tensorly.plugins"
    "tensorly.contrib"
  ];

  enabledTestPaths = [ "tensorly" ];

  disabledTests = [
    # this can fail on hydra and other peoples machines, check with others before re-enabling
    # AssertionError: Partial_SVD took too long, maybe full_matrices set wrongly
    "test_svd_time"
  ];

  meta = {
    description = "Tensor learning in Python";
    homepage = "https://tensorly.org/";
    changelog = "https://github.com/tensorly/tensorly/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
