{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pdm-backend
, huggingface-hub
, pyyaml
, safetensors
, torch
, torchvision
, expecttest
, pytestCheckHook
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "timm";
  version = "0.9.16";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    rev = "refs/tags/v${version}";
    hash = "sha256-IWEDKuI2565Z07q1MxTpzKS+CROPR6SyaD5fKcQ5eXk=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

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
