{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  julius,
  librosa,
  torch,
  torch-pitch-shift,
  torchaudio,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torch-audiomentations";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "torch-audiomentations";
    tag = "v${version}";
    hash = "sha256-5ccVO1ECiIn0q7m8ZLHxqD2fhaXeMDKUEswa49dRTsY=";
  };

  pythonRelaxDeps = [ "torchaudio" ];

  build-system = [ setuptools ];

  dependencies = [
    julius
    librosa
    torch
    torch-pitch-shift
    torchaudio
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

  disabledTests = [
    # AttributeError: module 'torchaudio' has no attribute 'info'
    # Removed in torchaudio v2.9.0
    # See https://github.com/pytorch/audio/issues/3902 for context
    # Reported to torch-audiomentations: https://github.com/iver56/torch-audiomentations/issues/184
    "test_background_noise_no_guarantee_with_empty_tensor"
    "test_colored_noise_guaranteed_with_batched_tensor"
    "test_colored_noise_guaranteed_with_single_tensor"
    "test_colored_noise_guaranteed_with_zero_length_samples"
    "test_colored_noise_no_guarantee_with_single_tensor"
    "test_same_min_max_f_decay"
    "test_transform_is_differentiable"
  ];

  meta = {
    description = "Fast audio data augmentation in PyTorch";
    homepage = "https://github.com/asteroid-team/torch-audiomentations";
    changelog = "https://github.com/asteroid-team/torch-audiomentations/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
