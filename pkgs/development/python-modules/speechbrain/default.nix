{
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  hyperpyyaml,
  joblib,
  lib,
  numpy,
  packaging,
  pythonOlder,
  sentencepiece,
  scipy,
  torch,
  torchaudio,
  tqdm,
}:

buildPythonPackage rec {
  pname = "speechbrain";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "speechbrain";
    rev = "refs/tags/v${version}";
    hash = "sha256-s23RHxqr+ZCWPYNchFpyYa01mY+Bum3thgNbJP8rAmA=";
  };

  propagatedBuildInputs = [
    huggingface-hub
    hyperpyyaml
    joblib
    numpy
    packaging
    sentencepiece
    scipy
    torch
    torchaudio
    tqdm
  ];

  doCheck = false; # requires sox backend

  pythonImportsCheck = [ "speechbrain" ];

  meta = with lib; {
    description = "PyTorch-based Speech Toolkit";
    homepage = "https://speechbrain.github.io";
    changelog = "https://github.com/speechbrain/speechbrain/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
