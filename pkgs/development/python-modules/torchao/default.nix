{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  torch,

  # tests
  bitsandbytes,
  expecttest,
  fire,
  pytest-xdist,
  pytestCheckHook,
  parameterized,
  tabulate,
  transformers,
  unittest-xml-reporting,
}:

buildPythonPackage rec {
  pname = "ao";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "ao";
    tag = "v${version}";
    hash = "sha256-R9H4+KkKuOzsunM3A5LT8upH1TfkHrD+BZerToCHwjo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
  ];

  env = {
    USE_SYSTEM_LIBS = true;
  };

  # Otherwise, the tests are loading the python module from the source instead of the installed one
  preCheck = ''
    rm -rf torchao
  '';

  pythonImportsCheck = [
    "torchao"
  ];

  nativeCheckInputs = [
    bitsandbytes
    expecttest
    fire
    parameterized
    pytest-xdist
    pytestCheckHook
    tabulate
    transformers
    unittest-xml-reporting
  ];

  disabledTests = [
    # Requires internet access
    "test_on_dummy_distilbert"

    # FileNotFoundError: [Errno 2] No such file or directory: 'checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth'
    "test_gptq_mt"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # AssertionError: tensor(False) is not true
    "test_quantize_per_token_cpu"

    # RuntimeError: failed to initialize QNNPACK
    "test_smooth_linear_cpu"

    # torch._inductor.exc.InductorError: LoweringException: AssertionError: Expect L1_cache_size > 0 but got 0
    "test_int8_weight_only_quant_with_freeze_0_cpu"
    "test_int8_weight_only_quant_with_freeze_1_cpu"
    "test_int8_weight_only_quant_with_freeze_2_cpu"

    # FileNotFoundError: [Errno 2] No such file or directory: 'test.pth'
    "test_save_load_int4woqtensors_2_cpu"
    "test_save_load_int8woqtensors_0_cpu"
    "test_save_load_int8woqtensors_1_cpu"
  ];

  meta = {
    description = "PyTorch native quantization and sparsity for training and inference";
    homepage = "https://github.com/pytorch/ao";
    changelog = "https://github.com/pytorch/ao/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
