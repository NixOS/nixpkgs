{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jsonref,
  jsonschema,
  numpy,
  pydantic,
  pyyaml,
  scikit-learn,
  scipy,

  # tests
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sweeps";
  version = "0.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wandb";
    repo = "sweeps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QqtyYpPChPNFN+3Rlpp1x1H0FFgxHPO3zFGcY6Pl24A=";
  };

  # Requires unpackaged pytest-profiling
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--profile" ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    jsonref
    jsonschema
    numpy
    pydantic
    pyyaml
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "sweeps" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: assert [] == [SweepRun(nam...running=None)]
    "test_5runs_band1_stop_2"
    "test_5runs_band1_stop_2_1stnoband"
    "test_eta_3"
    "test_eta_3_max"

    # AssertionError: assert [] == [10, 6, 1]
    "test_skipped_steps"

    # ValueError: Cannot extract metric loss from run
    "test_runs_bayes_runs2"

    # KeyError: 'loss is not a summary metric of this run.'
    "test_summary_metric_none"

    # AssertionError: Not equal to tolerance rtol=1e-07, atol=0.01
    "test_bayes_impute_best"
    "test_bayes_impute_latest"
  ];

  meta = {
    description = "W&B Hyperparameter Sweep Engine";
    homepage = "https://github.com/wandb/sweeps";
    changelog = "https://github.com/wandb/sweeps/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
