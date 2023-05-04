{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, expecttest
, pytest-timeout
, huggingface-hub
, pyyaml
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "timm";
  version = "0.6.12";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    rev = "refs/tags/v${version}";
    hash = "sha256-RNjCcCnNhtr5a+29Bx+k427a03MSooqvnuiDQ8cT8FA=";
  };

  propagatedBuildInputs = [
    huggingface-hub
    pyyaml
    torch
    torchvision
  ];

  nativeCheckInputs = [ expecttest pytestCheckHook pytest-timeout ];
  pytestFlagsArray = [ "tests" ];
  # takes too long and also tries to download models:
  disabledTestPaths = [ "tests/test_models.py" ];

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
