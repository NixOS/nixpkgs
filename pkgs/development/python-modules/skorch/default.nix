{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  numpy,
  scikit-learn,
  scipy,
  tabulate,
  torch,
  tqdm,
  flaky,
  pandas,
  pytestCheckHook,
  safetensors,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "skorch";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JcplwaeYlGRAJXRNac1Ya/hgWoHE+NWjZhCU9eaSyRQ=";
  };

  disabled = pythonOlder "3.8";

  propagatedBuildInputs = [
    numpy
    scikit-learn
    scipy
    tabulate
    torch
    tqdm
  ];

  nativeCheckInputs = [
    flaky
    pandas
    pytestCheckHook
    safetensors
  ];

  # patch out pytest-cov dep/invocation
  postPatch = ''
    substituteInPlace setup.cfg  \
      --replace "--cov=skorch" ""  \
      --replace "--cov-report=term-missing" ""  \
      --replace "--cov-config .coveragerc" ""
  '';

  disabledTests =
    [
      # on CPU, these expect artifacts from previous GPU run
      "test_load_cuda_params_to_cpu"
      # failing tests
      "test_pickle_load"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # there is a problem with the compiler selection
      "test_fit_and_predict_with_compile"
    ]
    ++ lib.optionals (pythonAtLeast "3.11") [
      # Python 3.11+ not yet supported for torch.compile
      # https://github.com/pytorch/pytorch/blob/v2.0.1/torch/_dynamo/eval_frame.py#L376-L377
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

  meta = with lib; {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
