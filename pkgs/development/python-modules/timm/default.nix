{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, expecttest
, pytest-timeout
, huggingface-hub
, pyyaml
, safetensors
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "timm";
  version = "0.9.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    rev = "refs/tags/v${version}";
    hash = "sha256-poLyhwdpZpSH0w95Uj5n/fRoMe7fK0auMDWUna1d6/U=";
  };

  propagatedBuildInputs = [
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

  pytestFlagsArray = [
    "tests"
  ];

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

  meta = with lib; {
    description = "PyTorch image models, scripts, and pretrained weights";
    homepage = "https://huggingface.co/docs/timm/index";
    changelog = "https://github.com/huggingface/pytorch-image-models/blob/v${version}/README.md#whats-new";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
