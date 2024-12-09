{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  huggingface-hub,
  hyperpyyaml,
  joblib,
  numpy,
  packaging,
  sentencepiece,
  scipy,
  torch,
  torchaudio,
  tqdm,
}:

buildPythonPackage rec {
  pname = "speechbrain";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "speechbrain";
    rev = "refs/tags/v${version}";
    hash = "sha256-Un7RPxMq1sD7uD3jcw3Bjp+Oo8ld+XC5g2I89gF6jxs=";
  };

  dependencies = [
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

  meta = {
    description = "PyTorch-based Speech Toolkit";
    homepage = "https://speechbrain.github.io";
    changelog = "https://github.com/speechbrain/speechbrain/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
