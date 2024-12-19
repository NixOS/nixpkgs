{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  primepy,
  torch,
  torchaudio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "torch-pitch-shift";
  version = "1.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KentoNishi";
    repo = "torch-pitch-shift";
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Pitch-shift audio clips quickly with PyTorch (CUDA supported)! Additional utilities for searching efficient transformations are included";
    homepage = "https://github.com/KentoNishi/torch-pitch-shift";
    changelog = "https://github.com/KentoNishi/torch-pitch-shift/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
