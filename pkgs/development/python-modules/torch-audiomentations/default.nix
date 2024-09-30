{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  julius,
  librosa,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  torch-pitch-shift,
  torch,
  torchaudio,
}:

buildPythonPackage rec {
  pname = "torch-audiomentations";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "torch-audiomentations";
    rev = "refs/tags/v${version}";
    hash = "sha256-0+5wc+mP4c221q6mdaqPalfumTOtdnkjnIPtLErOp9E=";
  };

  pythonRelaxDeps = [ "torchaudio" ];

  build-system = [ setuptools ];

  dependencies = [
    julius
    librosa
    torch
    torchaudio
    torch-pitch-shift
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "torch_audiomentations" ];

  disabledTestPaths = [
    # librosa issues
    "tests/test_mix.py"
    "tests/test_convolution.py"
    "tests/test_impulse_response.py"
    "tests/test_background_noise.py"
  ];

  disabledTests = [ "test_transform_is_differentiable" ];

  meta = with lib; {
    description = "Fast audio data augmentation in PyTorch";
    homepage = "https://github.com/asteroid-team/torch-audiomentations";
    changelog = "https://github.com/asteroid-team/torch-audiomentations/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
