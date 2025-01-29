{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
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
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "skorch";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AguMhI/MO4DNexe5azVEXOw7laTRBN0ecFW81qqh0rY=";
  };

  # AttributeError: 'NoneType' object has no attribute 'span' with Python 3.13
  # https://github.com/skorch-dev/skorch/issues/1080
  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scikit-learn
    scipy
    tabulate
    torch # implicit dependency
    tqdm
  ];

  nativeCheckInputs = [
    flaky
    pandas
    pytest-cov-stub
    pytestCheckHook
    safetensors
  ];

  checkInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  disabledTests =
    [
      # on CPU, these expect artifacts from previous GPU run
      "test_load_cuda_params_to_cpu"
      # failing tests
      "test_pickle_load"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # there is a problem with the compiler selection
      "test_fit_and_predict_with_compile"
    ];

  disabledTestPaths =
    [
      # tries to import `transformers` and download HuggingFace data
      "skorch/tests/test_hf.py"
    ]
    ++ lib.optionals (stdenv.hostPlatform.system != "x86_64-linux") [
      # torch.distributed is disabled by default in darwin
      # aarch64-linux also failed these tests
      "skorch/tests/test_history.py"
    ];

  pythonImportsCheck = [ "skorch" ];

  meta = {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
