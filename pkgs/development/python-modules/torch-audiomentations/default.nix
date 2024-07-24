{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  julius,
  librosa,
  torch,
  torchaudio,
  torch-pitch-shift,
}:

buildPythonPackage rec {
  pname = "torch-audiomentations";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "torch-audiomentations";
    rev = "refs/tags/v${version}";
    hash = "sha256-0+5wc+mP4c221q6mdaqPalfumTOtdnkjnIPtLErOp9E=";
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
