{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, julius
, librosa
, torch
, torchaudio
, torch-pitch-shift
}:

buildPythonPackage rec {
  pname = "torch-audiomentations";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "torch-audiomentations";
    rev = "v${version}";
    hash = "sha256-r3J8yo3+jjuD4qqpC5Ax3TFPL9pGUNc0EksTkCTJKbU=";
  };

  propagatedBuildInputs = [
    julius
    librosa
    torch
    torchaudio
    torch-pitch-shift
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "torch_audiomentations" ];

  meta = with lib; {
    description = "Fast audio data augmentation in PyTorch. Inspired by audiomentations. Useful for deep learning";
    homepage = "https://github.com/asteroid-team/torch-audiomentations";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
