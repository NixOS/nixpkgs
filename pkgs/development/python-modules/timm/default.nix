{
  lib,
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

  # checks
  expecttest,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "timm";
  version = "1.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    rev = "refs/tags/v${version}";
    hash = "sha256-+e4+k1Oyxf94rLsOTWfMl5YWTteXgSoecvbyxL348kg=";
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

  disabledTestPaths = [
    # Takes too long and also tries to download models
    "tests/test_models.py"
  ];

  disabledTests = [
    # AttributeError: 'Lookahead' object has no attribute '_optimizer_step_pre...
    "test_lookahead"
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
