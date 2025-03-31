{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  huggingface-hub,
  pyyaml,
  safetensors,
  torch,
  torchvision,

  # tests
  expecttest,
  pytestCheckHook,
  pytest-timeout,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "timm";
  version = "1.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    tag = "v${version}";
    hash = "sha256-TXc+D8GRrO46q88fOH44ZHKOGnCdP47ipEcobnGTxWU=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    huggingface-hub
    pyyaml
    safetensors
    torch
    torchvision
  ];

  nativeCheckInputs = [
    expecttest
    pytestCheckHook
    pytest-timeout
  ];

  pytestFlagsArray = [ "tests" ];

  disabledTests =
    lib.optionals
      (
        # RuntimeError: Dynamo is not supported on Python 3.13+
        (pythonAtLeast "3.13")

        # torch._dynamo.exc.BackendCompilerFailed: backend='inductor' raised:
        # CppCompileError: C++ compile error
        # OpenMP support not found.
        || stdenv.hostPlatform.isDarwin
      )
      [
        "test_kron"
      ];

  disabledTestPaths = [
    # Takes too long and also tries to download models
    "tests/test_models.py"
  ];

  pythonImportsCheck = [
    "timm"
    "timm.data"
  ];

  meta = {
    description = "PyTorch image models, scripts, and pretrained weights";
    homepage = "https://huggingface.co/docs/timm/index";
    changelog = "https://github.com/huggingface/pytorch-image-models/blob/v${version}/README.md#whats-new";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
