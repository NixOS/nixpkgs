{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  packaging,
  primepy,
  torch,
  torchaudio,
}:

buildPythonPackage rec {
  pname = "torch-pitch-shift";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KentoNishi";
    repo = "torch-pitch-shift";
    rev = "v${version}";
    hash = "sha256-s3z+6jOGC7RfF9TzVZ9HFbIFz2BsBm6Yhx7lgaEKv6o=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    packaging
    primepy
    torch
    torchaudio
  ];

  pythonImportsCheck = [ "torch_pitch_shift" ];

  meta = with lib; {
    description = "Pitch-shift audio clips quickly with PyTorch (CUDA supported)! Additional utilities for searching efficient transformations are included";
    homepage = "https://github.com/KentoNishi/torch-pitch-shift";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
