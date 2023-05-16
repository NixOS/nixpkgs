{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, expecttest
, pytest-timeout
, huggingface-hub
, pyyaml
<<<<<<< HEAD
, safetensors
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "timm";
<<<<<<< HEAD
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.6.12";
  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-gYrc8ds6urZvwDsTnzPjxjSTiAGzUD3RlCf0wogCrDI=";
=======
    hash = "sha256-RNjCcCnNhtr5a+29Bx+k427a03MSooqvnuiDQ8cT8FA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    huggingface-hub
    pyyaml
<<<<<<< HEAD
    safetensors
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    torch
    torchvision
  ];

<<<<<<< HEAD
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
=======
  nativeCheckInputs = [ expecttest pytestCheckHook pytest-timeout ];
  pytestFlagsArray = [ "tests" ];
  # takes too long and also tries to download models:
  disabledTestPaths = [ "tests/test_models.py" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
