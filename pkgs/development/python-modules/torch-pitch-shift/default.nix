{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  primepy,
  torch,
  torchaudio,
}:

buildPythonPackage rec {
  pname = "torch-pitch-shift";
  version = "1.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KentoNishi";
    repo = "torch-pitch-shift";
    tag = "v${version}";
    hash = "sha256-QuDz9IpmBdzfMjwAuG2Ln0x2OL/w3RVd/EfO4Ws78dw=";
  };

  pythonRelaxDeps = [ "torchaudio" ];

  build-system = [ setuptools ];

  dependencies = [
    packaging
    primepy
    torch
    torchaudio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "torch_pitch_shift" ];

  meta = {
    description = "Pitch-shift audio clips quickly with PyTorch (CUDA supported)! Additional utilities for searching efficient transformations are included";
    homepage = "https://github.com/KentoNishi/torch-pitch-shift";
    changelog = "https://github.com/KentoNishi/torch-pitch-shift/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
