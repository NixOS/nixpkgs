{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  numpy,
  scikit-learn,
  scipy,
  setuptools,
  tabulate,
  torch,
  tqdm,
  flaky,
  llvmPackages,
  pandas,
  pytest-cov-stub,
  pytestCheckHook,
  safetensors,
  transformers,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "skorch";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skorch-dev";
    repo = "skorch";
    tag = "v${version}";
    sha256 = "sha256-f0g/kn3HhvYfGDgLpA7gAnYocJrYqHUq680KrGuoPCQ=";
  };

  # AttributeError: 'NoneType' object has no attribute 'span' with Python 3.13
  # https://github.com/skorch-dev/skorch/issues/1080
  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    scikit-learn
    scipy
    tabulate
    torch # implicit dependency
    tqdm
  ];

  nativeCheckInputs = [
    flaky
    pytest-cov-stub
    pytestCheckHook
    safetensors
    transformers
  ];

  checkInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  disabledTests = [
    # on CPU, these expect artifacts from previous GPU run
    "test_load_cuda_params_to_cpu"
    # failing tests
    "test_pickle_load"
    # there is a problem with the compiler selection
    "test_fit_and_predict_with_compile"
    # "Weights only load failed"
    "test_can_be_copied"
    "test_pickle"
    "test_pickle_save_load"
    "test_train_net_after_copy"
    "test_weights_restore"
    # Reported as flaky
    "test_fit_lbfgs_optimizer"
  ];

  disabledTestPaths = [
    # tries to download missing HuggingFace data
    "skorch/tests/test_dataset.py"
    "skorch/tests/test_hf.py"
    "skorch/tests/llm/test_llm_classifier.py"
    # These tests fail when running in parallel for all platforms with:
    # "RuntimeError: The server socket has failed to listen on any local
    # network address because they use the same hardcoded port."
    # This happens on every platform with sandboxing enabled.
    "skorch/tests/test_history.py"
  ];

  pythonImportsCheck = [ "skorch" ];

  meta = {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
    badPlatforms = [
      # Most tests fail with:
      # Fatal Python error: Segmentation fault
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
